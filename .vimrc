call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'  " Visual representation of changed lines
Plug 'dense-analysis/ale' " Syntax checker
Plug 'lifepillar/vim-solarized8' " Solarized Color Scheme
Plug 'nvim-lua/plenary.nvim' " Required for telescope
Plug 'nvim-telescope/telescope.nvim' " Fuzzy search across project
Plug 'mhinz/vim-startify' " Custom start screen
Plug 'rstacruz/vim-closer' " Bracket Closer
Plug 'sheerun/vim-polyglot' " Multi-language support
Plug 'vim-airline/vim-airline' " Better status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki' " wiki
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vim-which-key'

" Clojure
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'Olical/conjure'

" All of your Plugins must be added before the following line
call plug#end()

" =General=
let mapleader = ","
let maplocalleader=","

lua << EOF
require'nvim-treesitter.configs'.setup {
  auto_install = true,
}
EOF

if !has('nvim')
  set nocompatible
  set autoindent
  set smarttab
  set background=dark
  set history=10000
  set hlsearch " highlight matches
  set incsearch " Search as characters are entered
  set autoread
  set wildmenu " visual autocomplete for command menu
  set ruler " Show linenumber, char pos at bottom
  set termguicolors
endif


" =UI=
set number " Shows line numbers
set cursorline " highlights current line
set showmatch " highlights matching brackets
set title " Shows title of file in top bar
set scrolloff=4

" =Searching=
set ignorecase
set smartcase

" =Spaces and Tabs=
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in TAB when editing
set expandtab " tabs are spaces
set shiftwidth=4 " sets indentation to 4 spaces

set smartindent

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

nnoremap <silent> <leader>gd :YcmCompleter GoTo<cr>
nnoremap <silent> <leader>gf :YcmCompleter FixIt<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope git_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Who needs NERDTree?
let g:netrw_banner = 0
nnoremap <leader>pv :30Lex<cr>

" Destroy whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * if !&binary | call TrimWhitespace() | endif

" == PLUGIN & COLOURS ==

" =Airline=
let g:airline_theme='solarized'

" =Ale=
let g:ale_open_list = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_linters = {'clojure': ['clj-kondo']}

" =Coc=
" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <leader>rn <Plug>(coc-rename)

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
  " read in templates files
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e")
augroup END


" =WhichKey=
nnoremap <silent> <leader>      :<c-u>WhichKey  ','<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

" =Colors=
colorscheme solarized8
