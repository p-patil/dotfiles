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
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mbbill/undotree'
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

""" fzf settings
let $FZF_DEFAULT_COMMAND=""

""" gutentags settings
let g:gutentags_cache_dir = '~/.tags'     " Directory where tags files are stored (as opposed to in the root project directory)

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
filetype plugin on                  " enable filetype-specific plugins
let file_name = fnamemodify(bufname("%"), ":t")
let file_ext = matchstr(file_name, '.*\.tex')
if empty(file_ext)
    filetype indent on              " enable filetype-specific indenting, but not for tex files
    set cindent
    set indentkeys-=0#
endif

" Color settings
set rtp+=$HOME/.vim                     " colorschemes and stuff for neovim
let python_highlight_all = 1
let g:polyglot_disabled = ['python']
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

" Misc. options
set cinkeys-=0#
set cursorline        " Highlight the line where the cursor is
set hidden            " Hides unloaded buffers instead of closing - this allows for switching between buffers without saving
set incsearch         " Start searching as the search query is typed
set linebreak
set noconfirm         " Don't display 'Enter to continue' prompts
set nu                " But display the current line number next to the line, instead of 0
set relativenumber    " Make line numbering relative
set scrolloff=4       " always show 5 lines above and below cursor
set showcmd		      " Display typed characters in Normal mode
set showmatch		  " Show matching brackets
set sidescrolloff=5   " always show 10 characters to left and right of line
set smartcase
set wildmenu

" Tab stuff
set expandtab
set hlsearch
set shiftwidth=4
set smarttab
set softtabstop=0
set tabstop=4

" Don't move the cursor back a character when returning to normal mode from insert mode
imap <Esc> <Esc>l

" Motion-related key mappings

"" Swap commands for moving visual lines and moving over actual lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k

"" Map to scrolling
noremap J <C-e>
noremap K <C-y>

"" Map to smooth scrolling
noremap <silent> U :call smooth_scroll#up(&scroll, 0, 1)<CR>
noremap <silent> D :call smooth_scroll#down(&scroll, 0, 1)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 2)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 2)<CR>

" Misc. key mappings

"" Easily open window in new tab, to simulate quick fullscreen of a window
noremap tt :tab split<CR>
noremap tq :tabc <CR>

"" Ctrl+x to unhighlight searched text
nnoremap <silent> <C-x> :nohl<CR><C-l>

"" TODO(piyush) this might be redundant given the leader mappings one section below
"" Use space instead of colon for saving, quitting, copy-pasting, etc.
if has('nvim')
    function! ClipboardYank()
      call system('xclip -i -selection clipboard', @@)
    endfunction
    function! ClipboardPaste()
      let @@ = system('xclip -o -selection clipboard')
    endfunction
endif

"" Easier leader mappings
let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :qall<CR>
nnoremap <Leader><Leader>w :wq<CR>
nmap <Leader>y y:call ClipboardYank()<cr>
vmap <Leader>y y:call ClipboardYank()<cr>
vmap <Leader>d d:call ClipboardYank()<cr>
nmap <Leader>p :call ClipboardPaste()<cr>p

"" Sometimes I don't want to override the default register when editing text.
nnoremap dx "_dd

"" Debugging-related stuff
function! TodoComment(comment)
    call NERDComment('n', 'append')
    let line=getline('.')
    call setline('.', line . a:comment)
endfunction
nnoremap <expr> td getline('.')=~'^\s*$' ?":call TodoComment('TODO(piyush)')<CR><C-o>I <C-o>==<C-o>A":":call TodoComment('TODO(piyush)')<CR><C-o>A"
nnoremap <expr> tr getline('.')=~'^\s*$' ?":call TodoComment('TODO(piyush) remove')<CR><C-o>I <C-o>==<Esc>":":call TodoComment('TODO(piyush) remove')<CR><Esc>"
nnoremap <expr> tu getline('.')=~'^\s*$' ?":call TodoComment('TODO(piyush) uncomment')<CR><C-o>I <C-o>==<Esc>":":call TodoComment('TODO(piyush) uncomment')<CR><Esc>"

"" Key to toggle undo tree (depends on Undotree)
nnoremap <Leader>u :UndotreeToggle <CR>

"" Regex search (depends on eregex)
nnoremap <Leader>/ :M/

" Use asterisk to search for word under cursor
nnoremap * *``

" Buffer- and file-related key mappings

"" Easier buffer switching (and set bufmru mappings)
:nnoremap <Leader>b :Buffers<CR>
:nnoremap <A-Tab> :b#<CR>

" Fuzzy search (depends on fzf.vim)

"" Search in current buffer
:nnoremap \ :BLines<CR> 

"" Search in all open buffers
:nnoremap <Leader>\ :Lines<CR>

"" Search recursively in files in current directory, using ag
:nnoremap <Leader>a :Ag<CR> 

"" Search recursively over files names in current directory
:nnoremap <C-p> :Files<CR> 

" ctags key bindings

"" Map spacebar + d to jump to defining tag of term under cursor.
nnoremap <Leader>d <C-]>

"" Map spacebar + t to jump back from a tag to previous cursor location.
nnoremap <Leader>t <C-t>

" Save session
nnoremap <Leader>s :mksession! session.vim<CR>
