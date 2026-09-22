# Intro
This is a tool for installing many tree sitter parsers in a neovim 0.12+ compatible way. It is written in TS for Deno, installs concurrently, and is directly intended to be used with neovim. I no longer use `nvim-treesitter` as it was suddenly archived on github in April 2026 due to maintainer fatigue, and this is my way of handling that as smoothly as I can.

## Specs
- This is for Neovim 0.12 and later, without nvim-treesitter. Do not confuse any part of this with any other use case.
- All postprocessing changes should be in `setup.ts`, so that a run to `setup.ts` doesn't overwrite any tweaks that we do to the original file
- Running `setup.ts` does not take terribly long, so it is preferred to simply update setup.ts and then run the file to update parsers.
- Not sure if it does this yet, but when we run `setup.ts`, it should pull the latest changes (if not already tagged) for each repo before building
