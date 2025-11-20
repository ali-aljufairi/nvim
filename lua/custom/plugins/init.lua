-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify", -- optional for notifications
    },
    opts = {
      -- configuration goes here
      lang = "python3", -- or "cpp", "java", etc. Change to your preferred language
    },
  },
}
