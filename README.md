# tree-sitter-language-injection.nvim

A NVIM Plugin which applies inline language injections, when a string above contains the name of the language or the string contains a comment with the language name.
You can configure it with own queries for languages that aren't built in yet.

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

### Configurable
Now its possible to add languages and their treesitter scm quiries via the setup.

before the configuration:

![Screenshot 2024-10-10 111556](https://github.com/user-attachments/assets/2f92846e-5b8c-4916-b049-7d0b68cc8155)

configuration:

![Screenshot 2024-10-10 111439](https://github.com/user-attachments/assets/788a512f-47ab-49b8-b438-661b746a23c2)

after the configuration:

![Unbenannt](https://github.com/user-attachments/assets/16a48553-653c-4bc3-8b6a-11ed9efcff71)

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


## Built In Languages

- python
  - comment inline
    - `sql`
    - `javascript`
    - `typescript`
    - `html`
    - `css`
  - comment above
    - `sql`
    - `javascript`
    - `typescript`
    - `html`
    - `css`
