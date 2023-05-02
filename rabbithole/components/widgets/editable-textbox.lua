local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local editable_textbox = {}
editable_textbox.__index = editable_textbox

function editable_textbox.new(args)
    local self = setmetatable({}, editable_textbox)
    self.args = args or {}

    self.textbox = wibox.widget.textbox()

    self.last_click_time = 0
    self.double_click_threshold = self.args.double_click_threshold or 0.5
    self.debounce_duration = self.args.debounce_duration or 0.2
    self.debounce_timer = gears.timer()

    self.double_click_callback = function()
        self:check_double_click()
    end
    self.start_editing_callback = function()
        self:start_editing()
    end
    self.textbox:connect_signal("button::press", self.double_click_callback)

    return self
end

function editable_textbox:start_editing()
    local edit_prompt = self.args.edit_prompt or "Edit: "
    local backup = self.textbox.text
    awful.prompt.run {
        prompt = edit_prompt,
        textbox = self.textbox,
        exe_callback = function(new_text)
            if not new_text or #new_text == 0 then return end
            self.textbox:set_markup(new_text)
        end,
        done_callback = function()
            if self.textbox.text == "" then
                self.textbox:set_markup(backup)
            end
            self.textbox:disconnect_signal("button::press", self.start_editing_callback)
            self.textbox:connect_signal("button::press", self.double_click_callback)
        end
    }
end

function editable_textbox:check_double_click()
    local current_time = os.clock()
    if current_time - self.last_click_time < self.double_click_threshold then
        -- Debugger.dbg()
        if not self.debounce_timer.started then
            self.debounce_timer.timeout = self.debounce_duration
            self.debounce_timer:connect_signal("timeout", function()
                self.debounce_timer:stop()
                self.textbox:disconnect_signal("button::press", self.double_click_callback )
                self.textbox:connect_signal("button::press", self.start_editing_callback)
            end)
            self.debounce_timer:start()
        end
    else
        self.last_click_time = current_time
    end
end

function editable_textbox:get_widget()
    return self.textbox
end

-- Usage example
-- local my_editable_textbox = editable_textbox.new {
--     text = "Double-click to edit me!",
--     edit_prompt = "Enter new text: ",
--     double_click_threshold = 0.5
-- }

-- Add 'my_editable_textbox' to your wibar or other container
-- Use 'my_editable_textbox:get_widget()' to get the widget instance

return editable_textbox
