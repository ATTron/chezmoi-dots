vim.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
})

-- set colorscheme
require("gruvbox").setup({
  terminal_colors = true,
  transparent_mode = true,
})
vim.opt.background = "dark"
vim.cmd([[colorscheme gruvbox]])
