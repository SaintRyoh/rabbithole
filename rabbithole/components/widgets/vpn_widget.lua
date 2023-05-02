local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local vpnWidget = {}


function vpnWidget.new(args)
    local self = {}
    setmetatable(self, { __index = vpnWidget })

    self.widget = self:createWidget(args)
    self:updateVpnStatus()

    -- Update VPN status every 10 seconds
    self.timer = gears.timer.start_new(10, function()
        self:updateVpnStatus()
        return true
    end)

    return self
end

function vpnWidget:createWidget(args)
    local widget = wibox.widget.imagebox()
    widget.resize = false
    return widget
end

function vpnWidget:updateVpnStatus()
    local command = "nmcli -t -f type,state,connection d"
    awful.spawn.easy_async_with_shell(command, function(stdout)
        local vpn_active = false
        for line in stdout:gmatch("[^\r\n]+") do
            local connection_type, connection_state, connection_name = string.match(line, "(%w+):(%w+):(.+)")
            if connection_type == "vpn" and connection_state == "connected" then
                vpn_active = true
                break
            end
        end

        local icon_path = beautiful.vpn_icon_path or "themes/rabbithole/icons/vpn/"

        if vpn_active then
            self.widget.image = icon_path .. "vpn-active.svg"
        else
            self.widget.image = icon_path .. "vpn-inactive.svg"
        end
    end)
end

return vpnWidget
