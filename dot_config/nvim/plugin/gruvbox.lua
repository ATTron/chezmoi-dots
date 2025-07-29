vim.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
})

-- set colorscheme
require("gruvbox").setup({
  transparent_mode = true,
  terminal_colors = true,
})
vim.opt.background = "dark"
vim.cmd([[colorscheme gruvbox]])
