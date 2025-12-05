return {
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Get blink.cmp capabilities for LSP completion
      local blink_cmp = require('blink.cmp')
      local capabilities = vim.tbl_deep_extend('force',
        vim.lsp.protocol.make_client_capabilities(),
        blink_cmp.get_lsp_capabilities()
      )

      -- Start LSP servers without additional settings
      vim.lsp.config('pyright', {
        capabilities = capabilities,
      })

      vim.lsp.config('ruff', {
        capabilities = capabilities,
      })
    end,
  },
}
