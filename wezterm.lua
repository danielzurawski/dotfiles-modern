local wezterm = require('wezterm')
local config = {}

-- Use config builder object if possible
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Font configuration
config.font = wezterm.font('MesloLGS NF')
config.font_size = 13.0
config.line_height = 1.1
config.cell_width = 1.0
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'

-- Color scheme and visual settings
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- Terminal behavior
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate = 800
config.cursor_blink_ease_in = 'Linear'
config.cursor_blink_ease_out = 'Linear'

-- Send the correct key codes for Option+Arrow keys
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Key tables for word-wise movement
config.key_tables = {
  copy_mode = {
    { key = "LeftArrow",  mods = "ALT", action = wezterm.action({ SendString = "\x1b\x62" }) },
    { key = "RightArrow", mods = "ALT", action = wezterm.action({ SendString = "\x1b\x66" }) },
  },
}

-- macOS specific configurations
config.native_macos_fullscreen_mode = true
config.keys = {
  -- macOS standard key bindings
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'DefaultDomain',
  },
  {
    key = 'f',
    mods = 'CMD',
    action = wezterm.action.ToggleFullScreen,
  },
  -- Word-wise movement
  {
    key = "LeftArrow",
    mods = "ALT",
    action = wezterm.action({ SendString = "\x1b\x62" }), -- Alt+b
  },
  {
    key = "RightArrow",
    mods = "ALT",
    action = wezterm.action({ SendString = "\x1b\x66" }), -- Alt+f
  },
}

-- Shell integration
config.automatically_reload_config = true
config.default_prog = { '/bin/zsh' }
config.set_environment_variables = {
  -- Terminal
  TERM = 'xterm-256color',
  -- Path to ensure brew works correctly on macOS
  PATH = os.getenv('PATH'),
}

-- Set working directory behavior
config.default_cwd = wezterm.home_dir

return config