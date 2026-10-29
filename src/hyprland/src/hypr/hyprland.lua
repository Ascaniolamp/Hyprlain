-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Hyprland Lua Configuration                 --
-- https://github.com/Ascaniolamp/Hyprlain                --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/configuring/core/monitors/
-- Default generic configuration (overridable per system)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Example per-monitor custom setup:
-- hl.monitor({ output = "MONITOR_NAME", mode = "preferred", position = "auto", scale = 1.0 })

-------------------------
---- MODULE IMPORTS -----
-------------------------

require("palette")
require("programs")
require("style")
require("input")
require("keys")
require("windows")
require("plugins")
require("wallpaper")
