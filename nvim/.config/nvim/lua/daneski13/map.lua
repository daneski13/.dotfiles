local utils = require("daneski13.utils")

COLEMAK = false
if COLEMAK then
	require("daneski13.colemak")
end
-- ======== Mappings ========
-- Leader key
vim.g.mapleader = " "


if not COLEMAK then
	-- window nav using bindngs
	utils.noremap_s("<leader>wh", "<C-w>h")
	utils.noremap_s("<leader>wj", "<C-w>j")
	utils.noremap_s("<leader>wk", "<C-w>k")
	utils.noremap_s("<leader>wl", "<C-w>l")

	-- faster up/down nav
	utils.noremap_s("K", "5kzz")
	utils.noremap_s("J", "5jzz")

	-- Moves the selected line down one
	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
	-- Moves the selected line up one
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
end

-- close, window if there's a spit, the buffer if not
vim.keymap.set("n", "<leader>x", function()
	local windows = utils.getWindowCount()
	if windows > 1 then
		-- Close the current window
		vim.cmd("close")
	else
		-- Close the current buffer
		vim.cmd("bd")
	end
end)
-- force version of the above
vim.keymap.set("n", "<leader>X", function()
	local windows = utils.getWindowCount()
	if windows > 1 then
		-- Close the current window
		vim.cmd("close")
	else
		-- force close the current buffer
		vim.cmd("bd!")
	end
end)

-- swap windows
vim.keymap.set("n", "<leader>ws", "<C-w>x")
-- rotate windows
vim.keymap.set("n", "<leader>wr", "<C-w>r")
--  new window vertical
vim.keymap.set("n", "<leader>w|", "<cmd>vsplit<CR>")
--  new window horizontal
vim.keymap.set("n", "<leader>w-", "<cmd>split<CR>")
-- close current window
vim.keymap.set("n", "<leader>wx", "<cmd>close<CR>")
-- cycle through windows with tab
vim.keymap.set("n", "<TAB>", "<C-w>w", { noremap = true })
-- cycle through windows backwards with shift tab
vim.keymap.set("n", "<S-TAB>", "<C-w>W", { noremap = true })
-- active window only (close all other panes)
vim.keymap.set("n", "<leader>wo", "<cmd>only<CR>")
-- window =, equalize window sizes
vim.keymap.set("n", "<leader>w=", "<C-w>=")
-- maximize/"zoom" window
vim.keymap.set("n", "<leader>wz", "<C-w>|<C-w>_")
-- arrow keys to resize windows in normal mode
-- ensure we aren't in netrw, mason, or neo tree
function Remap_arrows()
	if vim.bo.filetype ~= "netrw" and vim.bo.filetype ~= "mason" and vim.bo.filetype ~= "neo-tree" and vim.bo.filetype ~= "lazy" then
		vim.keymap.set("n", "<Up>", ":resize -1<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<Down>", ":resize +1<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<Left>", ":vertical resize -3<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<Right>", ":vertical resize +3<CR>", { noremap = true, silent = true })
	else
		vim.keymap.set("n", "<Up>", "<Up>", { silent = true })
		vim.keymap.set("n", "<Down>", "<Down>", { silent = true })
		vim.keymap.set("n", "<Left>", "<Left>", { silent = true })
		vim.keymap.set("n", "<Right>", "<Right>", { silent = true })
	end
end

Remap_arrows()
vim.cmd([[
	augroup ArrowMap
		autocmd!
		autocmd FileType,BufRead * lua Remap_arrows()
	augroup END
]])

-- Change ~ to ` for flipping case its just faster
utils.noremap_s("`", "~")

-- file exp, "Project View"
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")
-- file exp, "Project Tree"
vim.keymap.set("n", "<leader>pt", "<cmd>Neotree<CR>")

-- C-\ is good enough for terminal normal mode
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>")

-- paste over visual selection from buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- delete to void buffer
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Why would I ever want a single char deleted with x to be in my default register?
vim.keymap.set("n", "x", '"_x')

-- Word wrap toggle
vim.keymap.set("n", "<leader>ww", "<cmd>set wrap!<CR>")

-- Half a page down/up and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Ctrl + U or E will move up/down the view port without moving the cursor
-- vim.keymap.set({ "n", "v" }, "<C-U>", "5<C-y>")
-- vim.keymap.set({ "n", "v" }, "<C-E>", "5<C-e>")

-- format the current file
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format)

-- save the file
vim.keymap.set({ "n", "v" }, "<C-s>", "<cmd>w<CR>")
vim.keymap.set("i", "<C-s>", "<ESC><cmd>w<CR>a")

-- chmod file "file x-cutable"
vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>")

-- F5 to reload the keymap
vim.keymap.set("n", "<F5>", ":luafile ~/.config/nvim/init.lua<CR>")

-- "view list" toggle
vim.keymap.set("n", "<leader>vl", "<cmd>set list!<CR>")

-- open package manager "vim package manager"
vim.keymap.set("n", "<leader>vpm", "<cmd>e ~/.config/nvim/lua/daneski13/lazy.lua<CR>")
