FROM quay.io/ascend/cann:9.1.0-910b-ubuntu22.04-py3.12

ENV LANG=zh_CN.UTF-8
ENV TZ=Asia/Shanghai
# 显式设置基础 PATH，防止脚本加载时丢失核心路径
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"

# 创建用户 guozr 并赋予 sudo 权限
RUN useradd -m -s /bin/bash guozr && \
    echo "guozr:0919" | chpasswd && \
    usermod -aG sudo guozr

# 官方 ports.ubuntu.com 源（TUNA 对本 pod egress IP 返回 403，无法用镜像）
RUN printf '%s\n' \
    'deb http://ports.ubuntu.com/ubuntu-ports/ jammy main restricted universe multiverse' \
    'deb http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted universe multiverse' \
    'deb http://ports.ubuntu.com/ubuntu-ports/ jammy-backports main restricted universe multiverse' \
    'deb http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse' \
    > /etc/apt/sources.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        zsh \
        tmux \
        curl \
        git \
        openssh-client \
        locales \
        tzdata \
    && localedef -i zh_CN -c -f UTF-8 zh_CN.UTF-8 \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 Oh My Zsh - 独立层，便于调试
RUN git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git /tmp/ohmyzsh && \
    cd /tmp/ohmyzsh/tools && \
    REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh --unattended && \
    rm -rf /tmp/ohmyzsh

# 安装 Zsh 插件 - 独立层，可以单独更新
RUN git clone https://gitee.com/starmountain1997/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://gitee.com/starmountain1997/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 配置 Zsh 主题和插件
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' $HOME/.zshrc && \
    sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"random\"/' $HOME/.zshrc

# 配置 pip 镜像源
RUN mkdir -p /root/.pip && \
    echo "[global]" > /root/.pip/pip.conf && \
    echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> /root/.pip/pip.conf && \
    echo "extra-index-url = https://mirrors.huaweicloud.com/ascend/repos/pypi" >> /root/.pip/pip.conf

# 配置 Git 用户信息 - 配置独立层
RUN git config --global user.name "guozr" && \
    git config --global user.email "guozr1997@hotmail.com" && \
    git config --global pull.rebase true

# 配置 SSH 访问 GitHub
RUN mkdir -p ~/.ssh && \
    echo "Host github.com" >> ~/.ssh/config && \
    echo "    Hostname github.com" >> ~/.ssh/config && \
    echo "    User git" >> ~/.ssh/config && \
    chmod 600 ~/.ssh/config

# 生成 SSH 密钥对（ed25519 类型，更安全且更快）
RUN ssh-keygen -t ed25519 -C "guozr-ds" -f ~/.ssh/id_ed25519 -N "" && \
    chmod 600 ~/.ssh/id_ed25519 && \
    chmod 644 ~/.ssh/id_ed25519.pub && \
    echo "=== SSH Public Key (add to GitHub) ===" && \
    cat ~/.ssh/id_ed25519.pub

# 安装 Neovim
RUN wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-arm64.tar.gz -O /tmp/nvim.tar.gz && \
    tar -xzf /tmp/nvim.tar.gz -C /opt && \
    mv /opt/nvim-* /opt/nvim && \
    ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.tar.gz

# 安装 nvm、Node.js、Yarn、pi 及扩展
ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 26 && \
    nvm alias default 26 && \
    nvm use default && \
    npm install -g yarn && \
    yarn config set registry https://registry.npmmirror.com && \
    npm config set registry https://registry.npmmirror.com && \
    yarn global add --ignore-scripts @earendil-works/pi-coding-agent && \
    export PATH="$(yarn global bin):$PATH" && \
    pi install npm:@juanibiapina/pi-powerbar && \
    pi install npm:pi-hashline-edit-pro && \
    pi install npm:@narumitw/pi-goal && \
    pi install npm:@narumitw/pi-subagents && \
    pi install npm:pi-mcp-adapter && \
    pi install npm:@ff-labs/pi-fff && \
    pi install npm:pi-cache-optimizer


# 安装 uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN echo "export UV_DEFAULT_INDEX=\"https://pypi.tuna.tsinghua.edu.cn/simple\""  >> $HOME/.zshrc


# 安装 Rust（清华镜像源加速）
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh && \
    chmod +x /tmp/rustup.sh && \
    RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup \
    RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup \
    /tmp/rustup.sh -y && \
    rm /tmp/rustup.sh

# 配置 crates.io 清华镜像
RUN mkdir -p $HOME/.cargo && \
    echo "[source.crates-io]" > $HOME/.cargo/config.toml && \
    echo "replace-with = \"mirror\"" >> $HOME/.cargo/config.toml && \
    echo "" >> $HOME/.cargo/config.toml && \
    echo "[source.mirror]" >> $HOME/.cargo/config.toml && \
    echo "registry = \"sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/\"" >> $HOME/.cargo/config.toml

# 安装 zellij（终端复用器/工作区管理）
RUN . "$HOME/.cargo/env" && cargo install --locked zellij

# 为 zsh 设置 Cargo 环境变量
RUN echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $HOME/.zshrc

# 安装 rtk（Rust 工具包）
RUN . "$HOME/.cargo/env" && cargo install --git https://github.com/rtk-ai/rtk
