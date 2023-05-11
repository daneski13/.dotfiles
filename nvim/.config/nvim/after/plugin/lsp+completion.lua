if vim.g.vscode then return end

local lsp = require("lsp-zero")
lsp.preset({})

-- Ensure servers
lsp.ensure_installed({
	'rust_analyzer',
})

-- nvim support for lua
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- === Completion ===
-- copilot
vim.g.copilot_assume_mapped = true
require('copilot').setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
	},
	filetypes = {
		["*"] = true,
	},
	copilot_node_command = 'node', -- Node.js version must be > 16.x
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_a
require('luasnip.loaders.from_vscode').lazy_load()
cmp.setup({
	-- mappings
	mapping = {
		-- use tab for both copilot and cmp, when copilot is visible accept, otherwise select next item on cmp. Remember arrow keys still work on cmp
		['<Tab>'] = cmp.mapping(function(fallback)
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept()
			elseif cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			elseif require('luasnip').expandable() then
				require('luasnip').expand()
			else
				fallback()
			end
		end),
		-- use shift+tab for both copilot and cmp, when copilot is visible accept word, otherwise select previous item on cmp
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept_word()
			elseif cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			else
				fallback()
			end
		end),
		-- "Accept" with Enter
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		-- "Reject" with Alt/Opt + R
		['®'] = cmp.mapping(function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").dismiss()
			end
			if cmp.visible() then
				cmp.close()
			end
		end),
	},

	-- snippet
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'buffer',  keyword_length = 3 },
		{ name = 'luasnip', keyword_length = 2 },
		{ name = 'path' },
		{ name = 'nvim_lua' },
	},

	-- borders
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	}
})

-- on buffer only
local builtin = require('telescope.builtin')
lsp.on_attach(function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	-- format on save
	lsp.buffer_autoformat()

	-- prefixed with leader+l ("lang"/"lsp") for lsp related commands
	-- go to definition, declaration, implementation, references
	vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, opts)
	vim.keymap.set("n", "<leader>lD", function() vim.lsp.buf.declaration() end, opts)
	vim.keymap.set("n", "<leader>li", builtin.lsp_implementations, opts)
	vim.keymap.set("n", "<leader>lr", builtin.lsp_references, opts)
	-- hover
	vim.keymap.set("n", "<leader>lh", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "[]d", builtin.diagnostics, opts)
	-- rename
	vim.keymap.set("n", "<leader>lrn", function() vim.lsp.buf.rename() end, opts)

	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()


-- lsp loader progress
require("fidget").setup {
	window = {
		-- make transparent
		blend = 0
	}
}