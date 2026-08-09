--Fix errors in lua.config
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			diagnostics = { globals = { 'vim' } },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			telemetry = { enable = false },
		},
	},
})

-- Basic Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.number = true
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
	{ src = "https://github.com/saghen/blink.cmp",                           version = vim.version.range('^1') },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/lervag/vimtex" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/RRethy/base16-nvim" },
	{ src = "https://github.com/acksld/nvim-neoclip.lua" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = 'main' },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/kevinhwang91/promise-async" },
	{ src = "https://github.com/kevinhwang91/nvim-ufo" },
	{ src = "https://github.com/luukvbaal/statuscol.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/nvimdev/dashboard-nvim" },
})

-- Pack Clean

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

vim.keymap.set('n', '<leader>pc', pack_clean)

-- Dashboard setup

local db = require('dashboard')

local custom_header = {
	[[                         ███                 ]],
	[[                        ░░░                  ]],
	[[ ████████   █████ █████ ████  █████████████  ]],
	[[░░███░░███ ░░███ ░░███ ░░███ ░░███░░███░░███ ]],
	[[ ░███ ░███  ░███  ░███  ░███  ░███ ░███ ░███ ]],
	[[ ░███ ░███  ░░███ ███   ░███  ░███ ░███ ░███ ]],
	[[ ████ █████  ░░█████    █████ █████░███ █████]],
	[[░░░░ ░░░░░    ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░ ]],
	[[                                             ]],

	os.date("%A, %d %B %Y  |  %H:%M"),
	"",
	"",
}

db.setup({
	theme = 'doom',

	config = {
		header = custom_header,
		center = {
			{
				desc = 'Find File',
				desc_hl = 'String',
				key = 'f',
				key_hl = 'Number',
				action = "lua require('fzf-lua').files()"
			},
			{
				desc = 'Grep',
				desc_hl = 'String',
				key = 'g',
				key_hl = 'Number',
				action = "lua require('fzf-lua').live_grep()"

			},
			{
				desc = 'Tmux Sessionizer',
				desc_hl = 'String',
				key = 's',
				key_hl = 'Number',
				action = 'TmuxSessionizer'
			},
			{
				desc = 'Tmux Sessions',
				desc_hl = 'String',
				key = 'r',
				key_hl = 'Number',
				action = 'TmuxSwitchSession'
			},
			{
				desc = 'Open Dotfiles',
				desc_hl = 'String',
				key = 'd',
				key_hl = 'Number',
				action = "lua require('fzf-lua').files({ cwd = '~/.config' })"
			},
			{
				desc = 'Scratch Buffer',
				desc_hl = 'String',
				key = 'n',
				key_hl = 'Number',
				action = 'enew | setlocal buftype=nofile bufhidden=hide noswapfile'
			},
		},
		footer = {},
		vertical_center = true,
	}
})

-- Themes setup

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
	options = { theme = 'auto' },
})

require("lualine").setup({
  options = { theme = 'auto' },

  winbar = {
    lualine_x = {
      {
        'filename',
        path = 3, 
        shorting_target = 40,
      }
    }
  },

  inactive_winbar = {
    lualine_x = {
      {
        'filename',
        path = 1,
      }
    }
  }
})


-- LSP config
require("mason").setup()
local capabilities = require('blink.cmp').get_lsp_capabilities()
require("mason-lspconfig").setup({
	automatic_enable = true,
	handleprs = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities
			})
		end,
	}
})

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- Treesitter
require('nvim-treesitter').setup()

-- Treesitter highlighting

vim.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- Treesitter Textobjects config

require("nvim-treesitter-textobjects").setup {
	select = {
		lookahead = true
	},
	move = {
		set_jumps = true,
	},
}

vim.keymap.set({ "x", "o" }, "am", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end, { desc = "treesitter around method/function" })
vim.keymap.set({ "x", "o" }, "im", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end, { desc = "treesitter inner method/function" })
vim.keymap.set({ "x", "o" }, "ac", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end, { desc = "treesitter around class" })
vim.keymap.set({ "x", "o" }, "ic", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end, { desc = "treesitter inner class" })
vim.keymap.set({ "x", "o" }, "ik", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@block.inner", "textobjects")
end, { desc = "treesitter block inner" })
vim.keymap.set({ "x", "o" }, "ak", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@block.outer", "textobjects")
end, { desc = "treesitter block outer" })
vim.keymap.set({ "x", "o" }, "al", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@loop.outer", "textobjects")
end, { desc = "treesitter loop outer" })
vim.keymap.set({ "x", "o" }, "il", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@loop.inner", "textobjects")
end, { desc = "treesitter loop inner" })
vim.keymap.set({ "x", "o" }, "ai", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@conditional.outer", "textobjects")
end, { desc = "treesitter conditional outer" })
vim.keymap.set({ "x", "o" }, "ii", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@conditional.inner", "textobjects")
end, { desc = "treesitter conditional inner" })
vim.keymap.set({ "x", "o" }, "i/", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@comment.inner", "textobjects")
end, { desc = "treesitter comment inner" })
vim.keymap.set({ "x", "o" }, "a/", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@comment.outer", "textobjects")
end, { desc = "treesitter comment outer" })

