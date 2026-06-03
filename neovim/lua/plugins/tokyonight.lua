return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        transparent = true,
        terminal_colors = true,
        dim_inactive = false,
        lualine_bold = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "transparent",
            floats = "dark",
        },
        day_brightness = 0.3,
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd.colorscheme("tokyonight-night")
    end,
}
