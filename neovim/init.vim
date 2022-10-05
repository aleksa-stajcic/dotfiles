filetype plugin indent on
set number
set relativenumber
" set ignorecase
set nowrap
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set scrolloff=8
set cursorline

" termguicolors isn't supported by Terminal.app
" and some other terminal emulators
" so need to run `:set termguicolors!` and `:set background=dark`
" otherwise the light colorscheme will look weird
set termguicolors
set background=light
colorscheme gruvbox

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Set <leader>
let mapleader = "\<space>"

" Normal mode remaps
nnoremap <leader>; mkA;<Esc>`k
nnoremap <leader>, mkA,<Esc>`k
nmap <leader>[ A<space>{<Enter><Esc>O
nnoremap <leader>d "_d
nnoremap <leader>t :term<Enter>
nnoremap <leader>s a¯\_(ツ)_/¯<Esc>

nnoremap <leader>h :nohl<Enter>

" Insert mode remaps
" Auto-complete brackets and quotes
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap ' ''<left>
" inoremap \" \""<left>

" Visual mode remaps
vnoremap <leader>d "_d
vnoremap <leader>y "*y

" Setting wrap for minified js files
au BufRead js_*.js set wrap
au BufNewFile,BufRead *.md set wrap
au BufNewFile,BufRead *.txt set wrap

""" Plugins
call plug#begin('~/.config/nvim/plugged')

" Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Completion framework
Plug 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'

" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" See hrsh7th's other plugins for more completion sources!

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Fuzzy finder
" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Colorscheme
Plug 'morhetz/gruvbox'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Phpactor
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

call plug#end()

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

-- vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})

require('rust-tools').setup(opts)
EOF

" phpactor lsp setup
" default settings
lua <<EOF
 require'lspconfig'.phpactor.setup{
     on_attach = on_attach,
     init_options = {
         ["language_server_phpstan.enabled"] = false,
         ["language_server_psalm.enabled"] = false,
     }
 }
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF
