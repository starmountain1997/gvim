-- Treesitter configuration for syntax highlighting

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"python",
			"markdown",
			"markdown_inline",
			"lua",
			"javascript",
			"typescript",
			"json",
			"yaml",
		},
		highlight = { enable = true },
	},
}
