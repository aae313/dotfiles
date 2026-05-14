local mod = "SUPER"

local function focus_or_exec(class, cmd)
	local w = hl.get_active_window()
	if w and w.class == class then
		return
	end
	hl.dispatch(hl.dsp.focus({ window = "class:" .. class }))
	local after = hl.get_active_window()
	if not after or after.class ~= class then
		hl.dispatch(hl.dsp.exec_cmd(cmd))
	end
end

hl.bind(mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }))

hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mod .. " + M", hl.dsp.layout("focusmaster master"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.layout("swapwithmaster master"))

hl.bind(mod .. " + mouse:276", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

hl.bind(mod .. " + G", hl.dsp.group.toggle())
hl.bind(mod .. " + N", hl.dsp.group.next())
hl.bind(mod .. " + P", hl.dsp.group.prev())

hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pin())

hl.bind(mod .. " + O", hl.dsp.layout("orientationnext"))
hl.bind(mod .. " + SHIFT + O", hl.dsp.layout("orientationprev"))

hl.bind(mod .. " + bracketleft", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + bracketright", hl.dsp.focus({ direction = "r" }))

-- cycle workspaces
hl.bind(mod .. " + SHIFT + bracketleft", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + SHIFT + bracketright", hl.dsp.focus({ workspace = "m+1" }))

-- send focused workspace to left/right monitors
hl.bind(mod .. " + SHIFT + ALT + bracketleft", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mod .. " + SHIFT + ALT + bracketright", hl.dsp.workspace.move({ monitor = "r" }))

hl.bind(mod .. " + Z", hl.dsp.window.center())

hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("pypr toggle_special special"))
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("special"))

hl.bind(mod .. " + A", hl.dsp.exec_cmd("pypr toggle claude"))
hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd("pypr toggle chatgpt"))

hl.bind(mod .. " + Return", function()
	focus_or_exec("com.mitchellh.ghostty", "app2unit-term")
end)

hl.bind(mod .. " + SHIFT + Return", function()
	focus_or_exec("neovide", "neovide")
end)
hl.bind(mod .. " + CTRL + Return", hl.dsp.exec_cmd("app2unit footclient"))
hl.bind(mod .. " + Y", hl.dsp.exec_cmd("footclient -a foot.yazi ynv"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + C", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
hl.bind(
	mod .. " + Print",
	hl.dsp.exec_cmd(
		"grim -g \"$(slurp -c '##2BD2FF')\" -t ppm - | satty --filename - --fullscreen --output-filename ~/misc/screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png"
	)
)
hl.bind(
	mod .. " + SHIFT + Print",
	hl.dsp.exec_cmd(
		"grim -g \"$(slurp -o -r -c '##2BD2FF')\" -t ppm - | satty --filename - --fullscreen --output-filename ~/Pictures/satty-$(date '+%Y%m%d-%H:%M:%S').png"
	)
)
hl.bind(mod .. " + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("~/architect/scripts/launch-webapp"))
hl.bind(mod .. " + Backspace", function()
	focus_or_exec("firefox-developer-edition", "firefox-developer-edition")
end)

hl.bind(mod .. " + B", hl.dsp.exec_cmd("~/architect/scripts/openbook"))

local wsKeys = { "Grave", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
for i, k in ipairs(wsKeys) do
	hl.bind(mod .. " + " .. k, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. k, hl.dsp.window.move({ workspace = i, silent = true }))
end

hl.bind(mod .. " + equal", hl.dsp.layout("mfact +0.05"))
hl.bind(mod .. " + minus", hl.dsp.layout("mfact -0.05"))
hl.bind(mod .. " + SHIFT + 0", hl.dsp.layout("mfact exact 0.55"))

hl.bind(mod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 50, y = 50, relative = true }))
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.resize({ x = -50, y = -50, relative = true }))

hl.bind(mod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

hl.bind(mod .. " + ALT + left", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT + right", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT + up", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT + down", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })

hl.bind(mod .. " + slash", hl.dsp.exec_cmd("~/.config/hypr/scripts/select-window.py"))

hl.bind(mod .. " + f", hl.dsp.exec_cmd("pypr fetch_client_menu"))
hl.bind(mod .. " + SHIFT + f", hl.dsp.exec_cmd("pypr unfetch_client"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

local function layout_specific_cycle(direction)
	local ws = hl.get_active_workspace()
	if ws == nil then
		return
	end

	local win = hl.get_active_window()

	if ws.tiled_layout == "master" and win ~= nil and win.floating then
		hl.dispatch(hl.dsp.layout("focusmaster master"))
	elseif ws.tiled_layout == "scrolling" then
		hl.dispatch(hl.dsp.layout(direction == "next" and "focus r" or "focus l"))
	else
		hl.dispatch(hl.dsp.layout(direction == "next" and "cyclenext" or "cycleprev"))
	end
end

hl.bind(mod .. " + Tab", function()
	layout_specific_cycle("next")
end)

hl.bind(mod .. " + SHIFT + Tab", function()
	layout_specific_cycle("prev")
end)

hl.bind(mod .. " + W", hl.dsp.window.cycle_next({ floating = true }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("ALT + mouse:276", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("ALT + mouse:275", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume -n mute toggle"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume -n volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume -n volume down"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

hl.bind(mod .. " + CTRL + equal", hl.dsp.exec_cmd("~/.config/hypr/scripts/mfact.fish"))

local function toggle_master_monocle()
	local ws = hl.get_active_workspace()
	if ws == nil then
		return
	end

	hl.workspace_rule({
		workspace = ws.id,
		layout = (ws.tiled_layout == "master" and "monocle" or "master"),
	})
end

hl.bind(mod .. " + Space", toggle_master_monocle)
