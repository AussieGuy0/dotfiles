call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'lifepillar/vim-solarized8'
Plug 'mhinz/vim-startify'
Plug 'rstacruz/vim-closer'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'liuchengxu/vim-which-key'
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }

call plug#end()

" =General=
let mapleader = ","
let maplocalleader=","

set nocompatible
set autoindent
set smarttab
set background=dark
set history=10000
set hlsearch
set incsearch
set autoread
set wildmenu
set ruler
set termguicolors

" =UI=
set number
set cursorline
set showmatch
set title
set scrolloff=4

" =Searching=
set ignorecase
set smartcase

" =Spaces and Tabs=
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smartindent

" =Backups=
set nobackup
set noswapfile
set undodir=~/.vim/undodir
set undofile

" =Windows=
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

command W w !sudo tee % > /dev/null

nnoremap j gj
nnoremap k gk

nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" File explorer
let g:netrw_banner = 0
nnoremap <leader>pv :30Lex<cr>

" Destroy whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * if !&binary | call TrimWhitespace() | endif

" =Airline=
let g:airline_theme='solarized'

" =Ale=
let g:ale_open_list = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_linters = {'clojure': ['clj-kondo']}

" =VimWiki=
let g:vimwiki_list = [{'path': '~/Drive/Notes', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext=0

command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
    au BufNewFile ~/Drive/Notes/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template.py '%'
augroup end

au BufReadPost,BufNewFile *.txt,*.tex set tw=80

" =Templates=
augroup templates
  au!
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e")
augroup END

" =WhichKey=
nnoremap <silent> <leader>      :<c-u>WhichKey  ','<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

" =Colors=
colorscheme solarized8
