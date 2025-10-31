# 基于 Ascend VLLM 镜像的定制 Dockerfile
# 包含昇腾芯片支持的 VLLM 环境
FROM quay.io/ascend/vllm-ascend:v0.11.0rc0

# 设置代理并更新系统
ENV https_proxy=http://127.0.0.1:7897
ENV http_proxy=http://127.0.0.1:7897

# 更新系统并安装必要工具
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y zsh curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 配置 git 代理
RUN git config --global http.proxy http://127.0.0.1:7897 && \
    git config --global https.proxy http://127.0.0.1:7897

# 安装 Oh My Zsh
RUN yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装 Zsh 插件并配置
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' $HOME/.zshrc && \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="random"/' $HOME/.zshrc && \
    source ~/.zshrc

# 配置 pip 镜像源
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && \
    pip config set global.extra-index-url "https://download.pytorch.org/whl/cpu/ https://mirrors.huaweicloud.com/ascend/repos/pypi"

# 使用 zsh 作为默认 shell
CMD ["zsh"]