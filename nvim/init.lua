local opt = vim.opt
opt.number=true
opt.relativenumber=true
opt.scrolloff=5
opt.shiftwidth=4
opt.expandtab=true
opt.smartindent=true
opt.tabstop=4
opt.wrap=false
opt.clipboard='unnamedplus'

opt.background = 'light'

vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
]])

local path=vim.fn.stdpath('data')..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(path) then
  vim.fn.system({'git','clone','--filter=blob:none','https://github.com/folke/lazy.nvim.git',path})
end
opt.rtp:prepend(path)

require('lazy').setup({
  'neovim/nvim-lspconfig',
  {'hrsh7th/nvim-cmp',dependencies={'hrsh7th/cmp-nvim-lsp','L3MON4D3/LuaSnip'}},
  {'nvim-telescope/telescope.nvim',dependencies={'nvim-lua/plenary.nvim'}}
})

vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('vtsls')

local cmp=require('cmp')
cmp.setup({
  mapping=cmp.mapping.preset.insert({
    ['<Tab>']=cmp.mapping.select_next_item(),
    ['<S-Tab>']=cmp.mapping.select_prev_item(),
    ['<CR>']=cmp.mapping.confirm({select=true}),
  }),
  sources={{name='nvim_lsp'}},
})

vim.diagnostic.config({virtual_text = true})

vim.g.mapleader=' '

vim.keymap.set('n','<Leader>gd',vim.lsp.buf.definition,{})
vim.keymap.set('n','<Leader>gi',vim.lsp.buf.implementation,{})
vim.keymap.set('n','<Leader>gr',vim.lsp.buf.references,{})

local tb=require('telescope.builtin')
vim.keymap.set('n','<Leader>ff',tb.git_files,{})
vim.keymap.set('n','<Leader>fg',tb.live_grep,{})
vim.keymap.set('n','<Leader>fd',tb.diagnostics,{})

vim.keymap.set('n','<Leader>kj','ggyG',{})
