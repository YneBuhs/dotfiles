" ----------------------------------------------------------------------------
" Mappings
" ----------------------------------------------------------------------------
let mapleader="'"

" open fold with space
nnoremap <Leader><Space> za

" Rspec tests
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
noremap <Space> :set nohlsearch<CR>:echo ''<CR>

" move vertically by visual line
nnoremap j gj
nnoremap k gk
nnoremap - ddp
nnoremap _ ddkP
nnoremap + yyp
nnoremap <leader>+ <C-w>>
nnoremap <leader>- <C-w><
nnoremap == :winc =<CR>:echo ''<CR>
nnoremap ; :
nnoremap : ;

" NERDTree configs
map <C-n> :NERDTreeToggle<CR>

"  editing config files
nnoremap <leader>ev :vsp ~/.vimrc<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>

" ----------------------------------------------------------------------------
"  Abbreviations and Autocommands
" ----------------------------------------------------------------------------
iabbrev componenet component
iabbrev Componenet Component

" Remove trailing white space
autocmd BufWritePre * %s/\s\+$//e

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------
syntax on " turn on syntax highlighting
let base16colorspace=256
colorscheme base16-ocean
let g:airline_theme = 'base16'
set backspace=2 " make backspace work like most other programs
set nostartofline " ensure scrolling doesn't put cursor at start of line
set cursorline
let g:signify_vcs_list = ['git']

" Line and SignColumn settings
set number
set numberwidth=1
set nowrap
highlight LineNr ctermfg=grey ctermbg=NONE

" ----------------------------------------------------------------------------
"  Folding
" ----------------------------------------------------------------------------
set foldmethod=indent " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
set foldlevelstart=10   " start with fold level of 1

" ----------------------------------------------------------------------------
"  Text Navigation
" ----------------------------------------------------------------------------
" Searching text
set ignorecase " ignore case
set hlsearch " highlight text

" Tab settings
set tabstop=2
set expandtab
set autoindent " insert comment here
set shiftwidth=2
set shiftround " round indent to multipe of 'shiftwidth'

" ----------------------------------------------------------------------------
" Swap files
" ----------------------------------------------------------------------------
set noswapfile "disable swap files
set backup "enable backup files
set writebackup "write backup files
set backupdir=~/.vim/tmp/backups// "directory to save backup files
set undofile "set ability to undo previous changes in a file after persistence
set undoreload=1000 "number of undos a file can have after persistence

" ----------------------------------------------------------------------------
"  Globals
" ----------------------------------------------------------------------------
let g:closetag_xhtml_filenames = '*.jsx'
let g:UltiSnipsExpandTrigger="<C-l>"

" ----------------------------------------------------------------------------
"  File Navigation
" ----------------------------------------------------------------------------
"CTRL+P
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
if executable('rg')
  set grepprg=rg--color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" ----------------------------------------------------------------------------
"  Plugins
"  To install, run `:PlugInstall`
" ----------------------------------------------------------------------------
call plug#begin()
Plug 'wakatime/vim-wakatime'

" Make code prettier
Plug 'tomtom/tcomment_vim'
Plug 'sheerun/vim-polyglot'
Plug 'mxw/vim-jsx' " JSX syntax
Plug 'vim-syntastic/syntastic' " For errors, check bottom right, put cursor on line to see error
" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" ==============================================================================
" SIGNS                                                            *signify-signs*
"     `+`     This line was added.
"     `!`     This line was modified.
"     `_1`    The number of deleted lines below this sign. If the number is larger
"     `99`    than 9, the `_` will be omitted. For numbers larger than 99, `_>`
"     `_>`    will be shown instead.
"     `!1`    This line was modified and a number of lines below were deleted.
"     `!>`    It is a combination of `!` and `_`. If the number is larger than 9,
"           `!>` will be shown instead.
"
"     `‾`     The first line was removed. It's a special case of the `_` sign.
"
" See |g:signify_sign_add| on how to use different signs.
" ==============================================================================

" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

" Autocomplete
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-ragtag'
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround' "'cs' command to change pair (cs'[) changes single quote to []
                          "'yss[x]' wrap entire line in delimiter
                          "'ysiw[x]' wrap x delimiter around word
                          "'ds[x]' command to delete x delimiter
                          "'S' for delimiters around visual blocks
Plug 'ajh17/VimCompletesMe'
Plug 'tpope/vim-repeat'
" Search
Plug 'ctrlpvim/ctrlp.vim'

" Syntax Highlighting Plugins
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'pangloss/vim-javascript'

" Testing
Plug 'thoughtbot/vim-rspec'

" NERDTree
Plug 'scrooloose/nerdtree'

" React code snippets
Plug 'epilande/vim-react-snippets' " check here: https://github.com/epilande/vim-react-snippets

" Ultisnips
Plug 'SirVer/ultisnips'
call plug#end()
