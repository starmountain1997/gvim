" 关闭与 Vi 的兼容模式，使用 Vim 的全部功能
set nocompatible
" 设置文件编码为 UTF-8
set encoding=utf-8

" vim-plug 插件管理器初始化
call plug#begin()

" === 插件列表 ===

" NERDTree: 一个文件系统浏览器，让你在 Vim 中方便地浏览和操作文件目录
Plug 'preservim/nerdtree'
" ayu-vim: 一个现代化的 Vim 主题
Plug 'ayu-theme/ayu-vim'

" vim-airline: 一个功能强大的 Vim 状态栏增强插件
Plug 'vim-airline/vim-airline'
" vim-airline-themes: 为 vim-airline 提供更多主题
Plug 'vim-airline/vim-airline-themes'
" coc.nvim: Conquer of Completion，一个智能补全引擎，提供类似 VS Code 的 IntelliSense 功能
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" vim-commentary: 快速注释代码的插件
Plug 'tpope/vim-commentary'
" rainbow: 彩虹括号，用于高亮显示匹配的括号
Plug 'luochen1990/rainbow'
" python-syntax: 增强 Python 语法高亮
Plug 'vim-python/python-syntax'
" tabular: 文本对齐插件，可以方便地按等号、冒号等符号对齐文本
Plug 'godlygeek/tabular'
" vim-markdown: 提供 Markdown 文件的语法高亮和相关功能
Plug 'preservim/vim-markdown'
" vim_current_word: 高亮当前光标下的单词以及所有相同的单词
Plug 'dominikduda/vim_current_word'
Plug 'NLKNguyen/papercolor-theme'


" vim-plug 插件管理器结束
call plug#end()

" === 编辑器基本设置 ===

" 显示行号
set number
" 显示相对行号，便于跳转
set relativenumber

" 开启语法高亮
syntax on
" 高亮显示当前行
set cursorline

" 默认不自动换行
set nowrap
" 针对特定文件类型（markdown, text）开启自动换行
if has("autocmd")
  augroup filetype_settings
    autocmd!
    " 当 Vim 识别文件类型为 markdown 或 text 时，执行后续命令
    autocmd FileType markdown,text setlocal wrap
  augroup END
endif

" 高亮显示当前列
set cursorcolumn
" 启用鼠标支持
set mouse=a
" 在状态栏显示光标位置
set ruler
" 搜索时高亮显示匹配项
set hlsearch
" 输入搜索内容时即时高亮
set incsearch
" 搜索时忽略大小写
set ignorecase
" 如果搜索内容包含大写字母，则不忽略大小写（智能大小写）
set smartcase

" === 缩进与制表符 ===

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
" 当文件在外部被修改时自动重新加载
set autoread
" 使用 j/k 移动时，光标不回到行首
set nostartofline

" === 外观与颜色 ===

" 启用终端的真彩色支持
set termguicolors

set background=dark
colorscheme PaperColor


" 为 coc.nvim 的高亮文本设置特定背景色
highlight CocHighlightText ctermbg=24 guibg=#005f87

" === 文件类型与自动命令 ===

" 开启文件类型检测
filetype on
" 当 vimrc 文件被保存后，自动重新加载配置
autocmd BufWritePost *vimrc so $MYVIMRC

" === 插件配置 ===

" --- coc.nvim (Conquer of Completion) ---
" 配置回车键用于确认 coc.nvim 的补全项
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

" --- NERDTree ---
" 当 NERDTree 是最后一个窗口时，自动退出 Vim
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" 映射 F1 键来开关 NERDTree
map <F1> :NERDTreeToggle<CR>
" 设置 NERDTree 忽略的文件和文件夹
let g:NERDTreeIgnore = ['__pycache__', '.*\.egg-info$', '.claude']
" 显示隐藏文件
let g:NERDTreeShowHidden = 1


" --- 终端光标形状 ---
" 在 xterm/rxvt/alacritty/kitty 终端中，设置插入模式和普通模式下的光标形状
if &term =~# '\v(xterm|rxvt|alacritty|kitty)'
    let &t_EI = "\<Esc>[2 q" " 普通模式光标 (block)
    let &t_SI = "\<Esc>[6 q" " 插入模式光标 (line)
    let &t_SR = "\<Esc>[4 q" " 替换模式光标 (underline)
endif

" --- rainbow (彩虹括号) ---
" 启用 rainbow 插件
let g:rainbow_active = 1

" --- vim-airline ---
" 启用 powerline 字体，使状态栏显示特殊符号
let g:airline_powerline_fonts = 1

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
