" vim:foldmethod=marker

"vim-plug {{{
call plug#begin('~/.vim/plugged')
	Plug 'kien/ctrlp.vim'
	Plug 'vim-airline/vim-airline'
	Plug 'morhetz/gruvbox'
	Plug 'hashivim/vim-terraform'
	Plug 'machakann/vim-highlightedyank'
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
"}}}

"Mappings {{{
nnoremap : ;
nnoremap ; :
nnoremap <leader>sf :CtrlPCurWD<cr>
nnoremap <leader>sb :CtrlPBuffer<cr>
nnoremap <leader>s/ :CtrlPLine<cr>
nnoremap <leader>sg :CtrlPSample<cr>
nnoremap <silent> <leader>so :w<cr>:so<cr>:echo "Sourced"<cr>
nnoremap <leader>/ :set nohlsearch!<cr>
nnoremap <silent> <leader>qo :copen<cr>
nnoremap <silent> <leader>qc :cclose<cr>
nnoremap <silent> <leader>qj :cnext<cr>
nnoremap <silent> leader>qk :cprev<cr>
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

" Map a key (e.g., <leader>p) to trigger the prompt and echo the input
nnoremap <leader>p :call PromptAndEcho()<CR>

" Function to prompt the user and echo the input
function! PromptAndEcho()
  echohl SpecialKey
  let user_input = input(">>> ")
  echohl None
  redraw!

  if user_input == ""
    return
  endif

  execute 'silent grep! -r ' . shellescape(user_input) . ' .' | copen
endfunction

