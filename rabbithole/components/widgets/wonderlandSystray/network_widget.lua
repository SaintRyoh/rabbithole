local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local networkWidget = {}


function networkWidget.new(args)
    local self = {}
    setmetatable(self, { __index = networkWidget })

    self.widget = self:createWidget(args)
    self:updateNetworkStatus()

    -- Update network status every 10 seconds
    self.timer = gears.timer.start_new(10, function()
        self:updateNetworkStatus()
        return true
    end)

    return self
end

function networkWidget:createWidget(args)
    local widget = wibox.widget.imagebox()
    widget.resize = false
    return widget
end

function networkWidget:updateNetworkStatus()
    local command = "nmcli -t -f type,state,connection,signal d"
    awful.spawn.easy_async_with_shell(command, function(stdout)
        local connection_type, connection_state, connection_name, signal_strength = string.match(stdout, "(%w+):(%w+):(.+):(%d+)\n")
        local icon_path = beautiful.network_icon_path or "themes/rabbithole/icons/network/"

        if connection_type == "wifi" then
            if connection_state == "connected" then
                local signal_percentage = tonumber(signal_strength)

                if signal_percentage >= 75 then
                    self.widget.image = icon_path .. "wifi-strength-4.svg"
                elseif signal_percentage >= 50 then
                    self.widget.image = icon_path .. "wifi-strength-3.svg"
                elseif signal_percentage >= 25 then
                    self.widget.image = icon_path .. "wifi-strength-2.svg"
                else
                    self.widget.image = icon_path .. "wifi-strength-1.svg"
                end
            else
                self.widget.image = icon_path .. "wifi-strength-off-outline.svg"
            end
        elseif connection_type == "ethernet" then
            if connection_state == "connected" then
                self.widget.image = icon_path .. "ethernet.svg"
            else
                self.widget.image = icon_path .. "no-internet.svg"
            end
        else
            self.widget.image = icon_path .. "wifi-strength-outline.svg"
        end
    end)
end

return networkWidget
