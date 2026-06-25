# gubuntu

基于昇腾 NPU 的 vLLM 开发环境 Docker 镜像。

## 构建

```bash
# 远程 Linux 服务器：需要 --network host 让容器访问宿主机代理
docker build --network host -t gubuntu .
```

`--network host` 使构建容器共享宿主机网络栈，容器内 `127.0.0.1` 即可访问宿主机上的代理（如 SSH 反代端口）。

### 覆盖代理地址

```bash
docker build --network host --build-arg PROXY_HOST=192.168.1.100 --build-arg PROXY_PORT=7890 -t gubuntu .
```

## 运行

### docker run

```bash
docker run -it --privileged --network host gubuntu zsh
```

### docker compose

```bash
docker compose -p quant up -d
```

## 代理配置

容器内通过 `ARG PROXY_HOST` / `ARG PROXY_PORT`（默认 `127.0.0.1:6152`）设定代理，构建和运行时生效。

容器内别名：

```bash
set_proxy    # 开启代理
unset_proxy  # 关闭代理
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
| g-claude | Claude CLI（内置 rtx + uv） |
| vllm-ascend | 昇腾 vLLM（基础镜像自带） |
| aisbench / msmodelslim / msmodeling | 昇腾工具链 |

## SSH 配置

容器内已配置 Git SSH，通过 HTTP 代理连接 GitHub。ed25519 密钥对在构建时生成，公钥需添加到 GitHub。

## 注意事项

- 需要 `--privileged` 和 `--network host`（昇腾 NPU 设备访问）
- 基础镜像：`quay.nju.edu.cn/ascend/vllm-ascend:v0.21.0rc1`
- 代理默认端口：6152（可通过 `--build-arg PROXY_PORT` 覆盖）
