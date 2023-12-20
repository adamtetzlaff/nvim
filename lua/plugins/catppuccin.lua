return {
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
}
