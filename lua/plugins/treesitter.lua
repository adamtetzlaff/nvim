return {
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
}
