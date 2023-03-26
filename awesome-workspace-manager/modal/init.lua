local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local Modal = {}
Modal.__index = Modal

function Modal:new(args)
    local self = {}
    setmetatable(self, Modal)

    args = args or {}

    self.width = args.width or 400
    self.height = args.height or 300
    self.widget = args.widget or wibox.widget.textbox()
    self.bg_color = args.bg_color or beautiful.bg_normal
    self.fg_color = args.fg_color or beautiful.fg_normal
    self.border_color = args.border_color or beautiful.border_normal
    self.border_width = args.border_width or beautiful.border_width

    -- If no position is specified, center the widget on the screen
    if not args.x and not args.y then
        local screen = awful.screen.focused()
        local geometry = screen.geometry
        args.x = (geometry.width - self.width) / 2
        args.y = (geometry.height - self.height) / 2
    end

    -- If fullscreen is specified, cover the entire screen
    if args.fullscreen then
        args.x = 0
        args.y = 0
        args.width = awful.screen.focused().geometry.width
        args.height = awful.screen.focused().geometry.height
    end

    self.popup_widget = wibox({
        x = args.x,
        y = args.y,
        width = args.width,
        height = args.height,
        ontop = true,
        visible = false,
        bg = self.bg_color,
        fg = self.fg_color,
        border_width = self.border_width,
        border_color = self.border_color,
        widget = self.widget
    })

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
    args = args or {}
    local modal

    args.widget = awful.widget.prompt({
            prompt = args.prompt or "Enter text: ",
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

    args.widget:run()

    modal = Modal(args)

    return modal
end



function Modal.confirm(args)
    args = args or {}

    local widget = wibox.widget {
        {
            markup = "<b>" .. args.title .. "</b>",
            font = "sans 12",
            widget = wibox.widget.textbox
        },
        {
            markup = args.message,
            font = "sans 10",
            widget = wibox.widget.textbox
        },
        {
            {
                text = args.yes_text or "Yes",
                font = "sans 10",
                widget = wibox.widget.textbox,
                id = "modal_yes_button"
            },
            {
                text = args.no_text or "No",
                font = "sans 10",
                widget = wibox.widget.textbox,
                id = "modal_no_button"
            },
            layout = wibox.layout.fixed.horizontal
        },
        spacing = args.spacing or 10,
        layout = wibox.layout.fixed.vertical
    }

    local yes_callback = args.yes_callback or function() end
    local no_callback = args.no_callback or function() end

    local yes_button = widget:get_children_by_id("modal_yes_button")[1]
    local no_button = widget:get_children_by_id("modal_no_button")[1]

    yes_button:connect_signal("button::press", function()
        Modal.hide(modal)
        yes_callback(modal)
    end)

    no_button:connect_signal("button::press", function()
        Modal.hide(modal)
        no_callback(modal)
    end)

    args.fullscreen = args.fullscreen or false
    local modal = Modal(args)
    modal.widget = widget

    return modal
end



return setmetatable(Modal, {
    __call = function(cls, ...)
        return cls:new(...)
    end
})