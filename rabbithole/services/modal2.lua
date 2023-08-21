local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local Modal = {}
Modal.__index = Modal


function Modal.new(
    rabbithole__components__wiboxes__modal
)

    local self = setmetatable({ }, Modal)

    self.modal_factory = rabbithole__components__wiboxes__modal
    self.active_modal = nil

    return self

end

function Modal.connect_widget_update_signal(modal, widget)
    widget:connect_signal("widget::updated", function()
        local new_width = widget:get_preferred_size()
        modal.popup_widget.width = new_width.width
        modal.popup_widget.height = new_width.height
    end)
    return modal
end

function Modal:empty(args)
    return Modal.connect_widget_update_signal(
        self.modal_factory({ widget = args.widget }),
        args.widget
    )
end

function Modal:prompt(args)
    --maybe make an auto- :run() prompt? so i don't have to worry about 
    -- calling it myself
    local prompt = awful.widget.prompt(gears.table.crush({
        id = "prompt_textbox",
        textbox = wibox.widget.textbox(),
        done_callback = function()
            if args.done_callback then
                args.done_callback()
            end
            self.active_modal.visible = false
        end
    }, args or {}))

    -- keeping in mind the minimum dimensions, we need to center this widget
    self.active_modal = self:empty({
        widget = wibox.widget {
            {
                prompt,
                top = 10,
                bottom = 10,
                left = 10,
                right = 10,
                widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.vertical,
        } 
    })
      
    prompt:run()
end

function Modal:confirm(args)
    local modal = self.modal_factory.new(args)
    modal.popup_widget.visible = true
    return modal
end

return Modal