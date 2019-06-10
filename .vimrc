" =Vundle=
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic' " Syntax checker
Plugin 'lifepillar/vim-solarized8' " Solarized Color Scheme
Plugin 'rstacruz/vim-closer' " Bracket Closer
Plugin 'sheerun/vim-polyglot' " Multi-language support
Plugin 'airblade/vim-gitgutter'  " Visual representation of changed lines
Plugin 'mhinz/vim-startify' " Custom start screen
Plugin 'junegunn/goyo.vim' " No distraction mode
Plugin 'vimwiki/vimwiki' " wiki


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" =General=
let mapleader = "," 
let g:mapleader = ","

" Sets how many lines of history VIM has to remember
set history=500 

" :W writes in sudo mode, useful for when editing protected file
command W w !sudo tee % > /dev/null 

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


" =Spaces and Tabs=
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in TAB when editing
set expandtab " tabs are spaces
set shiftwidth=4 " sets indentation to 4 spaces

set autoindent
set smartindent

" =Windows=
" Move around windows with ctrl + direction 
map <C-j> <C-W>j 
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" =Backups=
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" == PLUGIN & COLOURS ==

" =Syntastic=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

autocmd VimLeave * :mksession! ~/.vim/sessions/last.vim

" =VimWiki=
let g:vimwiki_list = [{'path': '~/Drive/Notes', 'syntax': 'markdown', 'ext': '.md'}]

command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    autocmd BufRead,BufNewFile diary.wiki VimwikiDiaryGenerateLinks
augroup end
nnoremap <leader>wi :Diary<cr>

" =Markdown=
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown "sets md files as markdown
au BufReadPost,BufNewFile *.md,*.txt,*.tex set tw=80

" =Colors=
syntax enable " Enables syntax highlighting
set background=dark
set termguicolors
colorscheme solarized8
