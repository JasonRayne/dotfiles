local wezterm = require 'wezterm'
local act = wezterm.action -- Define 'act' as a local variable

local M = {}

-- Define the leader key
M.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1250 }

-- Define the keybindings
M.keys = {
	{
	key = "w",
	mods = "SUPER",
	action = act.CloseCurrentPane({ confirm = true }),
	},

	-- activate resize mode
	{
	key = "r",
	mods = "LEADER",
	action = act.ActivateKeyTable({
	name = "resize_pane",
	one_shot = false,
	}),
	},

	-- focus panes
	{
	key = "h",
	mods = "LEADER",
	action = act.ActivatePaneDirection("Left"),
	},
	{
	key = "l",
	mods = "LEADER",
	action = act.ActivatePaneDirection("Right"),
	},
	{
	key = "k",
	mods = "LEADER",
	action = act.ActivatePaneDirection("Up"),
	},
	{
	key = "j",
	mods = "LEADER",
	action = act.ActivatePaneDirection("Down"),
	},

	-- add new panes
	{
	key = "\\",
	mods = "LEADER",
	action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
	key = "|",
	mods = "LEADER|SHIFT",
	action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	}
}
	
	-- cycle tabs
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(M.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = act.ActivateTab(i - 1),
  })
  -- F1 through F8 to activate that tab
  table.insert(M.keys, {
    key = 'F' .. tostring(i),
    action = act.ActivateTab(i - 1),
  })
end     

M.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize({ 'Left', 5 }) },
    { key = 'h', action = act.AdjustPaneSize({ 'Left', 5 }) },

    { key = 'RightArrow', action = act.AdjustPaneSize({ 'Right', 5 }) },
    { key = 'l', action = act.AdjustPaneSize({ 'Right', 5 }) },

    { key = 'UpArrow', action = act.AdjustPaneSize({ 'Up', 2 }) },
    { key = 'k', action = act.AdjustPaneSize({ 'Up', 2 }) },

    { key = 'DownArrow', action = act.AdjustPaneSize({ 'Down', 2 }) },
    { key = 'j', action = act.AdjustPaneSize({ 'Down', 2 }) },

    { key = 'Escape', action = 'PopKeyTable' },
  },
}

return M
