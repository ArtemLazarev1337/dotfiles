vim.o.mouse = 'a'
vim.wo.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
  'nvim-lualine/lualine.nvim',
  'ryanoasis/vim-devicons',
  'nvim-treesitter/nvim-treesitter',
  'folke/tokyonight.nvim',
  'preservim/nerdtree',
}

opts = {

}

require("lazy").setup(plugins, opts)

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  }
}

vim.g.airline_theme = 'simple'
vim.g.tokyonight_style = "storm" -- storm/night/day
vim.g.tokyonight_italic_functions = true -- Включает/отключает курсив для функций (по умолчанию включено)
vim.g.tokyonight_italic_comments = true -- Включает/отключает курсив для комментариев (по умолчанию включено)
vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"} -- Список сайдбаров, которые будут иметь фоновый цвет темы
vim.cmd [[colorscheme tokyonight]] -- Устанавливаем тему оформления
