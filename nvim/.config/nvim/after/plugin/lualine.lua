if vim.g.vscode then return end

local M = {}
M.theme = function()
	-- slightly modified onedark theme from the lualine repo

	-- Copyright (c) 2020-2021 shadmansaleh
	-- MIT license, see LICENSE for more details.
	-- Credit: Zoltan Dalmadi(lightline)
	-- stylua: ignore
	local colors = {
		blue   = '#61afef',
		green  = '#98c379',
		purple = '#c678dd',
		cyan   = '#56b6c2',
		red1   = '#e06c75',
		red2   = '#be5046',
		yellow = '#e5c07b',
		fg     = '#abb2bf',
		bg     = '#282c34',
		-- want trnspt background
		gray1  = nil,
		gray2  = nil,
		gray3  = nil,
	}

	return {
		normal = {
			a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
			b = { fg = colors.fg, bg = colors.gray3 },
			c = { fg = colors.fg, bg = colors.gray2 },
		},
		command = { a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' } },
		insert = { a = { fg = colors.bg, bg = colors.blue, gui = 'bold' } },
		visual = { a = { fg = colors.bg, bg = colors.purple, gui = 'bold' } },
		terminal = { a = { fg = colors.bg, bg = colors.cyan, gui = 'bold' } },
		replace = { a = { fg = colors.bg, bg = colors.red1, gui = 'bold' } },
		inactive = {
			a = { fg = colors.gray1, bg = colors.bg, gui = 'bold' },
			b = { fg = colors.gray1, bg = colors.bg },
			c = { fg = colors.gray1, bg = colors.gray2 },
		},
	}
end

-- Code actions lightbulb
require('nvim-lightbulb').setup({
	status_text = {
		enabled = true,
	},
	autocmd = {
		enabled = true
	}
})
local function code_action_lightbulb()
	local lightbulb = require('nvim-lightbulb').get_status_text()
	return lightbulb
end

require('lualine').setup {
	options = {
		theme = M.theme(),
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics', code_action_lightbulb },
		lualine_c = { 'filename' },
		lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}
