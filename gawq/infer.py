"""
Run inference with quantized VibeVoice-ASR-W4A16.

Usage:
    uv run python infer.py audio.wav
    uv run python infer.py audio.wav --hotwords "Microsoft,VibeVoice"
"""

import argparse
import torch
import vibevoice.modular.modeling_vibevoice_asr  # registers AutoModel/CausalLM classes
from vibevoice.modular.configuration_vibevoice import VibeVoiceASRConfig
from vibevoice.modular.modular_vibevoice_text_tokenizer import VibeVoiceASRTextTokenizerFast
from vibevoice.processor.vibevoice_asr_processor import VibeVoiceASRProcessor
from transformers import AutoConfig, AutoModelForCausalLM

QUANT_MODEL = "./VibeVoice-ASR-W4A16"
# Local Qwen3 tokenizer (vocab-compatible with VibeVoice-ASR's Qwen2 decoder)
QWEN_LOCAL = "/home/guozr/.cache/huggingface/hub/models--Qwen--Qwen3-0.6B-GPTQ-Int8/snapshots/d3f20e7e71825fe57ad32705b396e9e156279107"

AutoConfig.register("vibevoice", VibeVoiceASRConfig)


def load_model():
    print(f"Loading quantized model from {QUANT_MODEL} ...")
    model = AutoModelForCausalLM.from_pretrained(
        QUANT_MODEL,
        local_files_only=True,
        dtype=torch.bfloat16,
        device_map="auto",
    )
    model.eval()
    if torch.cuda.is_available():
        mem_gb = torch.cuda.memory_allocated() / 1024**3
        print(f"GPU memory allocated: {mem_gb:.2f} GB")
    return model


def load_processor():
    tokenizer = VibeVoiceASRTextTokenizerFast.from_pretrained(
        QWEN_LOCAL, local_files_only=True
    )
    processor = VibeVoiceASRProcessor(tokenizer=tokenizer)
    return processor


def transcribe(audio_path: str, hotwords: str | None = None):
    model = load_model()
    processor = load_processor()

    print(f"Processing audio: {audio_path}")
    extra_kwargs = {"hotwords": hotwords} if hotwords else {}
    inputs = processor(audio_path, **extra_kwargs)

    inputs = {
        k: v.to(model.device) if isinstance(v, torch.Tensor) else v
        for k, v in inputs.items()
    }

    print("Generating transcription...")
    with torch.inference_mode():
        outputs = model.generate(**inputs)

    transcription = processor.decode(outputs)
    return transcription


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("audio", help="Path to audio file (.wav, .mp3, etc.)")
    parser.add_argument("--hotwords", default=None, help="Comma-separated hotwords")
    args = parser.parse_args()

    result = transcribe(args.audio, args.hotwords)
    print("\n--- Transcription ---")
    print(result)
