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

Plug 'https://github.com/neoclide/coc.nvim'

call plug#end()

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

nnoremap <C-d> :NERDTreeToggle <CR>
nnoremap <C-t> :terminal fish <CR>

source ~/.local/share/nvim/plugged/awesome-vim-colorschemes/colors/gruvbox.vim

