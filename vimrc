" =============================================================================
" === 基本设置 ===
" =============================================================================

" 关闭与 Vi 的兼容模式，使用 Vim 的全部功能
set nocompatible
" 设置文件编码为 UTF-8
set encoding=utf-8
" 启用鼠标支持
set mouse=a
" 当文件在外部被修改时自动重新加载
set autoread
" 使用 j/k 移动时，光标不回到行首
set nostartofline


" =============================================================================
" === 插件列表 (vim-plug) ===
" =============================================================================

call plug#begin()

" --- 主题与外观 ---
Plug 'ayu-theme/ayu-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" --- 文件浏览与管理 ---
Plug 'preservim/nerdtree'

" --- 语法与高亮 ---
Plug 'luochen1990/rainbow'
Plug 'vim-python/python-syntax'
Plug 'dominikduda/vim_current_word'
Plug 'preservim/vim-markdown'

" --- 编辑辅助 ---
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'

call plug#end()


" =============================================================================
" === 外观与 UI ===
" =============================================================================

" --- 颜色与主题 ---
" 启用终端的真彩色支持
set termguicolors
" 设置背景为深色
set background=dark
" 设置颜色主题
colorscheme PaperColor

" --- 界面元素 ---
" 开启语法高亮
syntax on
" 显示行号
set number
" 显示相对行号，便于跳转
set relativenumber
" 高亮显示当前行
set cursorline
" 高亮显示当前列
set cursorcolumn
" 在状态栏显示光标位置
set ruler

" --- 终端光标形状 ---
" 在特定终端中，根据模式设置光标形状
if &term =~# '\v(xterm|rxvt|alacritty|kitty)'
    let &t_EI = "\<Esc>[2 q" " 普通模式光标 (block)
    let &t_SI = "\<Esc>[6 q" " 插入模式光标 (line)
    let &t_SR = "\<Esc>[4 q" " 替换模式光标 (underline)
endif


" =============================================================================
" === 编辑与文本行为 ===
" =============================================================================

" --- 缩进与制表符 ---
" 设置制表符宽度为 4 个空格
set tabstop=4
" 设置自动缩进的宽度为 4 个空格
set shiftwidth=4
" 将制表符转换为空格
set expandtab
" 新行自动缩进
set autoindent
" 为 C 语言等风格的语言启用智能缩进
set smartindent

" --- 换行 ---
" 默认不自动换行
set nowrap

" --- 搜索 ---
" 搜索时高亮显示匹配项
set hlsearch
" 输入搜索内容时即时高亮
set incsearch
" 搜索时忽略大小写
set ignorecase
" 如果搜索内容包含大写字母，则不忽略大小写（智能大小写）
set smartcase


" =============================================================================
" === 文件与自动命令 ===
" =============================================================================

" 开启文件类型检测、插件和缩进
filetype plugin indent on

" 当 vimrc 文件被保存后，自动重新加载配置
autocmd BufWritePost *vimrc so $MYVIMRC

" 针对特定文件类型（markdown, text）开启自动换行
if has("autocmd")
  augroup filetype_settings
    autocmd!
    " 当 Vim 识别文件类型为 markdown 或 text 时，执行后续命令
    autocmd FileType markdown,text setlocal wrap
  augroup END
endif


" =============================================================================
" === 插件配置 ===
" =============================================================================

" --- NERDTree ---
" 映射 F1 键来开关 NERDTree
map <F1> :NERDTreeToggle<CR>
" 当 NERDTree 是最后一个窗口时，自动退出 Vim
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" 设置 NERDTree 忽略的文件和文件夹
let g:NERDTreeIgnore = ['__pycache__', '.*\.egg-info$', '.claude']
" 显示隐藏文件
let g:NERDTreeShowHidden = 1

" --- vim-airline ---
" 启用 powerline 字体，使状态栏显示特殊符号
let g:airline_powerline_fonts = 1

" --- rainbow (彩虹括号) ---
" 启用 rainbow 插件
let g:rainbow_active = 1

" --- python-syntax ---
" 启用所有 Python 语法高亮功能
let g:python_highlight_all = 1

" --- vim_current_word ---
" 高亮与当前光标下单词相同的所有单词
let g:vim_current_word#highlight_twins = 1
" 高亮当前光标下的单词
let g:vim_current_word#highlight_current_word = 1
" 高亮延迟设为 0，立即高亮
let g:vim_current_word#highlight_delay = 0

" 在加载颜色主题后应用高亮设置，以防被覆盖
augroup CurrentWordHighlight
    autocmd!
    " 为当前单词设置高亮颜色 (红色背景)
    autocmd ColorScheme * hi CurrentWord ctermbg=53 guibg=#5f0000
    " 为相同的其他单词设置高亮颜色 (深灰色背景)
    autocmd ColorScheme * hi CurrentWordTwins ctermbg=237 guibg=#3a3a3a
augroup END

