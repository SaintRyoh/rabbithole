-- A generic button widget that can be customized by passing arguments in the form of a table

-- Awesome libs
local wibox = require("wibox")
local gears = require("gears")

-- Define the button widget function
local function create_button_widget(args)
    local args = args or {}
    local bg_normal = args.bg_normal or "#333333"
    local bg_hover = args.bg_hover or "#444444"
    local bg_press = args.bg_press or "#555555"
    local fg_normal = args.fg_normal or "#ffffff"
    local fg_hover = args.fg_hover or "#ffffff"
    local fg_press = args.fg_press or "#ffffff"
    local font = args.font or "sans 10"
    local shape = args.shape or function(cr, width, height) gears.shape.rectangle(cr, width, height) end
    local shadow = args.shadow or false
    local text = args.text or ""
    local onclick = args.onclick or function() end

    local button = wibox.widget {
        {
            {
                {
                    text = text,
                    font = font,
                    align = "center",
                    valign = "center",
                    widget = wibox.widget.textbox
                },
                margins = 5,
                widget = wibox.container.margin
            },
            bg = bg_normal,
            shape = shape,
            widget = wibox.container.background
        },
        forced_width = 100,
        forced_height = 30,
        widget = wibox.container.constraint
    }

    -- Change button background color and text color on hover and press
    button:connect_signal("mouse::enter", function()
        button:get_children_by_id("bg")[1].bg = bg_hover
        button:get_children_by_id("text")[1].markup = "<b>" .. text .. "</b>"
        button:get_children_by_id("text")[1].fg = fg_hover
    end)
    button:connect_signal("mouse::leave", function()
        button:get_children_by_id("bg")[1].bg = bg_normal
        button:get_children_by_id("text")[1].markup = text
        button:get_children_by_id("text")[1].fg = fg_normal
    end)
    button:connect_signal("button::press", function()
        button:get_children_by_id("bg")[1].bg = bg_press
        button:get_children_by_id("text")[1].fg = fg_press
    end)
    button:connect_signal("button::release", function()
        button:get_children_by_id("bg")[1].bg = bg_hover
        button:get_children_by_id("text")[1].fg = fg_hover
        onclick()
    end)

    -- Add a shadow to the button if specified
    if shadow then
        button = wibox.widget {
            {
                button,
                widget = wibox.container.background
            },
            shape = shape,
            widget = wibox.container.background
        }
        button = wibox.widget {
            {
                {
                    button,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin
            },
            widget = wibox.container.background
        }
        button = wibox.widget {
            {
                {
                    button,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin
            },
            widget = wibox.container.background
        }
        button = wibox.widget {
            {
                {
                    button,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin
            }
        button = wibox.widget {
            {
                {
                    button,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin
            },
            widget = wibox.container.background
        }
        button = wibox.widget {
            {
                {
                    button,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin
            },
            widget = wibox.container.background
        }
        button = wibox.widget {
            {
                {
                    button,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin
            },
            shape = shape,
            widget = wibox.container.background
        }
    end
    
    return button
end 
