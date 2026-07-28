return {
  "nvim-neorg/neorg",
  lazy = false,
  version = "*",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            icon_preset = "varied",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
              other = "~/other",
            },
            default_workspace = "notes",
          },
        },
      },
    })
    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
}
