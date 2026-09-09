# gubuntu

基于昇腾 NPU 的 vLLM 开发环境 Docker 镜像。

## 构建

```bash
docker build --network host -t gubuntu .
```

`--network host` 使构建容器共享宿主机网络栈。

## 运行

### docker run

```bash
docker run -it --privileged --network host gubuntu zsh
```

### docker compose

```bash
docker compose -p guozr up -d
```

## 预装工具

| 工具 | 说明 |
|------|------|
| zsh | Oh My Zsh + zsh-autosuggestions + zsh-syntax-highlighting |
| Neovim 0.12.0 | 编辑器 |
| Node.js 24 | via nvm + yarn |
| rust | rustup + cargo（zellij） |
| ruff | Python linter |
| ty | Python 类型检查 |
| RTK | CLI 代理 |
| pi | AI 编程代理（yarn global 安装） |
| vllm-ascend | 昇腾 vLLM（基础镜像自带） |
| aisbench / msmodelslim / msmodeling | 昇腾工具链 |

## SSH 配置

容器内已配置 Git SSH。ed25519 密钥对在构建时生成，公钥需添加到 GitHub。

## 注意事项

- 需要 `--privileged` 和 `--network host`（昇腾 NPU 设备访问）
- 基础镜像：`quay.io/ascend/vllm-ascend:glm-5.3-flash-a3`
