" vim:foldmethod=marker

"vim-plug {{{
call plug#begin('~/.vim/plugged')
	Plug 'vim-airline/vim-airline'
	Plug 'morhetz/gruvbox'
	Plug 'hashivim/vim-terraform'
	Plug 'machakann/vim-highlightedyank'
	Plug 'vim-scripts/groovy.vim'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-commentary'
call plug#end()
"}}}

"Options {{{
let mapleader=" "
set path+=**
set nocompatible
set wildmenu
set number
set relativenumber
set autoindent
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
syntax on
filetype plugin indent on
set incsearch
set hlsearch
set hidden
set wrap
set showcmd
set splitright
set splitbelow
"}}}

"Mappings {{{
vnoremap : ;
vnoremap ; :
nnoremap : ;
nnoremap ; :
nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
nnoremap <silent> <leader>/ :set nohlsearch!<cr>
nnoremap <silent> <leader>so :w<cr>:so<cr>:echo "Sourced"<cr>
nnoremap <silent> <leader>qo :copen<cr>
nnoremap <silent> <leader>qc :cclose<cr>
nnoremap <silent> <leader>qj :cnext<cr>
nnoremap <silent> <leader>qk :cprev<cr>
nnoremap <silent> <leader>bn :bn<cr>
nnoremap <silent> <leader>bp :bp<cr>
nnoremap <silent> <leader>bd :bd<cr>
nnoremap <silent> <leader>le :25Lex<cr>
"}}}

let g:ctrlp_extensions = ['sample']
command! CtrlPSample call ctrlp#init(ctrlp#sample#id())

"gruvbox setup {{{
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
"}}}

"vim-highlightedyank setup {{{
let g:highlightedyank_highlight_duration = 100
"}}}

"groovy setup {{{
au BufNewFile,BufRead *.Jenkinsfile,*.groovy setf groovy

if did_filetype()
  finish
endif
if getline(1) =~ '^#!.*[/\\]groovy\>'
  setf groovy
endif
"}}}

"fzf setup {{{
nnoremap <leader>sf :Files<cr>
nnoremap <leader>sb :Buffers<cr>
nnoremap <leader>s/ :Lines<cr>
nnoremap <leader>sg :Rg<cr>
nnoremap <leader>sh :Helptags<cr>

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
"}}}

