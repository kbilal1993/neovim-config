-- My NeoVim config
-- Goals: Be minimalistic but easy to use. Be self-documenting using which-key
-- All of my special binds use <space> so as not to conflict with anything
-- By the way have you tried Neovide? Great UI for NeoVim. This config works with and without it.
-- Usage: Put this in .config/nvim, close and open NeoVim.

-- bootstrap lazy.nvim
-- If you don't have it installed, this installs it
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- set mapleader to space
-- Is this needed? idk
vim.g.mapleader = " "

-- List of plugins to install
require("lazy").setup({
	{
		-- Telescope: Quickly look at lists of things
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{
		-- LspConfig: Easily set up LSP servers in NeoVim
		"neovim/nvim-lspconfig",
	},
	{
		-- Which-Key: Lets you know what the command you're typing in does
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	},
	{
		-- The theme Ayu
		"Shatur/neovim-ayu"
	},
	{
		-- Quickly toggle a terminal window
		"akinsho/toggleterm.nvim",
		config = true

	}
})

-- setting up theme
local ayu = require('ayu');
ayu.colorscheme()

-- setting up telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<c-p>', builtin.find_files) -- ctrlp = find files

-- setting up which-key
local wk = require('which-key')

-- setting up LSP server
local lspconfig = require("lspconfig")

lspconfig.vuels.setup {} -- vue
lspconfig.rust_analyzer.setup {} -- rust
lspconfig.lua_ls.setup { --lua
	settings = {
		Lua = {
			diagnostics = {
				globals = { -- These are needed because otherwise the LSP complains about this file.
					'vim',
					'require',
					'opts',
					'ev'
				}
			}
		}
	}
}
-- When a LSP server is attached, provide these keybindings
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- bind keys
		vim.keymap.set('n', '<space>cp', builtin.diagnostics, opts)
		vim.keymap.set('n', '<space>cD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', '<space>cd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', '<space>ch', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<space>ci', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<space>cs', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
		-- add docs
		wk.register({
			c = {
				name = "Code commands",
				a = "Code action",
				s = "Signature help",
				i = "Implementation",
				h = "Hover",
				d = "Definition",
				D = "Declaration",
				p = "List all errors"
			}
		}, { prefix = "<space>"})
	end
})

-- toggleterm setup
require('toggleterm').setup {
	direction = 'float',
	float_opts = {
		border = 'single',
		width = 60
	}
}


-- Extra keybinds
vim.keymap.set('n', '<space>bl', builtin.buffers)
vim.keymap.set('n', '<space>bd', ':bd<cr>')
vim.keymap.set('n', '<space>ws', ':sp<cr>')
vim.keymap.set('n', '<space>wv', ':vs<cr>')
vim.keymap.set('n', '<space>ml', builtin.marks)
vim.keymap.set('n', '<space>vc', ':edit ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<space>tt', ':ToggleTerm<cr>')

wk.register({
	b = {
		name = "Buffer commands",
		l = "List all buffers",
		d = "Delete buffer"

	},
	w = {
		name = "Window commands",
		s = "Split window horizontally",
		v = "Split window vertically"
	},
	m = {
		name = "Mark commands",
		l = "List all marks"
	},
	v = {
		name = "Vim specific commands",
		c = "Edit Config"
	},
	t = {
		name = "Terminal commands",
		t = "Toggle popup terminal"
	}
}, {prefix = "<space>"})


-- Extra keymap to make using NeoVim terminals less annoying
vim.keymap.set('t', '<esc>', '<c-\\><c-n>') -- esc = leave terminal mode
