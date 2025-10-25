-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 跨平台配置：Windows 下默认使用 WSL，Linux 下使用本地
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- Windows: 设置默认域为 WSL，并指定默认工作目录为用户 home
  config.default_domain = 'WSL:Ubuntu'

  -- 配置 WSL 域，确保启动时进入正确的 home 目录
  config.wsl_domains = {
    {
      name = 'WSL:Ubuntu',
      distribution = 'Ubuntu',
      default_cwd = '/home/guozr',  -- 直接指定 WSL home 目录
    },
  }
else
  -- Linux: 使用本地 home 目录
  config.default_cwd = wezterm.home_dir
end

-- 设置环境变量（仅在 Linux 下设置）
if wezterm.target_triple ~= 'x86_64-pc-windows-msvc' then
  config.set_environment_variables = {
    PATH = wezterm.home_dir .. '/.local/bin:' .. os.getenv('PATH'),
  }
end

-- 鼠标设置
config.mouse_bindings = {
  -- 右键粘贴
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- 主体设置
config.color_scheme = 'Catppuccin Mocha'

-- 字体设置
config.font = wezterm.font {
    family = 'FiraCode Nerd Font Mono',
    style = 'Normal',
}
config.font_size = 10

-- 禁用窗口关闭确认提示
config.window_close_confirmation = 'NeverPrompt'

-- Finally, return the configuration to wezterm:
return config
