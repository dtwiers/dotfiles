local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local apply_appearance = require("appearance")
local apply_keys = require("keys")
local apply_tabBar = require("tab-bar")
local apply_general = require("general")

config = apply_appearance(config)
config = apply_keys(config)
config = apply_tabBar(config)
config = apply_general(config)

return config
