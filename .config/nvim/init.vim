set encoding=UTF-8

set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set number
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set scrolloff=8
set noswapfile
set expandtab

call plug#begin()

Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/ap/vim-css-color'

Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-commentary'

call plug#end()

nnoremap <C-d> :NERDTreeToggle <CR>
nnoremap <C-t> :terminal fish <CR>

source ~/.local/share/nvim/plugged/awesome-vim-colorschemes/colors/gruvbox.vim
