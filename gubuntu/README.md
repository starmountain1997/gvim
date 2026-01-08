# vLLM Ascend Docker 服务

基于昇腾NPU的vLLM服务Docker配置

## 文件说明

- `Dockerfile`: 基于quay.io/ascend/vllm-ascend:v0.13.0rc1构建
- `docker-compose.yml`: Docker Compose配置文件，包含昇腾NPU设备映射

## 使用方法

### 构建并启动服务

```bash
docker-compose up -d --build
```

### 进入容器

```bash
docker-compose exec vllm-glm45v bash
```

### 停止服务

```bash
docker-compose down
```

### 同时运行多个容器

如果需要同时运行多个容器实例，需要修改 `docker-compose.yml`，注释掉或删除 `container_name` 行：

```yaml
# container_name: ${CONTAINER_NAME:-vllm-guozr}
```

然后使用不同的项目名称启动：

```bash
docker compose -p myproject1 up -d
docker compose -p myproject2 up -d
```

这样每个容器会自动命名为 `myproject1-g-vllm-ascend-1`、`myproject2-g-vllm-ascend-1` 等，互不冲突。

## 注意事项

- 需要宿主机已安装昇腾驱动和相关组件
- 容器需要privileged权限和host网络模式
- 映射了所有昇腾NPU设备到容器内