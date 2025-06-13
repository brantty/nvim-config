local keymap = vim.keymap.set

require("substitute").setup()

keymap("n", "t", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
keymap("n", "tt", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
keymap("n", "T", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
keymap("x", "t", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
vim.notify("Substitute setup")

keymap("n", "tx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
keymap("n", "txx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
keymap("n", "X", "<cmd>lua require('substitute.exchange').eol()<cr>", { noremap = true })
keymap("x", "txc", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
