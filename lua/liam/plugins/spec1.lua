return {
  -- editor colorscheme
  {
    -- dependency for jellybeans-nvim
    "rktjmp/lush.nvim",
    lazy = false,
    priority = 1001, -- load first
  },
  {
    "metalelf0/jellybeans-nvim",
    lazy = false,    -- load during startup
    priority = 1000, -- load second (make sure lush available first)
    config = function()
      -- load colorscheme via necessary vim command
      vim.cmd([[colorscheme jellybeans-nvim]])
    end,
  },
  {
    -- treesitter, better syntax highlighting
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate"
  },
  {
    -- telescope, our fuzzy finder
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { "<leader>pf", "<cmd>Telescope find_files<cr>" },
      { "<C-p>",      "<cmd>Telescope git_files<cr>" },
      { "<leader>ps", "<cmd>Telescope live_grep<cr>" },
    },
    lazy = false
  },
  {
    -- zen mode, for use with :ZenMode for opening minimal buffers
    "folke/zen-mode.nvim",
  },
  {
    -- display images inside nvim (useful for .md and .ipynb's)
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
    },
    config = function()
      -- image nvim options table. Pass to `require('image').setup`
      require('image').setup({
        backend = "kitty",                        -- Kitty will provide the best experience, but you need a compatible terminal (i.e. my Ghostty)
        integrations = {},                        -- do whatever you want with image.nvim's integrations
        max_width = 100,                          -- tweak to preference
        max_height = 12,                          -- ^
        max_height_window_percentage = math.huge, -- this is necessary for a good experience
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- enable language servers here

      -- deno prereq
      vim.g.markdown_fenced_languages = { "ts=typescript" }
      -- deno
      vim.lsp.enable('denols')

      -- lua
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              }
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      vim.lsp.enable('lua_ls')

      -- astro js
      vim.lsp.enable('astro')
    end
  },
}
