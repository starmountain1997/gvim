FROM quay.io/ascend/vllm-ascend:v0.11.0rc0

COPY .ssh/id_ed25519 /root/.ssh/id_ed25519
COPY .ssh/id_ed25519.pub /root/.ssh/id_ed25519.pub
COPY .ssh/known_hosts /root/.ssh/known_hosts

RUN apt update && apt install -y zsh curl && \
    chmod 600 /root/.ssh/id_ed25519 && \
    chmod 644 /root/.ssh/id_ed25519.pub && \
    chmod 644 /root/.ssh/known_hosts

RUN yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' $HOME/.zshrc && \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="random"/' $HOME/.zshrc && \
    echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> $HOME/.zshrc && \
    echo "source /usr/local/Ascend/nnal/atb/set_env.sh" >> $HOME/.zshrc && \
    echo "alias set_proxy=\"export http_proxy=http://127.0.0.1:7897 && export https_proxy=http://127.0.0.1:7897\"" >> $HOME/.zshrc && \
    echo "alias unset_proxy=\"unset http_proxy && unset https_proxy\"" >> $HOME/.zshrc

RUN pip install --upgrade pip && \
    yes | pip uninstall vllm vllm-ascend && \
    pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && \
    pip config set global.extra-index-url "https://download.pytorch.org/whl/cpu/ https://mirrors.huaweicloud.com/ascend/repos/pypi" && \
    curl -fsSL https://claude.ai/install.sh | bash
