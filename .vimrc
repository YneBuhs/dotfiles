syntax on " turn on syntax highlighting

" Line settings
set number 
set numberwidth=5 " set line spacing to 5

" Searching text
set ignorecase " ignore case
set hlsearch " highlight

" Tab settings
set tabstop=2
set expandtab
set autoindent " insert comment here
set shiftwidth=2

" Swap files
set noswapfile "disable swap files
set backup "enable backup files
set writebackup "write backup files
set backupdir=~/.vim/tmp/backups// "directory to save backup files
set undofile "set ability to undo previous changes in a file after persistence
set undoreload=1000 "number of undos a file can have after persistence

" Plugins
" To install, run `:PlugInstall`
call plug#begin()
" Git 
Plug 'tpope/vim-fugitive'

" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Autocomplete
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-surround' "'cs' command to change pair (cs'[) changes single quote to []

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
call plug#end() 

let g:airline_theme = 'dracula'

" Mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>

" NERDTree configs
map <C-n> :NERDTreeToggle<CR>
