-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Input & Gestures Configuration             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

hl.config({
    input = {
        kb_layout = "us,it",
        numlock_by_default = false,
        resolve_binds_by_sym = false,
        repeat_rate = 25,
        repeat_delay = 600,
        sensitivity = 0,
        accel_profile = "flat",
        force_no_accel = false,
        left_handed = false,
        scroll_method = "2fg",
        scroll_factor = 1.0,
        natural_scroll = false,
        follow_mouse = 1,
        focus_on_close = 0,
        mouse_refocus = true,
        float_switch_override_focus = 1,
        special_fallthrough = false,
        emulate_discrete_scroll = 1,

        touchpad = {
            disable_while_typing = true,
            natural_scroll = false,
            scroll_factor = 1.0,
            middle_button_emulation = false,
            clickfinger_behavior = false,
            tap_to_click = true,
            drag_lock = false,
            tap_and_drag = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
