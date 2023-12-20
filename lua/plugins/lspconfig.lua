return {
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
}
