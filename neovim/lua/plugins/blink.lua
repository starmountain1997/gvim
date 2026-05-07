return {
    "saghen/blink.cmp",
    dependencies = {
        "saghen/blink.lib",
    },
    build = function()
        require("blink.cmp").build():wait(60000)
    end,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "default",
            ["<CR>"] = { "accept", "fallback" },
        },
        completion = {
            list = { selection = { preselect = true, auto_insert = false } },
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
        },
        sources = { default = { "lsp", "path", "buffer" } },
        snippets = { preset = "default" },
        fuzzy = { implementation = "rust" },
    },
}
