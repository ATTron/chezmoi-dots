vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = "v1.3.1",
  },
  { src = "https://github.com/L3MON4D3/LuaSnip", }
})

local utils = require("utils")

local success = utils.ensure_plugin_built(
  'https://github.com/L3MON4D3/LuaSnip',
  'LuaSnip',
  'make install_jsregexp',
  'lua/luasnip-jsregexp.lua'
)

local success = utils.ensure_plugin_built(
  'https://github.com/saghen/blink.cmp.git',
  'blink.cmp',
  'cargo build --release',
  'target/release/libblink_cmp_fuzzy.so'
)

function in_treesitter_capture(capture)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if vim.api.nvim_get_mode().mode == 'i' then
    col = col - 1
  end

  local buf = vim.api.nvim_get_current_buf()
  local get_captures_at_pos = require('vim.treesitter').get_captures_at_pos

  local captures_at_cursor = vim.tbl_map(function(x)
    return x.capture
  end, get_captures_at_pos(buf, row - 1, col))

  if vim.tbl_isempty(captures_at_cursor) then
    return false
  elseif type(capture) == 'string' and vim.tbl_contains(captures_at_cursor, capture) then
    return true
  elseif type(capture) == 'table' then
    for _, v in ipairs(capture) do
      if vim.tbl_contains(captures_at_cursor, v) then
        return true
      end
    end
  end
  return false
end

if success then
  require('blink.cmp').setup({
    keymap = {
      preset = 'default',
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },

    appearance = {
      -- use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    completion = {
      trigger = {
        show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
        show_on_x_blocked_trigger_characters = { "'", '"', '(' },
        show_in_snippet = false,
      },
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'rounded',
        }
      },
      menu = {
        auto_show = function()
          return not require("luasnip").expand_or_jumpable() and not in_treesitter_capture({ "comment", "string" })
        end,
        -- auto_show = true,
        draw = {
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        }
      },
      ghost_text = { enabled = false },
    },


    fuzzy = { implementation = "prefer_rust_with_warning" },
    snippets = {
      expand = function(snippet)
        vim.snippet.expand(snippet)
      end,
      active = function(filter)
        return vim.snippet.active(filter)
      end,
      jump = function(direction)
        vim.snippet.jump(direction)
      end,
    },
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
end
