vim.pack.add({
  { src = "https://github.com/NMAC427/guess-indent.nvim" }
})

vim.cmd('packadd guess-indent.nvim')
require("guess-indent").setup({})
