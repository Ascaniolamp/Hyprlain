-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Programs & Autostart Configuration         --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local M = {}

local home = os.getenv("HOME") or ""
M.hyprscript = home .. "/.config/hypr/scripts"

M.terminal = "kitty"
M.browser = "firefox"
M.files = "nautilus"
M.editor = "zeditor"
M.zoom = "woomer"
M.music = "spotify"
M.menu = "rofi"
M.bar = "waybar"

M.colorPicker = "hyprpicker -a -fhex"
M.takeScreenshot = "hyprshot --mode=region --freeze --output-folder=Media/Screenshots"
M.nextKbdLayout = "hyprctl switchxkblayout logitech-usb-receiver-keyboard next"
M.startTimer = M.hyprscript .. "/timer"
M.pickEmoji = M.menu .. " -show emoji"
M.toggleDebugOverlay = M.hyprscript .. "/toggle_debug_overlay"
M.activateMenu = "killall " .. M.menu .. " || " .. M.menu .. " -show combi"
M.toggleBar = "killall -SIGUSR1 " .. M.bar
M.quickAccent = "espanso"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd(M.bar)
    hl.exec_cmd(M.terminal)
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("udiskie")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Optional background daemons
    -- hl.exec_cmd(M.quickAccent .. " start")
    -- hl.exec_cmd("nm-applet")
    -- hl.exec_cmd("otd-daemon")
    -- hl.exec_cmd("hyprsunset")
end)

return M
