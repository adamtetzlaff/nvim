return {
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
}
