syntax on
filetype plugin indent on
set autoindent
set number
set relativenumber
set ignorecase
set incsearch
" set hlsearch
set nowrap
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set scrolloff=8
set ruler
set cursorline

" Set <leader>
let mapleader = "\<space>"

" Normal mode remaps
nnoremap Y y$
nnoremap <leader>; mkA;<Esc>`k
nnoremap <leader>, mkA,<Esc>`k
nmap <leader>[ A<space>{<Enter>

" Insert mode remaps
" Auto-complete brackets and quotes
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
" inoremap ' ''<left>
" inoremap \" \""<left>

" Setting wrap for minified js files
au BufRead js_*.js set wrap
au BufNewFile,BufRead *.md set wrap
au BufNewFile,BufRead *.txt set wrap
