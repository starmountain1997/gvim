"""
Quantize microsoft/VibeVoice-ASR using GPTQ W4A16.

Steps:
  1. Load 128 audio clips from LibriSpeech (streaming)
     Fallback: synthetic white-noise audio
  2. Pre-process with VibeVoiceASRProcessor → dict of tensors
  3. Run GPTQ calibration via llmcompressor's low-level session API
     (bypasses the text-only dataset pipeline)
  4. Save to ./VibeVoice-ASR-W4A16-GPTQ

Memory notes (RTX 3060, 12 GB):
  BF16 model ~17 GB → loaded on CPU (31 GB RAM available).
  Sequential pipeline offloads one Qwen2DecoderLayer at a time to GPU.
  Falls back to BasicPipeline if torch.fx tracing fails on the custom model.
"""

import sys
import numpy as np
import torch
import vibevoice.modular.modeling_vibevoice_asr          # registers AutoModel classes
from vibevoice.modular.configuration_vibevoice import VibeVoiceASRConfig
from vibevoice.modular.modular_vibevoice_text_tokenizer import VibeVoiceASRTextTokenizerFast
from vibevoice.processor.vibevoice_asr_processor import VibeVoiceASRProcessor
from transformers import AutoConfig, AutoModelForCausalLM
from torch.utils.data import DataLoader, Dataset
from llmcompressor.modifiers.quantization.gptq import GPTQModifier
from llmcompressor.core import active_session
from llmcompressor.pipelines.registry import CalibrationPipeline
from llmcompressor.args.dataset_arguments import DatasetArguments
from llmcompressor.transformers.compression.compressed_tensors_utils import modify_save_pretrained

# ── paths ──────────────────────────────────────────────────────────────────────
MODEL_ID   = "microsoft/VibeVoice-ASR"
QWEN_LOCAL = ("/home/guozr/.cache/huggingface/hub/"
              "models--Qwen--Qwen3-0.6B-GPTQ-Int8/snapshots/"
              "d3f20e7e71825fe57ad32705b396e9e156279107")
SAVE_DIR   = "VibeVoice-ASR-W4A16-GPTQ"

NUM_CALIB  = 128
TARGET_SR  = 24_000
CLIP_SECS  = 15           # cap clip length to limit GPU activation memory

AutoConfig.register("vibevoice", VibeVoiceASRConfig)

# ── 1. build calibration audio list ───────────────────────────────────────────

def load_librispeech(n: int) -> list[np.ndarray]:
    try:
        from datasets import load_dataset
        print("Downloading LibriSpeech validation.clean (streaming) …")
        ds = load_dataset(
            "librispeech_asr", "clean",
            split="validation.clean",
            streaming=True,
            trust_remote_code=True,
        )
        clips = []
        for ex in ds.take(n):
            audio = ex["audio"]
            arr   = audio["array"].astype(np.float32)
            sr    = audio["sampling_rate"]
            if sr != TARGET_SR:
                import librosa
                arr = librosa.resample(arr, orig_sr=sr, target_sr=TARGET_SR)
            clips.append(arr[: TARGET_SR * CLIP_SECS])
        print(f"  loaded {len(clips)} LibriSpeech clips")
        return clips
    except Exception as e:
        print(f"  LibriSpeech unavailable ({e}), using synthetic audio")
        return []


def synthetic_audio(n: int) -> list[np.ndarray]:
    rng = np.random.default_rng(42)
    return [
        (rng.standard_normal(TARGET_SR * (3 + i % 8)) * 0.05).astype(np.float32)
        for i in range(n)
    ]


audio_clips = load_librispeech(NUM_CALIB) or synthetic_audio(NUM_CALIB)

# ── 2. pre-process clips with VibeVoiceASRProcessor ──────────────────────────

print("Loading processor …")
tokenizer = VibeVoiceASRTextTokenizerFast.from_pretrained(
    QWEN_LOCAL, local_files_only=True
)
processor = VibeVoiceASRProcessor(tokenizer=tokenizer)

