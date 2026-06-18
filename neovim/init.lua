vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- LSP
vim.lsp.enable({ "ruff", "ty" })

vim.diagnostic.config({
    float = { border = "rounded", source = true, header = "", prefix = "" },
    virtual_text = { source = "if_many" },
    severity_sort = true,
    update_in_insert = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { scope = "cursor", focus = false })
    end,
})

vim.o.updatetime = 500

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local opts = { buffer = args.buf }
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- go to references, excluding build/ (and other generated dirs)
        vim.keymap.set("n", "gr", function()
            local params = vim.lsp.util.make_position_params()
            params.context = { includeDeclaration = true }
            local buf = vim.api.nvim_get_current_buf()
            vim.lsp.buf_request_all(buf, vim.lsp.protocol.Methods.textDocument_references, params, function(results)
                local locations = {}
                for _, result in pairs(results or {}) do
                    if result.result then
                        for _, loc in ipairs(result.result) do
                            local path = vim.uri_to_fname(loc.uri)
                            -- exclude results from generated/build directories
                            if
                                not path:match("/build/")
                                and not path:match("/node_modules/")
                                and not path:match("/__pycache__/")
                            then
                                table.insert(locations, loc)
                            end
                        end
                    end
                end
                if #locations == 0 then
                    vim.notify("No references found", vim.log.levels.INFO)
                    return
                end
                local items = vim.lsp.util.locations_to_items(locations)
                vim.fn.setqflist({}, " ", { title = "LSP References", items = items })
                vim.cmd("copen")
            end)
        end, opts)
        -- Format on save via ruff only (avoids basedpyright conflict)
        if client and client.name == "ruff" then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ name = "ruff" })
                end,
            })
        end
    end,
})

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    { import = "plugins" },
    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    follow_files = true,
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false,
                update_debounce = 100,
                max_file_length = 40000,
            })
        end,
    },
})
