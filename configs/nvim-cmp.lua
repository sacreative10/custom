

local cmp = require('cmp')

local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")


local opts = {

config = function()
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
        -- more sources
      -- recommended configuration for <Tab> people:
      mapping = {
        ["<Tab>"] = cmp.mapping(
          function(fallback)
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
          end,
          { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
        ),
        ["<S-Tab>"] = cmp.mapping(
          function(fallback)
            cmp_ultisnips_mappings.jump_backwards(fallback)
          end,
          { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
        ),
      },
    })
  end,
      sources = {
      { name = "ultisnips" },
      { name = "nvim_lsp", group_index = 2 },
      -- { name = "copilot",  group_index = 2 }, -- again if you have copilot.
      { name = "luasnip",  group_index = 2 },
      { name = "buffer",   group_index = 2 },
      { name = "nvim_lua", group_index = 2 },
      { name = "path",     group_index = 2 },
      },
}



return opts
