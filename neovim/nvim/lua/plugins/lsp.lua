-- 使用 Mason 管理的 LSP 服务器
return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 获取 Mason 管理的 LSP 服务器路径
      local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"

      -- LSP 能力配置
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      capabilities.offsetEncoding = { 'utf-16' }

      -- 通用 LSP 按键映射
      local on_attach = function(client, bufnr)
        -- 基本 LSP 按键映射
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Find references" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show hover documentation" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Type definition" })
        vim.keymap.set("n", "<leader>ds", vim.lsp.buf.document_symbol, { buffer = bufnr, desc = "Document symbols" })
        vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "Workspace symbols" })

        -- 格式化快捷键
        vim.keymap.set("n", "<leader>ff", function()
          vim.lsp.buf.format({ async = false })
        end, { buffer = bufnr, desc = "Format file" })
      end

      -- 配置 pylsp (Python Language Server) - minimal 配置
      vim.lsp.config("pylsp", {
        capabilities = capabilities,
        cmd = { mason_path .. "pylsp" },
        filetypes = { "python" },
        root_dir = vim.fs.root(0, {
          ".git",
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          ".gitignore"
        }),
        settings = {
          pylsp = {
            plugins = {
              -- 启用 jedi 进行补全和定义跳转
              jedi = {
                enabled = true,
              },
              -- 启用 autopep8 进行格式化
              autopep8 = {
                enabled = true,
              },
              -- 启用 flake8 进行代码检查
              flake8 = {
                enabled = true,
                maxLineLength = 88,
              },
            },
          },
        },
      })

      -- 配置 ruff (快速代码检查和格式化)
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        cmd = { mason_path .. "ruff", "server", "--preview" },
        filetypes = { "python" },
        root_dir = vim.fs.root(0, {
          ".git",
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          ".gitignore"
        }),
        settings = {
          -- 基本配置
          lineLength = 88,
          organizeImports = true,
          fixAll = true,
          -- 代码操作配置
          codeAction = {
            disableRuleComment = {
              enable = true,
              minLines = 3,
            },
            fix = {
              enable = true,
            },
            lint = {
              enable = true,
              preview = true,
            },
          },
          -- 忽略一些常见的规则，减少干扰
          lint = {
            ignore = {
              "E501",  -- 行过长
              "E402",  -- 模块级别导入不在文件顶部
              "E701",  -- 多语句在同一行
              "E702",  -- 多语句在同一行（分号）
              "W291",  -- 行尾空白
              "W293",  -- 行尾空白
            },
          },
        },
      })

      -- 自动启动 LSP 服务器
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup('lsp_auto_start', { clear = true }),
        pattern = { "python" },
        callback = function(args)
          -- 自动启动 pylsp
          vim.lsp.enable("pylsp", {
            bufnr = args.buf,
            on_attach = on_attach,
          })

          -- 自动启动 ruff
          vim.lsp.enable("ruff", {
            bufnr = args.buf,
            on_attach = on_attach,
          })
        end,
        desc = 'Auto start LSP for Python files',
      })

      -- 禁用 Ruff 的悬停提示，让 pylsp 处理
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff',
      })

      -- 恢复默认的 updatetime 设置
      vim.o.updatetime = 4000

      -- 添加 LSP 状态检查命令
      vim.api.nvim_create_user_command('LspInfo', function()
        print('LSP clients attached to this buffer:')
        for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          print(string.format('  - %s: %s (id: %d)', client.name, client.config.cmd[1], client.id))
        end
      end, {})
    end,
  },
}
