hl.window_rule({ match = { float = true }, decorate = false })
hl.window_rule({ match = { xwayland = true }, border_color = "rgb(ff5555)" })

hl.window_rule({ match = { title = "^(Open File)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to save)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to open)$" }, center = true, float = true })

hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },
	float = true,
	size = { "45%", "45%" },
	center = true,
})

hl.window_rule({
	match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
	float = true,
	keep_aspect_ratio = true,
	move = { "73%", "72%" },
	size = { "25%", "25%" },
	pin = true,
})

hl.window_rule({
	match = { title = "^(firefox-developer-edition — Sharing Indicator)$" },
	workspace = "special silent",
})
hl.window_rule({ match = { title = "^(.*is sharing (your screen|a window).)$" }, workspace = "special silent" })

hl.window_rule({ match = { title = "^(.*(Disc|WebC)ord.*)$" }, workspace = 6 })
hl.window_rule({ match = { class = "com.mitchellh.ghostty" }, workspace = 1 })
hl.window_rule({ match = { class = "neovide" }, workspace = 1 })
hl.window_rule({ match = { class = "^(obsidian)$" }, workspace = 2 })
hl.window_rule({ match = { class = "^(firefox.*)$" }, opacity = "1.0 override" })

hl.window_rule({ match = { class = "foot" }, float = true, size = { 1000, 1000 }, center = true })
hl.window_rule({ match = { class = "foot.yazi" }, float = true, size = { 1600, 1000 }, center = true })
hl.window_rule({ match = { class = "^(chrome-.*__-Default)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(claude)$" }, float = true, center = true })

hl.window_rule({ match = { class = ".*(confirm|pavucontrol|cpupower|xdg-desktop-portal-gtk).*" }, tag = "+dialog" })
hl.window_rule({ match = { title = ".*(Extension.*Bitwarden).*" }, tag = "+dialog" })
hl.window_rule({ match = { tag = "dialog" }, float = true, size = { "45%", "45%" }, center = true })

hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(polkit-kde-authentication-agent-1)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(firefox)$", title = "^(File Upload)$" }, dim_around = true })

hl.layer_rule({ match = { namespace = "launcher" }, blur = true })
hl.layer_rule({ match = { namespace = "launcher" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true })
hl.layer_rule({ match = { namespace = "notifications" }, ignore_alpha = 0.69 })

hl.layer_rule({ match = { namespace = "launcher" }, no_anim = true })
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })
hl.layer_rule({ match = { namespace = "overview" }, no_anim = true })
hl.layer_rule({ match = { namespace = "noanim" }, no_anim = true })

hl.workspace_rule({ workspace = "special:special", gaps_out = 20 })

-- hl.workspace_rule({ workspace = 5, layout = "scrolling" })

hl.workspace_rule({ workspace = 1, monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = 2, monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = 3, monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = 4, monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = 5, monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = 6, monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = 7, monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = 8, monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = 9, monitor = "HDMI-A-1", default = true })

-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
--
-- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
-- hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0, rounding = 0 })
