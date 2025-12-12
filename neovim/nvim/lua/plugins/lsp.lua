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

      -- 配置 ruff
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        filetypes = { "python" },
        settings = {
          organizeImports = true,
          fixAll = true,
        },
      })
    end,
  },
}
