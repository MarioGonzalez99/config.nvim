return {
  'mfussenegger/nvim-dap',

  dependencies = {

    -- Go adapter
    'leoluz/nvim-dap-go',
    -- fancy UI for the debugger
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    -- virtual text for the debugger
    'theHamsta/nvim-dap-virtual-text',

    {
      'folke/which-key.nvim',
      optional = true,
      opts = {
        defaults = {
          ['<leader>d'] = { name = '+debug' },
        },
      },
    },
  },
  config = function(_, opts)
    local dap = require 'dap'
    local dapui = require 'dapui'
    dapui.setup(opts)
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open {}
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close {}
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close {}
    end

    -- Install golang specific config
    require('dap-go').setup {
      -- delve configurations
      delve = {
        -- the path to the executable dlv which will be used for debugging.
        -- by default, this is the "dlv" executable on your PATH.
        path = 'dlv',
        -- time to wait for delve to initialize the debug session.
        -- default to 20 seconds
        initialize_timeout_sec = 20,
        -- a string that defines the port to start delve debugger.
        -- default to string "${port}" which instructs nvim-dap
        -- to start the process in a random available port
        port = '${port}',
        -- additional args to pass to dlv
        args = {},
        -- the build flags that are passed to delve.
        -- defaults to empty string, but can be used to provide flags
        -- such as "-tags=unit" to make sure the test suite is
        -- compiled during debugging, for example.
        -- passing build flags using args is ineffective, as those are
        -- ignored by delve in dap mode.
        build_flags = '',
        -- whether the dlv process to be created detached or not. there is
        -- an issue on Windows where this needs to be set to false
        -- otherwise the dlv server creation will fail.
        detached = false,
      },
    }
  end,

  -- stylua: ignore
  keys = {
    { "<leader>gdB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>gdb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<F1>", function() require("dap").step_into() end, desc = "Step Into" },
    { "<F2>", function() require("dap").step_over() end, desc = "Step Over" },
    { "<F3>", function() require("dap").step_out() end, desc = "Step Out" },
    { "<F5>", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>gdC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>gdg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>gdj", function() require("dap").down() end, desc = "Down" },
    { "<leader>gdk", function() require("dap").up() end, desc = "Up" },
    { "<leader>gdl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>gdp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>gdr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>gds", function() require("dap").session() end, desc = "Session" },
    { "<leader>gdt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>gdw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<leader>gdu", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>gde", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
}
