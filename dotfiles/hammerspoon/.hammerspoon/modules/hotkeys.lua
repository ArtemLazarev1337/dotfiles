local vpn = require("modules.vpn")

local hotkeys = {}

function hotkeys.setup()
    local app_map = {
        ["t"] = "ITerm",
        ["b"] = "Zen",
        ["g"] = "Perplexity",
        ["c"] = "Zed",
        ["o"] = "Obsidian",
        ["f"] = "Finder",
        ["h"] = "NeoHtop",
        ["s"] = "Safari",
        ["i"] = "iPhone Mirroring",
        ["e"] = "Calendar",
        ["r"] = "Reminders"
    }

    for key, app_name in pairs(app_map) do
        hs.hotkey.bind({ "cmd", "ctrl" }, hs.keycodes.map[key], function()
            hs.application.launchOrFocus(app_name)
        end)
    end

    -- VPN
    hs.hotkey.bind({ "cmd", "ctrl" }, hs.keycodes.map["p"], function()
        vpn.toggle()
    end)

    -- Sleep
    hs.hotkey.bind({ "cmd", "ctrl" }, hs.keycodes.map["m"], function()
        hs.caffeinate.systemSleep()
    end)
end

return hotkeys
