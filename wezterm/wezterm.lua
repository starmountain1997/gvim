-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 基本配置设置
config.initial_cols = 120
config.initial_rows = 28
config.font_size = 12
config.color_scheme = 'AdventureTime'

-- 启用滚动条
config.enable_scroll_bar = true
config.min_scroll_bar_height = '2cell'

-- 设置默认工作目录为主目录
config.default_cwd = wezterm.home_dir

-- 设置环境变量
config.set_environment_variables = {
  PATH = wezterm.home_dir .. '/.local/bin:' .. os.getenv('PATH'),
}

-- 键位绑定
config.keys = {
  -- Ctrl+Shift+C 复制
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  -- Ctrl+Shift+V 粘贴
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- 鼠标设置
config.mouse_bindings = {
  -- 右键粘贴
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- 字体设置
config.font = wezterm.font {
    family = 'FiraCode Nerd Font Mono',
    style = 'Retina',
}

-- 窗口装饰
config.window_decorations = 'RESIZE'

-- 标签页设置
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Finally, return the configuration to wezterm:
return config