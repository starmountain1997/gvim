return {
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Configure pylsp using new vim.lsp.config API
      vim.lsp.config('pylsp', {
        settings = {
          pylsp = {
            -- Disable pylsp linting and formatting in favor of Ruff
            configurationSources = {},  -- 禁用配置源
            plugins = {
              -- Disable various pylsp plugins to avoid conflicts with Ruff
              autopep8 = { enabled = false },
              flake8 = { enabled = false },
              mccabe = { enabled = false },
              pycodestyle = { enabled = false },
              pydocstyle = { enabled = false },
              pyflakes = { enabled = false },
              pylint = { enabled = false },
              yapf = { enabled = false },
              rope_autoimport = { enabled = false },  -- 禁用自动导入
              rope_completion = { enabled = false },   -- 禁用补全
            },
          },
        },
      })

      -- Configure Ruff LSP using new vim.lsp.config API
      vim.lsp.config('ruff', {
        settings = {
          -- Ruff language server settings go here
          lineLength = 80,
          lint = {
            extendSelect = { 'I' },
          },
        },
      })

      -- Disable hover capability from Ruff when used with pylsp
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- Disable hover in favor of pylsp
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff (use pylsp instead)',
      })
    end,
  },
}