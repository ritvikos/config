return {
  settings = {
    ["rust-analyzer"] = {
      linkedProjects = { "rust-project.json" },
      checkOnSave = false,
      procMacro = { enable = true },
    },
  },
  root_markers = { "rust-project.json", "Cargo.toml", ".git" },
}
