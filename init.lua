-- these are configurations required by the nvim-tree plugin
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- show line numbers on left
vim.opt.number = true

-- Set global spell option to false initially to disable it for all file types
vim.opt.spell = false
vim.opt.modifiable = true

-- Creates an autocommand that executes ruff everytime python 
-- file is saved. It also runs a 'isort' like function
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.fn.executable("ruff") == 1 then
      vim.cmd("silent !ruff check --select I --fix " .. vim.api.nvim_buf_get_name(buf))
      vim.cmd("silent !ruff format " .. vim.api.nvim_buf_get_name(buf))
      vim.cmd("edit!")
    else
      vim.notify("ruff not installed!", vim.log.levels.WARN)
    end
  end,
})
	
-- Create an autocommand to enable spellcheck for text like files.
-- Do not apply it for source code files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },   
  callback = function()
    vim.opt_local.spell = true 
  end,
  desc = "Enable spellcheck for defined filetypes", -- Description for clarity
})


-- yank also copies to clipboard;
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 400 }
    if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
            vim.fn.setreg('+', vim.fn.getreg('"'))
    end
  end,
})



local Plug = vim.fn['plug#']

vim.call('plug#begin')
	Plug 'ggml-org/llama.vim'
	Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'tpope/vim-sensible'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'ray-x/lsp_signature.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'ray-x/go.nvim'
	Plug 'sainnhe/everforest'
	Plug('neoclide/coc.nvim', {['branch'] = 'release'})
	Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && npx --yes yarn install' })
vim.call('plug#end')


-- set neovim theme 
vim.cmd[[colorscheme everforest]]


-- configure treesitter 
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "query", "go", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}




local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').gofmt()
  end,
  group = format_sync_grp,
})




require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
    -- Do not show these files on the tree
    custom = {
	    ".git",
	    "__pycache__"
    }
  },
})


require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp_signature_help' }
  }
}

 -- Set up nvim-cmp.
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
       -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
         vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      --{ name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })



local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.enable('pyright', {
	settings={
		capabilities = capabilities
	},
})

vim.lsp.enable('bashls', {})

vim.lsp.enable('gopls', {})


require('go').setup()



require('lspconfig')['terraformls'].setup{
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})}

vim.keymap.set('n', 'o', ':NvimTreeFocus<CR>', {silent = true})
