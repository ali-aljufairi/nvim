vim.keymap.set('i', '<C-j>', function() return vim.fn["<C-n>"] end, {expr = true, noremap = true})
vim.keymap.set('i', '<C-k>', function() return vim.fn["<C-p>"] end, {expr = true, noremap = true})
