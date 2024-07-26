-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.fillchars = "eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:▶"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.ignorecase = true
vim.opt.keymodel = { "startsel", "stopsel" }
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { space = "⋅", tab = "⇥ ", eol = "↴", trail = "―", nbsp = "␣" }
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"
vim.opt.number = true
vim.opt.selectmode = { "mouse", "key", "cmd" }
vim.opt.selection = "exclusive"
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.virtualedit = "block"
vim.opt.whichwrap:append("<>[]")
vim.opt.wrap = false

vim.diagnostic.config
{
    underline = false,
    virtual_text = { prefix = "▎ " },
    signs = true,
    severity_sort = true,
    update_in_insert = true
}

-- Keyboard mappings
local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

local function map(lhs, rhs, opts)
    vim.keymap.set({ "n", "i", "x", "s", "c" }, lhs, rhs, opts)

    if type(rhs) == "string" then
        rhs = "<C-c>" .. rhs
    end

    vim.keymap.set("o", lhs, rhs, opts)
end

map("<C-n>", vim.cmd.tabnew, { desc = "New tab" })
map("<C-o>", function() require("telescope.builtin").find_files() end, { desc = "Open..." })
map("<C-s>", vim.cmd.update, { desc = "Save" })
map("<C-w>", "<Cmd>confirm quit<CR>", { desc = "Close" })
map("<C-q>", "<Cmd>confirm quitall<CR>", { desc = "Quit" })

map("<C-z>", "<C-O>u", { desc = "Undo" })
map("<C-y>", "<C-O><C-r>", { desc = "Redo" })
map("<C-c>", "<C-O>y", { desc = "Copy" })
map("<C-x>", "<C-O>x", { desc = "Cut" })
map("<C-v>", "<C-O>P", { desc = "Paste" })
map("<C-a>", "<C-\\><C-N><C-\\><C-N>gggH<C-O>G", { desc = "Select All" })
map("<C-f>", "<Cmd>SearchBoxIncSearch<CR>", { desc = "Find..." })
map("<C-h>", "<Cmd>SearchBoxReplace confirm=menu<CR>", { desc = "Replace..." })
map("<C-j>", function() require("telescope.builtin").live_grep() end, { desc = "Find in files..." })