-- Movement

vim.keymap.set({ "n", "x", "o" }, "]m", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end, { desc = "treesitter goto next function" })
vim.keymap.set({ "n", "x", "o" }, "]l", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
end, { desc = "treesitter goto next loop" })
vim.keymap.set({ "n", "x", "o" }, "]k", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "locals")
end, { desc = "treesitter goto next block" })
vim.keymap.set({ "n", "x", "o" }, "]i", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "locals")
end, { desc = "treesitter goto next conditional" })
vim.keymap.set({ "n", "x", "o" }, "]c", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end, { desc = "treesiter goto next class" })
vim.keymap.set({ "n", "x", "o" }, "[m", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end, { desc = "treesitter goto prev function" })
vim.keymap.set({ "n", "x", "o" }, "[c", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end, { desc = "treesiter goto prev class" })
vim.keymap.set({ "n", "x", "o" }, "[l", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end, { desc = "treesitter goto prev loop" })
vim.keymap.set({ "n", "x", "o" }, "[k", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "locals")
end, { desc = "treesittter goto prev block" })
vim.keymap.set({ "n", "x", "o" }, "[i", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "locals")
end, { desc = "treesitter goto prev conditional" })
vim.keymap.set({ "n", "x", "o" }, "]/", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@comment.outer", "textobjects")
end, { desc = "treesitter goto next comment" })

vim.keymap.set({ "n", "x", "o" }, "[/", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@comment.outer", "textobjects")
end, { desc = "treesitter goto prev comment" })

local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, { desc = "Repeat last move" })
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite, { desc = "Undo last move" })
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- Mini Modules

require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
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

vim.keymap.set('n', '<leader>ff', function() fzf.files({ hidden = false }) end, { desc = 'Fzf files' })
vim.keymap.set('n', '<leader>fa', function() fzf.files({ hidden = true }) end, { desc = 'Fzf hidden files' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Fzf buffers' })
vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'Fzf help tags' })
vim.keymap.set('n', '<leader>ft', fzf.colorschemes, { desc = 'Fzf find themes' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_workspace, { desc = 'Fzf diagnostics' })
vim.keymap.set('n', '<leader>fc', function()
		fzf.files { cwd = vim.fn.expand("~/.config") }
	end,
	{ desc = 'Fzf files in nvim directory' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Fzf live grep' })
vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = 'Fzf grep word under cursor' })
vim.keymap.set('v', '<leader>fw', fzf.grep_visual, { desc = 'Fzf grep visual selection' })
vim.keymap.set('n', '<leader>lr', fzf.lsp_references, { desc = 'Fzf LSP references' })
vim.keymap.set('n', '<leader>ld', fzf.lsp_definitions, { desc = 'Fzf LSP definitions' })
vim.keymap.set('n', '<leader>ls', fzf.lsp_workspace_symbols, { desc = 'Fzf LSP workspace symbols' })
vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, { desc = "Fzf code actions" })
vim.keymap.set('n', '<leader>fy', function()
	require('neoclip.fzf')()
end, { desc = 'Fzf clipboard/yank history' })
vim.keymap.set('n', '<leader>fk', fzf.keymaps, { desc = "Fzf keymaps" })

-- Blink setup
require("blink.cmp").setup()


-- Toggleterm setup

require("toggleterm").setup({
    float_opts = {
        border = "curved",
    },
})
vim.keymap.set("n", "<C-\\>", function()
    vim.cmd("1ToggleTerm direction=float dir=" .. vim.fn.getcwd())
end, { desc = "Toggle floating terminal in CWD" })
vim.keymap.set("t", "<C-\\>", "<cmd>1ToggleTerm<cr>", { desc = "Close Terminal 1" })

vim.keymap.set("n", "<C-t>", function()
    local file_dir = vim.fn.expand("%:p:h")
    local buf_id = vim.api.nvim_get_current_buf()
    local term_id = buf_id + 100 
    vim.cmd(term_id .. "ToggleTerm direction=horizontal dir=" .. file_dir)
end, { desc = "Toggle unique terminal for this file" })

