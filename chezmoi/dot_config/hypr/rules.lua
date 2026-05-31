hl.window_rule({ match = { float = true }, decorate = false })
hl.window_rule({ match = { xwayland = true }, border_color = "rgb(ff5555)" })

local dialog_titles = {
	"^(Open File)(.*)$",
	"^(Select a File)(.*)$",
	"^(Open Folder)(.*)$",
	"^(Save As)(.*)$",
	"^(Library)(.*)$",
	"^(File Upload)(.*)$",
	"^(.*)(wants to save)$",
	"^(.*)(wants to open)$",
}
for _, title in ipairs(dialog_titles) do
	hl.window_rule({ match = { title = title }, center = true, float = true })
end

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
hl.window_rule({ match = { class = "foot" }, workspace = 1 })
hl.window_rule({ match = { class = "neovide" }, workspace = 1 })
hl.window_rule({ match = { class = "^(obsidian)$" }, workspace = 2 })
hl.window_rule({ match = { class = "^(firefox.*)$" }, opacity = "1.0 override" })

hl.window_rule({ match = { class = "footclient" }, float = true, size = { 1000, 1000 }, center = true })
hl.window_rule({ match = { class = "^(chrome-.*__-Default)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(claude)$" }, float = true, center = true })

hl.window_rule({ match = { class = ".*(confirm|pavucontrol|cpupower|xdg-desktop-portal-gtk).*" }, tag = "+dialog" })
hl.window_rule({ match = { title = ".*(Extension.*Bitwarden).*" }, tag = "+dialog" })
hl.window_rule({ match = { tag = "dialog" }, float = true, size = { "45%", "45%" }, center = true })

hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(polkit-kde-authentication-agent-1)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(firefox)$", title = "^(File Upload)$" }, dim_around = true })

hl.layer_rule({ match = { namespace = "launcher" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0.69 })

for _, ns in ipairs({ "launcher", "selection", "overview", "noanim" }) do
	hl.layer_rule({ match = { namespace = ns }, no_anim = true })
end

hl.workspace_rule({ workspace = "special:special", gaps_out = 20 })

for i = 1, 5 do
	hl.workspace_rule({ workspace = i, monitor = "DP-1", default = true })
end
for i = 6, 9 do
	hl.workspace_rule({ workspace = i, monitor = "HDMI-A-1", default = true })
end
