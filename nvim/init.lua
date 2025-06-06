for k,v in pairs{clipboard='unnamedplus',number=true,relativenumber=true,
tabstop=4,shiftwidth=4,expandtab=true,smartindent=true,wrap=false,scrolloff=5} do vim.o[k]=v end

local p=vim.fn.stdpath('data')..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(p) then vim.fn.system({'git','clone','--filter=blob:none','https://github.com/folke/lazy.nvim.git',p}) end
vim.opt.rtp:prepend(p)

require('lazy').setup{
  'neovim/nvim-lspconfig',
  {'hrsh7th/nvim-cmp',dependencies={'hrsh7th/cmp-nvim-lsp','L3MON4D3/LuaSnip'}},
  {'nvim-telescope/telescope.nvim',dependencies={'nvim-lua/plenary.nvim'}},
}

for _,s in ipairs{'clangd','pyright', 'zls'} do require('lspconfig')[s].setup{} end

require('cmp').setup{
  mapping=require('cmp').mapping.preset.insert{
    ['<Tab>']=require('cmp').mapping.select_next_item(),
    ['<S-Tab>']=require('cmp').mapping.select_prev_item(),
    ['<CR>']=require('cmp').mapping.confirm{select=true},
  },
  sources={{name='nvim_lsp'}},
}

vim.g.mapleader = ' '

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})

local tb=require('telescope.builtin')
vim.keymap.set('n','<Leader>ff',tb.git_files,{})
vim.keymap.set('n','<Leader>fg',tb.live_grep,{})
vim.keymap.set('n','<Leader>fd',tb.diagnostics,{})
vim.keymap.set('n','<Leader>fc',tb.git_commits,{})
vim.keymap.set('n','<Leader>kj',function() vim.cmd('keepjumps normal! ggVG\"+y') end,{})
