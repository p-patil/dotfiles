" Helper function for conditionally loading plugins
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Plugins
"" Install with:
""" vim: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
""" neovim: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin()

"" Shared between vim and neovim
Plug 'craigemery/vim-autotag'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-smooth-scroll'
Plug 'tpope/vim-surround'

"" Vim plugins
" Plug 'example', Cond(!has('nvim'))

"" Neovim plugins
Plug 'Shougo/deoplete.nvim', Cond(has('nvim'), { 'do': ':UpdateRemotePlugins' })
Plug 'artur-shaik/vim-javacomplete2', Cond(has('nvim'))
Plug 'zchee/deoplete-jedi', Cond(has('nvim'))
call plug#end()

" Plugin settings
"" Shared between vim and neovim

"" Vim plugins
if (!has('nvim'))
    " Put plugin settings here
endif

"" Neovim plugins
if (has('nvim')) 
    """ Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    set completeopt-=preview                " disable preview window
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
endif

" Syntax
syntax on
filetype on                         " detect the type of file
filetype indent on                  " enable filetype-specific indenting
filetype plugin on                  " enable filetype-specific plugins


" General settings

" Color settings
set rtp+=~/.vim                     " colorschemes and stuff for neovim
colorscheme molokai                 " Located at https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim

if has('mouse')
    set mouse=a                     " enable mouse mode if avail
endif

if !has('nvim')
    set ttymouse=xterm2             " needed for tmux
endif

" Set default directories for installs and swap files
set directory=~/.vim
set backupdir=~/.vimtmp

set hidden            " Hides unloaded buffers instead of closing - this allows for switching between buffers without saving
set wildmenu
set relativenumber    " Make line numbering relative
set cindent
set cinkeys-=0#
set indentkeys-=0#
set showcmd		      " Display typed characters in Normal mode
set smartcase
set incsearch
set showmatch		  " Show matching brackets
set cursorline
set breakindent       " Smart text wrapping
set linebreak
set scrolloff=5       " always show 5 lines above and below cursor
set sidescrolloff=5   " always show 10 characters to left and right of line

" Tab stuff
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
set hlsearch

" Don't move the cursor back a character when returning to normal mode from insert mode
imap <Esc> <Esc>l

" Swap commands for moving visual lines and moving over actual lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Map to scrolling
noremap J <C-e>
noremap K <C-y>

" Map to smooth scrolling
noremap <silent> U :call smooth_scroll#up(&scroll, 0, 1)<CR>
noremap <silent> D :call smooth_scroll#down(&scroll, 0, 1)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 2)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 2)<CR>

" Ctrl+x to unhighlight searched text
nnoremap <silent> <C-x> :nohl<CR><C-l>

" Easier buffer switching
:nnoremap <A-tab> <C-6>

" Use space instead of colon for saving, quitting, copy-pasting, etc.
let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :qall<CR>
nnoremap <Leader>W :wq<CR>
nmap <Leader>y "+yy
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Easier buffer switching (and set bufmru mappings)
:nnoremap <Leader>b :buffers<CR>:buffer<Space>
:nnoremap <A-Tab> :b#<CR>

" Use asterisk to search for word under cursor
nnoremap * *``
