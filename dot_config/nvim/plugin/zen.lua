vim.pack.add({
  { src = "https://github.com/folke/zen-mode.nvim" },
})

require("zen-mode").setup({
  window = {
    width = 90,
    options = {
      number = false,
      relativenumber = false,
      cursorline = false,
      signcolumn = "no",
    },
  },
  plugins = {
    options = {
      laststatus = 0,
      showcmd = false,
    },
    gitsigns = { enabled = false },
    tmux = { enabled = false },
  },
})

vim.keymap.set("n", "<leader>zm", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode" })
