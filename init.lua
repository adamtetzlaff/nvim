require("set")
require("remap")

-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "folke/which-key.nvim", event = "VeryLazy", opts = {} },
	{ "lewis6991/gitsigns.nvim" },
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				no_italic = true,
				no_bold = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					telescope = {
						enabled = true,
					},
					treesitter = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
		opts = {
			theme = "catppuccin",
			sections = {
				lualine_c = { { "filename", path = 1 } },
			},
		},
	},
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"html",
					"javascript",
					"json",
					"kdl",
					"lua",
					"markdown_inline",
					"rust",
					"typescript",
					"yaml",
				},
				highlight = {
					enable = true,
				},
			})
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		lazy = true,
		config = function()
			-- This is where you modify the settings for lsp-zero
			-- Note: autocompletion settings will not take effect

			require("lsp-zero.settings").preset({})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			-- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
			-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

			require("lsp-zero.cmp").extend()

			-- And you can configure cmp even more, if you want to.
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			local cmp_action = require("lsp-zero.cmp").action()

			-- Insert '(' after selecting function
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			cmp.setup({
				mapping = {
					["<C-space>"] = cmp.mapping.complete(),
					["<cr>"] = cmp.mapping.confirm({ select = true }),
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "williamboman/mason.nvim" },
			{ "jose-elias-alvarez/null-ls.nvim" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "jsonls", "lua_ls", "tailwindcss", "tsserver", "yamlls" },
			})

			local lsp = require("lsp-zero").preset({})

			lsp.on_attach(function(_, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
				vim.keymap.set("n", "K", vim.lsp.buf.hover)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
				vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition)
				vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>")
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
			end)

			-- (Optional) Configure lua language server for neovim
			require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

			lsp.setup()

			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
								vim.lsp.buf.format({ bufnr = bufnr })
								-- vim.lsp.buf.formatting_sync()
							end,
						})
					end
				end,
				sources = {
					null_ls.builtins.formatting.prettierd,
					-- null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.formatting.stylua,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
					},
				},
				mappings = {
					n = {
						["d"] = "delete_buffer",
					},
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fa", function()
				builtin.find_files({ follow = true, no_ignore = true, hidden = true })
			end, {})
			vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
			vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, {})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			view = {
				width = 50,
			},
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)

			vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>")
			vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<cr>")
		end,
	},
})
