local colorschemes = {
  "gruvbox",
  "solarized-osaka",
}

local function select_colorscheme()
  vim.ui.select(colorschemes, {
    prompt = "Select colorscheme:",
    format_item = function(item)
      local current = vim.g.colors_name or "default"
      if item == current then
        return "● " .. item
      else
        return "  " .. item
      end
    end,
  }, function(choice)
    if choice then
      local ok, _ = pcall(vim.cmd, "colorscheme " .. choice)
      if ok then
        print("Switched to " .. choice)
      else
        print("Error: Colorscheme '" .. choice .. "' not found")
      end
    end
  end)
end

vim.keymap.set("n", "<leader>cs", select_colorscheme, { desc = "Select colorscheme" })
