return {
    "rebelot/terminal.nvim",
    lazy = false, -- 常用工具，开机加载
    keys = {
        -- 切换终端
        { "<leader>tt", "<cmd>TermToggle<cr>", desc = "Toggle terminal" },
        { "<leader>tf", "<cmd>TermToggle float<cr>", desc = "Toggle float terminal" },
        -- 运行新命令
        { "<leader>tr", "<cmd>TermRun<cr>", desc = "Run command in terminal" },
        -- 关闭终端
        { "<leader>tk", "<cmd>TermKill<cr>", desc = "Kill terminal" },
        -- 循环切换（由 config 内注册，使用 count 如 2<leader>t]）
        { "<leader>t]", desc = "Next terminal" },
        { "<leader>t[", desc = "Prev terminal" },
        -- 发送选定文本到终端
        { "<leader>ts", desc = "Send to terminal", mode = { "n", "x" } },
    },
    config = function()
        -- 基本配置
        require("terminal").setup({
            layout = { open_cmd = "botright new" },
            cmd = { vim.o.shell },
            autoclose = true,
        })

        -- 终端映射
        local term_map = require("terminal.mappings")

        -- 循环切换终端
        vim.keymap.set("n", "<leader>t]", term_map.cycle_next, { desc = "Next terminal" })
        vim.keymap.set("n", "<leader>t[", term_map.cycle_prev, { desc = "Prev terminal" })

        -- 发送文本（normal/visual 模式通过 motion 或选中）
        vim.keymap.set({ "n", "x" }, "<leader>ts", term_map.operator_send, { expr = true })

        -- 切换布局：水平分屏 / 垂直分屏 / 浮动
        vim.keymap.set("n", "<leader>tH", term_map.move({ open_cmd = "botright new" }), { desc = "Horizontal split" })
        vim.keymap.set("n", "<leader>tV", term_map.move({ open_cmd = "botright vnew" }), { desc = "Vertical split" })
        vim.keymap.set("n", "<leader>tF", term_map.move({ open_cmd = "float" }), { desc = "Float" })

        -- 快速命名终端：Lazygit（浮动）
        local lazygit = require("terminal").terminal:new({
            layout = { open_cmd = "float", height = 0.9, width = 0.9 },
            cmd = { "lazygit" },
            autoclose = true,
        })
        vim.api.nvim_create_user_command("Lazygit", function(args)
            lazygit.cwd = args.args and vim.fn.expand(args.args) or nil
            lazygit:toggle(nil, true)
        end, { nargs = "?", desc = "Toggle Lazygit terminal" })
        vim.keymap.set("n", "<leader>gg", function()
            lazygit:toggle(nil, true)
        end, { desc = "Lazygit" })

        -- 快速命名终端：htop（浮动）
        local htop = require("terminal").terminal:new({
            layout = { open_cmd = "float", height = 0.8, width = 0.8 },
            cmd = { "htop" },
            autoclose = true,
        })
        vim.api.nvim_create_user_command("Htop", function()
            htop:toggle(nil, true)
        end, { desc = "Toggle htop terminal" })

        -- 进入终端 buffer 自动进入插入模式
        vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
            callback = function(args)
                if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
                    vim.cmd("startinsert")
                end
            end,
        })
    end,
}
