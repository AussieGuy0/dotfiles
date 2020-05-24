" =Vundle=
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'dense-analysis/ale' " Syntax checker
Plugin 'lifepillar/vim-solarized8' " Solarized Color Scheme
Plugin 'rstacruz/vim-closer' " Bracket Closer
Plugin 'sheerun/vim-polyglot' " Multi-language support
Plugin 'airblade/vim-gitgutter'  " Visual representation of changed lines
Plugin 'mhinz/vim-startify' " Custom start screen
Plugin 'junegunn/goyo.vim' " No distraction mode
Plugin 'vimwiki/vimwiki' " wiki
Plugin 'ycm-core/YouCompleteMe'

Plugin 'vim-airline/vim-airline' " Better status bar
Plugin 'vim-airline/vim-airline-themes'

" Clojure
Plugin 'tpope/vim-salve'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fireplace'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" =General=
let mapleader = ","
let g:mapleader = ","

" Sets how many lines of history VIM has to remember
set history=1000

" =UI=
set number " Shows line numbers
set cursorline " highlights current line
set showmatch " highlights matching brackets
set wildmenu " visual autocomplete for command menu
set title " Shows title of file in top bar
set ruler " Show linenumber, char pos at bottom

" =Searching=
set incsearch " Search as characters are entered
set hlsearch " highlight matches
set ignorecase
set smartcase

" =Spaces and Tabs=
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in TAB when editing
set expandtab " tabs are spaces
set shiftwidth=4 " sets indentation to 4 spaces

set autoindent
set smartindent
set smarttab

set autoread

" =Backups=
set nobackup
set noswapfile
set undodir=~/.vim/undodir
set undofile

" =Windows=
" Move around windows with ctrl + direction
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" :W writes in sudo mode, useful for when editing protected file
command W w !sudo tee % > /dev/null
" =Move vertically by visual line=
nnoremap j gj
nnoremap k gk

nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Who needs NERDTree? 
let g:netrw_banner = 0
nnoremap <leader>pv :30Lex<CR>

" == PLUGIN & COLOURS ==

" =Airline=
let g:airline_theme='solarized'

" =Ale=
let g:ale_open_list = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

" =VimWiki=
let g:vimwiki_list = [{'path': '~/Drive/Notes', 'syntax': 'markdown', 'ext': '.md'}]

command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
    au BufNewFile ~/Drive/Notes/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template.py '%'
augroup end

" =Markdown=
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown "sets md files as markdown
au BufReadPost,BufNewFile *.md,*.txt,*.tex set tw=80

" =Templates=
augroup templates
  au!
  " read in templates files
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e")
augroup END

" =Colors=
syntax enable " Enables syntax highlighting
set background=dark
set termguicolors
colorscheme solarized8
