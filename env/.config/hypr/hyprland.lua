-- Hyprland Configuration file.

-- Monitor configuration.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- Environment variables.
hl.env("XCURSOR_THEME", "DMZ-White")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "DMZ-White")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("MOZ_DBUS_REMOTE", "1")
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("HYPRSHOT_DIR", "/home/nahuel/Pictures/screenshots")

-- Default programs i use.
local terminal = "kitty"
local menu = "rofi -show drun -show-icons"
local browser = "zen-browser"
local fileManager = terminal .. " -o window_padding_width='0 0 0 0' -e yazi"

-- Autoexec programs.
hl.on("hyprland.start", function()
	hl.exec_cmd(
		"bash -c 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE; systemctl --user start hyprland-session.target'"
	)
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hyprshade on ~/.config/hypr/shaders/digital-vibrance.glsl")
	hl.exec_cmd(terminal, { workspace = "1 silent" })
	hl.exec_cmd(browser, { workspace = "2 silent" })
	hl.exec_cmd("obsidian", { workspace = "special:notes silent" })
end)

-- Workspace rules.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })

-- Binds.
local mainMod = "SUPER"

-- REMOVE:
hl.bind("mouse:276", hl.dsp.focus({ workspace = "-1" }))
hl.bind("mouse:275", hl.dsp.focus({ workspace = "+1" }))

-- WaybarToggle this binds shows/hides the gaps/borders from windows depending on waybar status.
local waybar_visible = false
hl.bind(mainMod .. " + GRAVE", function()
	hl.dispatch(hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-waybar.sh"))
	waybar_visible = not waybar_visible
	if waybar_visible then
		-- waybar abierta: gaps/border/rounding normales
		hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 12, gaps_in = 6 })
		hl.workspace_rule({ workspace = "f[1]", gaps_out = 12, gaps_in = 6 })
		hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
		hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 10 })
		hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
		hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 10 })
	else
		-- waybar oculta: sin gaps/border/rounding
		hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
		hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
		hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
		hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
		hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
		hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
	end
end)

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("notes"))

hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-picker.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("DEV_ENV=/home/nahuel/personal/dev /home/nahuel/personal/dev/dev-env"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + W", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + PAUSE", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + SCROLL_LOCK", hl.dsp.exec_cmd("hyprshot -m output"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Requires playerctl.
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Looks and feel.
hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,
		border_size = 1,
		col = {
			active_border = "rgba(2a2a2aff)",
			inactive_border = "rgba(59595900)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		active_opacity = 1.0,
		inactive_opacity = 0.95,

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = false, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = false, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Misc.
hl.config({
	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	scrolling = {
		fullscreen_on_one_column = true,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		accel_profile = "flat",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})
