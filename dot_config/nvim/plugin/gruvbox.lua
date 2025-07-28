vim.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
})

-- set colorscheme
require("gruvbox").setup({
  transparent_mode = true,
  overrides = {
    FloatBorder = {
      fg = "#ebdbb2",
      bg = "#3c3836",
    },
    NormalFloat = {
      bg = "#282828",
    },
  },
  terminal_colors = true,
})
vim.opt.background = "dark"
vim.cmd([[colorscheme gruvbox]])
