vim.pack.add({
  { src = "https://github.com/vieitesss/miniharp.nvim" },
})

require("miniharp").setup({
  autoload = true,
  autosave = true,
})

vim.keymap.set("n", "<leader>a", require("miniharp").toggle_file, { desc = "miniharp: toggle file mark" })
vim.keymap.set("n", "<c-n>", require("miniharp").next, { desc = "miniharp: next file mark" })
vim.keymap.set("n", "<c-p>", require("miniharp").prev, { desc = "miniharp: prev file mark" })
vim.keymap.set("n", "<leader>e", require("miniharp").show_list, { desc = "miniharp: list marks" })
