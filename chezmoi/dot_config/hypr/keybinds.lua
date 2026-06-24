local mod = "SUPER"
local temporary_window_origin_workspaces = {}
local workspace_layout_overrides = {}

local function is_primary_workspace(workspace)
	if not workspace then
		return false
	end

	local monitor = workspace.monitor

	return monitor == "DP-1" or (monitor and monitor.name == "DP-1") or (workspace.id >= 1 and workspace.id <= 5)
end

local function is_primary_workspace_window(window)
	if not window then
		return false
	end

	if window.monitor and window.monitor.name == "DP-1" then
		return true
	end

	return is_primary_workspace(window.workspace)
end

local function focus_primary_window_or_exec(app_class, command)
	for _, window in ipairs(hl.get_windows()) do
		if window.class == app_class and is_primary_workspace_window(window) then
			hl.dispatch(hl.dsp.focus({ window = window }))
			return
		end
	end

	hl.exec_cmd(command)
end

local function window_identity(window)
	return tostring(window.address or window.stable_id or window)
end

local function toggle_primary_window_on_current_workspace(app_class)
	local workspace = hl.get_active_workspace()

	if not is_primary_workspace(workspace) then
		return
	end

	for _, window in ipairs(hl.get_windows()) do
		local origin = temporary_window_origin_workspaces[window_identity(window)]

		if window.class == app_class and origin and window.workspace and window.workspace.id == workspace.id then
			local active_window = hl.get_active_window()

			temporary_window_origin_workspaces[window_identity(window)] = nil
			hl.dispatch(hl.dsp.window.move({ window = window, workspace = origin, follow = false }))

			if active_window and window_identity(active_window) ~= window_identity(window) then
				hl.dispatch(hl.dsp.focus({ window = active_window }))
			else
				hl.dispatch(hl.dsp.focus({ workspace = workspace.id }))
			end

			return
		end
	end

	for _, window in ipairs(hl.get_windows()) do
		if window.class == app_class and is_primary_workspace_window(window) and window.workspace then
			if window.workspace.id == workspace.id then
				hl.dispatch(hl.dsp.focus({ window = window }))
				return
			end

			temporary_window_origin_workspaces[window_identity(window)] = window.workspace.name
				or tostring(window.workspace.id)
			hl.dispatch(hl.dsp.window.move({ window = window, workspace = workspace.id, silent = true }))
			hl.dispatch(hl.dsp.focus({ window = window }))
			return
		end
	end
end

local function toggle_window_group()
	local win = hl.get_active_window()

	if win and win.group then
		hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
	else
		hl.dispatch(hl.dsp.group.toggle())
	end
end

local function move_into_any_group()
	for _, direction in ipairs({ "l", "r", "u", "d" }) do
		hl.dispatch(hl.dsp.window.move({ into_group = direction }))
	end
end

local function move_window_to_relative_workspace(offset)
	local workspace = hl.get_active_workspace()

	if not workspace then
		return
	end

	local target = workspace.id + offset

	if target < 1 then
		return
	end

	hl.dispatch(hl.dsp.window.move({ workspace = target, silent = true }))
end

local function toggle_workspace_master_monocle_layout()
	local workspace = hl.get_active_workspace()

	if not workspace then
		return
	end

	local actual_layout = workspace.tiled_layout

	if actual_layout ~= "master" and actual_layout ~= "monocle" then
		workspace_layout_overrides[workspace.id] = nil
		return
	end

	local current_layout = workspace_layout_overrides[workspace.id] or actual_layout
	local next_layout = current_layout == "master" and "monocle" or "master"

	workspace_layout_overrides[workspace.id] = next_layout
	hl.workspace_rule({
		workspace = tostring(workspace.id),
		layout = next_layout,
	})
end

hl.bind(mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))

hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))

