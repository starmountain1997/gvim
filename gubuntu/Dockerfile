FROM quay.m.daocloud.io/ascend/vllm-ascend:v0.13.0rc1

ENV http_proxy=http://127.0.0.1:6152
ENV https_proxy=http://127.0.0.1:6152
ENV HTTP_PROXY=http://127.0.0.1:6152
ENV HTTPS_PROXY=http://127.0.0.1:6152
# 将代理设置传递给构建过程和容器运行时
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        zsh \
        curl \
        git \
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

# 添加环境变量配置 - 独立层，便于修改环境配置
RUN echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> $HOME/.zshrc && \
    echo "source /usr/local/Ascend/nnal/atb/set_env.sh" >> $HOME/.zshrc

# 添加代理别名 - 独立层，便于修改代理设置
RUN echo "alias set_proxy=\"export http_proxy=http://127.0.0.1:6152 && export https_proxy=http://127.0.0.1:6152\"" >> $HOME/.zshrc && \
    echo "alias unset_proxy=\"unset http_proxy && unset https_proxy\"" >> $HOME/.zshrc

# 添加本地 bin 目录到 PATH
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.zshrc

# 升级 pip 并配置镜像源 - Python 相关独立层
RUN pip install --upgrade pip

# 卸载不需要的包 - 独立层，便于控制依赖
RUN yes | pip uninstall vllm vllm-ascend || true

# 配置 pip 镜像源 - 网络相关独立配置
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && \
    pip config set global.extra-index-url "https://download.pytorch.org/whl/cpu/ https://mirrors.huaweicloud.com/ascend/repos/pypi"

ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 24


# 安装 Claude CLI - 工具安装独立层
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN . $NVM_DIR/nvm.sh && corepack enable yarn && yes | yarn global add @anthropic-ai/claude-code

# 配置 Git 用户信息 - 配置独立层
RUN git config --global user.name "guozr" && \
    git config --global user.email "guozr1997@hotmail.com"
