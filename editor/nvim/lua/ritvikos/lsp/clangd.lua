local nproc_out = vim.fn.systemlist("nproc")
local nproc = (nproc_out and nproc_out[1]) or "2"

return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "-j",
    nproc,
    "--function-arg-placeholders",
    "--query-driver=**",
  },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".git",
    "Makefile",
    "Kbuild",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
}
