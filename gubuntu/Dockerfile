FROM quay.nju.edu.cn/ascend/cann:9.0.0-910b-ubuntu22.04-py3.12

ARG PROXY_HOST=127.0.0.1
ARG PROXY_PORT=6152
ARG NO_PROXY_HOSTS="localhost,127.0.0.1,gitcode.com,mirrors.aliyun.com,mirrors.huaweicloud.com,mirrors.tuna.tsinghua.edu.cn,download.pytorch.org"
ENV PROXY_PORT=${PROXY_PORT}
ENV NO_PROXY_HOSTS=${NO_PROXY_HOSTS}
ENV http_proxy=http://${PROXY_HOST}:${PROXY_PORT}
ENV https_proxy=http://${PROXY_HOST}:${PROXY_PORT}
ENV HTTP_PROXY=http://${PROXY_HOST}:${PROXY_PORT}
ENV HTTPS_PROXY=http://${PROXY_HOST}:${PROXY_PORT}
ENV no_proxy=${NO_PROXY_HOSTS}
ENV NO_PROXY=${NO_PROXY_HOSTS}
ENV LANG=zh_CN.UTF-8
ENV TZ=Asia/Shanghai
# 显式设置基础 PATH，防止脚本加载时丢失核心路径
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"

# 配置 Aliyun Jammy ports 源（TUNA 镜像 403，改用阿里云）
RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports|https://mirrors.aliyun.com/ubuntu-ports|g' /etc/apt/sources.list && \
    sed -i 's|http://archive.ubuntu.com/ubuntu|https://mirrors.aliyun.com/ubuntu-ports|g' /etc/apt/sources.list

# 将代理设置传递给构建过程和容器运行时
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        zsh \
	    tmux \
        curl \
        git \
        ncat \
        openssh-client \
        locales \
        tzdata \
    && localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 Oh My Zsh - 独立层，便于调试
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 安装 Zsh 插件 - 独立层，可以单独更新
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 配置 Zsh 主题和插件
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' $HOME/.zshrc && \
    sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"random\"/' $HOME/.zshrc


# 添加代理别名 - 独立层，便于修改代理设置
RUN echo "alias set_proxy=\"export http_proxy=http://${PROXY_HOST}:${PROXY_PORT} && export https_proxy=http://${PROXY_HOST}:${PROXY_PORT} && export HTTP_PROXY=http://${PROXY_HOST}:${PROXY_PORT} && export HTTPS_PROXY=http://${PROXY_HOST}:${PROXY_PORT} && export no_proxy=${NO_PROXY_HOSTS} && export NO_PROXY=${NO_PROXY_HOSTS} && git config --global http.proxy http://${PROXY_HOST}:${PROXY_PORT} && git config --global https.proxy http://${PROXY_HOST}:${PROXY_PORT}\"" >> $HOME/.zshrc && \
    echo "alias unset_proxy=\"unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY && git config --global --unset http.proxy && git config --global --unset https.proxy\"" >> $HOME/.zshrc

# 安装 uv - Python 包管理器
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# 配置 uv 镜像源
ENV UV_INDEX_URL=https://mirrors.aliyun.com/pypi/simple
ENV UV_EXTRA_INDEX_URL=https://mirrors.huaweicloud.com/ascend/repos/pypi

# 配置 Git 用户信息 - 配置独立层
RUN git config --global user.name "guozr" && \
    git config --global user.email "guozr1997@hotmail.com" && \
    git config --global http.proxy http://${PROXY_HOST}:${PROXY_PORT} && \
    git config --global https.proxy http://${PROXY_HOST}:${PROXY_PORT} && \
    git config --global pull.rebase true

# 配置 SSH - 使用代理访问 GitHub
RUN mkdir -p ~/.ssh && \
    echo "Host github.com" >> ~/.ssh/config && \
    echo "    Hostname github.com" >> ~/.ssh/config && \
    echo "    User git" >> ~/.ssh/config && \
    echo "    ProxyCommand ncat --proxy-type http --proxy ${PROXY_HOST}:${PROXY_PORT} %h %p" >> ~/.ssh/config && \
    chmod 600 ~/.ssh/config

# 生成 SSH 密钥对（ed25519 类型，更安全且更快）
RUN ssh-keygen -t ed25519 -C "guozr-ds" -f ~/.ssh/id_ed25519 -N "" && \
    chmod 600 ~/.ssh/id_ed25519 && \
    chmod 644 ~/.ssh/id_ed25519.pub && \
    echo "=== SSH Public Key (add to GitHub) ===" && \
    cat ~/.ssh/id_ed25519.pub

RUN uv tool install ruff && uv tool install ty

# 安装 Neovim 0.12.0
RUN wget https://github.com/neovim/neovim/releases/download/v0.12.0/nvim-linux-arm64.tar.gz -O /tmp/nvim.tar.gz && \
    tar -xzf /tmp/nvim.tar.gz -C /opt && \
    mv /opt/nvim-* /opt/nvim && \
    ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.tar.gz

# 安装 nvm、Node.js 和 Yarn
ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 24 && \
    nvm alias default 24 && \
    nvm use default && \
    corepack enable yarn && \
    yarn config set registry https://registry.npmmirror.com 

# 创建 uv 虚拟环境，所有 Python 包统一管理
RUN mkdir -p /workspace && cd /workspace && uv init && uv venv /workspace/.venv --python 3.12
ENV VIRTUAL_ENV="/workspace/.venv"
ENV PATH="$VIRTUAL_ENV/bin:${PATH}"


# 安装 aisbench benchmark
RUN mkdir -p $HOME/ascend-repo && \
    git clone https://github.com/AISBench/benchmark.git /workspace/benchmark && \
    cd /workspace/benchmark && uv pip install -e .

# 安装 msmodelslim
RUN git clone https://gitcode.com/Ascend/msmodelslim.git /workspace/msmodelslim && \
    cd /workspace/msmodelslim && bash install.sh

# 安装 vllm
RUN git clone --depth 1 --branch v0.21.0 https://github.com/vllm-project/vllm /workspace/vllm && \
    cd /workspace/vllm && \
    VLLM_TARGET_DEVICE=empty uv pip install -e .

# 安装 vllm-ascend
RUN git clone --depth 1 --branch v0.21.0rc1 https://github.com/vllm-project/vllm-ascend.git /workspace/vllm-ascend && \
    cd /workspace/vllm-ascend && \
    git submodule update --init --recursive

# 安装 msmodeling
RUN git clone https://gitcode.com/Ascend/msmodeling.git /workspace/msmodeling && \
    cd /workspace/msmodeling && \
    uv pip install -r requirements.txt

# 安装 rust（配置清华镜像源）
RUN mkdir -p $HOME/.cargo && \
    echo '[source.crates-io]' > $HOME/.cargo/config.toml && \
    echo 'replace-with = "mirror"' >> $HOME/.cargo/config.toml && \
    echo '' >> $HOME/.cargo/config.toml && \
    echo '[source.mirror]' >> $HOME/.cargo/config.toml && \
    echo 'registry = "sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/"' >> $HOME/.cargo/config.toml
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
