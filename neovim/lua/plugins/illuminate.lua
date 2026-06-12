return {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
        local illuminate = require("illuminate")
        illuminate.configure({
            -- providers: 按优先级顺序获取引用
            providers = {
                "lsp",
                "treesitter",
                "regex",
            },
            -- delay: 高亮延迟（毫秒），避免频繁闪烁
            delay = 100,
            -- under_cursor: 是否高亮光标下的单词本身
            under_cursor = true,
            -- filetypes_denylist: 禁用高亮的文件类型
            filetypes_denylist = {
                "dirvish",
                "fugitive",
                "NvimTree",
                "lazy",
                "mason",
                "help",
            },
            -- large_file_cutoff: 超过此行数的大文件自动禁用 under_cursor
            large_file_cutoff = 5000,
            -- min_count_to_highlight: 至少出现几次才高亮
            min_count_to_highlight = 1,
        })

    end,
}
