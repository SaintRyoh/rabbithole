-- Elements- Base user interface widget objects

local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local class = require("src.modules.class")

--[[ Usage:

Widgets:

local myCheckbox = Checkbox(false, {color = "#ffffff"}, function(checked)
    print("Checkbox state:", checked)
end)

local myTextInput = TextInput("Type here...", {font = "Roboto 14", color = "#ffffff", border_color = "#3f51b5"})

local myProgressBar = ProgressBar(50, {width = 200, height = 20, color = "#3f51b5", bg = "#ffffff", border_color = "#000000"})

]]

local Widget = class()

function Widget:init(properties)
    for k, v in pairs(properties) do
        self[k] = v
    end
end

function Widget:addAnimation(animation, ...)
    if animation and type(animation) == "function" then
        animation(self, ...)
    else
        print("Invalid animation function")
    end
end

local Label = class(Widget)

function Label:init(text, properties)
    Widget.init(self, properties)
    self.widget = wibox.widget.textbox(text)
    self.widget.font = self.font or "Sans 12"
    self.widget.fg = self.color or "#ffffff"
end

local Button = class(Widget)

function Button:init(text, properties, onclick)
    Widget.init(self, properties)
    self.widget = wibox.widget {
        {
            {
                id = "text_role",
                widget = wibox.widget.textbox
            },
            widget = wibox.container.margin,
            left = self.padding_left or 8,
            right = self.padding_right or 8,
            top = self.padding_top or 4,
            bottom = self.padding_bottom or 4,
        },
        shape = gears.shape.rounded_rect,
        border_width = self.border_width or 0,
        border_color = self.border_color or "#000000",
        bg = self.bg or "#ffffff",
        fg = self.fg or "#000000",
        widget = wibox.container.background
    }

    self.widget:get_children_by_id("text_role")[1].markup = text
    self.widget:get_children_by_id("text_role")[1].font = self.font or "Sans 12"

    -- Connect the button's onclick function
    if onclick and type(onclick) == "function" then
        self.widget:buttons(gears.table.join(
            awful.button({}, 1, nil, onclick)
        ))
    end
end

local Checkbox = class(Widget)

function Checkbox:init(checked, properties, onchange)
    Widget.init(self, properties)
    self.widget = wibox.widget {
        checked and "☑" or "☐",
        id = "text_role",
        valign = "center",
        halign = "center",
        font = self.font or "Sans 14",
        widget = wibox.widget.textbox
    }
    self.widget.fg = self.color or "#ffffff"

    self.checked = checked or false

    if onchange and type(onchange) == "function" then
        self.widget:buttons(gears.table.join(
            awful.button({}, 1, nil, function()
                self.checked = not self.checked
                self.widget.text = self.checked and "☑" or "☐"
                onchange(self.checked)
            end)
        ))
    end
end

local TextInput = class(Widget)

function TextInput:init(text, properties)
    Widget.init(self, properties)

    local textbox = wibox.widget.textbox(text)
    textbox.font = self.font or "Sans 12"
    textbox.fg = self.color or "#ffffff"

    self.widget = wibox.widget {
        {
            textbox,
            id = "text_role",
            widget = wibox.container.margin,
            left = self.padding_left or 8,
            right = self.padding_right or 8,
            top = self.padding_top or 4,
            bottom = self.padding_bottom or 4,
        },
        shape = gears.shape.rounded_rect,
        border_width = self.border_width or 1,
        border_color = self.border_color or "#000000",
        widget = wibox.container.background
    }
end

local ProgressBar = class(Widget)

function ProgressBar:init(value, properties)
    Widget.init(self, properties)

    self.widget = wibox.widget {
        max_value     = self.max_value or 100,
        value         = value or 0,
        forced_height = self.height or 20,
        forced_width  = self.width or 200,
        shape         = gears.shape.rounded_rect,
        border_width  = self.border_width or 1,
        border_color  = self.border_color or "#000000",
        color         = self.color or "#3f51b5",
        background_color = self.bg or "#ffffff",
        widget        = wibox.widget.progressbar
    }
end

local RadioButton = class(Widget)

function RadioButton:init(checked, properties, onchange)
    Widget.init(self, properties)
    self.widget = wibox.widget {
        checked and "●" or "○",
        id = "text_role",
        valign = "center",
        halign = "center",
        font = self.font or "Sans 14",
        widget = wibox.widget.textbox
    }
    self.widget.fg = self.color or "#ffffff"

    self.checked = checked or false

    if onchange and type(onchange) == "function" then
        self.widget:buttons(gears.table.join(
            awful.button({}, 1, nil, function()
                if not self.checked then
                    self.checked = not self.checked
                    self.widget.text = self.checked and "●" or "○"
                    onchange(self.checked)
                end
            end)
        ))
    end
