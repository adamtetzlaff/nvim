vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("n", "gl", "$")
vim.keymap.set("n", "gh", "^")

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear highlight/search entry
vim.keymap.set("n", "<leader>nh", ":nohl<cr>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
