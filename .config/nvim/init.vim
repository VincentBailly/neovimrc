" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')

" better integration with netwk
" - press '-' to explore the directory of the current buffer
" - press 'gh' to toggle hidden files hiding
" - press '.' to start cmd mode prepopulated with the file name under the
"   cursor
" - press 'y.' to yank the absolute path of the file under the cursor
" - press '~' to go to HOME
" - press 'CTRL-^' to jump back to previous buffer
Plug 'tpope/vim-vinegar'

" Initialize plugin system
call plug#end()
