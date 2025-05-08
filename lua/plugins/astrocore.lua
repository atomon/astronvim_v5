-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing


local opt_config = function()
  local opt = {}

  -- set to true or false etc.
  opt["relativenumber"] = false -- sets vim.opt.relativenumber
  opt["number"] = true          -- sets vim.opt.number
  opt["spell"] = false          -- sets vim.opt.spell
  opt["signcolumn"] = "auto"    -- sets vim.opt.signcolumn to auto
  opt["wrap"] = false           -- sets vim.opt.wrap
  opt["mousescroll"] = { "ver:9", "hor:6" }
  opt["tabstop"] = 4
  opt["shiftwidth"] = 4

  if vim.fn.executable == "pwsh" then
    -- sets Nvim terminal for pwsh (https://www.siddharta.me/configuring-neovim-as-a-python-ide-2023.html)
    opt["shell"] = "pwsh"
    opt["shellcmdflag"] =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    opt["shellredir"] = "-RedirectStandardOutput %s -NoNewWindow -Wait"
    opt["shellpipe"] = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    opt["shellquote"] = ""
    opt["shellxquote"] = ""
  else
    opt["shell"] = "/bin/bash"
  end

  return opt
end

local g_config = function()
  local g = {}

  -- configure global vim variables (vim.g)
  -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
  -- This can be found in the `lua/lazy_setup.lua` file
  if vim.fn.executable == "pwsh" then g["python3_host_prog"] = vim.fn.system { "which", "python3" } end

  g["presence_editing_text"] = "Editing code"
  g["presence_workspace_text"] = "Working on workspace"

  return g
end


---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },             -- set global limits for large files for disabling features like treesitter
      autopairs = true,                                             -- enable autopairs at start
      cmp = true,                                                   -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true,                                          -- highlight URLs at start
      notifications = true,                                         -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = opt_config(), -- vim.opt.<key>
      g = g_config(),     -- vim.g.<key>
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
        ["<ESC>"] = { "<C-\\><C-n>", desc = "change normal mode" },
      },
      v = {
        ["J"] = { ":move '>+1<CR>gv-gv", desc = "Move lines of code up" },
        ["K"] = { ":move '<-2<CR>gv-gv", desc = "Move lines of code down" },
      },
    },
  },
}
