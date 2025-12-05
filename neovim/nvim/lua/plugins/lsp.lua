-- 安装必要的插件
return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ruff",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- blink.cmp LSP能力配置
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      capabilities.offsetEncoding = { 'utf-16' }

      -- 使用新的 vim.lsp.config API
      local lsp = vim.lsp.config

      -- Pyright配置：主要提供文档提示
      lsp('pyright', {
        capabilities = capabilities,
        settings = {
          pyright = {
            -- 使用Ruff的导入组织功能
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- 忽略所有文件的分析，专门使用Ruff进行代码检查
              ignore = { '*' },
              typeCheckingMode = "off", -- 关闭类型检查（可选）
              diagnosticMode = "off",   -- 完全禁用诊断
            },
          },
        },
      })

      -- Ruff配置：主要提供代码检查和格式化
      lsp('ruff', {
        capabilities = capabilities,
        init_options = {
          settings = {
            -- Ruff配置
            lineLength = 88,  -- 行长度限制
            organizeImports = true,  -- 保存时组织导入
            showSyntaxErrors = true,  -- 显示语法错误
            logLevel = 'info',
            fixAll = true,  -- 自动修复所有可修复的问题
            codeAction = {
              lint = {
                enable = true,
                preview = true,
              },
            },
            -- 忽略某些规则
            args = {
              "--ignore", "F821",  -- 未定义名称
              "--ignore", "E402",  -- 模块级别导入不在文件顶部
              "--ignore", "E722",  -- 裸异常
              "--ignore", "E712",  -- 与True的比较应为'if cond is True:'或'if cond:'
            },
          },
        },
      })

      -- 应用配置 - vim.lsp.config 会自动处理服务器启动
      
      -- 禁用Ruff的悬停提示，让Pyright处理
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- 禁用Ruff的悬停提示，让Pyright处理
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
    end,
  },
}
