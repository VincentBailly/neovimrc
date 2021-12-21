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

" theme
Plug 'mhartington/oceanic-next'

" LSP config
Plug 'neovim/nvim-lspconfig'
" Initialize plugin system

" Snipets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
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


" set the << and >> command to use 2 spaces for indentation
set shiftwidth=2

" insert a tab will instead insert spaces instead
set expandtab

" don't kill a buffer when we navigate away from it
" This is useful to not loose the terminal buffer.
" It is also useful to navigate from one file to another without the need to
" save the former (useful to look up definitions of functions when coding)
set hidden

" disabling smartindent and autoindent because they don't always do what I
" expect. For formatting the code I prefere to rely on actual code formatting
" tools like prettier
set nosmartindent
set noautoindent
set nocindent
set indentexpr=

" theme
set termguicolors
colorscheme OceanicNext
set background=dark

" make it easier to exit insert mode on the terminal
:tnoremap <M-x> <C-\><C-n>

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

"initialize tsserver
" Note that this requires to have typescript-language-server installed locally
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

end
require'lspconfig'.tsserver.setup{
  init_options = {
    hostInfo = 'neovim',
    maxTsServerMemory = 16000,
    preferences = {
      disableSuggestions = true
    }
  },
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
}
EOF


" make neovim used as git editor
let $GIT_EDITOR = 'nvr -cc split --remote-wait'
" make git buffer deleted when hidden
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
