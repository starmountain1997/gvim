return {
    "ntpeters/vim-better-whitespace",
    config = function()
        -- 默认启用高亮
        vim.g.better_whitespace_enabled = 1
        -- 高亮颜色（终端/GUI）
        vim.g.better_whitespace_ctermcolor = "red"
        vim.g.better_whitespace_guicolor = "#E06C75"
        -- 保存时自动删除行尾空格
        -- vim.g.strip_whitespace_on_save = 1
        -- 删除前确认
        vim.g.strip_whitespace_confirm = 1
        -- 操作符快捷键（如 <leader>sip 删除当前段落空格）
        vim.g.better_whitespace_operator = ""
        -- 不在当前行高亮空格（normal 模式下也不高亮）
        vim.g.current_line_whitespace_disabled_soft = 1
        -- 跳过空白行
        vim.g.better_whitespace_skip_empty_lines = 1
        -- 最大文件大小限制（行数），超过不自动 strip
        vim.g.strip_max_file_size = 10000

        -- 快捷键：在行尾空格之间跳转
        vim.keymap.set("n", "]w", ":NextTrailingWhitespace<CR>", { silent = true, desc = "Next trailing whitespace" })
        vim.keymap.set("n", "[w", ":PrevTrailingWhitespace<CR>", { silent = true, desc = "Prev trailing whitespace" })
        vim.keymap.set("n", "<leader>sw", ":StripWhitespace<CR>", { silent = true, desc = "Strip trailing whitespace" })
        vim.keymap.set(
            "n",
            "<leader>tw",
            ":ToggleWhitespace<CR>",
            { silent = true, desc = "Toggle whitespace highlight" }
        )
    end,
}
