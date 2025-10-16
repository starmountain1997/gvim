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
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" --- 文件浏览与管理 ---
Plug 'preservim/nerdtree'

" --- 语法与高亮 ---
Plug 'luochen1990/rainbow'
Plug 'dominikduda/vim_current_word'

" --- 编辑辅助 ---
Plug 'tpope/vim-commentary'

Plug 'dense-analysis/ale'


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

" --- 补全设置 ---
" 设置补全选项，改善补全体验，自动选择第一个补全选项
set completeopt=menu,menuone,preview,noinsert
" 设置补全弹窗的最大高度
set pumheight=10


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
" 映射 F1 键来开关 NERDTree (使用nnoremap避免递归映射)
nnoremap <F1> :NERDTreeToggle<CR>
" 当 NERDTree 是最后一个窗口时，自动退出 Vim
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" 设置 NERDTree 忽略的文件和文件夹
let g:NERDTreeIgnore = ['__pycache__', '.*\.egg-info$', '.claude']
" 显示隐藏文件
let g:NERDTreeShowHidden = 1

" --- vim-airline ---
" 启用 powerline 字体，使状态栏显示特殊符号
let g:airline_powerline_fonts = 1
" 在 airline 中集成 ALE 状态显示
let g:airline#extensions#ale#enabled = 1

" --- rainbow (彩虹括号) ---
" 启用 rainbow 插件
let g:rainbow_active = 1

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


" --- ALE 配置 ---

" 启用 ALE 的代码补全功能（必须在 ALE 加载前设置）
let g:ale_completion_enabled = 1
" 启用自动导入功能
let g:ale_completion_autoimport = 1

" 启用 ALE 的代码导航功能（跳转到定义、查找引用等）
let g:ale_navigation = 1

" ALE Python 最佳实践配置
" 使用 pyright 进行类型检查，ruff 进行快速语法和代码风格检查
let g:ale_linters = {
            \   "python": ["pyright", "ruff"]
            \ }

" 使用 ruff 作为主要的代码修复和格式化工具
" ruff_fixer 修复代码问题，ruff_format 进行格式化
let g:ale_fixers = {
            \   "python": ["ruff", "ruff_format"]
            \ }

" 配置 ALE 使用 uv 的 Python 路径
" 自动检测 uv 管理的 Python 路径
function! SetupPythonWithUv()
    " 检查当前目录是否存在 uv 项目或 .venv
    if filereadable('pyproject.toml') || isdirectory('.venv')
        " 优先使用 .venv 中的 Python
        if isdirectory('.venv/bin')
            let g:ale_python_python_executable = '.venv/bin/python'
        elseif isdirectory('.venv/Scripts')
            let g:ale_python_python_executable = '.venv/Scripts/python.exe'
        endif
    endif
endfunction

" 每次进入缓冲区时检查 Python 环境
autocmd BufEnter *.py call SetupPythonWithUv()

" 全局配置：如果 uv 命令可用，优先使用 uv run python
if executable('uv')
    " 配置 ruff 使用 uv 运行，保持详细的规则配置
    let g:ale_python_ruff_executable = 'uv'
    let g:ale_python_ruff_format_executable = 'uv'
    let g:ale_python_ruff_format_options = 'run ruff format'

endif

" 设置错误和警告的符号
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

" 在命令行中显示错误信息
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

" 优化 ALE 性能和用户体验
" 在保存时自动修复代码
let g:ale_fix_on_save = 1
" 设置延迟，避免频繁检查（毫秒）
let g:ale_lint_delay = 1000
" 打开文件时立即检查
let g:ale_lint_on_enter = 1
" 在插入模式下不检查，减少干扰
let g:ale_lint_on_insert_leave = 1
" 修改文本后延迟检查
let g:ale_lint_on_text_changed = 'normal'

" Python 特定优化
" 让 pyright 更专注于类型检查，减少与 ruff 的冲突
let g:ale_python_pyright_options = '--diagnostic-severity=information'
" ruff 专注于代码风格和快速检查（忽略行长度限制）
let g:ale_python_ruff_options = '--select=E,W,F,I'
" ruff format 配置：使用 ruff format 进行格式化
let g:ale_python_ruff_format_options = 'run ruff format'

" 智能格式化配置：在 Git 仓库中只处理修改的文件
function! SmartRuffFormat()
    " 检查是否在 Git 仓库中
    if executable('git') && system('git rev-parse --is-inside-work-tree 2>/dev/null') =~# 'true'
        " 如果文件未被 Git 跟踪，进行完整格式化
        if system('git ls-files -- ' . expand('%:p')) ==# ''
            " 完整格式化
            return 1
        else
            " 已跟踪文件也进行格式化（ruff 会处理整个文件）
            " 这是 ruff 的设计哲学，确保代码风格一致性
            return 1
        endif
    else
        " 不在 Git 仓库中，正常格式化
        return 1
    endif
endfunction


" --- ALE 代码导航快捷键 ---
" 跳转到定义
nnoremap <C-]> :ALEGoToDefinition<CR>
" 查找引用
nnoremap <C-\> :ALEFindReferences<CR>
" 返回上一个位置
nnoremap <C-t> :ALEPopLocation<CR>
" 查看类型信息
nnoremap <C-k> :ALEHover<CR>
" 跳转到实现（C++等语言）
nnoremap <C-i> :ALEGoToImplementation<CR>

