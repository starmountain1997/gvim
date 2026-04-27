-- Resolve basedpyright-langserver from the same bin dir as `node` to avoid
-- picking up a broken pip-installed wrapper from an active venv.
local node_bin = vim.fn.fnamemodify(vim.fn.exepath("node"), ":h")
local langserver = node_bin ~= "" and (node_bin .. "/basedpyright-langserver") or "basedpyright-langserver"

return {
    cmd = { langserver, "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                ignore = { "*" },
            },
        },
    },
}
