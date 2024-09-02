local wezterm = require 'wezterm'
local mux = wezterm.mux
local mappings = require'modules.mappings'
local config = {}
if wezterm.config_builder then
   config = wezterm.config_builder()
end

wezterm.on("update-right-status", function(window, pane)
  local key_table = window:active_key_table()
  local workspace = window:active_workspace()
  local domain_name = pane:get_domain_name()

  local status = ""

  if workspace then
    status = "WORKSPACE: " .. workspace
  end

  if domain_name then
    if #status > 0 then
      status = status .. " | "
    end
    status = status .. "DOMAIN: " .. domain_name
  end

  if key_table then
    if #status > 0 then
      status = status .. " | "
    end
    status = status .. "TABLE: " .. key_table
  end

  window:set_right_status(status)
end)

-- Apply configuration
config.default_cursor_style = "BlinkingBlock"
config.color_scheme = "carbonfox"
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = 12
config.window_background_opacity = 0.97
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 999999
config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 20,
}
config.window_decorations = "RESIZE"
config.inactive_pane_hsb = {
  brightness = 0.7,
}
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.hide_mouse_cursor_when_typing = false
config.window_close_confirmation = "NeverPrompt"

-- Apply key bindings
config.leader = mappings.leader
config.keys = mappings.keys
config.key_tables = mappings.key_tables

-- Enable custom workspaces
wezterm.on('gui-startup', function(cmd)
 local args = {}
    if cmd and cmd.args then
      args = cmd.args
    end

  -- Define the project directory
  local project_dir = wezterm.home_dir .. '/projects'

   -- Function to set up another workspace (example)
   local function setup_default_workspace()
     local tab, main_pane, window = mux.spawn_window {
       workspace = 'default',
       cwd = wezterm.home_dir,
     }
      window:gui_window():set_inner_size(1080, 720)

     -- Split the main pane to create the editor pane
     local secondary_pane = main_pane:split {
       direction = 'Left',
       size = 0.7,
       cwd = wezterm.home_dir,
     }

     -- Set the active workspace to default
     mux.set_active_workspace 'default'
   end

  -- Function to set up another workspace (example)
  local function setup_other_workspace()
    local tab, main_pane, window = mux.spawn_window {
      workspace = 'other',
      cwd = project_dir,
    }
    window:gui_window():set_inner_size(80, 120)

    -- Split the main pane to create the editor pane
    local editor_pane = main_pane:split {
      direction = 'Top',
      size = 0.6,
      cwd = project_dir,
    }
    editor_pane:send_text 'vim\n'

    -- Split the main pane to create the terminal pane
    local terminal_pane = main_pane:split {
      direction = 'Right',
      size = 0.5,
      cwd = wezterm.home_dir,
    }
    terminal_pane:send_text 'pwd\n'

    -- Set the active workspace to Other
    mux.set_active_workspace 'other'
  end

  -- Determine which workspace to set up based on the argument
  if args[1] == 'other' then
    setup_other_workspace()
  elseif args[1] == nil then
    -- Default empty window setup if no argument is provided
    setup_default_workspace()
  else
    -- Default workspace setup if no argument is provided
    setup_default_workspace()
  end
end)

return config
