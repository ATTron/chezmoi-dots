vim.pack.add({
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    always_show_bufferline = false,
    custom_filter = function(buf)
      return vim.bo[buf].buftype ~= "terminal"
    end,
  },
})

-- stylua: ignore
local c = {
  bg     = "#1c1816", fg     = "#e2d9c8",
  red    = "#ef5350", orange = "#ff8c42", yellow = "#ffd54f",
  green  = "#9ccc65", aqua   = "#4dd0e1", blue   = "#64b5f6", purple = "#ba68c8",
}

-- stylua: ignore
local mode_colors = {
  n = c.blue, i = c.green, v = c.purple, V = c.purple, ["\22"] = c.purple,
  c = c.aqua, R = c.orange, s = c.orange, S = c.orange, t = c.red,
}

-- nerd font icons (can't embed PUA unicode directly)
local nr = vim.fn.nr2char
-- stylua: ignore
local icons = {
  error    = nr(0xF015A) .. " ", -- 󰅚
  warn     = nr(0xF071) .. " ",  --
  info     = nr(0xF05A) .. " ",  --
  added    = nr(0xF457) .. " ",  --
  modified = nr(0xF459) .. " ",  --
  removed  = nr(0xF458) .. " ",  --
  branch   = nr(0xE0A0) .. " ",  --
  lsp      = nr(0xF085) .. " ",  --
  bar      = nr(0x258A),         -- ▊
}

-- jj bookmark component (async, cached)
local jj_info = ""
local function refresh_jj()
  local tpl = 'if(bookmarks, bookmarks.join(", "), change_id.shortest(8))'
  vim.fn.jobstart({ "jj", "log", "-r", "@", "--no-graph", "-T", tpl }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      jj_info = (data and data[1] ~= "") and data[1] or ""
    end,
  })
end
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "BufWritePost" }, { callback = refresh_jj })
refresh_jj()

local not_empty = function()
  return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
end
local wide = function()
  return vim.fn.winwidth(0) > 80
end

local config = {
  options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    theme = {
      normal = { c = { fg = c.fg, bg = c.bg } },
      inactive = { c = { fg = c.fg, bg = c.bg } },
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

local function il(comp)
  table.insert(config.sections.lualine_c, comp)
end
local function ir(comp)
  table.insert(config.sections.lualine_x, comp)
end

-- prevent Neovim from filling empty statusline sections with < or ^
vim.opt.fillchars:append({ stl = " ", stlnc = " " })

-- left
il({
  function()
    return icons.bar
  end,
  color = { fg = c.blue },
  padding = { left = 0, right = 1 },
})
il({
  function()
    return vim.fn.mode():sub(1, 1):upper()
  end,
  color = function()
    return { fg = mode_colors[vim.fn.mode()] or c.fg }
  end,
  padding = { right = 1 },
})
il({ "filesize", cond = not_empty, padding = { left = 1, right = 0 } })
il({ "filename", cond = not_empty, color = { fg = c.purple, gui = "bold" }, padding = { left = 1, right = 0 } })
il({ "location", padding = { left = 1, right = 0 } })
il({ "progress", color = { fg = c.fg, gui = "bold" }, padding = { left = 1, right = 0 } })
il({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = icons.error, warn = icons.warn, info = icons.info },
  diagnostics_color = {
    error = { fg = c.red },
    warn = { fg = c.yellow },
    info = { fg = c.aqua },
  },
})

-- mid
il({
  function()
    return "%="
  end,
})
il({
  function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return "No LSP"
    end
    return clients[1].name
  end,
  icon = icons.lsp,
  color = { fg = c.fg, gui = "bold" },
})

-- right
ir({ "o:encoding", fmt = string.upper, cond = wide, color = { fg = c.green, gui = "bold" }, padding = { left = 0, right = 1 } })
ir({ "fileformat", fmt = string.upper, icons_enabled = false, color = { fg = c.green, gui = "bold" }, padding = { left = 0, right = 1 } })
ir({
  function()
    return jj_info
  end,
  cond = function()
    return jj_info ~= ""
  end,
  color = { fg = c.purple, gui = "bold" },
  padding = { left = 0, right = 1 },
})
ir({
  "diff",
  symbols = { added = icons.added, modified = icons.modified, removed = icons.removed },
  diff_color = { added = { fg = c.green }, modified = { fg = c.orange }, removed = { fg = c.red } },
  cond = wide,
})
ir({
  function()
    return icons.bar
  end,
  color = { fg = c.blue },
  padding = { left = 1 },
})

require("lualine").setup(config)
