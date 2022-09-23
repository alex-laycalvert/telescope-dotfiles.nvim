local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  error("This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local themes = require('telescope.themes')
local scan = require('plenary.scandir')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

M.dotfiles = function ()
    local opts = themes.get_dropdown({})
    local home = os.getenv('HOME')
    local config_dir = home .. '/.config'
    local file_list = scan.scan_dir(config_dir, { hidden = true, depth = 2 })
    local results = {}
    local added_files = {}
    local i = 1
    for k, v in pairs(file_list) do
        local dot_name = string.gsub(v, config_dir .. '/', '')
        -- there is a sub dir in the config dir
        if string.match(v, '^' .. config_dir .. '/.+/') then
            dot_name = string.match(dot_name, '^.+/')
            if added_files[dot_name] == nil then
                results[i] = { v, dot_name, true }
                added_files[dot_name] = dot_name
                i = i + 1
            end
        else
            results[i] = { v, dot_name, false }
            i = i + 1
        end
    end
    pickers.new(opts, {
        prompt_title = 'colors',
        finder = finders.new_table({
            results = results,
            entry_maker = function (entry)
                return {
                    value = entry,
                    display = entry[2],
                    ordinal = entry[2],
                }
            end
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function ()
            actions.select_default:replace(function (prompt_bufnr, map)
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection.value[3] then
                    command = 'cd '
                else
                    command = 'e '
                end
                vim.cmd(command .. config_dir .. '/' .. selection.value[2])
            end)
            return true
        end
    }):find()
end

return require('telescope').register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    dotfiles = M.dotfiles
  },
}
