# nvim-cmp 代码补全配置研究报告

## 一、接口规范

### 核心 API

nvim-cmp 的核心配置通过 `require('cmp').setup()` 进行：

```lua
local cmp = require('cmp')

cmp.setup({
  snippet = { ... },      -- 代码片段引擎配置（必需）
  mapping = { ... },      -- 键盘映射
  sources = { ... },      -- 补全源配置
  window = { ... },       -- 窗口样式（可选）
  formatting = { ... },   -- 格式化显示（可选）
})
```

### 与 LSP 集成的关键 API

```lua
-- 获取 LSP 兼容的 capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- 在 LSP 服务器配置中使用
require('lspconfig')[server_name].setup {
  capabilities = capabilities
}
```

## 二、基础使用

### 最小化配置所需插件

基于官方文档和社区实践，最小化配置需要以下插件：

1. **核心插件**（必需）
   - `hrsh7th/nvim-cmp` - 补全引擎核心
   - `hrsh7th/cmp-nvim-lsp` - LSP 补全源
   - `neovim/nvim-lspconfig` - LSP 配置

2. **代码片段引擎**（必需其一）
   - 选项 1：**Neovim 原生 snippet**（推荐 Neovim 0.10+）
   - 选项 2：`hrsh7th/vim-vsnip` + `hrsh7th/cmp-vsnip`
   - 选项 3：`L3MON4D3/LuaSnip` + `saadparwaiz1/cmp_luasnip`

3. **额外补全源**（可选）
   - `hrsh7th/cmp-buffer` - 缓冲区文本补全
   - `hrsh7th/cmp-path` - 文件路径补全

### 插件安装示例

使用 lazy.nvim（推荐）:

```lua
{
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
}
```

使用 packer.nvim:

```lua
use {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  }
}
```

## 三、最小化配置示例

### 方案一：使用 Neovim 原生 Snippet（最简单）

**适用于 Neovim 0.10+**

```lua
local cmp = require('cmp')

-- 设置 completeopt
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)  -- Neovim 原生 snippet
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- LSP 集成
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')[YOUR_LSP_SERVER].setup {
  capabilities = capabilities
}
```

### 方案二：使用 vim-vsnip（轻量级）

```lua
local cmp = require('cmp')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- LSP 集成（同上）
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')[YOUR_LSP_SERVER].setup {
  capabilities = capabilities
}
```

## 四、进阶技巧

### 1. 源配置优化

使用 `group_index` 控制补全源优先级：

```lua
sources = cmp.config.sources({
  { name = 'nvim_lsp', group_index = 1 },
  { name = 'buffer', group_index = 2 },
})
```

### 2. 性能优化

```lua
cmp.setup({
  performance = {
    debounce = 60,        -- 防抖延迟（毫秒）
    throttle = 30,        -- 节流延迟（毫秒）
  },
  sources = {
    {
      name = 'buffer',
      keyword_length = 3,  -- 至少输入 3 个字符才触发
    },
  },
})
```

### 3. 特定文件类型配置

```lua
-- 为 Markdown 文件配置不同的补全源
cmp.setup.filetype({ 'markdown', 'help' }, {
  sources = {
    { name = 'path' },
    { name = 'buffer' },
  }
})
```

### 4. 命令行补全

```lua
-- 搜索模式补全
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- 命令行模式补全
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
```

## 五、巧妙用法

### 1. 条件禁用补全

在注释中禁用补全：

```lua
cmp.setup({
  enabled = function()
    local context = require('cmp.config.context')
    return not context.in_syntax_group('Comment')
  end
})
```

### 2. 特定缓冲区禁用

```lua
-- 在某个缓冲区禁用补全
require('cmp').setup.buffer { enabled = false }
```

### 3. 自定义补全项过滤

```lua
sources = {
  {
    name = 'nvim_lsp',
    entry_filter = function(entry, ctx)
      -- 过滤掉 Text 类型的补全项
      return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
    end
  }
}
```

## 六、注意事项

### 1. Snippet 引擎是必需的

nvim-cmp **必须**配置一个 snippet 引擎，否则会报错。如果不想使用额外插件，Neovim 0.10+ 可以使用原生的 `vim.snippet.expand`。

### 2. completeopt 设置

建议设置：
```lua
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
```

- `menu`: 显示补全菜单
- `menuone`: 即使只有一个匹配也显示菜单
- `noselect`: 不自动选中第一项

### 3. 事件触发配置

如果使用 lazy.nvim，需要包含 `CmdlineEnter` 事件以支持命令行补全：

```lua
{
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
}
```

### 4. LSP capabilities 配置

**必须**在 LSP 服务器配置中添加 nvim-cmp 的 capabilities，否则 LSP 补全不会正常工作：

```lua
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').lua_ls.setup {
  capabilities = capabilities  -- 重要！
}
```

### 5. 键位映射注意

- 使用 `cmp.mapping.preset.insert()` 可以获得默认的插入模式键位映射
- `['<CR>']` 的 `select = true` 表示会自动选中第一项并确认

## 七、真实代码片段

### 来自 LazyVim 的配置

```lua
{
  "hrsh7th/nvim-cmp",
  version = false,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
}
```

### 来自 ThePrimeagen 的配置

```lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
}
```

### 简洁的 Neovim 原生 snippet 配置

来自 jonhoo/configs:

```lua
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)  -- 使用原生 snippet
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})
```

## 八、推荐方案总结

### 对于最小化配置（推荐）

1. **必需插件**：
   - `hrsh7th/nvim-cmp`
   - `hrsh7th/cmp-nvim-lsp`
   - `hrsh7th/cmp-buffer`（可选但推荐）
   - `hrsh7th/cmp-path`（可选但推荐）

2. **Snippet 引擎**：
   - Neovim 0.10+: 使用原生 `vim.snippet.expand`（无需额外插件）
   - Neovim < 0.10: 使用 `vim-vsnip`（最轻量级）

3. **配置复杂度**：约 20-30 行代码即可完成基础配置

### 为什么推荐原生 snippet

1. **零依赖**：Neovim 0.10+ 内置支持
2. **简单**：无需额外插件和配置
3. **够用**：满足 LSP 补全的基本需求
4. **轻量**：不增加启动时间

## 九、引用来源

### 官方文档
- nvim-cmp GitHub: https://github.com/hrsh7th/nvim-cmp
- nvim-cmp Wiki: https://github.com/hrsh7th/nvim-cmp/wiki
- 官方文档: https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt

### 社区资源
- LazyVim 配置: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/nvim-cmp.lua
- ThePrimeagen 配置: https://github.com/ThePrimeagen/init.lua
- 各种真实项目配置来自 GitHub 搜索结果

### 关键信息来源
- 插件依赖列表：官方 README 和 Wiki
- LSP 集成方法：官方文档和社区最佳实践
- Snippet 引擎对比：官方文档和 GitHub 实际使用案例
- 性能优化技巧：社区配置和官方 API 文档
