vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1"),
  },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "select_and_accept", "fallback" },
  },

  appearance = {
    nerd_font_variant = "mono",
    use_nvim_cmp_as_default = true,
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
      auto_show = true,
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
