if vim.g.vscode then return end

-- rooter setup
vim.g.rooter_patterns = { '.git', 'package.json', 'Cargo.toml', 'go.mod' }
-- vim.g.rooter_manual_only = 1
local rooter = vim.fn.FindRootDirectory()

local actions = require('telescope.actions')
-- exclude .git from telescope, .gitignore is respected already
require('telescope').setup({
	defaults = {
		file_ignore_patterns = { ".git$", "%.git/" },
		mappings = {
			n = {
				--  close selected buffers
				["dd"] = actions.delete_buffer,
			}
		}
	},
})

-- load fzf extension
require('telescope').load_extension('fzf')
-- load ui select
require("telescope").load_extension("ui-select")

-- === Mappings ===
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")
-- "Find files" returns all the files in the cwd
vim.keymap.set('n', '<leader>ff', function()
	builtin.find_files({
		hidden = true
	})
end)
-- "Find project files" returns all the files in the project dir
vim.keymap.set('n', '<leader>fpf', function()
	builtin.find_files({
		-- use rooter to attempt to find the root of the project, find files from there
		cwd = rooter,
		hidden = true,
	})
end, {})
-- "Find buffer file" returns all the files relative to the buffer
vim.keymap.set('n', '<leader>fbf', function()
	builtin.find_files({
		cwd = utils.buffer_dir(),
		hidden = true,
	})
end, {})
-- "Find buffers"
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- "Find help"
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- "Find Old/Recent" files
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})

-- "Find git" Only the files in git (respects .gitignore)
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})

-- "Find Grep"
vim.keymap.set('n', '<leader>fG', function()
	builtin.live_grep({
		-- search hidden files as well, but ignore .git
		additional_args = function()
			return { '--hidden' }
		end,
	})
end)

-- "Find buffer Grep" files relative to the buffer
vim.keymap.set('n', '<leader>fbG', function()
	builtin.live_grep({
		cwd = utils.buffer_dir(),
		-- search hidden files as well, but ignore .git
		additional_args = function()
			return { '--hidden' }
		end,
	})
end)

-- "Find project Grep" attempts to grep from the project root dir
vim.keymap.set('n', '<leader>fpG', function()
	builtin.live_grep({
		cwd = rooter,
		-- search hidden files as well, but ignore .git
		additional_args = function()
			return { '--hidden' }
		end,
	})
end)
