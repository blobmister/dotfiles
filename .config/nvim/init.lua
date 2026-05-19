-- Basic Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = false
vim.o.autoread = true
vim.o.cursorline = true
vim.o.cursorlineopt = "line,number"

-- Default keymaps
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-b>', '<C-b>zz')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Resize windows with Ctrl + arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize +2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize -2<cr>', { desc = 'Increase window width' })

-- Load in all plugins

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/lervag/vimtex" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/RRethy/base16-nvim" },
	{ src = "https://github.com/acksld/nvim-neoclip.lua" },
	{ src = "https://github.com/ibhagwan/fzf-lua" }
})

-- -- Themes setup

local theme_file = vim.fn.stdpath("data") .. "/current_theme.txt"
local f = io.open(theme_file, "r")
if f then
	local saved_theme = f:read("*l")
	f:close()
	if saved_theme and saved_theme ~= "" then
		pcall(vim.cmd.colorscheme, saved_theme)
	end
else
	vim.cmd.colorscheme("habamax")
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(args)
		local new_theme = args.match
		local out = io.open(theme_file, "w")
		if out then
			out:write(new_theme)
			out:close()
		end
	end,
})

require("lualine").setup({
	options = { theme = 'auto' }
})

-- LSP config
require("mason").setup()
local capabilities = require('blink.cmp').get_lsp_capabilities()
require("mason-lspconfig").setup({
	automatic_enable = true,
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities
			})
		end,
	}
})

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- Mini Modules
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.ai").setup()
require("mini.move").setup()
require("mini.cursorword").setup()
require("mini.indentscope").setup()

local miniclue = require('mini.clue')
miniclue.setup({
	triggers = {
		-- Leader triggers
		{ mode = { 'n', 'x' }, keys = '<Leader>' },

		-- `[` and `]` keys
		{ mode = 'n',          keys = '[' },
		{ mode = 'n',          keys = ']' },

		-- Built-in completion
		{ mode = 'i',          keys = '<C-x>' },

		-- `g` key
		{ mode = { 'n', 'x' }, keys = 'g' },

		-- Marks
		{ mode = { 'n', 'x' }, keys = "'" },
		{ mode = { 'n', 'x' }, keys = '`' },

		-- Registers
		{ mode = { 'n', 'x' }, keys = '"' },
		{ mode = { 'i', 'c' }, keys = '<C-r>' },

		-- Window commands
		{ mode = 'n',          keys = '<C-w>' },

		-- `z` key
		{ mode = { 'n', 'x' }, keys = 'z' },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
})

-- Neoclip

require('neoclip').setup()

-- fzf Setup

local fzf = require("fzf-lua")

vim.keymap.set('n', '<leader>ff', function() fzf.files( { hidden = false } ) end, { desc = 'Fzf files' })
vim.keymap.set('n', '<leader>fa', function() fzf.files({ hidden = true }) end, { desc = 'Fzf hidden files' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Fzf buffers' })
vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'Fzf help tags' })
vim.keymap.set('n', '<leader>ft', fzf.colorschemes, { desc = 'Fzf find themes' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_workspace, { desc = 'Fzf diagnostics' })
vim.keymap.set('n', '<leader>fc', function()
	fzf.files{ cwd = vim.fn.stdpath("config")}
end,
{ desc = 	'Fzf files in nvim directory' })


-- Blink setup
require("blink.cmp").setup()

-- ToggleTerm setup
require("toggleterm").setup({
	direction = "float",
	open_mapping = [[<C-\>]],
	float_opts = {
		border = "curved",
	},
})

-- VimTex setup
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_compiler_silent = 1

-- Oil.nvim
require("oil").setup()

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- termdebug
vim.cmd("packadd! termdebug")
vim.g.termdebug_wide = 1
