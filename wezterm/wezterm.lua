-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- ==================== 通用设置 ====================

-- Enable native Wayland support for better integration and performance
-- Required for proper IME (fcitx5/rime) support on Wayland
config.enable_wayland = true

-- Enable IME (Input Method Editor) support for fcitx5/rime
config.use_ime = true

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

-- 通用透明度设置
config.window_background_opacity = 0.75

-- ==================== Linux 特定设置 ====================

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
    }
}

-- Linux: 使用本地 home 目录
config.default_cwd = wezterm.home_dir

-- 窗口装饰设置
config.window_decorations = "RESIZE"

-- SSH 域配置：默认连接到 arch-gaming
config.ssh_domains = {
    {
        name = 'arch-gaming',
        remote_address = 'arch-gaming',
    },
}

-- 设置默认域为 SSH
config.default_domain = 'arch-gaming'

-- 设置环境变量
config.set_environment_variables = {
    PATH = wezterm.home_dir .. '/.local/bin:' .. os.getenv('PATH'),
    -- Fix for NVIDIA Wayland DRM syncobj protocol error
    -- See: https://github.com/wezterm/wezterm/issues/6998
    __NV_DISABLE_EXPLICIT_SYNC = '1',
}

-- 返回配置（最后执行）
return config
