if vim.g.vscode then return end

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local terminal = require("harpoon.tmux")
require("telescope").load_extension('harpoon')

-- mark a file for harpoon, "add"
vim.keymap.set("n", "<leader>a", mark.add_file)
-- quick toggle menu "harpoon menu"
vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu)
-- go to terminal
vim.keymap.set("n", "<leader>t", function()
	local out, _, _ = require("harpoon.utils").get_os_command_output({
		"tmux",
		"display",
		"-p",
		"-t",
		'{down-of}',
		"#{pane_id}"
	}, vim.loop.cwd())
	--  if out is empty, we need to create a new pane below
	if out[1] == "" then
		os.execute("tmux splitw -v -l 7")
	end
	terminal.gotoTerminal("{bottom}")
end)

-- Toggle between files using left hand Colemak home row + Alt/Opt
vim.keymap.set("n", "ƒ", function() ui.nav_file(1) end)
vim.keymap.set("n", "∂", function() ui.nav_file(2) end)
vim.keymap.set("n", "ß", function() ui.nav_file(3) end)
vim.keymap.set("n", "å", function() ui.nav_file(4) end)
