# gvim 配置

## 安装

```bash
git clone https://github.com/starmountain1997/gvim.git && (cd gvim && sh install_gvim.sh) && rm -rf gvim
```

## 启用的插件及使用方法

| 插件 | 功能 | 使用方法 |
| --- | --- | --- |
| [preservim/nerdtree](https://github.com/preservim/nerdtree) | 文件浏览器 | 按 `F1` 切换显示 |
| [ayu-theme/ayu-vim](https://github.com/ayu-theme/ayu-vim) | Ayu 主题 | 通过 `colorscheme ayu` 设置 |
| [morhetz/gruvbox](https://github.com/morhetz/gruvbox) | Gruvbox 主题 | 通过 `colorscheme gruvbox` 设置 |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Catppuccin 主题 | 当前使用的主题 `colorscheme catppuccin-mocha` |
| [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline) | 精美的状态栏 | 自动启用 |
| [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) | Airline 主题集合 | 自动加载 |
| [tpope/vim-commentary](https://github.com/tpope/vim-commentary) | 快速注释代码 | 在普通模式或可视模式下，使用 `gcc` 注释/取消注释当前行 |
| [luochen1990/rainbow](https://github.com/luochen1990/rainbow) | 彩虹括号 | 自动为不同层级的括号显示不同颜色 |
| [vim-python/python-syntax](https://github.com/vim-python/python-syntax) | 增强的 Python 语法高亮 | 自动为 Python 文件启用 |
| [godlygeek/tabular](https://github.com/godlygeek/tabular) | 文本对齐 | 选中要对齐的文本，输入 `:Tabularize /` 即可按 `/` 对齐 |
| [preservim/vim-markdown](https://github.com/preservim/vim-markdown) | Markdown 语法高亮和折叠 | 自动为 Markdown 文件启用 |
| [dominikduda/vim_current_word](https://github.com/dominikduda/vim_current_word) | 高亮当前单词 | 自动高亮光标下的单词及所有相同单词 |

