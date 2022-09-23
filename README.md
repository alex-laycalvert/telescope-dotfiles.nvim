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
            config_dir = '<YOUR CONFIG DIR>'
        }
    }
})

telescope.load_extension('dotfiles')
```

`config_dir` is where all of your dotfiles are stored. Default is `$HOME/.config`.
Using `~/` is allowed.

`TODO`: Add dotfiles stored in `$HOME` to list.
`TODO`: Allow users to specify finder theme.

## Usage

This is a subcommand of `Telescope` so to call it, just execute `:Telescope dotfiles`
