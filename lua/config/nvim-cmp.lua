-- Setup nvim-cmp.
local cmp = require("cmp")
local luasnip = require("luasnip")
local compare = require("cmp.config.compare")
local neotab = require("neotab")

-- The extensions needed by nvim-cmp should be loaded beforehand
require("cmp_nvim_lsp")
require("cmp_path")
require("cmp_buffer")
require("cmp_omni")
-- require("cmp_nvim_ultisnips")
require("cmp_cmdline")

local MiniIcons = require("mini.icons")

local source_names = {
  nvim_lsp = "[LSP]",
  luasnip = "[Snippet]",
  buffer = "[Buffer]",
  path = "[Path]",
}

local duplicates = {
  buffer = 1,
  path = 1,
  nvim_lsp = 0,
  luasnip = 1,
}

local function has_word_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_word_before() then
        cmp.complete()
      else
        neotab.tabout()
      end
    end, { "i", "s", "c" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s", "c" }),
    ["<C-,>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping {
      i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
        else
          fallback()
        end
      end,
    },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = cmp.mapping.close(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  },
  sources = {
    { name = "nvim_lsp", group_index = 1 }, -- For nvim-lsp
    -- { name = "ultisnips" }, -- For ultisnips user.
    { name = "luasnip", group_index = 1 }, -- For ultisnips user.
    { name = "path", group_index = 2 }, -- for path completion
    { name = "buffer", group_index = 2, keyword_length = 2 }, -- for buffer word completion
  },
  completion = {
    keyword_length = 1,
    completeopt = "menu,menuone,noselect",
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.score,
      compare.recently_used,
      compare.offset,
      compare.exact,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  view = {
    entries = "custom",
  },
  -- solution taken from https://github.com/echasnovski/mini.nvim/issues/1007#issuecomment-2258929830
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(vim_entry, vim_item)
      local icon, hl = MiniIcons.get("lsp", vim_item.kind)
      vim_item.kind = icon .. " " .. vim_item.kind
      vim_item.kind_hl_group = hl
      local duplicates_default = 0
      vim_item.menu = source_names[vim_entry.source.name]
      vim_item.dup = duplicates[vim_entry.source.name] or duplicates_default
      return vim_item
    end,
  },
}

cmp.setup.filetype("tex", {
  sources = {
    { name = "omni" },
    { name = "ultisnips" }, -- For ultisnips user.
    { name = "buffer", keyword_length = 2 }, -- for buffer word completion
    { name = "path" }, -- for path completion
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

--  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd([[
  highlight! link CmpItemMenu Comment
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])
