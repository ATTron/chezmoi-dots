vim.pack.add({
  { src = "https://github.com/akinsho/bufferline.nvim" },
})
vim.opt.termguicolors = true
local bufferline = require('bufferline')
bufferline.setup({
  options = {
    diagnostics = "nvim_lsp",
    numbers = "none",
    separator_style = "thin",
    always_show_bufferline = false,
    custom_filter = function(buf_number)
      -- Filter out terminal buffers
      if vim.bo[buf_number].buftype == "terminal" then
        return false
      end
      return true
    end
  }

})
