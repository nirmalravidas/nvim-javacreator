# nvim-javacreator

> Java file creator and project detection for Neovim

![Neovim](https://img.shields.io/badge/Neovim-0.9+-green?logo=neovim)
![LazyVim](https://img.shields.io/badge/LazyVim-required-blue)
![License](https://img.shields.io/badge/license-MIT-brightgreen)
![Open Source](https://img.shields.io/badge/Open%20Source-red)

nvim-javacreator is a Neovim plugin that does two things well.
It detects your project type automatically and isolates LSP servers
so intellisense never mixes between projects. It also lets you create
Java files from templates with the correct package name and Spring Boot
annotations already filled in.

---

## What nvim-javacreator does

These are the things this plugin itself does:

- **Auto project detection** — detects Spring Boot, React, Python and C++
  projects on startup by checking for pom.xml, package.json,
  requirements.txt and CMakeLists.txt
- **Per project LSP isolation** — creates .neoconf.json automatically so
  only the correct LSP servers load for each project. No more intellisense
  mixing between Spring Boot, React, Python and C++ projects
- **Java file creator** — create Controller, Service, Entity, Repository
  and more with the correct package name and Spring Boot annotations
  already filled in from templates

---

## Requirements

- Neovim >= 0.9
- [LazyVim](https://lazyvim.org)
- LazyVim extras:
  - `lang.java`
  - `lsp.neoconf`

---

## Installation & Setup

### Step 1 — Enable LazyVim Extras

Open LazyVim extras:
```vim
:LazyExtras
```

Enable these by pressing `x` on each:
```
lang.java        - Java LSP support
lsp.neoconf      - Per project LSP isolation
```

---

### Step 2 — Install the Plugin

Create a plugin file:
```bash
nvim ~/.config/nvim/lua/plugins/javacreator.lua
```

Paste this inside:
```lua
return {
  {
    "nirmalravidas/nvim-javacreator",
    opts = {},
  },
}
```

---

### Step 3 — Sync Plugins
```vim
:Lazy sync
```

Wait for everything to install then restart Neovim.

---

### Step 4 — Open Your Project
```bash
cd ~/your-project
nvim .
```

On first open you will see:
```
javacreator: Spring Boot Project
.neoconf.json created
```

This means nvim-javacreator has detected your project and configured
the LSP servers correctly.

---

### Step 5 — Verify Setup

Run:
```vim
:JavaCreatorInfo
```

You will see:
```
javacreator info:
  project type : java
  .neoconf.json: exists
  cwd          : /home/user/your-project
```

---

## Configuration

Works out of the box with no configuration needed.
To customize, pass opts:
```lua
return {
  {
    "nirmalravidas/nvim-javacreator",
    opts = {
      detect = {
        enabled             = true,
        auto_create_neoconf = true,
        notify              = true,
      },
      creator = {
        enabled = true,
        keymap  = "<leader>jn",
        types = {
          { label = "Class",           template = "class" },
          { label = "Interface",       template = "interface" },
          { label = "Enum",            template = "enum" },
          { label = "Record",          template = "record" },
          { label = "Annotation",      template = "annotation" },
          { label = "REST Controller", template = "controller" },
          { label = "Service",         template = "service" },
          { label = "Repository",      template = "repository" },
          { label = "Entity",          template = "entity" },
          { label = "Component",       template = "component" },
          { label = "Configuration",   template = "config" },
        },
      },
    },
  },
}
```

---

## Keymaps

| Key | Action |
|-----|--------|
| `<leader>jn` | Create new Java file from template |

---

## Java File Creator

Press `<leader>jn` or run `:JavaCreatorNew` to create a new Java file.

nvim-javacreator detects the target directory from:
1. Current open Java file directory
2. `src/main/java` in project root
3. Current working directory

Available templates:

| Template | Annotations |
|----------|-------------|
| Class | plain class |
| Interface | plain interface |
| Enum | plain enum |
| Record | plain record |
| Annotation | `@interface` |
| REST Controller | `@RestController` `@RequestMapping` |
| Service | `@Service` |
| Repository | `@Repository` `JpaRepository` |
| Entity | `@Entity` `@Table` `@Id` |
| Component | `@Component` |
| Configuration | `@Configuration` |

Package name is auto detected from folder path:
```
src/main/java/com/myapp/service/UserService.java
                 |
package com.myapp.service;
```

---

## Project Detection

nvim-javacreator auto detects your project type on startup and creates
`.neoconf.json` to isolate LSP servers:

| Project | Detected by |
|---------|-------------|
| Spring Boot | `pom.xml` or `build.gradle` |
| React | `package.json` |
| Python | `requirements.txt` or `pyproject.toml` |
| C++ | `CMakeLists.txt` or `*.cpp` |

First time you open a project:
```
nvim .
-> Project type detected
-> .neoconf.json created automatically
-> Only correct LSP servers load for this project
-> No intellisense mixing between different project types
```

If `.neoconf.json` already exists it will not be overwritten.
You can manually edit it to customize which LSP servers load.

---

## Commands

| Command | Description |
|---------|-------------|
| `:JavaCreatorNew` | Create new Java file with template |
| `:JavaCreatorInfo` | Show project type and status |

---

## Daily Workflow
```
1.  cd ~/projects/myapp && nvim .
2.  Project auto detected -> .neoconf.json created
3.  <leader>e  -> explore project structure
4.  Open a java file or navigate to target folder
5.  <leader>jn -> select file type
6.  Type class name -> file created with correct package
7.  Start coding -> LSP autocomplete works immediately
```

---

## Open Source

nvim-javacreator is completely free and open source.

You can:
- Use it for free in any project
- Modify it however you want
- Distribute it to others
- Submit issues and feature requests
- Contribute code via pull requests

If it helps you, consider giving it a star on GitHub!

---

## Contributing

Contributions are welcome! Please open an issue or pull request on GitHub.

1. Fork the repo
2. Create your branch: `git checkout -b feat/my-feature`
3. Commit changes: `git commit -m "feat: add my feature"`
4. Push: `git push origin feat/my-feature`
5. Open a Pull Request

---

## Troubleshooting

**Project not detected?**
- Make sure you opened nvim from project root: `cd your-project && nvim .`
- Check if `pom.xml` exists in root: `ls pom.xml`

**LSP not attaching?**
- Check `:LspInfo` shows jdtls attached
- Make sure `lang.java` is enabled in `:LazyExtras`
- Run `:JdtUpdateConfig`

**File created in wrong location?**
- Open a java file first then press `<leader>jn`
- It will use that file's directory as target

**Package is empty?**
- Make sure your java files are inside `src/main/java/`
- Package is detected from the path after `src/main/java/`

**Still having issues?**
- Open an issue on GitHub with the output of `:checkhealth`

---

## Acknowledgements

- [LazyVim](https://lazyvim.org) — the best Neovim config
- [neoconf.nvim](https://github.com/folke/neoconf.nvim) — per project LSP config
- [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) — Java LSP

---
