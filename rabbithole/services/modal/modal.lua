local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local Modal = {}
Modal.__index = Modal

function Modal.new(args)
    local self = {}
    setmetatable(self, Modal)

    args.width = args.width or 300
    args.height = args.height or 100

    self.widget = args.widget or wibox.widget.textbox()
    self.bg_color = args.bg_color or beautiful.bg_normal
    self.fg_color = args.fg_color or beautiful.fg_normal
    self.border_color = args.border_color or beautiful.danger
    self.border_width = args.border_width or beautiful.border_width

    -- If no position is specified, center the widget on the screen
    if not args.x and not args.y then
        local screen = awful.screen.focused()
        local geometry = screen.geometry
        args.x = (geometry.width - args.width) / 2
        args.y = (geometry.height - args.height) / 2
    end

    -- If fullscreen is specified, cover the entire screen
    if args.fullscreen then
        args.x = 0
        args.y = 0
        args.width = awful.screen.focused().geometry.width
        args.height = awful.screen.focused().geometry.height
    end

    self.popup_widget = awful.popup {
        widget = self.widget,
        bg = self.bg_color,
        fg = self.fg_color,
        border_width = self.border_width,
        border_color = self.border_color,
        placement = args.placement or awful.placement.centered,
        ontop = true,
        visible = false,
        x = args.x,
        y = args.y,
        width = args.width,
        height = args.height,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end
    }

    -- Update the popup_widget size when the child widget changes
    self.widget:connect_signal("widget::updated", function()
        local new_width = self.widget:get_preferred_size()
        self.popup_widget.width = new_width.width
        self.popup_widget.height = new_width.height
    end)

    return self
end

function Modal:show()
    if not self.popup_widget.visible then
        self.popup_widget.visible = true
    end
end

function Modal:hide()
    if self.popup_widget.visible then
        self.popup_widget.visible = false
    end
end

function Modal.prompt(args)
    local modal

    args.prompt = args.prompt or "Run: "

    local prompt_widget = awful.widget.prompt({
        prompt = args.prompt,
        textbox = wibox.widget.textbox(),
        exe_callback = function(text)
            if args.exe_callback then
                args.exe_callback(text)
            end
            Modal.hide(modal)
        end,
        done_callback = function()
            if args.done_callback then
                args.done_callback()
            end
            Modal.hide(modal)
        end
    })
    args.widget = wibox.widget {
        {
            prompt_widget,
            top = 10,
            bottom = 10,
            left = 10,
            right = 10,
            widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.vertical,
    }
    prompt_widget:run()
    modal = Modal.new(args)

    return modal
end

function Modal.confirm(args)
    local modal

    args.title = args.title or "Confirm"
    args.message = args.message or "Are you sure?"
    args.yes_text = args.yes_text or "Yes"
    args.no_text = args.no_text or "No"

    local yes_button = wibox.widget {
        {
            {
                {
                    text = args.yes_text,
                    align = "center",  -- Center align button text
                    widget = wibox.widget.textbox
                },
                forced_width = dpi(30),
                margins = dpi(4),
                widget = wibox.container.margin
            },
            bg = beautiful.bg_focus,
            fg = beautiful.fg_focus,
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal,
    }

    local no_button = wibox.widget {
        {
            {
                {
                    text = args.no_text,
                    align = "center",  -- Center align button text
                    widget = wibox.widget.textbox
                },
                forced_width = dpi(30),
                margins = dpi(4),
                widget = wibox.container.margin
            },
            bg = beautiful.bg_focus,
            fg = beautiful.fg_focus,
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal,
    }

    local widget = wibox.widget {
        {
            {
                markup = "<b>" .. args.title .. "</b>",
                align = "center",  -- Center align title
                font = "Ubuntu 16",
                fg = beautiful.secondary_color,
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.fixed.horizontal,
        },
        {
            markup = args.message,
            widget = wibox.widget.textbox
        },
        {
            yes_button,
            no_button,
            spacing = args.spacing or dpi(20),
            layout = wibox.layout.fixed.horizontal
        },
        bg = beautiful.bg_neutral,
        layout = wibox.layout.fixed.vertical
    }

    local yes_callback = args.yes_callback or function(...) end
    local no_callback = args.no_callback or function(...) end

    yes_button:connect_signal("button::press", function()
        Modal.hide(modal)
        yes_callback(modal)
    end)

    no_button:connect_signal("button::press", function()
        Modal.hide(modal)
        no_callback(modal)
    end)

    yes_button:connect_signal("mouse::enter", function()
        yes_button.bg = beautiful.bg_focus
    end)

    yes_button:connect_signal("mouse::leave", function()
        yes_button.bg = beautiful.tertiary_1
    end)

    no_button:connect_signal("mouse::enter", function()
        no_button.bg = beautiful.bg_focus
    end)

    no_button:connect_signal("mouse::leave", function()
        no_button.bg = beautiful.tertiary_1
    end)

    args.widget = widget
    modal = Modal.new(args)

    return modal
end



return Modal