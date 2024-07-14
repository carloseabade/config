let mapleader = ","
"Set fuzzy find
set path=**
"Set no compatible mode
set nocompatible
"Show menu for command-line completion
set wildmenu
"Show line numbers
set number
"Show relative line numbers
set relativenumber
"Copy indent from current line when starting a new line
set autoindent
"Expand <Tab> into spaces
set expandtab
"A <Tab> in front of a line inserts blanks according to 'shiftwidth'
set smarttab
"Number of spaces to use for each step of (auto)indent
set shiftwidth=2
"Number of spaces that a <Tab> counts for
set tabstop=2
"Turn on syntax highlighting
syntax on
"Support file type detection
filetype plugin indent on
"Disable word wrapping
set nowrap
"Highlight the first string while typing the search
set incsearch
"Minimal number of screen lines to keep above and below the curso
set scrolloff=999
"vertical column guides
set colorcolumn=80
"Allows to switch from a not saved buffer
set hidden
"Word wrap
set wrap

colorscheme habamax

set showcmd

"filetype plugin on

"vim-go config
set autowrite
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

"YouCompleteMe config
set completeopt-=preview

"Save file
map <leader>w :w<CR>
"Save and close file
map <leader>wq :wq<CR>
"Close file without saving it
map <leader>qq :q!<CR>
"Go to next buffer
map <leader>bn :bn<CR>
"Go to previous buffer
map <leader>bp :bp<CR>
"List buffers
map <leader>bl :buffers<CR>
"Close all other buffers
map <leader>o <C-w>o
