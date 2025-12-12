-- Render Markdown plugin configuration

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    -- Minimal configuration - only enable the plugin
    require('render-markdown').setup({})
  end,
}