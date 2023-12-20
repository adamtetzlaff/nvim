return {
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
}
