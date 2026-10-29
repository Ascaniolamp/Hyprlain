-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Keybindings Configuration                  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local programs = require("programs")

local mainMod = "SUPER_L"

-- Application launch binds
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.files))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(programs.editor))

-- Utilities
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(programs.colorPicker))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(programs.takeScreenshot))
hl.bind("Print",                   hl.dsp.exec_cmd(programs.takeScreenshot))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(programs.nextKbdLayout))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(programs.startTimer))
hl.bind(mainMod .. " + SHIFT + code:60", hl.dsp.exec_cmd(programs.pickEmoji))

-- Media app on dedicated workspace
hl.bind(mainMod .. " + 9", hl.dsp.exec_cmd("[workspace 9 silent; fullscreen] " .. programs.music))

-- Menu & Bar
hl.bind(mainMod,               hl.dsp.exec_cmd(programs.activateMenu), { release = true })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(programs.activateMenu))
hl.bind(mainMod .. " + O",     hl.dsp.exec_cmd(programs.toggleBar))

-- Window actions
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + N", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M", hl.dsp.group.toggle())

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",           hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + TAB",         hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Group navigation
hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + K", hl.dsp.group.next())
hl.bind(mainMod .. " + CTRL + J", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.next())

-- Move window
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

-- Focus window
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Mouse window manipulation
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Zoom bindings
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd(programs.zoom))
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 + 0.5}')"))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 - 0.5}')"))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"))

-- Multimedia keys (volume, brightness)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl s 10%+"),                           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl s 10%-"),                           { locked = true, repeating = true })

-- Media player controls
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Debug overlay
hl.bind(mainMod .. " + ALT + CTRL + SPACE", hl.dsp.exec_cmd(programs.toggleDebugOverlay))