hl.bind(
	mod .. " + CTRL + left",
	hl.dsp.window.resize({
		x = -20,
		y = 0,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(
	mod .. " + CTRL + down",
	hl.dsp.window.resize({
		x = 0,
		y = 20,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(
	mod .. " + CTRL + up",
	hl.dsp.window.resize({
		x = 0,
		y = -20,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(
	mod .. " + CTRL + right",
	hl.dsp.window.resize({
		x = 20,
		y = 0,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(
	mod .. " + ALT + left",
	hl.dsp.window.move({
		x = -20,
		y = 0,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(
	mod .. " + ALT + down",
	hl.dsp.window.move({
		x = 0,
		y = 20,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(
	mod .. " + ALT + up",
	hl.dsp.window.move({
		x = 0,
		y = -20,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(
	mod .. " + ALT + right",
	hl.dsp.window.move({
		x = 20,
		y = 0,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind(mod .. " + bracketleft", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + bracketright", hl.dsp.focus({ workspace = "m+1" }))

hl.bind(mod .. " + grave", hl.dsp.exec_cmd("snappy-switcher next --mod super"))

hl.bind(mod .. " + Tab", hl.dsp.exec_cmd("snappy-switcher next --workspace --silent --linear"))
hl.bind(mod .. " + SHIFT + Tab", hl.dsp.exec_cmd("snappy-switcher prev --workspace --silent --linear"))

hl.bind(mod .. " + Q", hl.dsp.layout("focusmaster previous"))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.layout("swapwithmaster master"))

hl.bind(mod .. " + O", hl.dsp.layout("orientationnext"))
hl.bind(mod .. " + SHIFT + O", hl.dsp.layout("orientationprev"))

hl.bind(mod .. " + Space", toggle_workspace_master_monocle_layout)
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + equal", hl.dsp.layout("mfact +0.05"))
hl.bind(mod .. " + minus", hl.dsp.layout("mfact -0.05"))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.layout("mfact exact 0.55"))

hl.bind(
	mod .. " + SHIFT + equal",
	hl.dsp.window.resize({
		x = 50,
		y = 50,
		relative = true,
	})
)

hl.bind(
	mod .. " + SHIFT + minus",
	hl.dsp.window.resize({
		x = -50,
		y = -50,
		relative = true,
	})
)

hl.bind(mod .. " + g", toggle_window_group)
hl.bind(mod .. " + N", hl.dsp.group.next())
hl.bind(mod .. " + P", hl.dsp.group.prev())
hl.bind(mod .. " + SHIFT + g", move_into_any_group)

hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pin())
hl.bind(mod .. " + W", hl.dsp.window.cycle_next({ floating = true }))
hl.bind(mod .. " + Z", hl.dsp.window.center())
hl.bind(mod .. " + CTRL + D", hl.dsp.window.close())

hl.bind(mod .. " + SHIFT + bracketleft", function()
	move_window_to_relative_workspace(-1)
end)

hl.bind(mod .. " + SHIFT + bracketright", function()
	move_window_to_relative_workspace(1)
end)

hl.bind(mod .. " + SHIFT + ALT + bracketleft", hl.dsp.workspace.move({ monitor = "l" }))

hl.bind(mod .. " + SHIFT + ALT + bracketright", hl.dsp.workspace.move({ monitor = "r" }))

for workspace = 1, 9 do
	hl.bind(
		mod .. " + " .. workspace,
		hl.dsp.focus({
			workspace = workspace,
		})
	)

	hl.bind(
		mod .. " + SHIFT + " .. workspace,
		hl.dsp.window.move({
			workspace = workspace,
			follow = false,
		})
	)
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(
	mod .. " + mouse:276",
	hl.dsp.window.fullscreen({
		mode = "fullscreen",
		action = "toggle",
	})
)

hl.bind(mod .. " + Return", function()
	focus_primary_window_or_exec("kitty", " app2unit-term")
end)

hl.bind(mod .. " + SHIFT + Return", function()
	toggle_primary_window_on_current_workspace("kitty")
end)

hl.bind(mod .. " + CTRL + Return", hl.dsp.exec_cmd("footclient"))

hl.bind(mod .. " + Backspace", function()
	focus_primary_window_or_exec("firefox-nightly", "firefox-nightly")
end)

hl.bind(mod .. " + SHIFT + Backspace", function()
	toggle_primary_window_on_current_workspace("firefox-nightly")
end)

hl.bind(mod .. " + A", hl.dsp.exec_cmd("pypr toggle chatgpt"))
hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd("pypr toggle claude"))

hl.bind(mod .. " + B", hl.dsp.exec_cmd("open-bookmark"))
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("open-book"))

hl.bind(mod .. " + C", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

hl.bind(mod .. " + SHIFT + semicolon", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + f", hl.dsp.exec_cmd("pypr fetch_client_menu"))
hl.bind(mod .. " + SHIFT + f", hl.dsp.exec_cmd("pypr unfetch_client"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(
	"Print",
	hl.dsp.exec_cmd(
		"grim -g \"$(slurp -c '##89dceb')\" -t ppm -"
			.. " | satty --filename - --fullscreen"
			.. " --copy-command wl-copy"
			.. " --output-filename ~/misc/screenshots/satty-$(date '+%Y%m%d-%H%M%S').png"
	)
)
