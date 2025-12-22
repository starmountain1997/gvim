-- LSP configuration with basedpyright and ruff
return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')

    -- Enable inlay hints when LSP attaches
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
      end,
    })

    -- Configure basedpyright with inlay hints
    lspconfig.basedpyright.setup({
      settings = {
        basedpyright = {
          analysis = {
            inlayHints = {
              variableTypes = true,
              callArgumentNames = true,
              functionReturnTypes = true,
              genericTypes = false,
            },
          },
        },
      },
    })

    -- Configure ruff for linting and formatting
    lspconfig.ruff.setup({})
  end,
}
