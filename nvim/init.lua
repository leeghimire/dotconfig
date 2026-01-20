local opt = vim.opt
opt.clipboard='unnamedplus'
opt.number=true
opt.relativenumber=true
opt.tabstop=4
opt.shiftwidth=4
opt.expandtab=true
opt.smartindent=true
opt.wrap=false
opt.scrolloff=5

local path=vim.fn.stdpath('data')..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(path) then
  vim.fn.system({'git','clone','--filter=blob:none','https://github.com/folke/lazy.nvim.git',path})
end
opt.rtp:prepend(path)

require('lazy').setup({
  'neovim/nvim-lspconfig',
  "R-nvim/R.nvim",
  {'hrsh7th/nvim-cmp',dependencies={'hrsh7th/cmp-nvim-lsp','L3MON4D3/LuaSnip'}},
  {'nvim-telescope/telescope.nvim',dependencies={'nvim-lua/plenary.nvim'}},
  {'Exafunction/windsurf.nvim',
    dependencies={'nvim-lua/plenary.nvim','hrsh7th/nvim-cmp'},
    config=function()
      require('codeium').setup({
        virtual_text={enabled=true,idle_delay=75,accept_fallback = "<Tab>",},
      })
    end,
  },
})

vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--clang-tidy',
    '--background-index',
    '--query-driver=/nix/store/*/bin/*'
  },
})
vim.lsp.enable('clangd')

vim.lsp.config('pyright', {})
vim.lsp.enable('pyright')

vim.lsp.config('zls', {})
vim.lsp.enable('zls')

vim.lsp.config('r_language_server', {
  cmd = { "R", "--no-echo", "-e", "languageserver::run()" },
})
vim.lsp.enable('r_language_server')

local cmp=require('cmp')
cmp.setup({
  mapping=cmp.mapping.preset.insert({
    ['<Tab>']=cmp.mapping.select_next_item(),
    ['<S-Tab>']=cmp.mapping.select_prev_item(),
    ['<CR>']=cmp.mapping.confirm({select=true}),
  }),
  sources={{name='nvim_lsp'},{name='codeium'}},
})

vim.g.mapleader=' '

vim.keymap.set('n','gd',vim.lsp.buf.definition,{})
vim.keymap.set('n','gi',vim.lsp.buf.implementation,{})
vim.keymap.set('n','gr',vim.lsp.buf.references,{})

local tb=require('telescope.builtin')
vim.keymap.set('n','<Leader>ff',tb.git_files,{})
vim.keymap.set('n','<Leader>fg',tb.live_grep,{})
vim.keymap.set('n','<Leader>fd',tb.diagnostics,{})
vim.keymap.set('n','<Leader>fc',tb.git_commits,{})

vim.keymap.set('n','<Leader>kj',function()vim.cmd('keepjumps normal! ggVG"+y')end,{})
