" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')

" better integration with netrw
" - press '-' to explore the directory of the current buffer
" - press 'gh' to toggle hidden files hiding
" - press '.' to start cmd mode prepopulated with the file name under the
"   cursor
" - press 'y.' to yank the absolute path of the file under the cursor
" - press '~' to go to HOME
" - press 'CTRL-^' to jump back to previous buffer
"
" Netwr is okay for navigating the file system so I use it for it.
" For interactive fs operations, I find netwr confusing so I use the terminal
" instead.
"
" useful netrw commands:
" - cycle between different layouts: i
" - refresh view: <c-l>
" - jump one directory up: -
" - preview file: p
" - close preview window <c-w>z
Plug 'tpope/vim-vinegar'

" tree sitter, useful for AST-based syntax highlighting
" to install the JavaScript language, use ':TSInstall javascript'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Initialize plugin system
call plug#end()


" Use tree sitter for syntax highlighting
lua <<EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}
EOF

" Use tree sitter for indentation when using the = command
lua <<EOF
require'nvim-treesitter.configs'.setup {
	indent = {
		enable = true
	}
}
EOF
