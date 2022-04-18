local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
end

local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { command = "source <afile> | PackerCompile", group = packer_group, pattern = "init.lua" })

require("packer").startup(function(use)
    -- plugin manager
    use "wbthomason/packer.nvim"

    -- vcs
    use "tpope/vim-fugitive"
    use "tpope/vim-rhubarb"

    -- handy tools
    use "numToStr/Comment.nvim"
    use "ludovicchabant/vim-gutentags"
    use "lukas-reineke/indent-blankline.nvim"
    use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }

    -- eyecandy
    use "navarasu/onedark.nvim"
    use "nvim-lualine/lualine.nvim"

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    -- native lsp
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-path"
    use "hrsh7th/nvim-cmp"
    use "neovim/nvim-lspconfig"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- set leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require("gitsigns").setup {
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
}

-- Comment.nvim
require("Comment").setup()

vim.wo.number = true
vim.o.mouse = "a"
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.breakindent = true
vim.wo.linebreak = true
vim.opt.clipboard = { "unnamedplus" }
vim.o.ff = "unix"
vim.wo.signcolumn = "yes"
vim.o.colorcolumn = "89"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 250
vim.o.completeopt = "menu,menuone,noselect"
vim.api.nvim_set_keymap("i", "<C-c>", "<ESC>", {})
vim.g.c_syntax_for_h = 1

-- search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- theme
vim.o.background = "dark"
require("onedark").setup {
    style = "darker",
}
require("onedark").load()

require("lualine").setup {
    options = {
        icons_enabled = false,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
    },
}

-- Telescope
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
}
require("telescope").load_extension "fzf"

vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>sf", function()
    require("telescope.builtin").find_files { previewer = false }
end)
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").current_buffer_fuzzy_find)
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>st", require("telescope.builtin").tags)
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").grep_string)
vim.keymap.set("n", "<leader>sp", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>so", function()
    require("telescope.builtin").tags { only_current_buffer = true }
end)
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles)

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "lua", "rust" },
    highlight = { enable = true },
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local luasnip = require "luasnip"
local cmp = require "cmp"
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
}

cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" },
    }, {
        { name = "buffer" },
    }),
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

-- LSP settings
local lspconfig = require "lspconfig"
local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        vim.inspect(vim.lsp.buf.list_workspace_folders())
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>so", require("telescope.builtin").lsp_document_symbols, opts)
    vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.texlab.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        texlab = {
            build = {
                args = { "-pdfxe", "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = true,
            },
            latexindent = { modifyLineBreaks = true },
        },
    },
}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Enable the following language servers
local servers = { "clangd", "rust_analyzer", "pyright" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end