map("<C-r>", function() require("nvim-treesitter-refactor.smart_rename").smart_rename() end, { desc = "Rename..." })
map("<C-k>f", function() require("conform").format { async = true, lsp_fallback = true } end, { desc = "Format Buffer" })
map("<C-_>", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle Comments" })
vim.keymap.set({ "s", "x" }, "<C-_>", function() vim.api.nvim_feedkeys(esc, "nx", false) require("Comment.api").toggle.linewise(vim.fn.visualmode()) end, { desc = "Toggle Comments" })

map("<F12>", function() require("nvim-treesitter-refactor.navigation").goto_definition_lsp_fallback() end, { desc = "Go to Definition" })
map("<F24>", function() require("telescope.builtin").lsp_references() end, { desc = "Find all references..." })
map("<C-g>d", function() require("nvim-treesitter-refactor.navigation").goto_definition_lsp_fallback() end, { desc = "Go to Definition" })
map("<C-g>r", function() require("telescope.builtin").lsp_references() end, { desc = "Find all references..." })
map("<C-g>l", "<Esc><Esc>:", { desc = "Go to Line..." })

map("<C-p>", function() require("telescope.builtin").keymaps() end, { desc = "Command Palette..." })
map("<C-b>", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
map("<C-k>o", "<Cmd>Outline<CR>", { desc = "Toggle Code Outline" })
map("<C-d>", vim.diagnostic.setloclist, { desc = "Toggle Diagnostics" })
map("<C-k>d", function() require("dapui").toggle() end, { desc = "Toggle Debugger" })

map("<C-t>r", function() require("neotest").run.run() end, { desc = "Run Current Test" })
map("<C-t>R", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run All Tests" })
map("<C-t>d", function() require("neotest").run.run({strategy = "dap"}) end, { desc = "Debug Current Test" })
map("<C-t>s", function() require("neotest").run.stop() end, { desc = "Stop Current Test" })
map("<C-t>a", function() require("neotest").run.attach() end, { desc = "Attach Current Test" })

local function map_lsp(client, buffer)
    map("<F12>", require("telescope.builtin").lsp_definitions, { buffer = buffer, desc = "LSP: Go to Definition" })
    map("<F24>", require("telescope.builtin").lsp_references, { buffer = buffer, desc = "LSP: Find all References" })
    map("<C-g>d", require("telescope.builtin").lsp_definitions, { buffer = buffer, desc = "LSP: Go to Definition" })
    map("<C-g>r", require("telescope.builtin").lsp_references, { buffer = buffer, desc = "LSP: Find all References" })
    map("<C-g>i", require("telescope.builtin").lsp_implementations, { buffer = buffer, desc = "LSP: Go to Implementation" })
    map("<C-g>t", require("telescope.builtin").lsp_type_definitions, { buffer = buffer, desc = "LSP: Go to Type Definition" })
    map("<C-g>s", require("telescope.builtin").lsp_document_symbols, { buffer = buffer, desc = "LSP: Find in Document Symbols..." })
    map("<C-g>S", require("telescope.builtin").lsp_dynamic_workspace_symbols, { buffer = buffer, desc = "LSP: Find in Workspace Symbols..." })
    map("<C-r>", vim.lsp.buf.rename, { buffer = buffer, desc = "LSP: Rename" })
    map("<C-k>a", vim.lsp.buf.code_action, { buffer = buffer, desc = "LSP: Code Action" })
    map("<C-g>D", vim.lsp.buf.declaration, { buffer = buffer, desc = "LSP: Go to Declaration" })
    map("<C-d>", "<Cmd>Trouble diagnostics toggle<CR>", { buffer = buffer, desc = "Toggle Diagnostics" })

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map("<C-g>h", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buffer }) end, { buffer = buffer, desc = "LSP: Toggle Inlay Hints" })
    end
end

-- Mouse mappings
map("<M-LeftMouse>", "<4-LeftMouse>", { desc = "Start block selection" })
map("<M-LeftDrag>", "<LeftDrag>", { desc = "Block selection" })
map("<M-LeftRelease>", "", { desc = "End block selection" })

-- Context menu
vim.cmd.aunmenu("PopUp.How-to\\ disable\\ mouse")
vim.cmd.amenu("PopUp.Go\\ to\\ Definition <Cmd>lua require(\"nvim-treesitter-refactor.navigation\").goto_definition_lsp_fallback()<CR>")
vim.cmd.amenu("PopUp.Find\\ all\\ References <Cmd>lua require(\"telescope.builtin\").lsp_references()<CR>")
vim.cmd.amenu("PopUp.Rename <Cmd>lua vim.lsp.buf.rename()<CR>")
vim.cmd.amenu("PopUp.Code\\ Action <Cmd>lua vim.lsp.buf.code_action()<CR>")
vim.cmd.amenu("PopUp.LSP\\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                            { out, "WarningMsg" },
                            { "\nPress any key to exit..." } }, true, { })
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy.view.config").keys.close = "<Esc>"

-- Setup lazy.nvim
local tools = { }
local function tool(name)
    tools[name] = true
    return name
end

