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

Then in your `init.lua` or wherever your `telescope` config is:

```lua
require('telescope').load_extension('dotfiles')
```

## Usage

This is a subcommand of `Telescope` so to call it, just execute `:Telescope dotfiles`
