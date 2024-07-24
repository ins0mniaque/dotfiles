-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
vim.opt.clipboard = 'unnamedplus'
vim.opt.expandtab = true
vim.opt.keymodel = { 'startsel', 'stopsel' }
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { space = '⋅', tab = '⇥ ', eol = '↴', trail = '―', nbsp = '␣' }
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup_setpos'
vim.opt.number = true
vim.opt.selectmode = { 'mouse', 'key', 'cmd' }
vim.opt.selection = 'exclusive'
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = 'block'
vim.opt.whichwrap:append('<>[]')

local function map(lhs, rhs, opts)
    vim.keymap.set('n', lhs, rhs, opts)
    vim.keymap.set('i', lhs, rhs, opts)
    vim.keymap.set('x', lhs, rhs, opts)
    vim.keymap.set('s', lhs, rhs, opts)
    vim.keymap.set('c', lhs, rhs, opts)

    if type(rhs) == 'string' then
        rhs = '<C-c>' .. rhs
    end

    vim.keymap.set('o', lhs, rhs, opts)
end

-- Keyboard mappings
map('<C-n>', '<Cmd>tabnew<CR>', { desc = 'New tab' })
map('<C-t>', '<Cmd>tabnew<CR>', { desc = 'New tab' })
map('<C-o>', function() require('telescope.builtin').find_files() end, { desc = 'Open...' })
map('<C-s>', '<Cmd>update<CR>', { desc = 'Save' })
map('<C-q>', '<Cmd>qa<CR>', { desc = 'Quit' })
map('<C-z>', '<C-O>u', { desc = 'Undo' })
map('<C-S-z>', '<C-O><C-r>', { desc = 'Redo' })
map('<C-y>', '<C-O><C-r>', { desc = 'Redo' })
map('<C-c>', '<C-O>y', { desc = 'Copy' })
map('<C-x>', '<C-O>x', { desc = 'Cut' })
map('<C-v>', '<C-O>P', { desc = 'Paste' })
map('<C-a>', '<C-\\><C-N><C-\\><C-N>gggH<C-O>G', { desc = 'Select All' })
map('<C-f>', '<C-\\><C-N><C-\\><C-N>/', { desc = 'Find...' })
map('<F4>', '<C-\\><C-N><C-\\><C-N><left>gN', { desc = 'Find Previous' })
map('<F3>', '<C-\\><C-N><C-\\><C-N>gn', { desc = 'Find Next' })
map('<C-p>', '<Cmd>Telescope<CR>', { desc = 'Command Palette...' })
map('<C-b>', '<Cmd>NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })

-- Mouse mappings
map('<M-LeftMouse>', '<4-LeftMouse>', { desc = 'Start block selection' })
map('<M-LeftDrag>', '<LeftDrag>', { desc = 'Block selection' })
map('<M-LeftRelease>', '', { desc = 'End block selection' })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
                            { out, 'WarningMsg' },
                            { '\nPress any key to exit...' } }, true, { })
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup
{
    checker = { enabled = true },
    install = { colorscheme = { 'sonokai' } },
    spec =
    {
        -- Sacrilege
        { 'ins0mniaque/sacrilege.nvim', lazy = false, priority = 1000, opts = { } },

        -- Theme
        {
            'sainnhe/sonokai',
            lazy = false,
            priority = 1000,
            config = function()
                vim.g.sonokai_enable_italic = true
                vim.cmd.colorscheme('sonokai')
            end
        },

        -- Buffer line
        {
            'romgrk/barbar.nvim',
            dependencies =
            {
                'lewis6991/gitsigns.nvim',
                'nvim-tree/nvim-web-devicons',
                'adelarsq/vim-emoji-icon-theme'
            },
            init = function() vim.g.barbar_auto_setup = false end,
            opts = { sidebar_filetypes = { NvimTree = true } }
        },

        -- Status line
        {
            'nvim-lualine/lualine.nvim',
            dependencies =
            {
                'nvim-tree/nvim-web-devicons',
                'adelarsq/vim-emoji-icon-theme'
            },
            opts = { options = { theme = 'sonokai' } }
        },

        -- File explorer
        {
            'nvim-tree/nvim-tree.lua',
            lazy = false,
            dependencies =
            {
                'nvim-tree/nvim-web-devicons',
                'adelarsq/vim-emoji-icon-theme'
            },
            opts = { }
        },

        -- Telescope
        {
            'nvim-telescope/telescope.nvim',
            event = 'VimEnter',
            dependencies =
            {
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    build = 'make',
                    cond = function() return vim.fn.executable 'make' == 1 end,
                },
                'nvim-telescope/telescope-ui-select.nvim'
            },
            config = function()
                require('telescope').setup
                {
                    defaults = { mappings = { i = { ['<esc>'] = require('telescope.actions').close } } },
                    extensions =
                    {
                        ['ui-select'] = { require('telescope.themes').get_dropdown() },
                    },
                }

                pcall(require('telescope').load_extension, 'fzf')
                pcall(require('telescope').load_extension, 'ui-select')
            end
        },

        -- TODO: LSP/treesitter/cmp
    }
}