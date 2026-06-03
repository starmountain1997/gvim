return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    config = function()
        require("nvim-tree").setup({
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = true,
            update_focused_file = { enable = true, update_root = true },
            view = {
                width = 30,
                side = "left",
                preserve_window_proportions = true,
            },
            renderer = {
                root_folder_label = false,
                icons = {
                    glyphs = {
                        default = "󰈚",
                        folder = {
                            default = "",
                            open = "",
                        },
                    },
                },
            },
            filters = {
                custom = { "__pycache__", "%.egg-info" },
            },
        })
    end,
}
