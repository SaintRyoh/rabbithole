local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local awful = require("awful")


local batteryWidget = {}


function batteryWidget.new(args)
    local self = {}
    setmetatable(self, { __index = batteryWidget })

    self.widget = self:createWidget(args)

    self.widget:connect_signal("mouse::enter", function()
        self:showBatteryNotification()
    end)

    self.widget:connect_signal("mouse::leave", function()
        self:hideBatteryNotification()
    end)

    return self
end

function batteryWidget:createWidget(args)
    local widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            id = "icon",
            widget = wibox.widget.imagebox,
            resize = true
        },
        {
            id = "text",
            widget = wibox.widget.textbox
        }
    }

    -- these will be custom settings in the settings manager
    widget.icon.image = beautiful.battery_icon or "/path/to/default/battery_icon.svg"
    widget.text.font = beautiful.battery_font or "sans 12"
    widget.text.align = "center"
    widget.text.valign = "center"

    -- update battery information every 120 seconds
    gears.timer.start_new(120, function()
        self:updateBatteryInfo()
        return true
    end)

    return widget
end

function batteryWidget:updateBatteryInfo()
    local battery_command = "acpi -i"
    awful.spawn.easy_async(battery_command, function(stdout)
        local battery_info = self:parseBatteryInfo(stdout)
        self.widget.icon.image = battery_info.icon
        self.widget.text.text = battery_info.text
    end)
end

function batteryWidget:parseBatteryInfo(output)
    local battery_info = {
        icon = beautiful.battery_icon,
        text = "N/A"
    }

    -- parse battery status
    local status = output:match("Battery %d+: (%a+),")
    if status then
        if status == "Charging" then
            battery_info.icon = beautiful.battery_charging_icon or "/path/to/default/battery_charging_icon.svg"
        elseif status == "Discharging" then
            battery_info.icon = beautiful.battery_discharging_icon or "/path/to/default/battery_discharging_icon.svg"
        else
            battery_info.icon = beautiful.battery_icon or "/path/to/default/battery_icon.svg"
        end
    end

    -- parse battery percentage
    local percentage = output:match(" (%d?%d?%d)%%")
    if percentage then
        battery_info.text = percentage .. "%"
    end

    -- parse time remaining
    local hours, minutes = output:match("(%d?%d):(%d%d) remaining")
    if hours and minutes then
        battery_info.text = battery_info.text .. " (" .. hours .. "h" .. minutes .. "m)"
    end

    return battery_info
end

function batteryWidget:showBatteryNotification()
    if not self.batteryNotification then
        self.batteryNotification = naughty.connect_signal("request::display", function(n)
            naughty.layout.box {
                notification = n,
                type = "notification",
                widget_template = {
                    {
                        {
                            id = "battery_details",
                            widget = wibox.widget.textbox
                        },
                        widget = wibox.container.margin,
                        margins = 8
                    },
                    widget = wibox.container.background,
                    bg = beautiful.notification_bg,
                    shape = gears.shape.rounded_rect
                }
            }
        end)
    end

    self:updateBatteryInfo()
    naughty.notify {
        title = "Battery Status",
        text = self.widget.text.text,
        icon = self.widget.icon.image,
        preset = naughty.config.presets.normal,
        timeout = 5
    }
end

function batteryWidget:hideBatteryNotification()
    if self.batteryNotification then
        naughty.destroy_all_notifications()
    end
end

return batteryWidget
