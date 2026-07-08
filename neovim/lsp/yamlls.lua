return {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
    root_markers = { ".git" },
    settings = {
        yaml = {
            format = { enable = true, singleQuote = false, bracketSpacing = true },
            validate = true,
            hover = true,
            completion = true,
            schemas = {},
        },
    },
}
