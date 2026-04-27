return {
    "saghen/blink.cmp",
    dependencies = {
        "saghen/blink.lib",
        "rafamadriz/friendly-snippets",
    },
    build = function()
        require("blink.cmp").build():wait(60000)
    end,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = "default" },
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
        },
        sources = { default = { "lsp", "path", "snippets", "buffer" } },
        fuzzy = { implementation = "rust" },
    },
}
