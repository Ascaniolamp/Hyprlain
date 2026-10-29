-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Window Rules & Workspaces                  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Suppress maximize events for all applications
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix dragging issues with XWayland
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Floating applications
local float_apps = {
    "org.gnome.Nautilus",
    "vlc",
    "mpv",
    "pavucontrol",
    "blueman-manager",
    "feh",
    "nm-connection-editor",
    "imv",
    "xdg-desktop-portal-gtk",
}

for _, app in ipairs(float_apps) do
    hl.window_rule({
        name = "float-" .. app,
        match = { class = app },
        float = true,
    })
end

-- Forced popup windows (auth agents, desktop portals)
hl.window_rule({
    name = "forced-popups",
    match = {
        class = "(polkit-gnome-authentication-agent-1|org.kde.polkit-kde-authentication-agent-1|hyprpolkitagent|xdg-desktop-portal-gtk)",
    },
    stay_focused = true,
    dim_around = true,
    float = true,
})
