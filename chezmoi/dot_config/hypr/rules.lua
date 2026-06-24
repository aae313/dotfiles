hl.window_rule({ match = { float = true }, decorate = false })
hl.window_rule({ match = { xwayland = true }, border_color = "rgb(f38ba8)" })

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

hl.window_rule({ match = { title = "^(Media viewer)$" }, float = true })
hl.window_rule({ match = { class = "chrome-nngceckbapebfimnlniiiahkandclblb-Profile_1" }, float = true })

hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
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
	match = { title = "^(firefox — Sharing Indicator)$" },
	workspace = "special silent",
})
hl.window_rule({ match = { title = "^(.*is sharing (your screen|a window).)$" }, workspace = "special silent" })

hl.window_rule({ match = { title = "^(.*(Disc|WebC)ord.*)$" }, workspace = 6 })
hl.window_rule({ match = { class = "^(kitty)$" }, workspace = 1 })
hl.window_rule({
	match = {
		class = "foot",
	},
	workspace = 1,
})
hl.window_rule({ match = { class = "^(neovide)$" }, workspace = 2, no_anim = true })
hl.window_rule({ match = { class = "^(obsidian)$" }, workspace = 3 })
hl.window_rule({ match = { class = "^(firefox-nightly)$" } })

hl.window_rule({
	match = { class = "footclient" },
	float = true,
	size = { "(monitor_w*0.65)", "(monitor_h*0.75)" },
	center = true,
})

hl.window_rule({
	match = { class = "^(org\\.mozilla\\.firefox\\.webapp-.*)$" },
	float = true,
	size = { "40%", "60%" },
	center = true,
})

hl.window_rule({ match = { class = ".*(confirm|pwvucontrol|xdg-desktop-portal-gtk).*" }, tag = "+dialog" })
hl.window_rule({ match = { tag = "dialog" }, float = true, size = { "45%", "45%" }, center = true })

hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(polkit-kde-authentication-agent-1)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(firefox)$", title = "^(File Upload)$" }, dim_around = true })

hl.layer_rule({ match = { namespace = "launcher" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0.69 })
hl.layer_rule({ match = { namespace = "snappy-switcher" }, blur = true, ignore_alpha = 0.01 })

for _, ns in ipairs({ "launcher", "selection", "overview", "noanim" }) do
	hl.layer_rule({ match = { namespace = ns }, no_anim = true })
end

for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1", default = true })
end
for i = 6, 9 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", default = true })
end

hl.workspace_rule({ workspace = "1", layout = "master" })
hl.workspace_rule({ workspace = "2", layout = "master" })
hl.workspace_rule({ workspace = "3", layout = "scrolling" })