require("lazy").setup
{
    checker = { enabled = true, notify = false },
    install = { colorscheme = { "sonokai" } },
    spec =
    {
        -- Sacrilege
        { "ins0mniaque/sacrilege.nvim", lazy = false, priority = 1000, opts = { } },

        -- Theme
        {
            "sainnhe/sonokai",
            lazy = false,
            priority = 1000,
            config = function()
                vim.g.sonokai_enable_italic = true
                vim.opt.background = "dark"
                vim.cmd.colorscheme("sonokai")
            end
        },

        -- vim.ui overrides
        {
            "stevearc/dressing.nvim",
            opts = { input = { mappings = { i = { ["<Esc>"] = "Close" } } } }
        },

        -- Start screen
        {
            "goolord/alpha-nvim",
            dependencies =
            {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "adelarsq/vim-emoji-icon-theme"
            },
            config = function()
                local dashboard = require("alpha.themes.dashboard")
                local config = require("alpha.themes.theta").config
                local header = config.layout[2]
                local buttons = config.layout[6]

                header.opts.hl = "AlphaHeader"
                header.val =
                {
                    "                                                     ",
                    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                    "                                                     "
                }

                buttons.val =
                {
                     { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
                     { type = "padding", val = 1 },
                     dashboard.button("n", "⭐ New file", "<Cmd>tabnew<CR>"),
                     dashboard.button("o", "📂 Open file...", "<Cmd>lua require(\"telescope.builtin\").find_files()<CR>"),
                     dashboard.button("f", "🔍 Find in files...", "<Cmd>lua require(\"telescope.builtin\").live_grep()<CR>"),
                     dashboard.button("c", "⚙️  Configuration", "<Cmd>cd ~/.config/nvim/<CR>"),
                     dashboard.button("t", "🔨 Tools", "<Cmd>Mason<CR>"),
                     dashboard.button("u", "🔗 Update plugins", "<Cmd>Lazy sync<CR>"),
                     dashboard.button("q", "✖  Quit", "<Cmd>confirm quitall<CR>"),
                }

                require("alpha").setup(config)
            end
        },

        -- Buffer line
        {
            "romgrk/barbar.nvim",
            dependencies =
            {
                "lewis6991/gitsigns.nvim",
                "nvim-tree/nvim-web-devicons",
                "adelarsq/vim-emoji-icon-theme"
            },
            init = function() vim.g.barbar_auto_setup = false end,
            opts = { sidebar_filetypes = { NvimTree = true, dapui_scopes = true } }
        },

        -- Status line
        {
            "nvim-lualine/lualine.nvim",
            dependencies =
            {
                "nvim-tree/nvim-web-devicons",
                "adelarsq/vim-emoji-icon-theme"
            },
            opts = { options = { theme = "sonokai" } }
        },

        -- File explorer
        {
            "nvim-tree/nvim-tree.lua",
            lazy = false,
            dependencies =
            {
                "nvim-tree/nvim-web-devicons",
                "adelarsq/vim-emoji-icon-theme"
            },
            opts = { }
        },

        -- Code outline
        {
            "hedyhli/outline.nvim",
            opts = { }
        },

        -- Diagnostics
        {
            "folke/trouble.nvim",
            dependencies =
            {
                "nvim-tree/nvim-web-devicons",
                "adelarsq/vim-emoji-icon-theme"
            },
            opts = { }
        },

        -- Telescope
        {
            "nvim-telescope/telescope.nvim",
            event = "VimEnter",
            dependencies =
            {
                "nvim-lua/plenary.nvim",
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "make",
                    cond = function() return vim.fn.executable "make" == 1 end,
                },
                "nvim-telescope/telescope-ui-select.nvim"
            },
            config = function()
                require("telescope").setup
                {
                    defaults = { mappings = { i = { ["<esc>"] = require("telescope.actions").close } } },
                    extensions =
                    {
                        ["ui-select"] = { require("telescope.themes").get_dropdown() },
                    },
                }

                pcall(require("telescope").load_extension, "fzf")
                pcall(require("telescope").load_extension, "ui-select")
            end
        },

        -- Find and replace
        {
            "VonHeikemen/searchbox.nvim",
            dependencies = { "MunifTanjim/nui.nvim" },
            opts =
            {
                defaults = { show_matches = true },
                hooks =
                {
                    after_mount = function(input)
                        -- TODO: Fix cursor not moving on prev/next matches
                        vim.keymap.set("i", "<Up>", "<Plug>(searchbox-prev-match)", { buffer = input.bufnr })
                        vim.keymap.set("i", "<Down>", "<Plug>(searchbox-next-match)", { buffer = input.bufnr })
                        vim.keymap.set("i", "<S-Tab>", "<Plug>(searchbox-prev-match)", { buffer = input.bufnr })
                        vim.keymap.set("i", "<Tab>", "<Plug>(searchbox-next-match)", { buffer = input.bufnr })
                        vim.keymap.set("i", "<Enter>", "<Plug>(searchbox-next-match)", { buffer = input.bufnr })
                    end
                }
            }
        },

        -- Auto-tag completion
        { "windwp/nvim-ts-autotag", opts = { } },

        -- Auto-pairs completion
        { "windwp/nvim-autopairs", event = "InsertEnter", opts = { } },

        -- Rainbow delimiters
        {
            "HiPhish/rainbow-delimiters.nvim",
            opts = { },
            config = function(_, opts)
                require("rainbow-delimiters.setup").setup(opts)
            end
        },

        -- Folding
        {
            "kevinhwang91/nvim-ufo",
            dependencies =
            {
                "kevinhwang91/promise-async",
                "neovim/nvim-lspconfig"
            },
            opts =
            {
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end
            }
        },

        -- Comments
        { "numToStr/Comment.nvim", opts = { } },

        -- Highlight todo comments
        { "folke/todo-comments.nvim", event = "VimEnter", dependencies = { "nvim-lua/plenary.nvim" }, opts = { } },

        -- Colorize color representations
        { "NvChad/nvim-colorizer.lua", opts = { } },

        -- Treesitter (Highlight, edit, and navigate code)
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            opts =
            {
                auto_install = true,
                ensure_installed = { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" },
                highlight = { enable = true, additional_vim_regex_highlighting = { "ruby" } },
                indent = { enable = true, disable = { "ruby" } },
            },
            config = function(_, opts)
                require("nvim-treesitter.install").prefer_git = true
                require("nvim-treesitter.configs").setup(opts)
            end,
        },
        { "nvim-treesitter/nvim-treesitter-context", dependencies = { "nvim-treesitter/nvim-treesitter" } },
        { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
        { "nvim-treesitter/nvim-treesitter-refactor", dependencies = { "nvim-treesitter/nvim-treesitter" } },

        -- Formatting
        {
            "stevearc/conform.nvim",
            opts =
            {
                formatters_by_ft =
                {
                    lua = { tool("stylua") },
                    sh = { tool("shfmt") },
                    bash = { tool("shfmt") },
                    ["*"] = { tool("codespell") },
                    ["_"] = { "trim_whitespace" }
                }
            }
        },

        -- Linting
        {
            "mfussenegger/nvim-lint",
            event = { "BufReadPre", "BufNewFile" },
            config = function()
                local lint = require("lint")

                lint.linters_by_ft =
                {
                    sh = { tool("shellcheck") },
                    bash = { tool("shellcheck") }
                }

                vim.api.nvim_create_autocmd({ "BufWritePost" },
                {
                    group = vim.api.nvim_create_augroup("Lint", { }),
                    callback = lint.try_lint
                })
            end
        },

        -- Debugging
        {
            "mfussenegger/nvim-dap",
            opts = { tools = { tool("bash-debug-adapter") } },
            config = function()
                local dap = require("dap")

                dap.adapters.bashdb =
                {
                    type = "executable";
                    command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter";
                    name = "bashdb";
                }

                dap.configurations.sh =
                {
                    {
                        type = "bashdb";
                        request = "launch";
                        name = "Launch file";
                        showDebugOutput = true;
                        pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb";
                        pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir";
                        trace = true;
                        file = "${file}";
                        program = "${file}";
                        cwd = "${workspaceFolder}";
                        pathCat = "cat";
                        pathBash = "/bin/bash";
                        pathMkfifo = "mkfifo";
                        pathPkill = "pkill";
                        args = {};
                        env = {};
                        terminalKind = "integrated";
                    }
                }
            end
        },
        {
            "rcarriga/nvim-dap-ui",
            dependencies =
            {
                "mfussenegger/nvim-dap",
                "nvim-neotest/nvim-nio"
            },
            opts = { }
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            dependencies =
            {
                "mfussenegger/nvim-dap",
                "nvim-treesitter/nvim-treesitter"
            },
            opts = { }
        },

        -- Testing
        {
            "nvim-neotest/neotest",
            dependencies =
            {
                "nvim-neotest/nvim-nio",
                "rcasia/neotest-bash",
                "nvim-lua/plenary.nvim",
                "antoinemadec/FixCursorHold.nvim",
                "nvim-treesitter/nvim-treesitter"
            },
            config = function()
                require("neotest").setup
                {
                    adapters =
                    {
                        require("neotest-bash")
                    }
                }
            end
        },

        -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            event = { "InsertEnter", "CmdlineEnter" },
            dependencies =
            {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline"
            },
            config = function()
                local cmp = require("cmp")

                local function command(invoke)
                    local function callback(fallback)
                        if cmp.visible() then
                            invoke()
                        else
                            fallback()
                        end
                    end

                    return cmp.mapping(callback, { "n", "i", "c" })
                end

                local mapping =
                {
                    ["<Esc>"] = command(cmp.abort),
                    ["<Up>"] = command(function() cmp.select_prev_item { behavior = cmp.SelectBehavior.Select } end),
                    ["<Down>"] = command(function() cmp.select_next_item { behavior = cmp.SelectBehavior.Select } end),
                    ["<Space>"] = command(function() cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false } end),
                    ["<Tab>"] = command(function() cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false } end),
                    ["<CR>"] = command(function() cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false } end),
                    ["<C-Space>"] = command(cmp.complete)
                }

                cmp.setup
                {
                    snippet =
                    {
                        expand = function(args)
                            vim.snippet.expand(args.body)
                        end,
                    },
                    completion = { completeopt = "menu,menuone,noinsert" },
                    mapping = mapping,
                    sources =
                    {
                        { name = "lazydev", group_index = 0 },
                        { name = "nvim_lsp" },
                        { name = "buffer" },
                    },
                }

                cmp.setup.cmdline({ "/", "?" },
                {
                    mapping = mapping,
                    sources =
                    {
                        { name = "buffer" }
                    }
                })

                cmp.setup.cmdline(":",
                {
                    mapping = mapping,
                    sources =
                    {
                        { name = "path", group_index = 1 },
                        { name = "cmdline", group_index = 2 }
                    },
                    matching = { disallow_symbol_nonprefix_matching = false }
                })
            end,
        },

        -- LSP Configuration & Plugins
        {
            "neovim/nvim-lspconfig",
            event = { "BufRead", "BufNewFile" },
            dependencies =
            {
                { "williamboman/mason.nvim", opts = { } },
                "williamboman/mason-lspconfig.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                { "j-hui/fidget.nvim", opts = { } },

                -- Lua
                {
                    "folke/lazydev.nvim",
                    ft = "lua",
                    opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } }
                },
                { "Bilal2453/luvit-meta", lazy = true },
            },
            config = function()
                vim.api.nvim_create_autocmd("LspAttach",
                {
                    group = vim.api.nvim_create_augroup("LspAttach", { }),
                    callback = function(event)
                        local client = vim.lsp.get_client_by_id(event.data.client_id)

                        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                            local highlight_group = vim.api.nvim_create_augroup("LspHighlight", { })

                            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" },
                            {
                                group = highlight_group,
                                buffer = event.buf,
                                callback = vim.lsp.buf.document_highlight,
                            })

                            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
                            {
                                group = highlight_group,
                                buffer = event.buf,
                                callback = vim.lsp.buf.clear_references,
                            })

                            vim.api.nvim_create_autocmd("LspDetach",
                            {
                                group = vim.api.nvim_create_augroup("LspDetach", { }),
                                callback = function(_)
                                    vim.lsp.buf.clear_references()
                                    vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
                                end,
                            })
                        end

                        map_lsp(client, event.buf)
                    end
                })

                -- Configure capabilities
                local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())

                capabilities.textDocument.foldingRange =
                {
                    dynamicRegistration = false,
                    lineFoldingOnly = true
                }

                -- Configure servers (see `:help lspconfig-all` for a list of all the pre-configured LSPs)
                local servers =
                {
                    -- Lua
                    lua_ls =
                    {
                        settings = { Lua = { completion = { callSnippet = "Replace" } } },
                    }
                }

                local ensure_installed = vim.tbl_keys(servers or { })

                vim.list_extend(ensure_installed, vim.tbl_keys(tools or { }))

                require("mason").setup()
                require("mason-tool-installer").setup { ensure_installed = ensure_installed }
                require("mason-lspconfig").setup
                {
                    handlers =
                    {
                        function(server_name)
                            local server = servers[server_name] or { }
                            server.capabilities = vim.tbl_deep_extend("force", { }, capabilities, server.capabilities or { })
                            require("lspconfig")[server_name].setup(server)
                        end
                    }
                }
            end
        }
    }
}
