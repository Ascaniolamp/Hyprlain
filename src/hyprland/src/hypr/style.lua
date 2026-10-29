-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Style, Look & Feel, Animations             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local colors = require("palette")

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPRCURSOR_SIZE", "32")

hl.on("hyprland.start", function()
    hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "hyprlain"')
    hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        border_size = 2,
        gaps_in = 3,
        gaps_out = 6,
        col = {
            active_border = colors.foreprimary,
            inactive_border = colors.foresecondary,
        },
        layout = "dwindle",
        no_focus_fallback = false,
        resize_on_border = false,
        allow_tearing = false,
    },

    decoration = {
        rounding = 0,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.8,
        dim_inactive = true,
        dim_strength = 0.4,
        dim_special = 0.6,
        dim_around = 0.6,

        blur = {
            enabled = true,
            size = 10,
            passes = 1,
            ignore_opacity = false,
            noise = 0.0117,
            contrast = 0.8916,
            brightness = 0.8172,
            vibrancy = 0.1696,
            vibrancy_darkness = 0.0,
        },

        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = colors.foreoctonary,
            color_inactive = colors.backprimary,
        },
    },

    group = {
        auto_group = false,
        focus_removed_window = false,
        drag_into_group = 2,
        merge_groups_on_drag = false,
        col = {
            border_active = colors.foreprimary,
            border_inactive = colors.forequaternary,
            border_locked_active = colors.foreprimary,
            border_locked_inactive = colors.forequaternary,
        },
        groupbar = {
            enabled = true,
            font_family = "AdwaitaMono Nerd Font",
            font_size = 14,
            gradients = false,
            height = 24,
            stacked = false,
            render_titles = true,
            scrolling = false,
            text_color = colors.foreprimary,
            col = {
                active = colors.backtertiary,
                inactive = colors.backsecondary,
                locked_active = colors.backtertiary,
                locked_inactive = colors.backsecondary,
            },
        },
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        col = {
            splash = colors.highprimary,
        },
        font_family = "AdwaitaMono Nerd Font",
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        enable_swallow = true,
        focus_on_activate = true,
        background_color = colors.backprimary,
        close_special_on_empty = false,
        middle_click_paste = false,
        vrr = 0,
    },

    render = {
        direct_scanout = 0,
    },

    cursor = {
        persistent_warps = true,
        warp_on_change_workspace = 1,
        hide_on_key_press = true,
        warp_back_after_non_mouse_input = true,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },

    dwindle = {
        preserve_split = true,
        precise_mouse_move = true,
    },

    master = {
        allow_small_split = true,
        new_status = "master",
        new_on_top = true,
        orientation = "center",
    },

    animations = {
        enabled = true,
    },
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("linear",         { type = "bezier", points = { {0.00, 0.00}, {1.00, 1.00} } })
hl.curve("schwoop",        { type = "bezier", points = { {1.00, 0.00}, {0.00, 1.00} } })
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1.00}, {0.32, 1.00} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1.00} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.50, 0.50}, {0.75, 1.00} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0.00}, {0.10, 1.00} } })
hl.curve("overshoot",      { type = "bezier", points = { {0.05, 0.90}, {0.10, 1.10} } })
hl.curve("bigOvershoot",   { type = "bezier", points = { {0.50, 0.00}, {0.00, 1.50} } })

hl.animation({ leaf = "global",        enabled = true,  speed = 1.00, bezier = "default" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint", style = "popin 80%" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.10, bezier = "overshoot",    style = "popin 80%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 80%" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4.00, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.50, bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.50, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.00, bezier = "quick",        style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.00, bezier = "quick",        style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.00, bezier = "quick",        style = "fade" })
