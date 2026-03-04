vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
})

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    trigger = {
      show_on_blocked_trigger_characters = { " ", "\n", "\t" },
      show_on_x_blocked_trigger_characters = { "'", '"', "(" },
      show_in_snippet = false,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "rounded" },
    },
    menu = {
      auto_show = function()
        return not require("luasnip").expand_or_jumpable()
      end,
      draw = {
        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning",
    sorts = { "score", "sort_text", "label" },
  },
})
