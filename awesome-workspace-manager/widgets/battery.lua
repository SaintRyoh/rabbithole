local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local awful = require("awful")

local batteryWidget = {}

local icon_dir = "rabbithole/themes/rabbithole/icons/battery/"


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

    -- Update battery information
    gears.timer.start_new(30, function()
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
        icon = icon_dir .. "battery.svg",
        text = "N/A"
    }

    -- Parse battery status
    local status = output:match("Battery %d+: (%a+),")
    if status then
        if status == "Charging" then
            battery_info.icon = icon_dir .. "battery-charging.svg"
        elseif status == "Discharging" then
            battery_info.icon = icon_dir .. "battery-discharging.svg"
        else
            battery_info.icon = icon_dir .. "battery.svg"
        end
    end

    -- Parse battery percentage
    local percentage = output:match(" (%d?%d?%d)%%")
    if percentage then
        local icon_suffix
        if percentage >= 90 then
            icon_suffix = "90"
        elseif percentage >= 80 then
            icon_suffix = "80"
        elseif percentage >= 70 then
            icon_suffix = "70"
        elseif percentage >= 60 then
            icon_suffix = "60"
        elseif percentage >= 50 then
            icon_suffix = "50"
        elseif percentage >= 40 then
            icon_suffix = "40"
        elseif percentage >= 30 then
            icon_suffix = "30"
        elseif percentage >= 20 then
            icon_suffix = "20"
        else
            icon_suffix = "10"
        end

        if status == "Charging" then
            battery_info.icon = icon_dir .. "battery-charging-" .. icon_suffix .. ".svg"
        else
            battery_info.icon = icon_dir .. "battery-discharging-" .. icon_suffix .. ".svg"
        end

        battery_info.text = percentage .. "%"
    end

    -- Parse battery time remaining
    local hours, minutes = output:match("(%d?%d):(%d%d) remaining")
    if hours and minutes then
        battery_info.text = battery_info.text .. " (" .. hours .. "h"
        battery_info.text = battery_info.text .. " (" .. hours .. "h" .. minutes .. "m)"
    end

    return battery_info
end

function batteryWidget:showBatteryNotification()
    if self.notification then
        naughty.destroy(self.notification)
    end
    self.notification = naughty.notify({
        text = "Battery Status: " .. self.widget.text.text,
        timeout = 0,
        position = "bottom_right",
        screen = mouse.screen
    })
end

function batteryWidget:hideBatteryNotification()
    if self.notification then
        naughty.destroy(self.notification)
        self.notification = nil
    end
end

return batteryWidget
