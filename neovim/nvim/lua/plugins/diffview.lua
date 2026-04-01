return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	opts = {},
	keys = {
		{ "<leader>do", ":DiffviewOpen<cr>", desc = "Open diffview" },
		{ "<leader>dh", ":DiffviewFileHistory<cr>", desc = "Open file history" },
		{ "<leader>dc", ":DiffviewClose<cr>", desc = "Close diffview" },
	},
}
