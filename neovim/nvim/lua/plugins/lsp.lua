-- 安装必要的插件
return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- blink.cmp LSP能力配置
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      capabilities.offsetEncoding = { 'utf-16' }

      -- 配置LSP服务器（使用新的 vim.lsp.config API）

      -- pyright配置：提供更好的类型检查和性能
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        -- 超时设置可以更短，因为pyright启动更快
        timeout = 15000,  -- 15秒超时
        flags = {
          debounce_text_changes = 150,  -- 文本变化防抖时间（毫秒）
          allow_incremental_sync = true,  -- 允许增量同步
        },
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              -- 优化性能的配置
              typeCheckingMode = "basic",  -- 或 "strict" 更严格
              autoImportCompletions = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          -- 不再自动格式化，交给用户手动触发
        end,
      })

      -- Ruff配置：主要提供代码检查和快速格式化
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        cmd = { "ruff", "server", "--preview" },  -- 使用虚拟环境中的ruff
        filetypes = { "python" },  -- 只处理Python文件
        init_options = {
          settings = {
            -- Ruff的优化配置
            lineLength = 88,
            organizeImports = true,
            fixAll = true,
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
        },
      })

      -- 自动启动 LSP 服务器（新版本需要手动设置）
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup('lsp_auto_start', { clear = true }),
        pattern = { "python" },
        callback = function(args)
          local buf = args.buf
          -- 启动 pyright
          vim.lsp.start({
            name = "pyright",
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            root_dir = vim.fs.root(buf, {'.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'pyrightconfig.json', '.gitignore'}),
            capabilities = capabilities,
            timeout = 15000,  -- 15秒超时
            flags = {
              debounce_text_changes = 150,  -- 文本变化防抖时间（毫秒）
              allow_incremental_sync = true,  -- 允许增量同步
            },
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                  typeCheckingMode = "basic",
                  autoImportCompletions = true,
                },
              },
            },
            on_attach = function(client, bufnr)
              -- 不再自动格式化，交给用户手动触发
            end,
          })

          -- 启动 ruff
          vim.lsp.start({
            name = "ruff",
            cmd = { "ruff", "server", "--preview" },
            filetypes = { "python" },
            root_dir = vim.fs.root(buf, {'.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'pyrightconfig.json', '.gitignore'}),
            capabilities = capabilities,
            init_options = {
              settings = {
                lineLength = 88,
                organizeImports = true,
                fixAll = true,
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
                lint = {
                  ignore = {
                    "E501",
                    "E402",
                    "E701",
                    "E702",
                    "W291",
                    "W293",
                  },
                },
              },
            },
          })
        end,
        desc = 'Auto start LSP for Python files',
      })

      -- 禁用Ruff的悬停提示，让pyright处理
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- 禁用Ruff的悬停提示，让pyright处理
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff',
      })
      
      -- 按键映射
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

      -- 添加 LSP 状态检查命令
      vim.api.nvim_create_user_command('LspInfo', function()
        print('LSP clients attached to this buffer:')
        for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          print(string.format('  - %s: %s (id: %d)', client.name, client.config.cmd[1], client.id))
        end

        -- 显示 pylsp 进程状态
        local handle = io.popen('ps aux | grep pylsp | grep -v grep')
        if handle then
          local output = handle:read('*a')
          handle:close()
          if output and output ~= '' then
            print('\npylsp processes:')
            print(vim.trim(output))
          else
            print('\nNo pylsp processes found')
          end
        end
      end, {})

      -- 格式化快捷键
      vim.keymap.set("n", "<leader>ff", function()
        vim.lsp.buf.format({ async = false })
      end, { desc = "Format file" })
    end,
  },
}
