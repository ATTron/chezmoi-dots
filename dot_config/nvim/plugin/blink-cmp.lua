vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp" },
})

local utils = require("utils")

local success = utils.ensure_plugin_built(
  'https://github.com/saghen/blink.cmp.git',
  'blink.cmp',
  'cargo build --release',
  'target/release/libblink_cmp_fuzzy.so'
)


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
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    completion = {
      trigger = {
        show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
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
    },

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
