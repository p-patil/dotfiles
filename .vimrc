set nocompatible
let mapleader = "\<Space>" " At the top so can be used for mappings below

" VIM-PLUG PLUGINS
"" Install with:
""" for vi(m): curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
""" for neovim: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

"" Helper function for conditionally loading plugins
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
Plug 'mbbill/undotree'
Plug 'mhinz/vim-signify'
Plug 'othree/eregex.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
Plug 'terryma/vim-smooth-scroll'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'

"" Vim plugins
""" None so far. Example usage: Plug 'example', Cond(!has('nvim'))

"" Neovim plugins
Plug 'Shougo/deoplete.nvim', Cond(has('nvim'), { 'do': ':UpdateRemotePlugins' })
"TODO(piyush) remove if tabnine works well
"Plug 'artur-shaik/vim-javacomplete2', Cond(has('nvim'))
"Plug 'autozimu/LanguageClient-neovim', {
    "\ 'branch': 'next',
    "\ 'do': 'bash install.sh',
    "\ }
"Plug 'deoplete-plugins/deoplete-jedi', Cond(has('nvim'))

call plug#end()



" PLUGIN SETTINGS

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

""" nerdtree settings
map <C-n> :NERDTreeToggle<CR>
map <Leader>N :NERDTreeFind<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " Close vim if the only open window left is nerdtree

""" vim-signify settings
let g:signify_realtime = 1

"" Vim plugins
if (!has('nvim'))
    " None so far; put vim-only plugins here
endif

"" Neovim plugins
if (has('nvim')) 
    """ Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    """" Use tab for completion
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"

    """ LanguageClient_neovim "TODO(piyush) remove if tabnine works well
    "let g:LanguageClient_serverCommands = {
      "\ 'c': ['/home/piyush/bin/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
      "\ 'cpp': ['/home/piyush/bin/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
      "\ 'cuda': ['/home/piyush/bin/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
      "\ 'objc': ['/home/piyush/bin/ccls/Release/ccls', '--log-file=/tmp/cc.log'],
      "\ }
    "let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
    "let g:LanguageClient_settingsPath = '/home/piyush/.config/nvim/settings.json'
    "" https://github.com/autozimu/LanguageClient-neovim/issues/379 LSP snippet is not supported
    "let g:LanguageClient_hasSnippetSupport = 0
    "let g:LanguageClient_diagnosticsEnable = 0

    """ undotree
    if has("persistent_undo")
        set undodir=~/.vim/.undodir/
        set undofile
    endif
    """" Key to toggle undo tree (depends on Undotree)
    nnoremap <Leader>u :UndotreeToggle <CR>

    """ ale
    let g:ale_on_text_changed = 'never'
    let g:ale_sign_column_always=1
    let g:ale_fixers = {'python': ['autopep8'], 'c++': ['clang-format']}
    nnoremap <Leader>A :ALEToggle<CR>
endif



" MOTION-RELATED

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



" SEARCH-RELATED

"" Regex search (depends on eregex)
nnoremap <Leader>/ :M/

"" Only highlight word under cursor, don't jump to next match or scroll.
"" Explanation:
"" 1. To prevent the defualt register from being overwritten, save it into
""    register a.
"" 2. Set a mark at the current cursor position so we can restore it later.
"" 3. Visually select the word under the cursor and yank into register z.
"" 4. Then move back to the mark to restore cursor position.
"" 5. Paste from register z into the search register.
"" 6. Highlight the matches.
nnoremap * :let @a=@"<CR>mxviw"zy:let @"=@a<CR>:let @/='\<<C-r>z\>'<CR>:set hlsearch<CR>`x

"" Ctrl+x to unhighlight searched text
nnoremap <silent> <C-x> :nohl<CR><C-l>

"" Fuzzy search (depends on fzf.vim) stuff below

""" Search in current buffer
:nnoremap \ :BLines<CR> 

""" Search in all open buffers
:nnoremap <Leader>\ :Lines<CR>

""" Search recursively in files in current directory, using ag
:nnoremap <Leader>a :Ag<CR> 

