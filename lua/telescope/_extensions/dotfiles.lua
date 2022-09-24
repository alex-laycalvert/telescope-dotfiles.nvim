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
local home = os.getenv('HOME')

local M = {}

local config_dir = ''
local exclude_dirs = {}

local function concat (t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
end

local function contains (tbl, val)
    for k, v in pairs(tbl) do
        if v == val then return true end
    end
    return false
end

local function create_dot_list ()
    local results = {}
    config_dir_name = string.gsub(config_dir, '~/', '')
    config_dir = string.gsub(config_dir, '~', home)
    local complete_file_list = scan.scan_dir(home, { hidden = true, depth = 2 })
    local config_file_list = scan.scan_dir(config_dir, { hidden = true, depth = 2 })
    local added_files = {}
    local i = 1
    for k, v in pairs(complete_file_list) do
        local dot_name = string.gsub(v, home .. '/', '')
        if string.match(v, '^' .. home .. '/.+/') then
            dot_name = string.match(dot_name, '^.+/')
            if added_files[dot_name] == nil and not contains(exclude_dirs, dot_name) then
                results[i] = { string.match(v, home .. '/' .. dot_name), dot_name, true }
                added_files[dot_name] = dot_name
                i = i + 1
            end
        end
    end

    for k, v in pairs(config_file_list) do
        local dot_name = string.gsub(v, config_dir .. '/', '')
        if string.match(v, '^' .. config_dir .. '/.+/') then
            dot_name = string.match(dot_name, '^.+/')
            if added_files[dot_name] == nil then
                results[i] = { config_dir .. '/' .. dot_name, dot_name, true }
                added_files[dot_name] = dot_name
                i = i + 1
            end
        else
            results[i] = { config_dir .. '/' .. dot_name, dot_name, false }
            i = i + 1
        end
    end

    return results
end

M.dotfiles = function ()
    local opts = themes.get_dropdown({})
    local results = create_dot_list()

    pickers.new(opts, {
        prompt_title = 'dotfiles',
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
                vim.cmd(command .. selection.value[1])
            end)
            return true
        end
    }):find()
end

return require('telescope').register_extension {
  setup = function(ext_config, config)
      config_dir = ext_config.config_dir or home .. '/.config/'
      exclude_dirs = ext_config.exclude_dirs or { 
          '.cache/',
          '.cargo/',
          '.npm/',
          '.ssh/',
          '.wallpaper/',
          'Desktop/',
          'Documents/',
          'Downloads/',
          'Images/',
          'Pictures/',
          'Templates/',
          'Videos/',
      }
  end,
  exports = {
    dotfiles = M.dotfiles
  },
}
