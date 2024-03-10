local M = {}


M.general = {
  n = {
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
    ["<leader>cf"] = {
      "<cmd> ClangdSwitchSourceHeader <CR>",
      "Switch between source and header",
    },
    ["<leader>cr"] = {
      "<cmd> ClangdRestart <CR>",
      "Restart clangd",
    },
    ["<leader>cd"] = {
      "<cmd> ClangdShowDiagnostics <CR>",
      "Show diagnostics",
    },
    ["<leader>ce"] = {
      "<cmd> ClangdError <CR>",
      "Show errors",
    },
    ["<leader>cc"] = {
      "<cmd> ClangdClose <CR>",
      "Close clangd",
    },
    ["<leader>cs"] = {
      "<cmd> ClangdStatus <CR>",
      "Show clangd status",
    },
    -- show hover info
    ["K"] = {
      "<cmd> ClangdHover <CR>",
      "Show hover info",
    },
    -- show code actions
    ["<leader>ca"] = {
      "<cmd> ClangdCodeAction <CR>",
      "Show code actions",
    },
    ["<leader>lc"] = {
      "<cmd>update<CR><cmd>VimtexCompile<CR>",
      "Continuous compilation",
    },
    ["<leader>ls"] = {
      "<Cmd>update<CR><Cmd>VimtexCompileSS<CR>",
      "Update file and compile (single shot)",
    },
    ["<leader>lv"] = {
      "<Cmd>VimtexView<CR>",
      "Update file and compile (single shot)",
    },
  },
  i = {
    ["C-i>"] = {"copilot#Accept('<CR>')", "Copilot accept", {expr = true, silent = true}},

  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugger",
    }
  }
}


return M
