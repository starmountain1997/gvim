return {
  'HiPhish/rainbow-delimiters.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'BufReadPost',
  config = function()
    ---@type rainbow_delimiters.config
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
        vim = 'rainbow-delimiters.strategy.local',
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
      },
      priority = {
        [''] = 110,
        lua = 210,
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }

    -- 定义高亮组颜色
    vim.cmd [[
      highlight RainbowDelimiterRed   guifg=#c8556d ctermfg=Red
      highlight RainbowDelimiterYellow guifg=#e6c38a ctermfg=Yellow
      highlight RainbowDelimiterBlue   guifg=#7e9cd8 ctermfg=Blue
      highlight RainbowDelimiterOrange guifg=#f6a175 ctermfg=214
      highlight RainbowDelimiterGreen  guifg=#98bb6c ctermfg=Green
      highlight RainbowDelimiterViolet guifg=#938aa9 ctermfg=Magenta
      highlight RainbowDelimiterCyan   guifg=#7fb4ca ctermfg=Cyan
    ]]
  end,
}