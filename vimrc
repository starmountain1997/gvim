set nocompatible
set encoding=utf-8

call plug#begin()

Plug 'preservim/nerdtree'
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'luochen1990/rainbow'
Plug 'vim-python/python-syntax'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'



call plug#end()

set number
set relativenumber

syntax on
set cursorline

set nowrap
if has("autocmd")
  augroup filetype_settings
    autocmd!
    " 当 Vim 识别文件类型为 markdown 或 text 时，执行后续命令
    autocmd FileType markdown,text setlocal wrap
  augroup END
endif

set cursorcolumn
set mouse=a
set ruler
set hlsearch
set incsearch
set ignorecase
set smartcase

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set autoread
set nostartofline
set termguicolors     " enable true colors support
let ayucolor="dark"   " for dark version of theme
colorscheme ayu

filetype on
autocmd BufWritePost *vimrc so $MYVIMRC

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
map <F1> :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['__pycache__', '.*\.egg-info$', '.claude']
let g:NERDTreeShowHidden = 1


if &term =~# '\v(xterm|rxvt|alacritty|kitty)'
    let &t_EI = "\<Esc>[2 q"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
endif

let g:rainbow_active = 1
let g:airline_powerline_fonts = 1
let g:python_highlight_all = 1

" ============================================================================
" OSC 52 Clipboard Integration for modern terminals (like Windows Terminal)
" ============================================================================
if &term =~# '^(screen|tmux|alacritty|kitty|wezterm|iterm)'
  let s:osc52_file = tempname()

  function! s:OSC52Yank()
    try
      call writefile(getreg(''), s:osc52_file)
      let l:b64_data = system('base64 -w0 ' . shellescape(s:osc52_file))

      if v:shell_error == 0 && !empty(l:b64_data)
        let l:osc52_sequence = "\<Esc>]52;c;" . l:b64_data . "\<a\>"
        silent execute 'echoraw l:osc52_sequence'
      endif
    finally
      call delete(s:osc52_file)
    endtry
  endfunction

  nnoremap <silent> gy :call <SID>OSC52Yank()<CR>
  vnoremap <silent> gy :<C-u>call <SID>OSC52Yank()<CR>
endif
