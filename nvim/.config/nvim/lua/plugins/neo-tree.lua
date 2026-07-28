return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree toggle<CR>",
        desc = "Explorer NeoTree (toggle)",
      },
      {
        "<leader>o",
        "<cmd>Neotree reveal<CR>",
        desc = "Explorer NeoTree (reveal current file)",
      },
      {
        "<leader>ge",
        "<cmd>Neotree toggle git_status<CR>",
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        "<cmd>Neotree toggle buffers<CR>",
        desc = "Buffer Explorer",
      },
    },
  }
}
