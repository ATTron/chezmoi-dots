vim.pack.add({
  { src = "https://github.com/echasnovski/mini.statusline" },
})
local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })
