-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- ==================== 通用设置（所有平台共享）====================

-- Enable native Wayland support for better integration and performance
-- Disabled due to DRM sync object issues on current system
config.enable_wayland = false

-- 设置终端类型为 xterm-256color 以获得最佳兼容性
config.term = "xterm-256color"

-- 基础窗口设置（最先加载）
config.window_close_confirmation = 'NeverPrompt'

-- 字体渲染设置（核心视觉元素）
config.font = wezterm.font {
    -- family = 'Sarasa Term Slab SC',
    family = 'Fira Code',
    style = 'Normal',
}
config.font_size = 12.0

-- 主题颜色设置（视觉主题）
config.color_scheme = 'Dracula'

-- 标签页设置（固定标签页长度）
config.use_fancy_tab_bar = true  -- 使用现代样式的标签栏

-- 通用透明度设置（所有平台）
config.window_background_opacity = 0.75

-- ==================== 平台特定设置 ====================

-- Windows 和 Linux 共享的键绑定和鼠标设置
if wezterm.target_triple ~= 'x86_64-apple-darwin' then
  -- Windows 和 Linux 键绑定设置
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
    }
  }
end


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

  -- Windows 窗口背景效果配置
  config.win32_system_backdrop = 'Auto'
  config.window_decorations = "RESIZE"  -- 无边框窗口
  -- 透明度已在通用设置中统一配置
  -- 键绑定和鼠标绑定已在上面统一配置
 

elseif wezterm.target_triple == 'x86_64-apple-darwin' then
  -- macOS: 使用本地 home 目录
  config.default_cwd = wezterm.home_dir

  -- macOS 窗口背景模糊效果配置
  config.macos_window_background_blur = 20  -- 设置背景模糊半径（值越大模糊效果越明显）
  -- 透明度已在通用设置中统一配置
else
  -- Linux: 使用本地 home 目录
  config.default_cwd = wezterm.home_dir

  -- 透明度已在通用设置中统一配置

  -- Linux 窗口装饰设置
  config.window_decorations = "NONE"
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

