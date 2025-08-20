return {
  { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'arkav/lualine-lsp-progress' },
    config = function()
      require("lualine").setup({
        sections = {
          lualine_c = {
            'lsp_progress'
          }
        }
      })
    end
  },
  { "lewis6991/gitsigns.nvim",         lazy = false,      opts = {},    config = function() require("gitsigns").setup() end },
}
