local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Modern appearance settings with Powerlevel10k support
config.font = wezterm.font_with_fallback {
  {
    family = 'MesloLGS NF',     -- Recommended font for Powerlevel10k
    weight = 'Medium',
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
  },
  'JetBrains Mono',
  'Fira Code',
}
config.font_size = 14.0
config.line_height = 1.2
config.color_scheme = 'Catppuccin Mocha'

-- Window appearance
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

-- Modern features
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.enable_scroll_bar = false
config.native_macos_fullscreen_mode = true
config.window_background_opacity = 0.95

-- Terminal features
config.scrollback_lines = 10000
config.enable_kitty_keyboard = true
config.enable_wayland = true
config.term = 'wezterm'

-- Key bindings
config.keys = {
  -- Add your custom key bindings here
}

return config