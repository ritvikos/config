return {
  settings = {
    ["rust-analyzer"] = {
      -- linkedProjects = { "rust-project.json" },
      checkOnSave = false,
      procMacro = { enable = true },
      cargo = {
        allFeatures = true,
      },
    },
  },
  root_markers = { "rust-project.json", "Cargo.toml", ".git" },
}
