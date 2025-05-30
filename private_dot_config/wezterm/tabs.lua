local wezterm = require 'wezterm'

local result = {}

local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        title = " - " .. title
        return title
    end
    return tab_info.active_pane.title
end

local function ellipsis(text, max_width)
    if #text > max_width then
        return text:sub(1, max_width - 3) .. "..."
    end
    return text
end

local LEFT_BORDER = wezterm.nerdfonts.ple_pixelated_squares_big_mirrored
local RIGHT_BORDER = wezterm.nerdfonts.ple_pixelated_squares_big
local INACTIVE_LEFT_BORDER = "   "
local INACTIVE_RIGHT_BORDER = "   "

local INACTIVE_INDEX_COLOR = "#039660"
local BACKGROUND_COLOR = "#0e1013"
local TEXT_COLOR = "#B39DF3"
local ACTIVE_TEXT_COLOR = "#039660"
local HOVER_TEXT_COLOR = "#F39660"

local function format_left_border(hover, is_active)
    if is_active then
        return {
            { Background = { Color = BACKGROUND_COLOR } },
            { Foreground = { Color = ACTIVE_TEXT_COLOR } },
            { Text = LEFT_BORDER .. " "},
            { Background = { Color = ACTIVE_TEXT_COLOR } },
            { Foreground = { Color = BACKGROUND_COLOR } },
            { Text = " " },
        }
    else
        return {
            { Background = { Color = BACKGROUND_COLOR } },
            { Foreground = { Color = hover and HOVER_TEXT_COLOR or TEXT_COLOR } },
            { Text = INACTIVE_LEFT_BORDER },
        }
    end
end

local function format_index(text, is_active, hover)
    if is_active then
        return {
            { Background = { Color = ACTIVE_TEXT_COLOR } },
            { Foreground = { Color = BACKGROUND_COLOR } },
            { Attribute = { Intensity = "Bold" } },
            { Text = " " .. text .. " " },
        }
    else
        return {
            { Background = { Color = BACKGROUND_COLOR } },
            { Foreground = { Color = INACTIVE_INDEX_COLOR } },
            { Attribute = { Intensity = "Bold" } },
            { Attribute = { Italic = false } },
            { Text = " " .. text .. " " },
        }
    end
end

local function format_title(text, is_active, hover)
    if is_active then
        return {
            { Background = { Color = ACTIVE_TEXT_COLOR } },
            { Foreground = { Color = BACKGROUND_COLOR } },
            { Text = " " .. text .. " " },
        }
    else
        return {
            { Background = { Color = BACKGROUND_COLOR } },
            { Foreground = { Color = hover and HOVER_TEXT_COLOR or TEXT_COLOR } },
            { Attribute = { Intensity = hover and "Bold" or "Normal" } },
            { Attribute = { Italic = false } },
            { Text = " " .. text .. " " },
        }
    end
end

local function format_pane_count(text, is_active, hover)
    if is_active then
        return {
            { Background = { Color = ACTIVE_TEXT_COLOR } },
            { Foreground = { Color = BACKGROUND_COLOR } },
            { Text = "(" .. text .. ") " },
        }
    else
        return {
            { Background = { Color = BACKGROUND_COLOR } },
            { Foreground = { Color = hover and HOVER_TEXT_COLOR or TEXT_COLOR } },
            { Attribute = { Intensity = hover and "Bold" or "Normal" } },
            { Attribute = { Italic = false } },
            { Text = "(" .. text .. ") " },
        }
    end
end

local function format_right_border(_hover, is_active)
    if is_active then
        return {
            { Foreground = { Color = BACKGROUND_COLOR } },
            { Background = { Color = ACTIVE_TEXT_COLOR } },
            { Text = " " },
            { Background = { Color = BACKGROUND_COLOR } },
            { Foreground = { Color = ACTIVE_TEXT_COLOR } },
            { Text = RIGHT_BORDER .. " " },
        }
    else
        return {
            { Background = { Color = BACKGROUND_COLOR } },
            { Foreground = { Color = TEXT_COLOR } },
            { Text = INACTIVE_RIGHT_BORDER },
        }
    end
end

function result.format_tab(tab, tabs, panes, config, hover, max_width)
    local text = tab_title(tab)
    local pane_count = "" .. #panes
    local tab_index = "" .. tab.tab_index + 1
    local max_width_less_meta = max_width - string.len(tab_index) - string.len(pane_count) - 4
    local title = ellipsis(text, max_width_less_meta)
    local result = {
        format_left_border(hover, tab.is_active),
        format_index(tab_index, tab.is_active, hover),
        format_title(title, tab.is_active, hover),
        format_pane_count(pane_count, tab.is_active, hover),
        format_right_border(hover, tab.is_active),
    }
    local flattened_result = {}
    for _, value in ipairs(result) do
        for _, item in ipairs(value) do
            table.insert(flattened_result, item)
        end
    end
    return flattened_result
end

return result
