# vLLM Ascend Docker 服务

基于昇腾NPU的vLLM服务Docker配置

## 文件说明

- `Dockerfile`: 基于quay.io/ascend/vllm-ascend:v0.11.0rc3构建
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

## 注意事项

- 需要宿主机已安装昇腾驱动和相关组件
- 容器需要privileged权限和host网络模式
- 映射了所有昇腾NPU设备到容器内