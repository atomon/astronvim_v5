return {
  "Exafunction/windsurf.vim", -- もしくは "Exafunction/codeium.vim"
  event = "InsertEnter",
  config = function()
    -- 1. デフォルトのTabキー設定を無効化（AstroNvimの補完と競合するため）
    vim.g.codeium_no_map_tab = 1

    -- 2. キーマッピングの設定
    -- 例: <C-g> を押すと、表示されているゴーストテキスト（数行含む）を一括で確定
    vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })

    -- (オプション) 次の候補・前の候補の切り替え
    -- vim.keymap.set(
    --   "i",
    --   "<C-;>",
    --   function() return vim.fn["codeium#CycleCompletions"](1) end,
    --   { expr = true, silent = true }
    -- )
    -- vim.keymap.set(
    --   "i",
    --   "<C-,>",
    --   function() return vim.fn["codeium#CycleCompletions"](-1) end,
    --   { expr = true, silent = true }
    -- )

    -- (オプション) 補完のクリア
    vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
  end,
}