print(f"Pre-processing {len(audio_clips)} audio clips …")
calib_batches: list[dict] = []
skipped = 0
for i, arr in enumerate(audio_clips):
    try:
        b = processor(arr, return_tensors="pt")
        calib_batches.append(dict(b))   # tensors already have batch dim = 1
    except Exception as e:
        skipped += 1
        if skipped <= 5:
            print(f"  skip clip {i}: {e}")

print(f"  {len(calib_batches)} ready, {skipped} skipped")
if not calib_batches:
    sys.exit("No calibration batches — cannot run GPTQ.")

# ── 3. custom DataLoader (each item already batch_size=1) ─────────────────────

class PreBatchedDataset(Dataset):
    def __init__(self, batches):
        self.batches = batches
    def __len__(self):
        return len(self.batches)
    def __getitem__(self, idx):
        return self.batches[idx]

def identity_collate(batch):
    return batch[0]   # DataLoader wraps in list; unwrap

calib_loader = DataLoader(
    PreBatchedDataset(calib_batches),
    batch_size=1,
    shuffle=False,
    collate_fn=identity_collate,
)

# ── 4. load original BF16 model on CPU ────────────────────────────────────────

print("Loading original BF16 model on CPU (~17 GB RAM) …")
model = AutoModelForCausalLM.from_pretrained(
    MODEL_ID,
    local_files_only=True,
    dtype=torch.bfloat16,
    device_map="cpu",
    low_cpu_mem_usage=True,
)
model.eval()
print("  model loaded")

# ── 5. GPTQ recipe ────────────────────────────────────────────────────────────

IGNORE = [
    "lm_head",
    "re:model\\.acoustic_tokenizer\\..*",
    "re:model\\.semantic_tokenizer\\..*",
    "re:model\\.acoustic_connector\\..*",
    "re:model\\.semantic_connector\\..*",
]

recipe = GPTQModifier(
    targets="Linear",
    scheme="W4A16",
    ignore=IGNORE,
    dampening_frac=0.01,
    # sequential_targets set only in DatasetArguments (not here, to avoid conflict)
)

# ── 6. run calibration via low-level session API ──────────────────────────────

print("Initialising compression session …")
session = active_session()
session.reset()
session.initialize(
    model=model,
    start=-1,
    recipe=recipe,
    calib_data=calib_loader,
)

# Build dataset_args so the sequential pipeline knows the offload device etc.
dataset_args = DatasetArguments(
    sequential_targets=["Qwen2DecoderLayer"],
    sequential_offload_device="cpu",
)

print("Running GPTQ calibration (sequential pipeline) …")
print("  This may take 10-30 min depending on CPU↔GPU bandwidth.\n")

pipeline = CalibrationPipeline.from_modifiers(
    session.lifecycle.recipe.modifiers,
    user=None,   # GPTQ defaults to sequential pipeline
)
print(f"Using pipeline: {type(pipeline).__name__}")
pipeline(model, calib_loader, dataset_args)

session.finalize()
print("\nGPTQ quantization done.")

# ── 7. save ───────────────────────────────────────────────────────────────────

print(f"Saving to ./{SAVE_DIR} …")

# After GPTQ the sequential pipeline leaves onload_device=GPU on all offload
# caches.  Reset to CPU before saving so state_dict() never touches the GPU
# (which would OOM on 12 GB VRAM with the model still in RAM).
for module in model.modules():
    if hasattr(module._parameters, "onload_device"):
        module._parameters.onload_device = torch.device("cpu")
    if hasattr(module._buffers, "onload_device"):
        module._buffers.onload_device = torch.device("cpu")

# Patch save_pretrained so it calls compress_model() first (packs BF16
# fake-quantized weights → packed INT4) and writes quantization_config to
# config.json.  Without this the vanilla HF save writes 17 GB BF16.
modify_save_pretrained(model)

model.save_pretrained(SAVE_DIR, save_compressed=True)
print("Done.")
