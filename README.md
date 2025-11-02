<div align="center">

# nvim-lastplace

A rewrite of [`ethanholz/nvim-lastplace`](https://github.com/ethanholz/nvim-lastplace), which in of
itself is a Lua rewrite of [`farmergreg/vim-lastplace`](https://github.com/farmergreg/vim-lastplace).

</div>

> [!IMPORTANT]
> I foreseeably plan to maintain this, since the original has been archived.
>
> Any support is welcome!

---

## Installation

### Requirements

- Neovim `>=v0.8`

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'DrKJeff16/nvim-lastplace',
  lazy = false, -- WARNING: Lazy-loading is not supported currently!
  version = false,
  config = function()
    require('nvim-lastplace').setup()
  end
}
```

### [paq-nvim](https://github.com/savq/paq-nvim)

```lua
paq('DrKJeff16/nvim-lastplace')
```

---

## Configuration

To setup the function you may simply run the `setup()` function:

```lua
require('nvim-lastplace').setup()
```

The default setup options are:

```lua
{
  ignore = {
    bt = { 'quickfix', 'nofile', 'help' },
    ft = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
  },
  open_folds = true
}
```

---

## Credits

- [@ethanholz](https://github.com/ethanholz) For the original project this was forked from.
- [@farmergreg](https://github.com/farmergreg) For the project the original was inspired from.