""" Search recursively over files names in current directory
:nnoremap <C-p> :Files<CR> 



" BUFFER-, TAB-, AND FILE-RELATED

"" Easier buffer switching (and set bufmru mappings)
:nnoremap <Leader>b :Buffers<CR>
:nnoremap <A-Tab> :b#<CR>

"" Previous tab
nnoremap gr gT

" Save session
nnoremap <Leader>s :mksession! session.vim<CR>
nnoremap <Leader>S :mksession!

" Close buffer without closing its window, instead switching to previous buffer.
nnoremap :bdp :bp\|bd #<CR>

" Close all hidden buffers.
function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
command! Bdh call DeleteHiddenBuffers()



" DEBUGGING-RELATED

"" Easily add todo comments
function! TodoComment(comment)
    call NERDComment('n', 'append')
    let line=getline('.')
    call setline('.', line . a:comment)
endfunction
nnoremap <expr> td getline('.')=~'^\s*$' ?":call TodoComment('TODO(piyush)')<CR><C-o>I <C-o>==<C-o>A":":call TodoComment('TODO(piyush)')<CR><C-o>A"
nnoremap <expr> tr getline('.')=~'^\s*$' ?":call TodoComment('TODO(piyush) remove')<CR><C-o>I <C-o>==<Esc>":":call TodoComment('TODO(piyush) remove')<CR><Esc>"
nnoremap <expr> tu getline('.')=~'^\s*$' ?":call TodoComment('TODO(piyush) uncomment')<CR><C-o>I <C-o>==<Esc>":":call TodoComment('TODO(piyush) uncomment')<CR><Esc>"
"" Make a copy of the current line right below it, and comment out the original. Useful for
"" debugging purposes.
nnoremap <Leader>n Ypk:call NERDComment('n', 'Comment')<CR>j



" GENERAL SETTINGS

"" Syntax
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

"" Color settings
set rtp+=$HOME/.vim
let python_highlight_all = 1
let g:polyglot_disabled = ['python']
hi Normal ctermbg=black ctermfg=white
colorscheme molokai " Located at https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim

"" Enable mouse mode if available
if has('mouse')
    set mouse=a
endif

"" Needed for tmux
if !has('nvim')
    set ttymouse=xterm2 
endif

"" Set default directories for installs and swap files
set directory=$HOME/.vim
set directory^=$HOME/.vim/tmp//
set backupdir=$HOME/.vim/tmp//

"" Misc. options
set cinkeys-=0#           " Don't unindent when typing # in insert mode
set completeopt-=preview  " Disable previewing.
set cursorline            " Highlight the line where the cursor is
set hidden                " Hides unloaded buffers instead of closing - this allows for switching between buffers without saving
set hlsearch              " Highlight search matches
set incsearch             " Start searching as the search query is typed
set linebreak             " Don't let vim split words when it text wraps over window size
set noconfirm             " Don't display 'Enter to continue' prompts
set nu                    " But display the current line number next to the line, instead of 0
set relativenumber        " Make line numbering relative
set scrolloff=4           " always show 5 lines above and below cursor
set showcmd		          " Display typed characters in Normal mode
set showmatch	          " Show matching brackets
set sidescrolloff=5       " always show 10 characters to left and right of line
set smartcase             " All-lowercase patterns are case-insensitive, but otherwise case-sensitive
set wildmenu              " Command-line completion

"" Wrap git commit messages to 72 characters
au FileType gitcommit set tw=72

"" Tab (character, not window) stuff
set expandtab     " Use spaces when tab key is pressed
set shiftwidth=4  " The amount to indent or de-indent with >> or << operators
set smarttab      " Intelligent auto-indenting
set softtabstop=0 " Turn soft tab stop (which allows indenting between tabs) off
set tabstop=4    " Number of spaces equal to a tab



" MISC. KEY MAPPINGS

"" Don't move the cursor back a character when returning to normal mode from insert mode
imap <Esc> <Esc>l

"" Easily open window in new tab, to simulate quick fullscreen of a window
noremap tt :tab split<CR>
noremap tq :tabc <CR>

"" Omit the <C-w> when switching between windows.
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"" Easier leader mappings that use space instead of colon for saving, quitting, copy-pasting, etc.
nnoremap <Leader>w :wall<CR>
nnoremap <Leader>q :qall<CR>
nnoremap <Leader><Leader>w :wq<CR>
nmap <Leader>y y:call ClipboardYank()<cr>
vmap <Leader>y y:call ClipboardYank()<cr>
vmap <Leader>d d:call ClipboardYank()<cr>
nmap <Leader>p :call ClipboardPaste()<cr>p
if has('nvim')
    function! ClipboardYank()
      call system('xclip -i -selection clipboard', @@)
    endfunction
    function! ClipboardPaste()
      let @@ = system('xclip -o -selection clipboard')
    endfunction
endif

"" Command to see changes to file since last save
command! Df :w ! diff -C 1 % -

"" Shortcut to redirect output of a vim command, e.g. to file. NOTE: There
"" cannot be a space between the '>' and file name.
funct! Redir(command, to)
  exec 'redir '.a:to
  exec a:command
  redir END
endfunct
command! -nargs=+ R call call(function('Redir'), split(<q-args>, '\s\(\S\+\s*$\)\@='))
