local M = {}

-- LSP servers
local lsp_servers = {
  -- lsp servers
  "bashls",
  "clangd",
  "cssls",
  "eslint",
  "gopls",
  "groovyls",
  "html",
  "jdtls",
  "jsonls",
  "kotlin_language_server",
  "lua_ls",
  "markdown_oxide",
  "pyright",
  "ruff",
  "rust_analyzer",
  "ts_ls",
  "vimls",
  "yamlls",
  "zls",
}

function M.lsp_servers()
  return lsp_servers
end

-- formatters and DAP
local dap_formatters = {
  "stylua",
  "isort",
  "black",
  "clang-format",
  -- "ruff_format",
  "goimports",
  -- "gofmt",
  -- "markdownfmt",
  "pgformatter",
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

  -- lint
  "eslint_d",

  -- DAPs
  "chrome-debug-adapter",
  "go-debug-adapter",
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
  for _, package in ipairs(dap_formatters) do
    local p = mason_registry.get_package(package)
    if not p:is_installed() then
      p:install()
    end
  end
end)

return M
