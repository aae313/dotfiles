hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.monitor({
	output = "DP-1",
	mode = "2560x1440@59.951",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60.00",
	position = "2560x100",
	scale = 1,
	reserved_area = {
		top = 0,
		bottom = 0,
		left = 700,
		right = 0,
	},
})
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 4,
		border_size = 2,
		col = {
			active_border = {
				colors = { "0xff237fb8", "0xff7a5ccc" },
				angle = 45,
			},

			inactive_border = "0x66303030",
			nogroup_border_active = { colors = { "0xff237fb8", "0xff7a5ccc" }, angle = 45 },
			nogroup_border = "0x66303030",
		},
		resize_on_border = true,
		layout = "master",
		snap = {
			enabled = true,
			window_gap = 4,
			monitor_gap = 5,
			respect_gaps = true,
		},
	},

	master = {
		mfact = 0.5,
	},

	group = {
		groupbar = {
			font_family = "Inter",
			font_size = 13,
			rounding = 3,
			keep_upper_gap = false,
			blur = true,
			gradients = true,
			text_color = "rgb(000000)",
			text_color_inactive = "rgb(989898)",
			col = {
				active = "rgb(237fb8)",
				inactive = "rgb(303030)",
			},
		},
	},

	decoration = {
		active_opacity = 1.0,
		inactive_opacity = 0.90,
		dim_modal = true,
		dim_around = 0.2,
		dim_special = 0.2,
		dim_inactive = true,
		dim_strength = 0.04,

		shadow = {
			enabled = true,
			color = "rgba(00000055)",
			offset = { 0, 15 },
			range = 100,
			render_power = 2,
			scale = 0.97,
		},

		blur = {
			enabled = true,
			brightness = 1.0,
			contrast = 1.0,
			noise = 0.01,
			vibrancy = 0.2,
			vibrancy_darkness = 0.5,
			passes = 2,
			size = 6,
			popups = true,
			popups_ignorealpha = 0.2,
		},

		rounding = 8,
		rounding_power = 2,
	},

	input = {
		kb_layout = "de",
		kb_variant = "us",
		kb_options = "caps:escape",
		accel_profile = "flat",
		sensitivity = 0.75,
		focus_on_close = 1,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.5,
		},
		tablet = {
			output = "DP-1",
		},
	},

	gestures = {
		workspace_swipe_distance = 700,
		workspace_swipe_cancel_ratio = 0.2,
		workspace_swipe_min_speed_to_force = 5,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_create_new = true,
	},

	misc = {
		background_color = "rgb(000000)",
		focus_on_activate = true,
		initial_workspace_tracking = 0,
		animate_manual_resizes = false,
		enable_swallow = true,
		-- Anchored so "foot" cannot also match "footclient" popups.
		swallow_regex = "^(kitty|ghostty|foot)$",
		force_default_wallpaper = 0,
		on_focus_under_fullscreen = 1,
		allow_session_lock_restore = true,
		animate_mouse_windowdragging = false,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	debug = {
		disable_logs = true,
	},

	ecosystem = {
		no_update_news = true,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
