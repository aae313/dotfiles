local main_mod = "SUPER"
local borrowed_window_origin_workspaces = {}
local workspace_monocle_rules = {}

local function is_primary_workspace(workspace)
	if not workspace then
		return false
	end

	local monitor = workspace.monitor

	return (monitor ~= nil and monitor.name == "DP-1") or (workspace.id >= 1 and workspace.id <= 5)
end

local function is_window_on_primary_workspace(window)
	if not window then
		return false
	end

	if window.monitor and window.monitor.name == "DP-1" then
		return true
	end

	return is_primary_workspace(window.workspace)
end

-- stable_id survives for the window's lifetime; addresses are heap pointers
-- that can be reused after a window closes.
local function window_identity(window)
	return tostring(window.stable_id or window.address or window)
end

local function run_or_focus_primary_app(app_class, launch_command)
	local matching_windows = {}

	for _, window in ipairs(hl.get_windows()) do
		if window.class == app_class and is_window_on_primary_workspace(window) then
			table.insert(matching_windows, window)
		end
	end

	if #matching_windows == 0 then
		hl.exec_cmd(launch_command)
		return
	end

	local active_window = hl.get_active_window()
	local active_window_identity = active_window and window_identity(active_window)

	for index, window in ipairs(matching_windows) do
		if window_identity(window) == active_window_identity then
			if #matching_windows == 1 then
				local previous_window = hl.get_last_window()

				if previous_window then
					hl.dispatch(hl.dsp.focus({ window = previous_window }))
				end
			else
				local next_index = (index % #matching_windows) + 1
				hl.dispatch(hl.dsp.focus({ window = matching_windows[next_index] }))
			end

			return
		end
	end

	hl.dispatch(hl.dsp.focus({ window = matching_windows[1] }))
end

local function prune_closed_borrowed_windows(windows)
	local alive = {}

	for _, window in ipairs(windows) do
		alive[window_identity(window)] = true
	end

	for identity in pairs(borrowed_window_origin_workspaces) do
		if not alive[identity] then
			borrowed_window_origin_workspaces[identity] = nil
		end
	end
end

local function toggle_primary_app_on_active_workspace(app_class)
	local workspace = hl.get_active_workspace()

	if not is_primary_workspace(workspace) then
		return
	end

	local windows = hl.get_windows()
	prune_closed_borrowed_windows(windows)

	for _, window in ipairs(windows) do
		local identity = window_identity(window)
		local origin = borrowed_window_origin_workspaces[identity]

		if window.class == app_class and origin and window.workspace and window.workspace.id == workspace.id then
			local active_window = hl.get_active_window()

			borrowed_window_origin_workspaces[identity] = nil
			hl.dispatch(hl.dsp.window.move({ window = window, workspace = origin, follow = false }))

			if active_window and window_identity(active_window) ~= window_identity(window) then
				hl.dispatch(hl.dsp.focus({ window = active_window }))
			else
				hl.dispatch(hl.dsp.focus({ workspace = workspace.id }))
			end

			return
		end
	end

	for _, window in ipairs(windows) do
		if window.class == app_class and is_window_on_primary_workspace(window) and window.workspace then
			local identity = window_identity(window)
			local origin = borrowed_window_origin_workspaces[identity]

			if window.workspace.id == workspace.id then
				hl.dispatch(hl.dsp.focus({ window = window }))
				return
			end

			origin = origin or window.workspace.name or tostring(window.workspace.id)
			if origin == workspace.name or origin == tostring(workspace.id) then
				borrowed_window_origin_workspaces[identity] = nil
			else
				borrowed_window_origin_workspaces[identity] = origin
			end

			hl.dispatch(hl.dsp.window.move({ window = window, workspace = workspace.id, silent = true }))
			hl.dispatch(hl.dsp.focus({ window = window }))
			return
		end
	end
end

local function toggle_active_window_group()
	local window = hl.get_active_window()

	if not window then
		return
	end

	if window.group then
		hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
	else
		hl.dispatch(hl.dsp.group.toggle())
	end
end

local function move_active_window_to_relative_workspace(offset)
	local workspace = hl.get_active_workspace()

	if not workspace or not hl.get_active_window() then
		return
	end

	local target = workspace.id + offset

	if target < 1 then
		return
	end

	hl.dispatch(hl.dsp.window.move({ workspace = target, silent = true }))
end

-- Monocle blocks input on inactive windows, which excludes them from the
-- generic cycle_next candidate set, so monocle needs its own layout message.
local function cycle_active_workspace_windows(forward)
	local workspace = hl.get_active_workspace()
	local window = hl.get_active_window()

	if not workspace or not window then
		return
	end

	if workspace.tiled_layout == "monocle" and not window.floating then
		hl.dispatch(hl.dsp.layout(forward and "cyclenext" or "cycleprev"))
	else
		hl.dispatch(hl.dsp.window.cycle_next({ next = forward }))
	end
end

local function get_workspace_monocle_rules(workspace)
	local rules = workspace_monocle_rules[workspace.id]

	if rules then
		return rules
	end

	local workspace_selector = tostring(workspace.id)
	local isolated_workspace_selector = "r[" .. workspace_selector .. "-" .. workspace_selector .. "]s[false]"

	rules = {
		master = hl.workspace_rule({
			workspace = isolated_workspace_selector .. "n[false]",
			layout = "master",
			enabled = false,
		}),
		monocle = hl.workspace_rule({
			workspace = isolated_workspace_selector,
			layout = "monocle",
			gaps_in = 0,
			gaps_out = 0,
			enabled = false,
		}),
		window = hl.window_rule({
			match = { float = false, workspace = workspace_selector },
			border_size = 0,
			rounding = 0,
			enabled = false,
		}),
	}
	workspace_monocle_rules[workspace.id] = rules

	return rules
end

local function apply_workspace_layout_override(rules, layout)
	rules.master:set_enabled(layout == "master")
	rules.monocle:set_enabled(layout == "monocle")
	rules.window:set_enabled(layout == "monocle")
	hl.exec_scheduled_prop_refresh_immediately()
end

local function toggle_active_workspace_master_monocle_layout()
	local workspace = hl.get_active_workspace()

	if not workspace or workspace.id < 1 then
		return
	end

	local current_layout = workspace.tiled_layout

	if current_layout ~= "master" and current_layout ~= "monocle" then
		local rules = workspace_monocle_rules[workspace.id]

		if rules then
			apply_workspace_layout_override(rules, nil)
		end

		return
	end

	local rules = get_workspace_monocle_rules(workspace)
	local next_layout = current_layout == "master" and "monocle" or "master"

	apply_workspace_layout_override(rules, next_layout)
end

local function workspace_has_tiled_window(workspace)
	for _, window in ipairs(hl.get_workspace_windows(workspace)) do
		if not window.floating then
			return true
		end
	end

	return false
end

-- CMasterAlgorithm::layoutMsg segfaults when the workspace has no tiled
-- windows (e.g. a lone floating window), so master layout messages must
-- never be dispatched without at least one tiled window present.
local function bind_master_layout_message(keys, message)
	hl.bind(keys, function()
		local workspace = hl.get_active_workspace()

		if workspace and workspace.tiled_layout == "master" and workspace_has_tiled_window(workspace) then
			hl.dispatch(hl.dsp.layout(message))
		end
	end)
end

local function resize_active_window_or_master_area(sign)
	local window = hl.get_active_window()

	if not window then
		return
	end

	if window.floating then
		hl.dispatch(hl.dsp.window.resize({ x = 50 * sign, y = 50 * sign, relative = true }))
		return
	end

	local workspace = hl.get_active_workspace()

	if workspace and workspace.tiled_layout == "master" then
		hl.dispatch(hl.dsp.layout(sign > 0 and "mfact +0.05" or "mfact -0.05"))
	end
end

local direction_bindings = {
	{ keys = { "h", "left" }, direction = "l", delta = { x = -20, y = 0 } },
	{ keys = { "j", "down" }, direction = "d", delta = { x = 0, y = 20 } },
	{ keys = { "k", "up" }, direction = "u", delta = { x = 0, y = -20 } },
	{ keys = { "l", "right" }, direction = "r", delta = { x = 20, y = 0 } },
}

for _, binding in ipairs(direction_bindings) do
	for _, key in ipairs(binding.keys) do
		hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ direction = binding.direction }))
		hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = binding.direction }))
	end

	hl.bind(
		main_mod .. " + CTRL + " .. binding.keys[2],
		hl.dsp.window.resize({ x = binding.delta.x, y = binding.delta.y, relative = true }),
		{ repeating = true }
	)

	hl.bind(
		main_mod .. " + ALT + " .. binding.keys[2],
		hl.dsp.window.move({ x = binding.delta.x, y = binding.delta.y, relative = true }),
		{ repeating = true }
	)
