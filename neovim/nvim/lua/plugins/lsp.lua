-- LSP configuration with basedpyright and ruff using vim.lsp.config
return {
  'neovim/nvim-lspconfig',
  config = function()
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

    -- Get capabilities from nvim-cmp for LSP completion
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Configure LSP servers using the new vim.lsp.config API
    local lsps = {
      {
        "basedpyright",
        {
          capabilities = capabilities,
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
        },
      },
      { "ruff", { capabilities = capabilities } },
    }

    -- Enable all configured LSP servers
    for _, lsp in pairs(lsps) do
      local name, config = lsp[1], lsp[2]
      if config then
        vim.lsp.config(name, config)
      end
      vim.lsp.enable(name)
    end
  end,
}
