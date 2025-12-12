-- Conform.nvim configuration for formatting

return {
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        markdown = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
        -- You can add other filetypes here as needed
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
      },
      format_on_save = function(bufnr)
        -- Only format markdown files on save
        if vim.bo[bufnr].filetype == 'markdown' or vim.bo[bufnr].filetype == 'markdown.mdx' then
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      log_level = vim.log.levels.ERROR,
      notify_on_error = true,
      notify_no_formatters = true,
    })

    -- Key mappings for formatting
    vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
      require('conform').format({
        async = false,
        lsp_format = 'fallback',
      })
    end, { desc = 'Format buffer' })
  end,
}