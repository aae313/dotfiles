hl.on("hyprland.start", function()
	hl.exec_cmd("app2unit pypr")
	hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)
