-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nerd Font
vim.g.nerdfont = os.getenv("NERDFONT") and true or false

-- Options
function _G.foldtext()
    local line = vim.fn.getline(vim.v.foldstart)
    local lines = vim.v.foldend - vim.v.foldstart + 1
    local percentage = math.floor(lines / vim.fn.line("$") * 100 + 0.5)

    return line .. "…    [ " .. lines .. " lines / " .. percentage .. "% ]"
end

vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
vim.opt.expandtab = true
vim.opt.fillchars = vim.g.nerdfont and "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
                                   or  "eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:▶"
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldtext = "v:lua.foldtext()"
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { space = "⋅", tab = "⇥ ", eol = "↴", trail = "―", nbsp = "␣" }
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.whichwrap:append("<>[]")
vim.opt.wrap = false

vim.diagnostic.config
{
    underline = false,
    virtual_text =
    {
        prefix = function(diagnostic)
              if     diagnostic.severity == vim.diagnostic.severity.ERROR then return vim.g.nerdfont and "" or "ⓧ"
              elseif diagnostic.severity == vim.diagnostic.severity.WARN  then return vim.g.nerdfont and "" or "⚠️"
              elseif diagnostic.severity == vim.diagnostic.severity.INFO  then return vim.g.nerdfont and "" or "ⓘ"
              else                                                             return vim.g.nerdfont and "󰌵" or "💡"
              end
        end,
    },
    signs = true,
    severity_sort = true,
    update_in_insert = true
}

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
vim.api.nvim_create_autocmd("FileType",
{
    group = vim.api.nvim_create_augroup("LazyConfig", { }),
    pattern = "lazy",
    callback = function()
        vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(0, false) end, { buffer = true, nowait = true })
    end
})

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
    ui =
    {
        icons = vim.g.nerdfont and { } or
        {
            cmd = "⌘", config = "🛠", event = "📅", ft = "📂", init = "⚙",
            keys = "🗝", plugin = "🔌", runtime = "💻", require = "🌙",
            source = "📄", start = "🚀", task = "📌", lazy = "💤 "
        }
    },
    spec =
    {
        -- Sacrilege
        {
            "ins0mniaque/sacrilege.nvim",
            opts =
            {
                language = "pseudo",
                presets = { "default", "dap", "dap-ui", "neotest", "telescope", "nvim-cmp", "nvim-tree", "outline", "secrets" },
                commands = function(commands)
                    commands.format:override(function() require("conform").format({ async = true, lsp_fallback = true }) end):visual(false)
                    commands.diagnostics:override("<Cmd>Trouble diagnostics toggle<CR>")
                end
            }
        },

        -- Fix CursorHold update time
        { "antoinemadec/FixCursorHold.nvim", config = function() vim.g.cursorhold_updatetime = 100 end },

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
                { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerdfont }
            },
            config = function()
                local dashboard = require("alpha.themes.dashboard")
                local theta     = require("alpha.themes.theta")

                theta.header.opts.hl = "AlphaHeader"
                theta.header.val =
                {
                    "                                           ███                 ",
                    "                                          ░░░                  ",
                    " ████████    ██████   ██████  █████ █████ ████  █████████████  ",
                    "░░███░░███  ███░░███ ███░░███░░███ ░░███ ░░███ ░░███░░███░░███ ",
                    " ░███ ░███ ░███████ ░███ ░███ ░███  ░███  ░███  ░███ ░███ ░███ ",
                    " ░███ ░███ ░███░░░  ░███ ░███ ░░███ ███   ░███  ░███ ░███ ░███ ",
                    " ████ █████░░██████ ░░██████   ░░█████    █████ █████░███ █████",
                    "░░░░ ░░░░░  ░░░░░░   ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░ "
                }

                theta.buttons.val =
                {
                     { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
                     { type = "padding", val = 1 },
                     dashboard.button("n", (vim.g.nerdfont and "  " or "⭐ ") .. "New file", "<Cmd>tabnew<CR>"),
                     dashboard.button("o", (vim.g.nerdfont and "  " or "📂 ") .. "Open file...", "<Cmd>lua require(\"telescope\").extensions.file_browser.file_browser()<CR>"),
                     dashboard.button("f", (vim.g.nerdfont and "󰈞  " or "🔍 ") .. "Find in files...", "<Cmd>lua require(\"telescope.builtin\").live_grep()<CR>"),
                     dashboard.button("c", (vim.g.nerdfont and "  " or "⚙️  ") .. "Configuration", "<Cmd>cd ~/.config/nvim/<CR>"),
                     dashboard.button("t", (vim.g.nerdfont and "  " or "🔨 ") .. "Tools", "<Cmd>Mason<CR>"),
                     dashboard.button("u", (vim.g.nerdfont and "  " or "🔗 ") .. "Update plugins", "<Cmd>Lazy sync<CR>"),
                     dashboard.button("q", (vim.g.nerdfont and "󰅚  " or "✖  ") .. "Quit", "<Cmd>confirm quitall<CR>"),
                }

                theta.nvim_web_devicons.enabled = vim.g.nerdfont

                require("alpha").setup(theta.config)
            end
        },

        -- Buffer line
        {
            "romgrk/barbar.nvim",
            dependencies =
            {
                "lewis6991/gitsigns.nvim",
                { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerdfont }
            },
            init = function() vim.g.barbar_auto_setup = false end,
            opts =
            {
                sidebar_filetypes = { NvimTree = true, Outline = true, dapui_scopes = true },
                icons = { button = not vim.g.nerdfont and "✖" or nil, filetype = { enabled = vim.g.nerdfont } }
            }
        },

        -- Status column
        {
            "luukvbaal/statuscol.nvim",
            dependencies =
            {
                "lewis6991/gitsigns.nvim",
                { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerdfont }
            },
            config = function()
                local builtin = require("statuscol.builtin")

                require("statuscol").setup
                {
                    segments =
                    {
                        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                        { text = { "%s" }, click = "v:lua.ScSa" },
                        {
                            text = { builtin.lnumfunc, " " },
                            condition = { true, builtin.not_empty },
                            click = "v:lua.ScLa",
                        }
                    }
                }
            end
        },

        -- Status line
        {
            "nvim-lualine/lualine.nvim",
            dependencies =
            {
                { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerdfont }
            },
            opts = { options = { theme = "sonokai", icons_enabled = vim.g.nerdfont },
                     sections = { lualine_c = { "nvim_treesitter#statusline" } } }
        },

        -- File explorer
        {
            "nvim-tree/nvim-tree.lua",
            lazy = false,
            dependencies =
            {
                { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerdfont }
            },
            opts = { }
        },

        -- Code outline
        {
            "hedyhli/outline.nvim",
            opts =
            {
                keymaps =
                {
                    goto_location = { "<CR>", "<2-LeftMouse>" }
                }
            }
        },

        -- Diagnostics
        {
            "folke/trouble.nvim",
            dependencies =
            {
                { "nvim-tree/nvim-web-devicons", enabled = vim.g.nerdfont }
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
                "nvim-telescope/telescope-ui-select.nvim",
                "nvim-telescope/telescope-file-browser.nvim"
            },
            config = function()
                require("telescope").setup
                {
                    defaults = { mappings = { i = { ["<Esc>"] = require("telescope.actions").close } } },
                    extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } }
                }

                pcall(require("telescope").load_extension, "fzf")
                pcall(require("telescope").load_extension, "ui-select")
                pcall(require("telescope").load_extension, "file_browser")
            end
        },

        { "lewis6991/gitsigns.nvim", opts = { } },

        -- Automatic tabstop and shiftwidth
        { "tpope/vim-sleuth" },

        -- Auto-tag completion
        { "windwp/nvim-ts-autotag", opts = { } },

        -- Rainbow delimiters
        {
            "HiPhish/rainbow-delimiters.nvim",
            config = function()
                require("rainbow-delimiters.setup").setup { }
            end
        },

        -- Highlight todo comments
        {
            "folke/todo-comments.nvim",
            event = "VimEnter",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts =
            {
                keywords = vim.g.nerdfont and { } or
                {
                    FIX = { icon = "👾" },
                    TODO = { icon = "✔" },
                    HACK = { icon = "🔥" },
                    WARN = { icon = "⚠︎" },
                    PERF = { icon = "🕓" },
                    NOTE = { icon = "ⓘ" },
                    TEST = { icon = "⏲" }
                }
            }
        },

        -- Colorize color representations
        { "NvChad/nvim-colorizer.lua", opts = { } },

        -- Indentation guides
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts =
            {
                scope = { show_start = false, show_end = false },
                indent = { char = "▏" }
            }
        },

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
                refactor =
                {
                    navigation = { enable = true },
                    highlight_definitions = { enable = true },
                    highlight_current_scope = { enable = true },
                    smart_rename = { enable = true }
                }
            },
            config = function(_, opts)
                require("nvim-treesitter.install").prefer_git = true
                require("nvim-treesitter.configs").setup(opts)
            end,
        },
        { "nvim-treesitter/nvim-treesitter-context", dependencies = { "nvim-treesitter/nvim-treesitter" } },
        { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },

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

                vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" },
                {
                    group = vim.api.nvim_create_augroup("Lint", { }),
                    callback = function()
                        lint.try_lint()
                    end
                })
            end
        },

        -- Debugging
        {
            "mfussenegger/nvim-dap",
            dependencies =
            {
                "williamboman/mason.nvim",
                "jay-babu/mason-nvim-dap.nvim",

                "rcarriga/nvim-dap-ui",
                "nvim-neotest/nvim-nio",

                -- Go
                "leoluz/nvim-dap-go"
            },
            config = function()
                require("mason-nvim-dap").setup
                {
                    automatic_installation = true,
                    handlers = { },
                    ensure_installed = { "bash-debug-adapter", "delve" }
                }

                local dap   = require("dap")
                local dapui = require("dapui")

                vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#990000" })
                vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#1E90FF" })
                vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#4CBB17" })

                vim.fn.sign_define("DapBreakpoint", { text = vim.g.nerdfont and "⬤" or "⚫", texthl = "DapBreakpoint" })
                vim.fn.sign_define("DapBreakpointCondition", { text = vim.g.nerdfont and "⬤" or "⛔", texthl = "DapBreakpoint" })
                vim.fn.sign_define("DapBreakpointRejected", { text = vim.g.nerdfont and "" or "✖", texthl = "DapBreakpoint" })
                vim.fn.sign_define("DapLogPoint", { text = vim.g.nerdfont and "" or "⚫", texthl = "DapLogPoint" })
                vim.fn.sign_define("DapStopped", { text = vim.g.nerdfont and "" or "⚫", texthl = "DapStopped" })

                dap.adapters.bashdb =
                {
                    type = "executable",
                    command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
                    name = "bashdb"
                }

                dap.configurations.sh =
                {
                    {
                        type = "bashdb",
                        request = "launch",
                        name = "Launch file",
                        showDebugOutput = true,
                        pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
                        pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
                        trace = true,
                        file = "${file}",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                        pathCat = "cat",
                        pathBash = "/bin/bash",
                        pathMkfifo = "mkfifo",
                        pathPkill = "pkill",
                        args = { },
                        env = { },
                        terminalKind = "integrated"
                    }
                }

                dapui.setup
                {
                    icons = vim.g.nerdfont and { } or { expanded = "▾", collapsed = "▸", current_frame = "*" },
                    controls =
                    {
                      icons = vim.g.nerdfont and { } or
                      {
                            pause = "⏸",
                            play = "▶",
                            step_into = "⏎",
                            step_over = "⏭",
                            step_out = "⏮",
                            step_back = "b",
                            run_last = "▶▶",
                            terminate = "⏹",
                            disconnect = "⏏"
                        }
                    }
                }

                dap.listeners.after.event_initialized["dapui_config"] = dapui.open
                dap.listeners.before.event_terminated["dapui_config"] = dapui.close
                dap.listeners.before.event_exited["dapui_config"] = dapui.close

                require("dap-go").setup { delve = { detached = vim.fn.has("win32") == 0 } }
            end
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
                "nvim-neotest/neotest-plenary",
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter"
            },
            config = function()
                require("neotest").setup
                {
                    adapters =
                    {
                        require("neotest-bash"),
                        require("neotest-plenary")
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

                cmp.setup
                {
                    completion = { autocomplete = false, completeopt = table.concat(vim.opt.completeopt:get(), ",") },
                    experimental = { ghost_text = { hl_group = "Comment" } },
                    sources =
                    {
                        { name = "lazydev", group_index = 0 },
                        { name = "nvim_lsp" },
                        { name = "buffer" }
                    },
                    formatting =
                    {
                        format = function(_, item)
                            local icons =
                            {
                                Array         = " ",
                                Boolean       = "󰨙 ",
                                Class         = " ",
                                Codeium       = "󰘦 ",
                                Color         = " ",
                                Control       = " ",
                                Collapsed     = " ",
                                Constant      = "󰏿 ",
                                Constructor   = " ",
                                Copilot       = " ",
                                Enum          = " ",
                                EnumMember    = " ",
                                Event         = " ",
                                Field         = " ",
                                File          = " ",
                                Folder        = " ",
                                Function      = "󰊕 ",
                                Interface     = " ",
                                Key           = " ",
                                Keyword       = " ",
                                Method        = "󰊕 ",
                                Module        = " ",
                                Namespace     = "󰦮 ",
                                Null          = " ",
                                Number        = "󰎠 ",
                                Object        = " ",
                                Operator      = " ",
                                Package       = " ",
                                Property      = " ",
                                Reference     = " ",
                                Snippet       = " ",
                                String        = " ",
                                Struct        = "󰆼 ",
                                TabNine       = "󰏚 ",
                                Text          = " ",
                                TypeParameter = " ",
                                Unit          = " ",
                                Value         = " ",
                                Variable      = "󰀫 "
                            }

                            if icons[item.kind] then
                                item.kind = icons[item.kind] .. item.kind
                            end

                            return item
                        end
                    }
                }

                cmp.setup.cmdline({ "/", "?" },
                {
                    sources =
                    {
                        { name = "buffer" }
                    }
                })

                cmp.setup.cmdline(":",
                {
                    sources =
                    {
                        { name = "path", group_index = 1 },
                        { name = "cmdline", group_index = 2 }
                    },
                    matching = { disallow_symbol_nonprefix_matching = false }
                })
            end
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
                { "Bilal2453/luvit-meta", lazy = true }
            },
            config = function()
                vim.api.nvim_create_autocmd("LspAttach",
                {
                    group = vim.api.nvim_create_augroup("Lsp", { }),
                    callback = function(event)
                        local client = vim.lsp.get_client_by_id(event.data.client_id)

                        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                            local highlight_group = vim.api.nvim_create_augroup("Lsp.Highlight", { })

                            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" },
                            {
                                group = highlight_group,
                                buffer = event.buf,
                                callback = vim.lsp.buf.document_highlight
                            })

                            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
                            {
                                group = highlight_group,
                                buffer = event.buf,
                                callback = vim.lsp.buf.clear_references
                            })

                            vim.api.nvim_create_autocmd("LspDetach",
                            {
                                group = vim.api.nvim_create_augroup("Lsp.Detach", { }),
                                callback = function(_)
                                    vim.lsp.buf.clear_references()
                                    vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
                                end
                            })
                        end
                    end
                })

                -- Configure capabilities
                local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())

                -- Configure servers (see `:help lspconfig-all` for a list of all the pre-configured LSPs)
                local servers =
                {
                    -- Lua
                    lua_ls =
                    {
                        settings =
                        {
                            Lua =
                            {
                                runtime = { version = "LuaJIT" },
                                workspace = { library = vim.api.nvim_get_runtime_file("lua", true) },
                                completion = { callSnippet = "Replace" }
                            }
                        }
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