end

local Slider = class(Widget)

function Slider:init(value, properties, onchange)
    Widget.init(self, properties)

    self.widget = wibox.widget {
        bar_shape           = gears.shape.rounded_rect,
        bar_height          = self.bar_height or 4,
        bar_color           = self.bar_color or "#ffffff",
        handle_shape        = gears.shape.circle,
        handle_border_color = self.handle_border_color or "#000000",
        handle_border_width = self.handle_border_width or 1,
        handle_color        = self.handle_color or "#3f51b5",
        handle_size         = self.handle_size or 16,
        value               = value or 0,
        widget              = wibox.widget.slider
    }

    if onchange and type(onchange) == "function" then
        self.widget:connect_signal("property::value", function()
            onchange(self.widget.value)
        end)
    end
end

local Tooltip = class(Widget)

function Tooltip:init(text, properties)
    Widget.init(self, properties)

    self.widget = awful.tooltip {
        objects = {self},
        text = text,
        delay_show = self.delay_show or 0.5,
        mode = "outside",
        preferred_positions = {"bottom"},
        font = self.font or "Sans 12",
        fg = self.fg or "#ffffff",
        bg = self.bg or "#3f51b5",
    }
end

function Tooltip:attach(widget)
    self.widget:add_to_object(widget)
end

function Tooltip:detach(widget)
    self.widget:remove_from_object(widget)
end

local Image = class(Widget)

function Image:init(image_path, properties)
    Widget.init(self, properties)
    self.widget = wibox.widget {
        image = image_path,
        resize_strategy = self.resize_strategy or "fit",
        forced_width = self.width,
        forced_height = self.height,
        widget = wibox.widget.imagebox
    }
end

local Icon = class(Widget)

function Icon:init(icon_name, properties)
    Widget.init(self, properties)
    local icon_theme = require("beautiful").icon_theme
    self.widget = wibox.widget {
        image = icon_theme():find_icon_path(icon_name, self.size),
        resize_strategy = "fit",
        forced_width = self.size,
        forced_height = self.size,
        widget = wibox.widget.imagebox
    }
end

local VerticalSeparator = class(Widget)

function VerticalSeparator:init(properties)
    Widget.init(self, properties)
    self.widget = wibox.widget {
        orientation = "vertical",
        forced_width = self.width or 1,
        color = self.color or "#ffffff",
        widget = wibox.widget.separator
    }
end

local HorizontalSeparator = class(Widget)

function HorizontalSeparator:init(properties)
    Widget.init(self, properties)
    self.widget = wibox.widget {
        orientation = "horizontal",
        forced_height = self.height or 1,
        color = self.color or "#ffffff",
        widget = wibox.widget.separator
    }
end

local ScrollableText = class(Widget)

function ScrollableText:init(text, properties)
    Widget.init(self, properties)

    local textbox = wibox.widget.textbox(text)
    textbox.wrap = "word"
    textbox.font = self.font or "Sans 12"
    textbox.fg = self.color or "#ffffff"

    self.widget = wibox.widget {
        textbox,
        id = "text_role",
        forced_height = self.height or 100,
        forced_width = self.width or 200,
        widget = wibox.container.scroll.horizontal
    }
end

local Background = class(Widget)

function Background:init(widget, properties)
    Widget.init(self, properties)
    self.widget = wibox.widget {
        widget,
        shape = gears.shape.rounded_rect,
        border_width = self.border_width or 0,
        border_color = self.border_color or "#000000",
        bg = self.bg or "#ffffff",
        fg = self.fg or "#000000",
        widget = wibox.container.background
    }
end

local ListBox = class(Widget)

function ListBox:init(items, properties, onselect)
    Widget.init(self, properties)

    self.list_items = wibox.widget.listbox(items)
    self.list_items.forced_height = self.height or 200
    self.list_items.forced_width = self.width or 200
    self.list_items.bg = self.bg or "#ffffff"
    self.list_items.fg = self.fg or "#000000"
    self.list_items.font = self.font or "Sans 12"

    if onselect and type(onselect) == "function" then
        self.list_items:connect_signal("button::press", function(_, _, _, button)
            if button == 1 then
                local selected_item = self.list_items:get_selected_item()
                onselect(selected_item)
            end
        end)
    end

    self.widget = self.list_items
end
