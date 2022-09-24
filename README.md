# telescope-dotfiles.nvim

A custom `telescope.nvim` extension to quickly navigate to and edit your dotfiles.

## Installation

***NOTE***: This plugin is an extension to `telescope.nvim` so it does in fact require
you to have it installed.

Using your Neovim plugin manager of choice, add this repo to your plugin list.

Example using `packer`:

```lua
require('packer').startup(function(use)
    use { 'nvim-telescope/telescope.nvim' }
    use { 'alex-laycalvert/telescope-dotfiles.nvim' }
end)
```

## Setup

In your `init.lua` or wherever your `telescope` config is, you can load the extension
like this.

```lua
local telescope = require('telescope')

telescope.setup({
    -- ... your normal telescope config
    extensions = {
        -- ... other extension config
        dotfiles = {
            config_dir = '<YOUR CONFIG DIR>',
            exclude_dir = '<OPTIONAL EXCLUDE DIRS>'
        }
    }
})

telescope.load_extension('dotfiles')
```

Configuration Options:

- `config_dir`: Location of extra dotfiles. Default is `$HOME/.config/`.
- `exclude_dirs`: Files and directories to exclude from the dotfiles list. Default is:

    ```
    {
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
    ```

    Settings this value replaces the default.
    
***NOTE***: All directories used as values must have a trailing `/`.

## Usage

This is a subcommand of `Telescope` so to call it, just execute `:Telescope dotfiles`
