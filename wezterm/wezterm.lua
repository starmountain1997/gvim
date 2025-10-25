-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 透明度配置
local opacity_inactive = 0.3   -- 不在焦点时的透明度
local opacity_active = 0.7     -- 获得焦点时的透明度

-- 窗口焦点变化事件：动态切换透明度
wezterm.on('window-focus-changed', function(window, pane)
    local overrides = window:get_config_overrides() or {}

    if window:is_focused() then
        overrides.window_background_opacity = opacity_active
    else
        overrides.window_background_opacity = opacity_inactive
    end

    window:set_config_overrides(overrides)
end)

-- 跨平台配置：Windows 下默认使用 WSL，Linux 和 macOS 使用本地
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

  -- Windows 窗口透明度和背景效果配置
  config.window_background_opacity = opacity_active  -- 使用动态透明度配置
  -- config.win32_system_backdrop = 'Mica'
elseif wezterm.target_triple == 'x86_64-apple-darwin' then
  -- macOS: 使用本地 home 目录
  config.default_cwd = wezterm.home_dir

  -- macOS 窗口背景模糊效果配置
  config.macos_window_background_blur = 20  -- 设置背景模糊半径（值越大模糊效果越明显）
  config.window_background_opacity = opacity_active  -- 保持动态透明度配置
else
  -- Linux: 使用本地 home 目录
  config.default_cwd = wezterm.home_dir
end

-- 设置环境变量（在 Linux 和 macOS 下设置）
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
