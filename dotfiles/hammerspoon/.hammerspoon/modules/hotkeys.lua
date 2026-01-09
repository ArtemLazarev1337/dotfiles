local vpn = require("modules.vpn")

local hotkeys = {}

function hotkeys.setup()
    -- ITerm
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["t"], function()
        hs.application.launchOrFocus("ITerm")
    end)

    -- Zen
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["b"], function()
        hs.application.launchOrFocus("Zen")
    end)

    -- Perplexity
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["g"], function()
        hs.application.launchOrFocus("Perplexity")
    end)

    -- Visual Studio Code
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["c"], function()
        hs.application.launchOrFocus("Visual Studio Code")
    end)

    -- Obsidian
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["o"], function()
        hs.application.launchOrFocus("Obsidian")
    end)
    
    -- Finder
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["f"], function()
        hs.application.launchOrFocus("Finder")
    end)

    -- NeoHtop
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["h"], function()
        hs.application.launchOrFocus("NeoHtop")
    end)
    
    -- Safari
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["s"], function()
      hs.application.launchOrFocus("Safari")
    end)

    -- iPhone Mirroring
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["i"], function()
        hs.application.launchOrFocus("iPhone Mirroring")
    end)
    
    -- Calendar
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["e"], function()
        hs.application.launchOrFocus("Calendar")
    end)
    
    -- Reminders
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["r"], function()
        hs.application.launchOrFocus("Reminders")
    end)

    -- VPN
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["p"], function()
        vpn.toggle()
    end)

    -- Sleep
    hs.hotkey.bind({"cmd", "ctrl"}, hs.keycodes.map["m"], function()
        hs.caffeinate.systemSleep()
    end)
end

return hotkeys

