vim.pack.add({
  {
    src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  },
})

require("tiny-inline-diagnostic").setup({
  preset = "modern",
  options = {
    add_messages = {
      display_count = true,
    },
    multilines = {
      enabled = true,
    },
  },
})
vim.diagnostic.config({ virtual_text = false })
