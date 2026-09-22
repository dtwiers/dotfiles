# Chezmoi to Mise handoff

This repository is the shared Mise source for the `mise` branch. Chezmoi may continue managing files that are not listed here, but it must stop managing paths handed off to Mise.

The handoff has two stages:

1. Remove the migrated paths from Chezmoi without removing their live files.
2. Bootstrap Mise's global configuration, select the machine profile, and apply the repository sources.

Do not run `chezmoi unapply` or `chezmoi destroy` for this migration.

## Before leaving the current machine

Commit and push the repository changes. The other machine only sees committed history.

```sh
cd ~/dotfiles
git switch mise
git add config MISE_BOOTSTRAP.md
git commit -m "migrate remaining configuration to Mise"
git push origin mise
```

The repository's SSH remote is:

```text
git@github.com:dtwiers/dotfiles.git
```

## 1. Inspect Chezmoi ownership

On the destination machine, inspect the paths Chezmoi currently manages:

```sh
chezmoi managed ~/.config/mise
chezmoi managed ~/.config/nvim
chezmoi managed ~/.config/fish
chezmoi managed ~/.config/hypr
chezmoi managed ~/.config/waybar
chezmoi managed ~/.config/wezterm
chezmoi managed ~/.config/mpv
chezmoi managed ~/.config/nushell
chezmoi managed ~/.config/tree-sitter-parsers
chezmoi managed ~/.config/obsidian
chezmoi managed ~/.config/starship.toml ~/.gitconfig ~/.gitignore_global
```

Back up or commit the Chezmoi source tree before using `chezmoi forget`. `forget` removes entries from Chezmoi's source state; it does not apply the removal to the live destination files.

Forget only files that are now sourced from this repository. Typical migrated targets are:

```sh
chezmoi forget \
  ~/.config/nvim \
  ~/.config/starship.toml \
  ~/.gitconfig \
  ~/.gitignore_global \
  ~/.config/wezterm \
  ~/.config/mpv \
  ~/.config/hypr \
  ~/.config/waybar \
  ~/.config/obsidian/obsidian.json \
  ~/.config/nushell/config.nu \
  ~/.config/nushell/env.nu \
  ~/.config/tree-sitter-parsers/setup.ts \
  ~/.config/tree-sitter-parsers/languages.kdl \
  ~/.config/tree-sitter-parsers/.gitignore \
  ~/.config/tree-sitter-parsers/AGENTS.md
```

If Chezmoi manages individual children instead of the directory targets, forget those individual children instead. Do not forget these private or generated Fish paths:

- `~/.config/fish/private.fish`
- `~/.config/fish/fish_variables`
- `~/.config/fish/completions`

Mise deliberately leaves those paths outside the shared repository.

Confirm that only the remaining Chezmoi files are listed:

```sh
chezmoi managed ~/.config/mise ~/.config/nvim ~/.config/wezterm
```

## 2. Install Mise and clone the source

Install Git and Mise if they are not already installed:

```sh
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
```

Clone the shared branch:

```sh
git clone --branch mise git@github.com:dtwiers/dotfiles.git ~/dotfiles
```

If `~/dotfiles` already exists, update it instead:

```sh
cd ~/dotfiles
git fetch origin
git switch mise
git pull --ff-only origin mise
```

## 3. Bootstrap Mise config discovery

Mise must load `config.toml` before its `[dotfiles]` table can manage the Mise directory itself. Create the initial config links manually:

```sh
mkdir -p ~/.config/mise

for name in \
  config.toml \
  config.arch.toml \
  config.dev.toml \
  config.dj.toml \
  config.macos.toml \
  config.work.toml
do
  ln -s "$HOME/dotfiles/config/mise/$name" \
        "$HOME/.config/mise/$name"
done
```

If any destination already exists, move it into a timestamped backup directory first. Do not overwrite a Chezmoi-managed file blindly.

After the first load, Mise manages these links through this entry in the repository's base configuration:

```toml
"~/.config/mise" = {
  source = "~/dotfiles/config/mise",
  mode = "symlink-each",
  exclude = [".miserc.toml", "*.backup"]
}
```

The directory remains local so machine-specific state survives. The repository-backed config and overlay files inside it are symlinks.

## 4. Select the machine profile

Create `~/.config/mise/.miserc.toml`. This file is local and must not be committed:

```toml
# Arch desktop / Hyprland development machine
env = ["arch", "dev"]
```

Use the matching selection on other machines:

| Machine role | `env` |
| --- | --- |
| Arch desktop / Hyprland development | `["arch", "dev"]` |
| Fedora Proxmox headless development | `["fedora", "headless", "dev"]` |
| Personal macOS DJ machine | `["macos", "dj"]` |
| Personal macOS development machine | `["macos", "dev"]` |
| Restricted work MacBook | `["macos", "dev", "work"]` |

The `fedora` and `headless` tags intentionally have no overlay files today; they still identify the machine role.

## 5. Preview the handoff

Run the commands for the selected profile. This example uses the Arch development profile:

```sh
cd ~/dotfiles

mise -E arch,dev config
mise -E arch,dev dot status --json
mise -E arch,dev dot apply --dry-run --force
```

Review every proposed target. Expected behavior:

- Common paths come from `config.toml`.
- `config.arch.toml` adds MPV, Hyprland, and Waybar on Arch.
- `config.dev.toml` adds Nushell and tree-sitter source files.
- Fish remains `symlink-each` so private files and unmanaged neighbors survive.
- Existing conflicting Chezmoi files are shown before replacement.

Preview the other profile combinations without applying them:

```sh
mise -E fedora,headless,dev dot apply --dry-run --force
mise -E macos,dj dot apply --dry-run --force
mise -E macos,dev dot apply --dry-run --force
mise -E macos,dev,work dot apply --dry-run --force
```

## 6. Apply Mise and install declared tools

After reviewing the preview:

```sh
mise -E arch,dev bootstrap \
  --only dotfiles,tools \
  --force-dotfiles \
  --yes
```

Alternatively, apply only dotfiles first and install tools separately:

```sh
mise -E arch,dev dot apply --force --yes
mise -E arch,dev install
```

Use the selected environment for the other machine roles instead of `arch,dev`.

## 7. Verify the handoff

```sh
mise -E arch,dev dot status --missing
mise -E arch,dev dot diff
mise -E arch,dev config
```

A successful handoff has:

- `dot status --missing` exiting successfully.
- An empty `dot diff`.
- `~/.config/mise/config.toml` and overlay files resolving into `~/dotfiles/config/mise`.
- `~/.config/mise/.miserc.toml` remaining a regular local file.
- Chezmoi no longer listing the migrated paths.

If a target differs, do not use `--force` automatically. Inspect the target, back it up if needed, then rerun the dry-run. `--force-dotfiles` is the explicit handoff choice after the Chezmoi ownership has been removed.

## Ongoing updates

On this machine, pull repository changes and reapply the selected profile:

```sh
cd ~/dotfiles
git pull --ff-only origin mise
mise -E arch,dev dot apply
```

Keep private Fish files, credentials, and machine-local `.miserc.toml` outside the repository.
