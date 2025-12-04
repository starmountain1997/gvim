return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- nvim-tree 配置：文件浏览器插件设置
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",  -- 区分大小写排序
      },
      view = {
        width = 30,  -- 设置文件浏览器宽度为30
      },
      renderer = {
        group_empty = true,  -- 将空目录分组显示
      },
      filters = {
        dotfiles = true,  -- 显示隐藏文件（以.开头的文件）
      },
    })
  end,
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" }
  }
}
