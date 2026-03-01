vim.g.netrw_preview = 1

vim.api.nvim_set_hl(0, "netrwMarkFile", { reverse = true, italic = true, bold = true })

vim.keymap.set("n", "q", "<cmd>enew<CR>", { buffer = 0, nowait = true })
