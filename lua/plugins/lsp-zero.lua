return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/nvim-cmp" },
			{ "L3MON4D3/LuaSnip" },
			{ "nvimtools/none-ls.nvim" },
			{ "nvimtools/none-ls-extras.nvim" },
		},
		config = function()
			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })

				-- override any default keymaps
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

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "jsonls", "lua_ls", "tailwindcss", "tsserver", "yamlls", "rust_analyzer" },
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
					tsserver = lsp_zero.noop,
				},
			})

			local cmp = require("cmp")
			local cmp_format = lsp_zero.cmp_format()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			-- Insert '(' after selecting function
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			cmp.setup({
				formatting = cmp_format,
				mapping = cmp.mapping.preset.insert({
					-- scroll up and down the documentation window
					-- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
					-- ['<C-d>'] = cmp.mapping.scroll_docs(4),
					["<C-space>"] = cmp.mapping.complete(),
					["<cr>"] = cmp.mapping.confirm({ select = true }),
				}),
			})

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
					null_ls.builtins.formatting.stylua,
					require("none-ls.diagnostics.eslint_d"),
				},
			})
		end,
	},
}