end

hl.bind(main_mod .. " + bracketleft", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(main_mod .. " + bracketright", hl.dsp.focus({ workspace = "m+1" }))

hl.bind(main_mod .. " + grave", hl.dsp.exec_cmd("snappy-switcher next --mod super"))

hl.bind(main_mod .. " + Tab", function()
	cycle_active_workspace_windows(true)
end)
hl.bind(main_mod .. " + SHIFT + Tab", function()
	cycle_active_workspace_windows(false)
end)

bind_master_layout_message(main_mod .. " + W", "focusmaster previous")
bind_master_layout_message(main_mod .. " + SHIFT + W", "swapwithmaster master")

hl.bind(main_mod .. " + M", hl.dsp.focus({ monitor = "+1" }))
hl.bind(main_mod .. " + SHIFT + M", hl.dsp.window.move({ monitor = "+1", follow = false }))

bind_master_layout_message(main_mod .. " + O", "orientationnext")
bind_master_layout_message(main_mod .. " + SHIFT + O", "orientationprev")

hl.bind(main_mod .. " + Space", toggle_active_workspace_master_monocle_layout)
hl.bind(main_mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(main_mod .. " + equal", function()
	resize_active_window_or_master_area(1)
end)
hl.bind(main_mod .. " + minus", function()
	resize_active_window_or_master_area(-1)
end)
bind_master_layout_message(main_mod .. " + 0", "mfact exact 0.55")

hl.bind(
	main_mod .. " + SHIFT + equal",
	hl.dsp.window.resize({
		x = 50,
		y = 50,
		relative = true,
	})
)

hl.bind(
	main_mod .. " + SHIFT + minus",
	hl.dsp.window.resize({
		x = -50,
		y = -50,
		relative = true,
	})
)

hl.bind(main_mod .. " + g", toggle_active_window_group)
hl.bind(main_mod .. " + N", hl.dsp.group.next())
hl.bind(main_mod .. " + P", hl.dsp.group.prev())

hl.bind(main_mod .. " + SHIFT + P", hl.dsp.window.pin())
hl.bind(main_mod .. " + Z", hl.dsp.window.center())
hl.bind(main_mod .. " + SHIFT + Q", hl.dsp.window.close())

hl.bind(main_mod .. " + SHIFT + bracketleft", function()
	move_active_window_to_relative_workspace(-1)
end)

hl.bind(main_mod .. " + SHIFT + bracketright", function()
	move_active_window_to_relative_workspace(1)
end)

hl.bind(main_mod .. " + SHIFT + ALT + bracketleft", hl.dsp.workspace.move({ monitor = "l" }))

hl.bind(main_mod .. " + SHIFT + ALT + bracketright", hl.dsp.workspace.move({ monitor = "r" }))

for workspace = 1, 9 do
	hl.bind(
		main_mod .. " + " .. workspace,
		hl.dsp.focus({
			workspace = workspace,
		})
	)

	hl.bind(
		main_mod .. " + SHIFT + " .. workspace,
		hl.dsp.window.move({
			workspace = workspace,
			follow = false,
		})
	)
end

hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(
	main_mod .. " + mouse:276",
	hl.dsp.window.fullscreen({
		mode = "fullscreen",
		action = "toggle",
	})
)

hl.bind(main_mod .. " + Return", function()
	run_or_focus_primary_app("kitty", "app2unit-term")
end)

hl.bind(main_mod .. " + SHIFT + Return", function()
	toggle_primary_app_on_active_workspace("kitty")
end)

hl.bind(main_mod .. " + CTRL + Return", hl.dsp.exec_cmd("footclient"))

hl.bind(main_mod .. " + E", function()
	run_or_focus_primary_app("neovide", "neovide")
end)

hl.bind(main_mod .. " + SHIFT + E", function()
	toggle_primary_app_on_active_workspace("neovide")
end)

hl.bind(main_mod .. " + Backspace", function()
	run_or_focus_primary_app("firefox-nightly", "firefox-nightly")
end)

hl.bind(main_mod .. " + SHIFT + Backspace", function()
	toggle_primary_app_on_active_workspace("firefox-nightly")
end)

hl.bind(main_mod .. " + A", hl.dsp.exec_cmd("pypr toggle chatgpt"))

hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("open-bookmark"))
hl.bind(main_mod .. " + SHIFT + B", hl.dsp.exec_cmd("open-book"))

hl.bind(main_mod .. " + C", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

hl.bind(main_mod .. " + SHIFT + semicolon", hl.dsp.exec_cmd("fuzzel"))
hl.bind(main_mod .. " + f", hl.dsp.exec_cmd("pypr fetch_client_menu"))
hl.bind(main_mod .. " + SHIFT + f", hl.dsp.exec_cmd("pypr unfetch_client"))
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(
	"Print",
	hl.dsp.exec_cmd(
		-- "##" was a hyprlang comment escape; Lua strings need the plain "#".
		"grim -g \"$(slurp -c '#89dceb')\" -t ppm -"
			.. " | satty --filename - --fullscreen"
			.. " --copy-command wl-copy"
			.. " --output-filename ~/misc/screenshots/satty-$(date '+%Y%m%d-%H%M%S').png"
	)
)
