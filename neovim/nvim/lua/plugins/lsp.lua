-- LSP 配置 - 使用 Mason 自动管理
return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      -- 通用 LSP 按键映射
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('lsp_attach_keymaps', { clear = true }),
        callback = function(args)
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = args.buf, desc = "Find references" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code actions" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "Show hover documentation" })
          vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { buffer = args.buf, desc = "Format file" })
        end,
        desc = 'LSP: Apply key mappings on attach',
      })

      -- 配置 pylsp（禁用格式化，让 ruff 处理）
      vim.lsp.config("pylsp", {
        capabilities = capabilities,
        filetypes = { "python" },
        settings = {
          pylsp = {
            plugins = {
              -- 禁用 pylsp 的格式化插件，让 ruff 处理格式化
              autopep8 = { enabled = false },
              black = { enabled = false },
              yapf = { enabled = false },
              -- 启用其他有用的插件
              jedi_completion = { enabled = true },
              jedi_definition = { enabled = true },
              jedi_hover = { enabled = true },
              jedi_references = { enabled = true },
              jedi_signature_help = { enabled = true },
              jedi_symbols = { enabled = true },
              mccabe = { enabled = true },
              pycodestyle = { enabled = true },
              pydocstyle = { enabled = true },
              pyflakes = { enabled = true },
              rope_completion = { enabled = true },
            }
          }
        }
      })

      -- 配置 ruff（专门处理格式化和快速 linting）
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        filetypes = { "python" },
        settings = {
          -- 格式化相关
          format = { enabled = true },
          organizeImports = true,
          fixAll = true,
          -- 可以禁用 ruff 的某些检查，避免与 pylsp 重复
          lint = {
            enabled = true,
            -- 可以选择性地禁用一些检查，让 pylsp 处理
            select = {"ALL"},  -- 启用所有检查
            ignore = {},       -- 不禁用任何检查
          }
        },
      })
    end,
  },
}
