if vim.g.vscode then return end

-- === LSP ===

-- neodev
require("neodev").setup({})

-- on buffer only
local builtin = require("telescope.builtin")
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }

    -- format on save
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = false }),
      buffer = event.buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = event.buf, id = client.id, timeout_ms = 1000 })
      end,
    })
    -- lsp.buffer_autoformat()
    -- vim.g.rustfmt_autosave = 1

    -- go to definition, declaration, implementation, references
    vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, opts)
    vim.keymap.set("n", "<leader>gD", function()
      vim.lsp.buf.declaration()
    end, opts)
    vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations, opts)
    vim.keymap.set("n", "<leader>gr", builtin.lsp_references, opts)

    -- remap CTRL+O/CTRL+I to go back/forward in jump list
    vim.keymap.set("n", "<leader>gb", "<C-o>")
    vim.keymap.set("n", "<leader>gB", "<C-i>")


    -- "symbol rename"
    vim.keymap.set("n", "<leader>srn", function()
      vim.lsp.buf.rename()
    end, opts)
    -- "symbol hover"
    vim.keymap.set("n", "<leader>sh", function()
      vim.lsp.buf.hover()
    end, opts)

    -- signature help
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, opts)

    -- diagnostics
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set("n", "[]d", builtin.diagnostics, opts)
    -- "view diagnostics"
    vim.keymap.set("n", "<leader>vd", function()
      vim.diagnostic.open_float()
    end, opts)

    -- "view code action"
    vim.keymap.set("n", "<leader>vca", function()
      vim.lsp.buf.code_action()
    end, opts)
  end,
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")

-- bash/zsh
lspconfig.bashls.setup({
  filetypes = { "sh", "zsh" },
})
-- rust_analyzer
lspconfig.rust_analyzer.setup({
  capabilities = lsp_capabilities,
  settings = {
    ["rust-analyzer"] = {
      procMacro = {
        enable = false,
        attributes = {
          enable = false,
        },
      },
    }
  }
})
-- lua_ls
lspconfig.lua_ls.setup({
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      runtime = {
        version = 'LuaJIT'
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        }
      }
    }
  }
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls', 'rust_analyzer' },
  automatic_enable = true,
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({
        capabilities = lsp_capabilities,
      })
    end,
  }
})

-- === Completion ===
-- copilot
vim.g.copilot_assume_mapped = true
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
  },
  filetypes = {
    ["*"] = true,
  },
  copilot_node_command = "node", -- Node.js version must be > 16.x
})

-- === CMP ===
local co_suggest = require("copilot.suggestion")
local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  buffer = vim.api.nvim_get_current_buf(),
  -- mappings
  mapping = {
    -- Arrow Keys
    ['<Down>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback() -- fallback to default <Down> behavior
      end
    end,
    ['<Up>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback() -- fallback to default <Up> behavior
      end
    end,

    -- use tab for both copilot and cmp, when copilot is visible accept, otherwise select next item on cmp. Remember arrow keys still work on cmp
    ["<Tab>"] = cmp.mapping(function(fallback)
      if co_suggest.is_visible() then
        co_suggest.accept()
      elseif cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif require("luasnip").expandable() then
        require("luasnip").expand()
      else
        fallback()
      end
    end),
    -- use shift+tab for both copilot and cmp, when copilot is visible accept word, otherwise select previous item on cmp
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if co_suggest.is_visible() then
        co_suggest.accept_word()
      elseif cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      else
        fallback()
      end
    end),
    -- Accept with Enter
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- Reject, "No" with Alt/Opt + N (shift n)
    ["˜"] = cmp.mapping(function()
      if co_suggest.is_visible() then
        co_suggest.dismiss()
      end
      if cmp.visible() then
        cmp.close()
      end
    end),
    -- Scroll Complete Menu
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
  },

  -- snippet
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer",  keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
    { name = "path" },
    { name = "nvim_lua" },
  },

  -- borders
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})


-- === Formatting ===
-- lsp loader progress
fidget = require("fidget")
fidget.setup({
  notification = {
    window = {
      winblend = 0,
    },
  },
})
vim.notify = fidget.notify