-- In terminal mode, we don't need to calculate the ID.
-- Calling ToggleTerm with no number just closes whatever terminal you are currently inside.
vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<cr>", { desc = "Close current terminal" })

-- VimTex setup
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_compiler_silent = 1

-- Oil Setup
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })



-- termdebug
vim.cmd("packadd! termdebug")
vim.g.termdebug_wide = 1

-- TMUX sessionizer in fzf-lua

vim.api.nvim_create_user_command('TmuxSessionizer', function()
	local cmd = "fd --type d --hidden --exclude .git"
	require('fzf-lua').fzf_exec(cmd, {
		prompt = "Tmux Sessionizer> ",
		cwd = vim.env.HOME,
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then return end

				local selected_path = selected[1]:match("^%s*(.-)%s*$")
				local full_path = vim.env.HOME .. "/" .. selected_path

				local script_cmd = vim.fn.expand("~/.local/bin/tmux-sessionizer.sh")
				vim.fn.system({ script_cmd, full_path })

				vim.notify("Switching to session for: " .. selected_path, vim.log.levels.INFO)
			end
		}
	})
end, {})

vim.api.nvim_create_user_command('TmuxSwitchSession', function()
	local cmd = "tmux list-sessions -F '#{session_name}'"
	require('fzf-lua').fzf_exec(cmd, {
		prompt = "Switch Tmux Session> ",
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then return end
				local session_name = selected[1]
				vim.fn.system("tmux switch-client -t " .. vim.fn.shellescape(session_name))
			end
		}
	})
end, {})


vim.keymap.set('n', '<leader>ts', ':TmuxSessionizer<CR>', { desc = 'Tmux Sessionizer' })
vim.keymap.set('n', '<leader>tr', ':TmuxSwitchSession<CR>', { desc = 'Switch Tmux Session' })

-- Better fold support
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all fold expressions" })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all fold expressions" })
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = "Fold less" })
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = "Fold more" })

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (' 󰁂 %d '):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, 'MoreMsg' })
	return newVirtText
end

require('ufo').setup({
	fold_virt_text_handler = handler
})


require('ufo').setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { 'treesitter', 'indent' }
	end,
})

-- status-col
vim.opt.number = true
vim.opt.relativenumber = true

local builtin = require("statuscol.builtin")
require('statuscol').setup({
	setopt = true,
	segments = {
		{ text = { builtin.foldfunc } },
		{ text = { '%s' } },
		{
			text = { builtin.lnumfunc, ' ' },
			condition = { true, builtin.not_empty },
		},
	},
})

local augroup = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false

			-- Workaround for https://github.com/neovim/neovim/issues/32068
			if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
				vim.cmd "redraw"
			end
		end
	end,
})

vim.opt.fillchars:append({
	foldopen = "",
	foldclose = "",
	foldsep = " ",
})

-- Git Integration
require('gitsigns').setup {
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', function()
			if vim.wo.diff then
				vim.cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
		end, { desc = "Git: Jump to next hunk" })

		map('n', '[c', function()
			if vim.wo.diff then
				vim.cmd.normal({ '[c', bang = true })
			else
				gitsigns.nav_hunk('prev')
			end
		end, { desc = "Git: Jump to previous hunk" })

		-- Actions
		map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "Git: Stage hunk" })
		map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Git: Reset hunk" })

		map('v', '<leader>hs', function()
			gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end, { desc = "Git: Stage selected lines" })

		map('v', '<leader>hr', function()
			gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end, { desc = "Git: Reset selected lines" })

		map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "Git: Stage entire buffer" })
		map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "Git: Reset entire buffer" })
		map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Git: Preview hunk in float" })
		map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = "Git: Preview hunk inline" })

		map('n', '<leader>hb', function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Git: Show full line blame" })

		map('n', '<leader>hd', gitsigns.diffthis, { desc = "Git: Diff against index" })

		map('n', '<leader>hD', function()
			gitsigns.diffthis('~')
		end, { desc = "Git: Diff against last commit" })

		map('n', '<leader>hQ', function() gitsigns.setqflist('all') end,
			{ desc = "Git: Send all project hunks to quickfix" })
		map('n', '<leader>hq', gitsigns.setqflist, { desc = "Git: Send buffer hunks to quickfix" })

		-- Toggles
		map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Git: Toggle inline blame text" })
		map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Git: Toggle word-level diff" })

		-- Text object
		map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = "Git: Select inner hunk" })
	end
}


-- quickfix keybinds
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Quickfix: Next item" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Quickfix: Previous item" })
vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Quickfix: Open window" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Quickfix: Close window" })


