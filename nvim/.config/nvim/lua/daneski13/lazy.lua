-- ====== Lazy ======
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

local plugins = {
	-- distant (ssh editing)
	{
		'chipsenkbeil/distant.nvim',
		branch = 'v0.3',
	},

	-- Telescope
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build =
		'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		-- or                            , branch = '0.1.x',

		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			-- use lua fzf
			-- replace some core stuff with telescope
			{ 'nvim-telescope/telescope-ui-select.nvim' }
		},
	},

	-- buffer edit file system (replace netrw)
	{ "stevearc/oil.nvim" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	},

	-- Color scheme
	"olimorris/onedarkpro.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/playground" },
			{ "nvim-treesitter/nvim-treesitter-context" },
		},
	},
	-- rainbow parens
	"HiPhish/nvim-ts-rainbow2",
	-- auto tag
	"windwp/nvim-ts-autotag",
	-- auto pairs
	"windwp/nvim-autopairs",
	-- souround stuff with parrns, brackets, etc
	"machakann/vim-sandwich",
	"tpope/vim-surround",

	-- multiline edit
	"mg979/vim-visual-multi",

	-- Game to git good
	"theprimeagen/vim-be-good",

	-- harpoon
	"theprimeagen/harpoon",

	-- undo tree
	"mbbill/undotree",

	-- git integration
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"lewis6991/gitsigns.nvim",

	-- diagnostics
	"folke/trouble.nvim",

	-- automagic tab width/space width for project
	"tpope/vim-sleuth",

	-- commenting
	{ "numToStr/Comment.nvim" },

	-- startup dashboard
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	},

	-- project root
	{ "airblade/vim-rooter" },

	-- markdown preview
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- LSP/Completion
	{ "neovim/nvim-lspconfig" },
	-- LSP Support
	{
		"mason-org/mason.nvim",
		build = function()
			pcall(vim.cmd, "MasonUpdate")
		end,
	},
	{ "mason-org/mason-lspconfig.nvim" },
	-- Autocompletion
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },

	-- Snippets
	{ "L3MON4D3/LuaSnip" },
	{ "rafamadriz/friendly-snippets" },

	-- Github copilot
	{ "zbirenbaum/copilot.lua" },
	{ 'AndreM222/copilot-lualine' },

	-- code actions lightbulb
	{ "kosayoda/nvim-lightbulb" },

	--  proper completion for neovim lua
	{
		"folke/lua-dev.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
		},
	},
	-- LSP progress
	{ "j-hui/fidget.nvim" },
	-- Completion in vim cmd
	{
		"gelguy/wilder.nvim",
		build = ":UpdateRemotePlugins",
		dependencies = {
			{ "romgrk/fzy-lua-native" },
			{ "roxma/nvim-yarp" },
		},
	},
}
-- Sometimes I want a file tree explorer
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

local opts = {}

require("lazy").setup(plugins, opts)
