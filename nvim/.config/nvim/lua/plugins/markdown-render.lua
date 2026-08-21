return {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        render_modes = { "n", "c", "t" },
        latex = { enabled = false },
        checkbox = {
            enabled = true,
            unchecked = { icon = "󰄱 " }, -- [ ]
            checked = { icon = "󰱒 " }, -- [x]
            custom = {
                -- key names are arbitrary; `raw` is what you type in the note.
                todo = { raw = "[-]", rendered = "󰜺 ", highlight = "RenderMarkdownError" }, -- cancelled; overrides the built-in `todo` [-] clock (nf-md-cancel)
                important = { raw = "[!]", rendered = "󰀧 ", highlight = "RenderMarkdownWarn" }, -- important (nf-md-alert_box)
                question = { raw = "[?]", rendered = "󰋗 ", highlight = "RenderMarkdownHint" }, -- question (nf-md-help_circle)
                info = { raw = "[i]", rendered = "󰋼 ", highlight = "RenderMarkdownInfo" }, -- pending info (nf-md-information)
                escalated = { raw = "[u]", rendered = "󰁞 ", highlight = "RenderMarkdownWarn" }, -- escalated to bank (nf-md-arrow_up_bold)
                in_progress = { raw = "[/]", rendered = "󰔟 ", highlight = "RenderMarkdownTodo" }, -- in progress (nf-md-timer_sand)
                blocked = { raw = "[b]", rendered = "󰚌 ", highlight = "RenderMarkdownError" }, -- blocked (nf-md-block_helper)
                highest_priority = { raw = "[f]", rendered = "󰈸 ", highlight = "RenderMarkdownError" }, -- highest priority (nf-md-fire)
            },
        },
        pipe_table = {
            preset = "round",
            alignment_indicator = "┅",
        },
    },
}
