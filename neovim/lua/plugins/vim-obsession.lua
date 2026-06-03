return {
    "tpope/vim-obsession",
    init = function()
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                vim.cmd("Obsess")
            end,
        })
    end,
}
