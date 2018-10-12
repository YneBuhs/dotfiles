syntax on " turn on syntax highlighting

" Line settings
set number 
set numberwidth=5 " set line spacing to 5

" Searching text
set ignorecase " ignore case
set hlsearch " highlight

" Tab settings
set tabstop=2

" Vim-Plug configs
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
call plug#end() 
