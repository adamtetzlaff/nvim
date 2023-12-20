vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("NoNeckPain")
	end,
})

return {
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		opts = {
			width = 150,
		},
	},
}
