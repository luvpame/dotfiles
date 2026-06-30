-- Initialization
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Color Scheme
config.color_scheme = "Catppuccin Latte"

-- Font Settings
config.font = wezterm.font_with_fallback({
  "HackGen Console NF",
  "Noto Color Emoji",
})
config.font_size = 16
config.line_height = 1.1

config.use_ime = true

-- Cursor Settings
config.default_cursor_style = "BlinkingBlock"

-- Window Settings
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

-- Background Settings
config.window_background_opacity = 0.85
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.2,
}

-- Tab Bar Settings
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "e6e9ef" },
}
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#eff1f5",
      fg_color = "#4c4f69",
    },
    inactive_tab = {
      bg_color = "#ccd0da",
      fg_color = "#5c5f77",
    },
    inactive_tab_hover = {
      bg_color = "#bcc0cc",
      fg_color = "#4c4f69",
    },
  },
}

config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

config.keys = {
  { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
  { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "CMD|CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "CMD|CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "CMD|CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "CMD|CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
}

return config
