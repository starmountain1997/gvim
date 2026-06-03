return {
    "karb94/neoscroll.nvim",
    keys = {
        { "<C-u>", desc = "Smooth scroll up" },
        { "<C-d>", desc = "Smooth scroll down" },
        { "<C-b>", desc = "Smooth scroll page up" },
        { "<C-f>", desc = "Smooth scroll page down" },
    },
    opts = {
        easing = "quadratic",
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
    },
}
