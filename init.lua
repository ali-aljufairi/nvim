if vim.g.vscode then
  -- VSCode extension
  vim.cmd 'source $HOME/.config/nvim/vscode/settings.vim'
  vim.cmd 'source $HOME/.config/nvim/vscode/config.vim'
  vim.cmd 'source $HOME/.config/nvim/vscode/vimcom.vim'
  vim.cmd 'source $HOME/.config/nvim/vscode/scope.vim'
else
  -- Ordinary Neovim
  require 'base' -- Load vimrc
end
