vim.pack.add({
  { src = "https://github.com/ATTron/dojo.nvim" },
})

require("dojo").setup({
  icons = true,
  debug = true,
})

vim.keymap.set("n", "<leader>jj", "<cmd>Dojo<CR>")
