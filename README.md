# tree-sitter-language-injection.nvim

A NVIM Plugin which applies inline language injections, when a string contains a comment with the language name.

## Installation

### Packer

```lua
use({"dariuscorvus/tree-sitter-language-injection.nvim", after="nvim-treesitter"})
```

### Setup

```lua
require("tree-sitter-language-injection").setup()
```

### Lazy

```lua
return {
  "dariuscorvus/tree-sitter-language-injection.nvim",
  branch = "dev",
  opts = {} 'calls the setup
}
```

## Features

### Comment Inline

When a string is found, and the first line is language specifc comment, for the desired language, followed by the language name, syntax highlighting gets applied.

as example we use the language `typescript` and want that the string gets highlighted as `sql`

```typescript
const select = `
--sql
SELECT * FROM user
WHERE active = 1
`;
```

which results in

![typescript_inline_sql](https://raw.githubusercontent.com/DariusCorvus/DariusCorvus/main/assets/wezterm-gui_cchWP58tx2.png)

### Comment Above

When a comment is found above a variable, and starts with the name of the desired language, syntax highlighting gets applied.

as example we use the language `typescript` and want that the string gets highlighted as `sql`

```typescript
// sql
const select = `
SELECT * FROM user
WHERE active = 1
`;
```

which results in

![typescript_above_sql](https://raw.githubusercontent.com/DariusCorvus/DariusCorvus/main/assets/wezterm-gui_WDmWbPhxb9.png)

## Supported Languages

- python
  - comment inline
    - `sql`
    - `surrealdb`
  - comment above
    - sql
- typescript
  - comment inline
    - `sql`
    - `surrealdb`
  - comment above
    - `sql`
    - `surrealdb`
- javascript
  - comment inline
    - `sql`
    - `surrealdb`
  - comment above
    - `sql`
    - `surrealdb`
