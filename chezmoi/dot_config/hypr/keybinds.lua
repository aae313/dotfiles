local mod = "SUPER"

local function focus_or_exec(class, cmd)
	local win = hl.get_window("class:" .. class)

	if win then
		hl.dispatch(hl.dsp.focus({ window = win }))
		return
	end

	hl.exec_cmd(cmd)
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

local function group_or_master_monocle_cycle(direction)
	local win = hl.get_active_window()

	if win and win.group then
		local dispatch = direction == "next" and hl.dsp.group.next() or hl.dsp.group.prev()
		hl.dispatch(dispatch)
		return
	end

	local workspace = hl.get_active_workspace()

	if not workspace then
		return
	end

	if workspace.tiled_layout == "master" or workspace.tiled_layout == "monocle" then
		local command = direction == "next" and "cyclenext" or "cycleprev"
		hl.dispatch(hl.dsp.layout(command))
	end
end

local function layout_specific_cycle(direction)
	local workspace = hl.get_active_workspace()

	if not workspace then
		return
	end

	local win = hl.get_active_window()

	if workspace.tiled_layout == "master" and win and win.floating then
		hl.dispatch(hl.dsp.layout("focusmaster master"))
		return
	end

	if workspace.tiled_layout == "scrolling" then
		local command = direction == "next" and "focus r" or "focus l"
		hl.dispatch(hl.dsp.layout(command))
		return
	end

	local command = direction == "next" and "cyclenext" or "cycleprev"
	hl.dispatch(hl.dsp.layout(command))
end

local function toggle_master_monocle()
	local workspace = hl.get_active_workspace()

	if not workspace then
		return
	end

	if workspace.tiled_layout ~= "master" and workspace.tiled_layout ~= "monocle" then
		return
	end

	hl.workspace_rule({
		workspace = tostring(workspace.id),
		layout = workspace.tiled_layout == "master" and "monocle" or "master",
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

hl.bind(mod .. " + CTRL + left", hl.dsp.window.resize({
	x = -20,
	y = 0,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + CTRL + down", hl.dsp.window.resize({
	x = 0,
	y = 20,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + CTRL + up", hl.dsp.window.resize({
	x = 0,
	y = -20,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({
	x = 20,
	y = 0,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + ALT + left", hl.dsp.window.move({
	x = -20,
	y = 0,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + ALT + down", hl.dsp.window.move({
	x = 0,
	y = 20,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + ALT + up", hl.dsp.window.move({
	x = 0,
	y = -20,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + ALT + right", hl.dsp.window.move({
	x = 20,
	y = 0,
	relative = true,
}), { repeating = true })

hl.bind(mod .. " + bracketleft", function()
	layout_specific_cycle("prev")
end)

hl.bind(mod .. " + bracketright", function()
	layout_specific_cycle("next")
end)

hl.bind(mod .. " + Tab", function()
	group_or_master_monocle_cycle("next")
end)

hl.bind(mod .. " + SHIFT + Tab", function()
	group_or_master_monocle_cycle("prev")
end)

hl.bind(mod .. " + M", hl.dsp.layout("focusmaster master"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.layout("swapwithmaster master"))

hl.bind(mod .. " + O", hl.dsp.layout("orientationnext"))
hl.bind(mod .. " + SHIFT + O", hl.dsp.layout("orientationprev"))

hl.bind(mod .. " + Space", toggle_master_monocle)
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + equal", hl.dsp.layout("mfact +0.05"))
hl.bind(mod .. " + minus", hl.dsp.layout("mfact -0.05"))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.layout("mfact exact 0.55"))

hl.bind(mod .. " + SHIFT + equal", hl.dsp.window.resize({
	x = 50,
	y = 50,
	relative = true,
}))

hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.resize({
	x = -50,
	y = -50,
	relative = true,
}))

hl.bind(mod .. " + S", toggle_window_group)
hl.bind(mod .. " + N", hl.dsp.group.next())
hl.bind(mod .. " + P", hl.dsp.group.prev())
hl.bind(mod .. " + SHIFT + g", move_into_any_group)

hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pin())
hl.bind(mod .. " + W", hl.dsp.window.cycle_next({ floating = true }))
hl.bind(mod .. " + Z", hl.dsp.window.center())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())

hl.bind(mod .. " + SHIFT + bracketleft", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + SHIFT + bracketright", hl.dsp.focus({ workspace = "m+1" }))

hl.bind(
	mod .. " + SHIFT + ALT + bracketleft",
	hl.dsp.workspace.move({ monitor = "l" })
)

hl.bind(
	mod .. " + SHIFT + ALT + bracketright",
	hl.dsp.workspace.move({ monitor = "r" })
)

for workspace = 1, 9 do
	hl.bind(mod .. " + " .. workspace, hl.dsp.focus({
		workspace = workspace,
	}))

	hl.bind(mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({
		workspace = workspace,
		silent = true,
	}))
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
	focus_or_exec("foot", "env START_ZELLIJ=1 app2unit-term")
end)

hl.bind(mod .. " + CTRL + Return", hl.dsp.exec_cmd("footclient"))
hl.bind(mod .. " + Y", hl.dsp.exec_cmd("footclient -a foot.yazi ynv"))

hl.bind(mod .. " + Backspace", function()
	focus_or_exec("helium", "helium")
end)

hl.bind(mod .. " + A", hl.dsp.exec_cmd("pypr toggle chatgpt"))
hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd("pypr toggle claude"))

hl.bind(mod .. " + B", hl.dsp.exec_cmd("open-bookmark"))
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("open-book"))

hl.bind(
	mod .. " + C",
	hl.dsp.exec_cmd(
		"cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
	)
)

hl.bind(mod .. " + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + f", hl.dsp.exec_cmd("pypr fetch_client_menu"))
hl.bind(mod .. " + SHIFT + f", hl.dsp.exec_cmd("pypr unfetch_client"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(
	mod .. " + Print",
	hl.dsp.exec_cmd(
		"grim -g \"$(slurp -c '##89dceb')\" -t ppm -"
			.. " | satty --filename - --fullscreen"
			.. " --output-filename ~/misc/screenshots/"
			.. "satty-$(date '+%Y%m%d-%H:%M:%S').png"
	)
)

hl.bind(
	mod .. " + SHIFT + Print",
	hl.dsp.exec_cmd(
		"grim -g \"$(slurp -o -r -c '##89dceb')\" -t ppm -"
			.. " | satty --filename - --fullscreen"
			.. " --output-filename ~/Pictures/"
			.. "satty-$(date '+%Y%m%d-%H:%M:%S').png"
	)
)
