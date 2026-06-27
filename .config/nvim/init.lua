-- leaders must be set before lazy.nvim loads plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- ── Options ───────────────────────────────────────────────────────────────
local opt = vim.opt
opt.number        = true
opt.cursorline    = true
opt.showmatch     = true
opt.title         = true
opt.scrolloff     = 4
opt.termguicolors = true
opt.signcolumn    = 'yes'   -- reserve gutter; prevents layout jitter
opt.background    = 'dark'
opt.ignorecase    = true
opt.smartcase     = true
opt.hlsearch      = true
opt.incsearch     = true
opt.tabstop       = 4
opt.softtabstop   = 4
opt.shiftwidth    = 4
opt.expandtab     = true
opt.smartindent   = true
opt.autoindent    = true
opt.history       = 10000
opt.undofile      = true    -- nvim auto-manages ~/.local/state/nvim/undo
opt.autoread      = true
opt.swapfile      = false
opt.backup        = false
opt.wildmenu      = true

-- ── Keymaps ───────────────────────────────────────────────────────────────
local map = vim.keymap.set

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map('n', 'j', 'gj')
map('n', 'k', 'gk')

map('n', '<leader>ev', ':split $MYVIMRC<cr>',  { desc = 'Edit config' })
map('n', '<leader>sv', ':source $MYVIMRC<cr>', { desc = 'Source config' })
map('n', '<Esc>',      '<cmd>nohlsearch<cr>')

vim.g.netrw_banner = 0
map('n', '<leader>pv', ':30Lex<cr>', { desc = 'Project view' })

vim.cmd('command W w !sudo tee % > /dev/null')

-- ── Autocommands ──────────────────────────────────────────────────────────
local augroup  = vim.api.nvim_create_augroup
local autocmd  = vim.api.nvim_create_autocmd

-- Trim trailing whitespace on save
autocmd('BufWritePre', {
    group   = augroup('TrimWhitespace', { clear = true }),
    pattern = '*',
    callback = function()
        if not vim.bo.binary then
            local view = vim.fn.winsaveview()
            vim.cmd([[keeppatterns %s/\s\+$//e]])
            vim.fn.winrestview(view)
        end
    end,
})

-- Hard-wrap text/tex at 80 chars
autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group   = augroup('TextWrap', { clear = true }),
    pattern = { '*.txt', '*.tex' },
    callback = function() vim.opt_local.textwidth = 80 end,
})

-- Skeleton templates
autocmd('BufNewFile', {
    group   = augroup('Templates', { clear = true }),
    pattern = '*.*',
    command = [[silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e")]],
})

-- VimWiki diary
local wiki_grp = augroup('VimWikiGroup', { clear = true })
autocmd({ 'BufRead', 'BufNewFile' }, {
    group   = wiki_grp,
    pattern = 'diary.md',
    command = 'VimwikiDiaryGenerateLinks',
})
autocmd('BufNewFile', {
    group   = wiki_grp,
    pattern = vim.fn.expand('~') .. '/Drive/Notes/diary/*.md',
    command = [[silent 0r !~/.vim/bin/generate-vimwiki-diary-template.py '%']],
})

-- LSP keymaps (set per-buffer on attach)
autocmd('LspAttach', {
    group = augroup('LspKeymaps', { clear = true }),
    callback = function(ev)
        local lmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
        end
        lmap('<leader>gd', vim.lsp.buf.definition,     'Go to Definition')
        lmap('<leader>gD', vim.lsp.buf.declaration,    'Go to Declaration')
        lmap('<leader>gi', vim.lsp.buf.implementation, 'Go to Implementation')
        lmap('<leader>gr', vim.lsp.buf.references,     'References')
        lmap('<leader>gf', vim.lsp.buf.code_action,    'Code Action')
        lmap('<leader>rn', vim.lsp.buf.rename,         'Rename')
        lmap('K',          vim.lsp.buf.hover,          'Hover Docs')
    end,
})

-- ── lazy.nvim bootstrap ───────────────────────────────────────────────────
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ───────────────────────────────────────────────────────────────
require('lazy').setup({

    {
        'maxmx03/solarized.nvim',
        lazy = false, priority = 1000,
        config = function()
            require('solarized').setup()
            vim.cmd.colorscheme('solarized')
        end,
    },

    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, config = true },

    { 'folke/which-key.nvim', event = 'VeryLazy', config = true },

    -- Start screen
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('alpha').setup(require('alpha.themes.startify').config)
        end,
    },

    -- Fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>ff', '<cmd>Telescope git_files<cr>', desc = 'Find git files' },
            { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
            { '<leader>fb', '<cmd>Telescope buffers<cr>',   desc = 'Buffers' },
            { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
            { '<leader>fo', '<cmd>Telescope oldfiles<cr>',  desc = 'Recent files' },
        },
    },

    { 'lewis6991/gitsigns.nvim', config = true },

    -- master branch: Nvim 0.11 compat (main requires 0.12+)
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'master', build = ':TSUpdate', lazy = false,
        config = function()
            require('nvim-treesitter.configs').setup({
                auto_install = true,
                highlight    = { enable = true },
                indent       = { enable = true },
                ensure_installed = {
                    'clojure', 'lua', 'vim', 'vimdoc', 'markdown', 'markdown_inline',
                },
            })
        end,
    },

    -- Completion engine
    {
        'saghen/blink.cmp',
        version = '*',
        opts = {
            keymap     = { preset = 'default' },
            completion = { documentation = { auto_show = true } },
            signature  = { enabled = true },
        },
    },

    -- LSP: mason installs servers, lspconfig configures them
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'saghen/blink.cmp',
        },
        config = function()
            local caps = require('blink.cmp').get_lsp_capabilities()
            require('mason-lspconfig').setup({
                ensure_installed = { 'clojure_lsp', 'lua_ls' },
                handlers = {
                    function(server)
                        require('lspconfig')[server].setup({ capabilities = caps })
                    end,
                    ['lua_ls'] = function()
                        require('lspconfig').lua_ls.setup({
                            capabilities = caps,
                            settings = { Lua = {
                                runtime    = { version = 'LuaJIT' },
                                workspace  = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
                                diagnostics = { globals = { 'vim' } },
                                telemetry  = { enable = false },
                            }},
                        })
                    end,
                },
            })
        end,
    },

    -- Format on save
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        opts  = {
            formatters_by_ft = { lua = { 'stylua' } },
            format_on_save   = { timeout_ms = 500, lsp_fallback = true },
        },
    },

    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },

    -- Clojure REPL
    { 'Olical/conjure' },

    -- Wiki / diary
    {
        'vimwiki/vimwiki',
        init = function()
            vim.g.vimwiki_list       = {{ path = '~/Drive/Notes', syntax = 'markdown', ext = '.md' }}
            vim.g.vimwiki_global_ext = 0
        end,
    },

}, { change_detection = { notify = false } })
