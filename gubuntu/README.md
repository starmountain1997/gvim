# vLLM Ascend Docker 服务

基于昇腾NPU的vLLM服务Docker配置

## 文件说明

- `Dockerfile`: 基于 quay.io/ascend/cann:8.5.0-910b-ubuntu22.04-py3.11 构建
- 预装工具: zsh + Oh My Zsh、Claude CLI、OpenCode CLI、ruff、python-lsp-server

## 使用方法

### 构建镜像

```bash
docker build -t vllm-ascend .
```

### 进入容器

```bash
docker run -it vllm-ascend zsh
```

### 代理配置

容器内使用以下别名管理代理:

```bash
set_proxy   # 开启代理
unset_proxy # 关闭代理
```

## 预装工具

| 工具 | 说明 |
|------|------|
| zsh | 带 Oh My Zsh、zsh-autosuggestions、zsh-syntax-highlighting |
| Claude CLI | AI 编程助手 |
| OpenCode CLI | OpenCode AI 编程助手 |
| ruff | Python linter |
| python-lsp-server | Python LSP 服务器 |

## SSH 配置

容器内已配置 Git SSH:

- 自动使用代理连接 GitHub
- 已生成 ed25519 SSH 密钥对
- 公钥在容器启动时显示

## 注意事项

- 容器需要privileged权限和host网络模式（如需访问NPU设备）
- 代理默认端口: 7890
