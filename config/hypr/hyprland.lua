hl.monitor({
    output = "HDMI-A-1",
    mode = "3840x2160@60",
    position = "0x0",
    scale = 1.25
})

hl.monitor({
    output = "HDMI-A-2",
    mode = "3840x2160@60",
    position = "3072x0",
    scale = 1.25
})

local terminal = "wezterm"
-- local filemanager = "dolphin"


local envs = {
    XDG_SESSION_TYPE = "wayland",
    XDG_CURRENT_DESKTOP = "Hyprland",
    GDK_BACKEND = "wayland",
    QT_QPA_PLATFORM = "wayland",
    SDL_VIDEODRIVER = "wayland,x11",
    CLUTTER_BACKEND = "wayland",
    GTK_THEME = "Adwaita:dark",
    XCURSOR_THEME = "Adwaita",
    XCURSOR_SIZE = "24",
    QT_QPA_PLATFORMTHEME = "qt6ct",
    GTK_SCALE = "1.25",
    QT_SCALE_FACTOR = "1.25",
}

for key, val in pairs(envs) do
    hl.env(key, val)
end

local onces = {
    "dbus-update-activation-environment --systemd --all",
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "nm-applet",
    "waybar",
    "hyprpaper",
    "spotify",
    'gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"',
    'gsettings set org.gnome.desktop.interface gtk-theme "prefer-dark"',
    "hypridle",
    "hyprlauncher --daemon",
    "wezterm start --class btop -- btop",
    "wezterm start --class quikshell",
    "/usr/lib/polkit-kde-authentication-agent-1",
    'openrgb --startminimized --profile "/home/derek/.config/OpenRGB/Emerald Aeternal"',
}

hl.on("hyprland.start", function()
    for _i, cmd in ipairs(onces) do
        hl.exec_cmd(cmd)
    end
end)

hl.config({
    general = {
        gaps_in = 8,
        gaps_out = 20,
        border_size = 3,
        col = {
            active_border = {
                colors = { "rgba(11eeffee)", "rgba(00ff66ee)" },
                angle = 45,
            },
            inactive_border = "rgba(295969aa)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "master",
    },
    decoration = {
        rounding = 8,
        rounding_power = 8,
        active_opacity = 1.0,
        -- inactive_opacity = 0.8,
        shadow = {
            enabled = true,
            range = 19,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 3,
            vibrancy = 0.9696,
        },
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })
hl.curve("easeOutCubic", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })
hl.curve("easeOutCirc", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 1.3, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "easeOutCubic", style = "slidefade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2, bezier = "easeOutCubic", style = "slidefade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2, bezier = "easeOutCubic", style = "slidefade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "easeOutCubic", style = "fade" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "easeInOutCubic", style = "popin 65%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "easeInOutCubic", style = "popin 65%" })


hl.config({
    master = {
        new_status = "master",
        mfact = 0.64
    },
})

hl.config({
    input = {
        kb_layout = "us"
    }
})

hl.window_rule({
    name = "spotify-rule",
    match = { class = "(?i)^(spotify)$" },
    workspace = "special:music",
    size = { "monitor_w * 0.7", "monitor_h * 0.7" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "btop-rule",
    match = { class = "(?i)^(btop)$" },
    workspace = "special:system-monitor",
    size = { "monitor_w * 0.7", "monitor_h * 0.7" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "quikshell-rule",
    match = { class = "(?i)^(quikshell)$" },
    workspace = "special:quikshell",
    size = { "monitor_w * 0.7", "monitor_h * 0.7" },
    center = true,
    float = true,
})


hl.config({
    xwayland = {
        force_zero_scaling = true
    },
})

hl.bind("SUPER + J", hl.dsp.layout("cyclenext"))
hl.bind("SUPER + K", hl.dsp.layout("cycleprev"))
hl.bind("SUPER + SHIFT + J", hl.dsp.layout("swapnext"))
hl.bind("SUPER + SHIFT + K", hl.dsp.layout("swapprev"))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + W", hl.dsp.window.kill())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exit()) -- recommended to use hyprshutdown?
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind("SUPER + C", function()
    hl.dispatch(hl.dsp.workspace.toggle_special("system-monitor"))
    hl.dispatch(hl.dsp.window.center())
end)

hl.bind("SUPER + X", function()
    hl.dispatch(hl.dsp.workspace.toggle_special("quikshell"))
    hl.dispatch(hl.dsp.window.center())
end)

hl.bind("SUPER + V", function()
    hl.dispatch(hl.dsp.workspace.toggle_special("music"))
    hl.dispatch(hl.dsp.window.center())
end)
hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprlauncher"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))


local workspaces = {
    {
        id = "1",
        key = "1",
        name = "term",
    },
    {
        id = "2",
        key = "2",
        name = "web",
    },
    {
        id = "3",
        key = "3",
        name = "play",
    },
    {
        id = "4",
        key = "4",
        name = "comm",
    },
    {
        id = "5",
        key = "5",
        name = "misc",
    },
    {
        id = "6",
        key = "6",
        name = "msc2",
    },
    {
        id = "7",
        key = "7",
        name = "msc3",
    },
    {
        id = "8",
        key = "8",
        name = "msc4",
    },
    {
        id = "9",
        key = "9",
        name = "msc5",
    },
    {
        id = "10",
        key = "0",
        name = "msc6",
    },
}

for _i, workspace in ipairs(workspaces) do
    hl.bind("SUPER + " .. workspace.key, hl.dsp.focus({ workspace = workspace.id, on_current_monitor = true }))
    hl.bind("SUPER + SHIFT + " .. workspace.key, hl.dsp.window.move({ workspace = workspace.id, follow = false }))
    hl.workspace_rule({ workspace = workspace.id, default_name = workspace.name })
end

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl -p spotify play-pause"), { locked = true })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl -p spotify play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl -p spotify previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl -p spotify next"), { locked = true })
