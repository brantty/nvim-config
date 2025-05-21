local M = {}

-- LSP servers
local lsp_servers = {
  -- lsp servers
  "pyright",
  "ruff",
  "lua_ls",
  "vimls",
  "bashls",
  "yamlls",
  "ts_ls",
  "zls",
  "rust_analyzer",
}

function M.lsp_servers()
  return lsp_servers
end

-- formatters
local formatters = {
  "stylua",
  "isort",
  "black",
  -- "ruff_format",
  "goimports",
  -- "gofmt",
  -- "markdownfmt",
  "prettierd",
  "prettier",
  -- "rustfmt",
  "shfmt",
  "sqlfmt",
  "yamlfix",
  "yamlfmt",
  -- "zigfmt",
  "codespell",
  -- "trim_whitespace",
}

-- local ensure_installed = {}
-- for _, package in ipairs(packages) do
--   table.insert(ensure_installed, package)
-- end
-- for _, formatter in ipairs(formatters) do
--   table.insert(ensure_installed, formatter)
-- end

require("mason").setup {}
require("mason-lspconfig").setup {
  ensure_installed = lsp_servers,
  automatic_enable = true,
}

local mason_registry = require("mason-registry")
mason_registry:on("package:install:success", function()
  vim.defer_fn(function()
    -- trigger FileType event to possibly load this newly installed LSP server
    require("lazy.core.handler.event").trigger {
      event = "FileType",
      buf = vim.api.nvim_get_current_buf(),
    }
  end, 100)
end)

mason_registry.refresh(function()
  for _, package in ipairs(formatters) do
    local p = mason_registry.get_package(package)
    if not p:is_installed() then
      p:install()
    end
  end
end)

return M
