-- 获取当前行LSP诊断信息的自定义组件
local function current_line_diagnostics()
  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor_line })

    if #diagnostics == 0 then
      return ''
    end

    -- 获取第一个诊断信息
    local diagnostic = diagnostics[1]
    local message = diagnostic.message

    -- 截断过长的消息
    if #message > 60 then
      message = string.sub(message, 1, 57) .. '...'
    end

    -- 根据严重级别添加图标
    local icon = ''
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      icon = ''
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      icon = ''
    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
      icon = ''
    elseif diagnostic.severity == vim.diagnostic.severity.HINT then
      icon = ''
    end

    return icon .. ' ' .. message
  end
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'SessionLoadPost',
              'FileChangedShellPost',
              'VimResized',
              'Filetype',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
            },
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {
            {'filename'},
            {
              current_line_diagnostics(),
              color = { fg = '#ff6b6b' },
              separator = { left = ' | ', right = '' }
            }
          },
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end,
  },
}