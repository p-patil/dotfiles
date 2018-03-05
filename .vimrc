set nocompatible

" Plugins
"" Install with:
""" for vi(m): curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
""" for neovim: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Helper function for conditionally loading plugins
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()

"" Shared between vim and neovim
"Plug 'craigemery/vim-autotag'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
Plug 'jiangmiao/auto-pairs'
Plug 'othree/eregex.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-smooth-scroll'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'

"" Vim plugins
" Plug 'example', Cond(!has('nvim'))

"" Neovim plugins
Plug 'Shougo/deoplete.nvim', Cond(has('nvim'), { 'do': ':UpdateRemotePlugins' })
Plug 'artur-shaik/vim-javacomplete2', Cond(has('nvim'))
Plug 'zchee/deoplete-jedi', Cond(has('nvim'))

call plug#end()

" Plugin settings
"" Shared between vim and neovim

""" easymotion settings
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1 " Turn on case insensitive feature
nmap s <Plug>(easymotion-bd-w)
nmap <Leader>j <Plug>(easymotion-jumptoanywhere)
nmap <Leader>k <Plug>(easymotion-iskeyword-bd-w)

""" eregex settings
let g:eregex_default_enable = 0 " Enable
let g:eregex_force_case = 1
nnoremap <leader>/ :call eregex#toggle()<CR>

"" Vim plugins
if (!has('nvim'))
    " Put vim-only plugins here
endif

"" Neovim plugins
if (has('nvim')) 
    """ Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    set completeopt-=preview                " disable preview window
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    
    """ undotree
    if has("persistent_undo")
        set undodir=~/.vim/.undodir/
        set undofile
    endif

    """ ale
    let g:ale_sign_column_always=1
endif

" General settings

" Syntax
syntax on
filetype on                         " detect the type of file
filetype indent on                  " enable filetype-specific indenting
filetype plugin on                  " enable filetype-specific plugins

" Color settings
set rtp+=$HOME/.vim                     " colorschemes and stuff for neovim
let python_highlight_all=1
let g:polyglot_disabled=['python']
colorscheme molokai                 " Located at https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
hi Normal ctermbg=black ctermfg=white

if has('mouse')
    set mouse=a                     " enable mouse mode if avail
endif

if !has('nvim')
    set ttymouse=xterm2             " needed for tmux
endif

" Set default directories for installs and swap files
set directory=$HOME/.vim
set directory^=$HOME/.vim/tmp//
set backupdir=$HOME/.vim/tmp//

set hidden            " Hides unloaded buffers instead of closing - this allows for switching between buffers without saving
set wildmenu
set relativenumber    " Make line numbering relative
set nu
set cindent
set cinkeys-=0#
set indentkeys-=0#
set showcmd		      " Display typed characters in Normal mode
set smartcase
set incsearch
set showmatch		  " Show matching brackets
set cursorline
set linebreak
set scrolloff=5       " always show 5 lines above and below cursor
set sidescrolloff=5   " always show 10 characters to left and right of line

" Tab stuff
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
autocmd Filetype tex set shiftwidth=0 " Don't autoindent for .tex files
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

" Easily open window in new tab, to simulate quick fullscreen
noremap tt :tab split<CR>
noremap tq :tabc <CR>

" Ctrl+x to unhighlight searched text
nnoremap <silent> <C-x> :nohl<CR><C-l>

" Easier buffer switching
nnoremap <A-tab> <C-6>

" Use space instead of colon for saving, quitting, copy-pasting, etc.
if has('nvim')
    function! ClipboardYank()
      call system('xclip -i -selection clipboard', @@)
    endfunction
    function! ClipboardPaste()
      let @@ = system('xclip -o -selection clipboard')
    endfunction
endif

let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :qall<CR>
nnoremap <Leader><Leader>w :wq<CR>
nmap <Leader>y y:call ClipboardYank()<cr>
vmap <Leader>y y:call ClipboardYank()<cr>
vmap <Leader>d d:call ClipboardYank()<cr>
nmap <Leader>p :call ClipboardPaste()<cr>p

" Key to toggle undo tree
nnoremap <Leader>u :UndotreeToggle <CR>

" Easier buffer switching (and set bufmru mappings)
:nnoremap <Leader>b :buffers<CR>:buffer<Space>
:nnoremap <A-Tab> :b#<CR>

" Use asterisk to search for word under cursor
nnoremap * *``
