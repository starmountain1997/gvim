return {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
    flags = { debounce_text_changes = 150 },
    settings = {
        ty = {
            inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
            },
        },
    },
}
