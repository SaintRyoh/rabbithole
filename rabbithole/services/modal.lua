local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local buttons = require("sub.awesome-buttons.awesome-buttons")

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
    self.active_modal = self.modal_factory({
        widget = wibox.widget {
            prompt,
            layout = wibox.layout.align.vertical,
        } 
    })
      
    prompt:run()
end

function Modal:confirm(args)
    args = args or {}
    self.active_modal = self.modal_factory({
        widget = wibox.widget {
            {
                {
                    markup = "<b>Confirm</b>",
                    align = "center",  -- Center align title
                    font = "Ubuntu 16",
                    fg = beautiful.secondary_color,
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.fixed.horizontal,
            },
            {
                align = "center",  
                font = "Ubuntu 8",
                markup = "Are you sure?",
                widget = wibox.widget.textbox
            },
            {
                buttons.with_text({
                    text = "Yes",
                    color = beautiful.secondary_color,
                    onclick = function()
                        if args.yes_callback then
                            args.yes_callback()
                        end
                        self.active_modal.visible = false
                    end
                }),
                buttons.with_text({
                    text = "No",
                    color = beautiful.secondary_color,
                    onclick = function()
                        if args.no_callback then
                            args.no_callback()
                        end
                        self.active_modal.visible = false
                    end
                }),
                spacing = dpi(20),
                layout = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.container.place,
        valign = "center",
    })
end

return Modal