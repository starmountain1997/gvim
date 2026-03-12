FROM quay.io/ascend/vllm-ascend:v0.16.0rc1

ARG PROXY_PORT=6152
ENV PROXY_PORT=${PROXY_PORT}
ENV http_proxy=http://127.0.0.1:${PROXY_PORT}
ENV https_proxy=http://127.0.0.1:${PROXY_PORT}
ENV HTTP_PROXY=http://127.0.0.1:${PROXY_PORT}
ENV HTTPS_PROXY=http://127.0.0.1:${PROXY_PORT}
ENV LANG=zh_CN.UTF-8
ENV TZ=Asia/Shanghai
# 显式设置基础 PATH，防止脚本加载时丢失核心路径
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"

# 配置 TUNA Jammy ports 源
RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports|https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports|g' /etc/apt/sources.list && \
    sed -i 's|http://archive.ubuntu.com/ubuntu|https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports|g' /etc/apt/sources.list

# 将代理设置传递给构建过程和容器运行时
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        zsh \
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
RUN echo "alias set_proxy=\"export http_proxy=http://127.0.0.1:${PROXY_PORT} && export https_proxy=http://127.0.0.1:${PROXY_PORT} && export HTTP_PROXY=http://127.0.0.1:${PROXY_PORT} && export HTTPS_PROXY=http://127.0.0.1:${PROXY_PORT} && git config --global http.proxy http://127.0.0.1:${PROXY_PORT} && git config --global https.proxy http://127.0.0.1:${PROXY_PORT}\"" >> $HOME/.zshrc && \
    echo "alias unset_proxy=\"unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY && git config --global --unset http.proxy && git config --global --unset https.proxy\"" >> $HOME/.zshrc

# 升级 pip 并配置镜像源 - Python 相关独立层
RUN pip install --upgrade pip

# 卸载不需要的包 - 独立层，便于控制依赖
RUN pip uninstall -y vllm vllm-ascend

# 多次运行
RUN pip uninstall -y vllm vllm-ascend

# 配置 pip 镜像源 - 网络相关独立配置
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && \
    pip config set global.extra-index-url "https://download.pytorch.org/whl/cpu/ https://mirrors.huaweicloud.com/ascend/repos/pypi"

# 配置 Git 用户信息 - 配置独立层
RUN git config --global user.name "guozr" && \
    git config --global user.email "guozr1997@hotmail.com" && \
    git config --global http.proxy http://127.0.0.1:${PROXY_PORT} && \
    git config --global https.proxy http://127.0.0.1:${PROXY_PORT} && \
    git config --global pull.rebase true

# 配置 SSH - 使用代理访问 GitHub
RUN mkdir -p ~/.ssh && \
    echo "Host github.com" >> ~/.ssh/config && \
    echo "    Hostname github.com" >> ~/.ssh/config && \
    echo "    User git" >> ~/.ssh/config && \
    echo "    ProxyCommand ncat --proxy-type http --proxy 127.0.0.1:${PROXY_PORT} %h %p" >> ~/.ssh/config && \
    chmod 600 ~/.ssh/config

# 生成 SSH 密钥对（ed25519 类型，更安全且更快）
RUN ssh-keygen -t ed25519 -C "guozr-ds" -f ~/.ssh/id_ed25519 -N "" && \
    chmod 600 ~/.ssh/id_ed25519 && \
    chmod 644 ~/.ssh/id_ed25519.pub && \
    echo "=== SSH Public Key (add to GitHub) ===" && \
    cat ~/.ssh/id_ed25519.pub

RUN pip install ruff basedpyright


# 安装 nvm、Node.js 和 Yarn
ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 24 && \
    nvm alias default 24 && \
    nvm use default && \
    corepack enable yarn && \
    yarn config set registry https://registry.npmmirror.com && \
    yarn global add @google/gemini-cli \
    yarn global add @anthropic-ai/claude-code \
    yarn global add opencode-ai && \
    echo "export PATH=\"$(dirname $(which node)):$(yarn global bin):\$PATH\"" >> /root/.zshrc && \
    echo "export PATH=\"$(dirname $(which node)):$(yarn global bin):\$PATH\"" >> /root/.bashrc

# 安装 aisbench benchmark
RUN mkdir -p $HOME/ASCEND-REPO && \
    git clone https://gitee.com/aisbench/benchmark.git -b v3.0-20250930-master $HOME/ASCEND-REPO/benchmark && \
    cd $HOME/ASCEND-REPO/benchmark && pip3 install -e ./ --use-pep517

# 安装 msmodelslim
RUN git clone https://gitcode.com/Ascend/msmodelslim.git $HOME/ASCEND-REPO/msmodelslim && \
    cd $HOME/ASCEND-REPO/msmodelslim && bash install.sh

# 安装 vllm
RUN git clone https://github.com/vllm-project/vllm.git $HOME/ASCEND-REPO/vllm && \
    cd $HOME/ASCEND-REPO/vllm && \
    git checkout 4034c3d32e30d01639459edd3ab486f56993876d && \
    VLLM_TARGET_DEVICE=empty pip install -v -e .

# 安装 vllm-ascend
RUN git clone https://github.com/vllm-project/vllm-ascend.git $HOME/ASCEND-REPO/vllm-ascend && \
    cd $HOME/ASCEND-REPO/vllm-ascend && \
    git remote rename origin upstream && \
    git remote add origin git@github.com:starmountain1997/vllm-ascend.git