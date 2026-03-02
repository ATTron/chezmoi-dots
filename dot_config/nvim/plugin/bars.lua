vim.pack.add({
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

local bufferline = require("bufferline")
bufferline.setup({
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    always_show_bufferline = false,
    custom_filter = function(buf_number)
      -- Filter out terminal buffers
      if vim.bo[buf_number].buftype == "terminal" then
        return false
      end
      return true
    end,
  },
})

require("lualine").setup({
  options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    theme = "auto",
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_x = { "filetype" },
  },
})
