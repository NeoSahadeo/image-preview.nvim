# Image Preview for Nvim-Tree

A small preview plugin that uses feh to display images.

[![Preview](https://imgur.com/Vn7iKi4.png)](https://imgur.com/)

# Keymaps

The default keymap:

```
<Space>p
```

# How to change keymaps

```
require('image-preview').setup({
    mappings = {
        PreviewImage = {
            { 'n' },
            ' s', -- <leader>p
        },
    },
})
```
