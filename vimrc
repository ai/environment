set nocompatible "Use vim features, instead of vi

filetype off "Fix pathogem bundles loading

" Load plugins from ~/.vim/bundles subdirs
call pathogen#runtime_append_all_bundles()

syntax on "Enable syntax highlight

" Color scheme (only for supported output)
if &t_Co >= 256 || has("gui_running")
    colorscheme mustang
endif

let mapleader="," "Change start symbol of aliases
"Use ; as : to enter command
nnoremap ; :

set hidden "Hide buffers, instead of close
set nowrap "Don’t wrap lines
set number "Show line numbers
set title "Change terminal title
set fileencodings=utf8,cp1251 "Autodetech order

set nobackup "Don’t create backup~ file
set noswapfile "Don’t create swap.swp file
set backspace=indent,eol,start "Backspacing over everything in insert mode

set guioptions-=T "Remove toolbar from GVim

" Tabs
set tabstop=4 "Tab size
set shiftwidth=4 "Autoindent size
set expandtab "Use space instead of tab
set autoindent "Enable autoindent
set copyindent "Copy tabs from previous line
set smarttab "insert tabs on the start of a line, not tabstop
filetype plugin indent on

" Languages with another indent
autocmd filetype ruby set shiftwidth=2
autocmd filetype haml set shiftwidth=2
autocmd filetype yaml set shiftwidth=2
autocmd filetype javascript set shiftwidth=4

" Search
set ignorecase smartcase "Ignore case if search pattern is all lowercase
set hlsearch "Highlight search terms
set incsearch "Show search matches as you type
set gdefault "Search/replace globally (on a line) by default
set showmatch "Show matching parenthesis
nmap <silent> ,/ :nohlsearch<CR>

" Ignore in file completing
set wildignore=.git,*.jpg,*.png
:set wildignore+=vendor

set history=1000 "Remember 1000 commands and search history
set undolevels=1000 "Use many much levels of undo

" Show tabs and trail spaces
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

" Enable mouse
if has("mouse")
    set mouse=a
endif

" Save file by sudo on w!!
cmap w!! w !sudo tee % >/dev/null

" Spell
setlocal spell spelllang=
setlocal nospell
function ToggleSpell()
    if &spelllang =~ "en,ru_yo"
        setlocal spell spelllang=
        echo "Не проверять орфографию"
    else
        setlocal spell spelllang=en,ru_yo
        echo "Проверять орфографию"
    endif
endfunc
map <C-s> :call ToggleSpell()<cr>

" Enable to use Russian keyboard layout in command mode
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl;'zxcvbnm,.~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>

" Plugins

" NERD Commenter
map <C-c> :call NERDComment(0, 'invert')<cr>
