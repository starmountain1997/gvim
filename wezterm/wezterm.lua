-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 基础窗口设置（最先加载）
config.window_close_confirmation = 'NeverPrompt'

-- 字体渲染设置（核心视觉元素）
config.font = wezterm.font {
    family = 'FiraCode Nerd Font Mono',
    style = 'Normal',
}
config.font_size = 10

-- 主题颜色设置（视觉主题）
config.color_scheme = 'Dracula'


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
  config.win32_system_backdrop = 'Acrylic'
  config.window_decorations = "INTEGRATED_BUTTONS"
  config.window_background_opacity = 0.75  -- Windows 下统一的透明度，无论窗口是否活动
  -- 鼠标设置：右键粘贴
  config.mouse_bindings = {
    -- 右键粘贴（仅 Windows）
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom 'Clipboard',
    },
  }

  -- 键绑定设置
  config.keys = {
    -- Ctrl+C 复制（替代默认的中断信号）
    {
      key = 'c',
      mods = 'CTRL',
      action = wezterm.action.CopyTo 'Clipboard',
    },
    -- Ctrl+V 粘贴
    {
      key = 'v',
      mods = 'CTRL',
      action = wezterm.action.PasteFrom 'Clipboard',
    },
    -- Ctrl+Shift+C 发送中断信号（替代原来的 Ctrl+C）
    {
      key = 'c',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SendKey { key = 'c', mods = 'CTRL' },
    },
  }
 

elseif wezterm.target_triple == 'x86_64-apple-darwin' then
  -- macOS: 使用本地 home 目录
  config.default_cwd = wezterm.home_dir

  -- macOS 窗口背景模糊效果配置
  config.macos_window_background_blur = 20  -- 设置背景模糊半径（值越大模糊效果越明显）
  config.window_background_opacity = 0.95  -- macOS 下适度的透明度
else
  -- Linux: 使用本地 home 目录
  config.default_cwd = wezterm.home_dir

  -- Linux 透明度配置（如果支持的话）
  config.window_background_opacity = 0.9  -- Linux 下轻度透明度
end

-- 设置环境变量（在 Linux 和 macOS 下设置）
if wezterm.target_triple ~= 'x86_64-pc-windows-msvc' then
  config.set_environment_variables = {
    PATH = wezterm.home_dir .. '/.local/bin:' .. os.getenv('PATH'),
  }
end

-- Windows 平台特定设置（键绑定补充）
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
end

-- 返回配置（最后执行）
return config

