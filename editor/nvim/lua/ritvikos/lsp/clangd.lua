return {
  cmd = {
    "clangd",
    "--background-index",
    "--completion-style=detailed",
    "--clang-tidy",
    "--header-insertion=never",
    "-j=8",
    "--function-arg-placeholders",
  },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".git",
    "Makefile",
  },
  filetypes = { "c" },
}
