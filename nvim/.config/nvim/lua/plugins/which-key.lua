return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      -- add a border around the which-key popup
      border = "rounded", -- "none" | "single" | "double" | "rounded" | "solid" | "shadow"
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
