return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			filters = {
				custom = { "__pycache__", "%.egg-info" },
			},
		})
	end,
}
