if empty(glob('~/.vim/autoload/plug.vim'))
 silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
""""""""""""""""""""
" General Settings
""""""""""""""""""""
" set scrolloff=30
" autocmd VimEnter * stopinsert
" General Settings
" autocmd VimLeave * startinsert
" set tabstop=4
syntax enable
syntax on
filetype on
filetype plugin on
filetype indent on
let g:rehash256 = 1
" set clipboard=unnamedplus       " Copy/paste between vim and other programs.
set number relativenumber       " Display line numbers
" set termguicolors
set number
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
set splitright
set t_Co=256                    " Set if term supports 256 colors.
set mouse=a
set tabstop=4
set laststatus=2
set incsearch
set nowrap
set showmode
set wildmenu
set spelllang=en
set spell

" Cursor
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred     guifg=white
" hi Normal ctermfg=#0080FF ctermbg=#333B4A
hi Cursor ctermbg=15 ctermfg=8
hi CursorLine gui=underline cterm=underline
hi CursorLine gui=underline cterm=underline  ctermbg=8 ctermfg=15 "8 =     dark gray, 15 = white

call plug#begin('~/.vim/plugged')

"call plug#begin()
" Plug 'ap/vim-css-color'
Plug 'gko/vim-coloresque'
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/drewtempelmeyer/palenight.vim'
Plug 'https://github.com/joshdick/onedark.vim'
Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/dracula/vim'
Plug 'https://github.com/chrisbra/Colorizer'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdcommenter'
Plug 'ervandew/supertab'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'crusoexia/vim-monokai'
Plug 'tribela/vim-transparent'


call plug#end()

" colorscheme nord
" colorscheme slate
" colorscheme dracula
" colorscheme palenight
colorscheme onedark
" colorscheme desert
" colorscheme monokai


nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

let g:fzf_action = { 'enter': 'tab split' }
" let g:colorizer_auto_color = 1
" let g:colorizer_syntax = 1
" let g:colorizer_hex_pattern = ['#', '\%(\x\{3}\|\x\{6}\)', '']
" au BufNewFile,BufRead *.css,*.html,*.htm  :ColorHighlight!
" augroup auto_colorize
" autocmd!
" autocmd FileType * :ColorHighlight
nnoremap <C-c> :ColorHighlight<CR>
" augroup END
" let g:colorizer_skip_comments = 1
" let g:colorizer_disable_bufleave = 1
" let g:colorizer_debug = 1

" Start NERDTree and leave the cursor in it.
" autocmd VimEnter * NERDTree

" Start NERDTree and put the cursor back in the other window.
" autocmd VimEnter * NERDTree | wincmd p

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

" resize current buffer by +/- 5 
nnoremap <C-left> :vertical resize +5<cr>
nnoremap <C-down> :resize -5<cr>
nnoremap <C-up> :resize +5<cr>
nnoremap <C-right> :vertical resize -5<cr>

nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
noremap <C-b> <Esc>:w<CR>:! ./%<CR>
" Nerd_Commenter

" Create default mappings

let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1


 let g:airline_filetype_overrides = {
      \ 'coc-explorer':  [ 'CoC Explorer', '' ],
      \ 'defx':  ['defx', '%{b:defx.paths[0]}'],
      \ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}'],
      \ 'floggraph':  [ 'Flog', '%{get(b:, "flog_status_summary", "")}' ],
      \ 'gundo': [ 'Gundo', '' ],
      \ 'help':  [ 'Help', '%f' ],
      \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
      \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
      \ 'startify': [ 'startify', '' ],
      \ 'vim-plug': [ 'Plugins', '' ],
      \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
      \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
      \ 'vaffle' : [ 'Vaffle', '%{b:vaffle.dir}' ],
      \ }

augroup CustomCursorLine
au!    
au VimEnter * :hi! CursorLine gui=underline cterm=underline
augroup END


highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
" set guicursor=n-v-c:block-Cursor
" set guicursor+=n-v-c:blinkon1
" set guicursor+=i:ver100-iCursor
" set guicursor+=i:blinkwait10

" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -e "\e[5 q"
augroup END

