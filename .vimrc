" =Vundle=
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic' " Syntax checker
Plugin 'altercation/vim-colors-solarized' " Solarized Color Scheme
Plugin 'rstacruz/vim-closer' " Bracket Closer
Plugin 'sheerun/vim-polyglot' " Multi-language support
Plugin 'chriskempson/base16-vim' " Base-16 colorschemes
Plugin 'airblade/vim-gitgutter'  " Visual representation of changed lines
Plugin 'mhinz/vim-startify' " Custom start screen
Plugin 'junegunn/goyo.vim' " No distraction mode
Plugin 'nelstrom/vim-markdown-folding' "auto folding of markdown documents
Plugin 'vimwiki/vimwiki' " wiki


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" =UI=
set number " Shows line numbers
set cursorline " highlights current line
set showmatch " highlights matching brackets
set wildmenu " visual autocomplete for command menu
set title " Shows title of file in top bar

" =Searching=
set incsearch " Search as characters are entered
set hlsearch " highlight matches

" =Move vertically by visual line=
nnoremap j gj
nnoremap k gk

nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Disable arrow keys in normal mode
nnoremap <Right> <nop>
nnoremap <Left> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>

" leader is comma
let mapleader = "," 

" =Spaces and Tabs=
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in TAB when editing
set expandtab " tabs are spaces
set autoindent
set cindent
set shiftwidth=4 " sets indentation to 4 spaces

" =Backups=
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" =Syntastic=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" =Markdown=
let g:vimwiki_list = [{'path': '~/Drive/Notes/wiki', 'syntax': 'markdown', 'ext': '.md'}]

" =Colors=
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown "sets md files as markdown
syntax enable " Enables syntax highlighting
set t_Co=16 " Neccesary for correct colours in terminal for base 16
let base16colorspace=256
set background=dark
colorscheme solarized
