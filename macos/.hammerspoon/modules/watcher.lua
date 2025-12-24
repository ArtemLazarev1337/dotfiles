local vpn = require("modules.vpn")

local watcher = {}

local appsToEnableVPN = {
    "ChatGPT",
}

function watcher.applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.launched then
        for _, app in ipairs(appsToEnableVPN) do
            if appName == app then
                vpn.enable()
                break
            end
        end
    end
end

function watcher.start()
    local appWatcher = hs.application.watcher.new(watcher.applicationWatcher)
    appWatcher:start()
end

return watcher
