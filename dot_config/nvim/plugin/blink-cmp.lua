vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = "v1.7.0",
  },
  { src = "https://github.com/L3MON4D3/LuaSnip", }
})

local utils = require("utils")

local success = utils.ensure_plugin_built(
  'https://github.com/L3MON4D3/LuaSnip',
  'LuaSnip',
  'make install_jsregexp',
  'lua/luasnip-jsregexp'
)

local success = utils.ensure_plugin_built(
  'https://github.com/saghen/blink.cmp',
  'blink.cmp',
  'cargo build --release',
  'target/release/libblink_cmp_fuzzy'
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
          winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
        }
      },
      menu = {
        auto_show = function()
          return not require("luasnip").expand_or_jumpable() and not in_treesitter_capture({ "comment", "string" })
        end,
        -- auto_show = true,
        border = 'rounded',
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        draw = {
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        }
      },
      ghost_text = { enabled = false },
    },


    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        'score',
        'sort_text',
        'label',
      },
    },
    signature = { enabled = true },
    snippets = { preset = 'luasnip' },
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

  -- Custom highlight groups for better styling (dynamic based on colorscheme)
  local function setup_highlights()
    -- Menu styling - uses Pmenu (popup menu) colors from the theme
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { link = 'Pmenu' })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { link = 'PmenuSel' })

    -- Documentation window - uses NormalFloat for floating windows
    vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { link = 'NormalFloat' })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocCursorLine', { link = 'CursorLine' })

    -- Kind icon colors - links to semantic highlight groups
    vim.api.nvim_set_hl(0, 'BlinkCmpKindText', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindMethod', { link = '@function.method' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFunction', { link = 'Function' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindConstructor', { link = '@constructor' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindField', { link = '@variable.member' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindVariable', { link = '@variable' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindClass', { link = 'Type' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindInterface', { link = 'Type' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindModule', { link = '@module' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindProperty', { link = '@property' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindKeyword', { link = 'Keyword' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindSnippet', { link = 'Special' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFile', { link = 'Directory' })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFolder', { link = 'Directory' })
  end

  -- Set up highlights initially
  setup_highlights()

  -- Re-apply highlights when colorscheme changes
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('BlinkCmpHighlights', { clear = true }),
    callback = setup_highlights,
  })
end
