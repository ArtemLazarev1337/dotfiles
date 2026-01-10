local vpn = {}

local defaultService = "Shadowrocket"

function vpn.isRunning(serviceName)
    serviceName = serviceName or defaultService
    local output = hs.execute("scutil --nc status '" .. serviceName .. "'")
    local firstLine = output:match("^[^\n]+")
    return firstLine == "Connected"
end

function vpn.enable(serviceName)
    serviceName = serviceName or defaultService
    hs.execute("scutil --nc start '" .. serviceName .. "'", true)
end

function vpn.disable(serviceName)
    serviceName = serviceName or defaultService
    hs.execute("scutil --nc stop '" .. serviceName .. "'", true)
end

function vpn.toggle(serviceName)
    serviceName = serviceName or defaultService
    if vpn.isRunning(serviceName) then
        vpn.disable(serviceName)
        hs.notify.new({
            title = serviceName,
            informativeText = "Сервис остановлен!",
            contentImage = "~/.hammerspoon/icons/cancel.png"
        }):send()
    else
        vpn.enable(serviceName)
        hs.notify.new({
            title = serviceName,
            informativeText = "Сервис запущен!",
            contentImage = "~/.hammerspoon/icons/done.png"
        }):send()
    end
end

return vpn
