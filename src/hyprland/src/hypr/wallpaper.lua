-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Wallpaper Configuration                   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local home = os.getenv("HOME") or ""
local wallpaper_daemon = "awww-daemon"
local wallpaper = "awww"
local def_wallpaper = home .. "/.config/assets/media/anim/bg_dark_anim_0_08.gif"

hl.on("hyprland.start", function()
    hl.exec_cmd(wallpaper_daemon)
    hl.exec_cmd("sleep 0.5 && " .. wallpaper .. " img " .. def_wallpaper)
end)
