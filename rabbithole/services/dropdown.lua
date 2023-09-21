local awful = require("awful")
local gears = require("gears")

local capi = {client = client}

-- Easing function for animation, remove when animation library is brought back fron the dead
local function outCubic(t, b, c, d)
    t = t / d - 1
    return c * (t * t * t + 1) + b
end

-- Dropdown application container widget
local Dropdown = {}

function Dropdown:new(config)
    local conf = config or {}
    conf = {
        app = conf.app or "xterm",
        name = conf.name or "Dropdown",
        argname = conf.argname or "-name %s",
        extra = conf.extra or "",
        border = conf.border or 1,
        visible = conf.visible or false,
        followtag = conf.followtag or false,
        overlap = conf.overlap or false,
        screen = conf.screen or awful.screen.focused(),
        settings = conf.settings,
        height = conf.height or 0.25,
        width = conf.width or 0.75,
        vert = conf.vert or "top",
        horiz = conf.horiz or "center",
        geometry = {}
    }

    local dropdown = setmetatable(conf, { __index = Dropdown })

    capi.client.connect_signal("manage", function(c)
        if c.instance == dropdown.name and c.screen == dropdown.screen then
            dropdown:display()
        end
    end)

    capi.client.connect_signal("unmanage", function(c)
        if c.instance == dropdown.name and c.screen == dropdown.screen then
            dropdown.visible = false
        end
    end)

    return dropdown
end

-- Dropdown Management
function Dropdown:display()
    if self.followtag then
        self.screen = awful.screen.focused()
    end

    local client = awful.client.iterate(function(c)
        return c.instance == self.name
    end)()

    if not client and not self.visible then
        return
    end

    if not client then
        awful.spawn(string.format("%s %s %s", self.app, string.format(self.argname, self.name), self.extra), {
            tag = self.screen.selected_tag
        })
        return
    end

    client.floating = true
    client.border_width = self.border
    client.size_hints_honor = false
    client:geometry(self.geometry[self.screen.index] or self:compute_size())
    client.sticky = false
    client.ontop = true
    client.above = true
    client.skip_taskbar = true
    if self.settings then
        self.settings(client)
    end

    -- Animate client height
    local target_geometry = self.geometry[self.screen.index] or self:compute_size()
    local anim_target = self.visible and target_geometry.height or 0
    local anim_duration = 0.3
    local anim_steps = 30
    local current_step = 0

    gears.timer.start_new(anim_duration / anim_steps, function()
        local new_height = outCubic(current_step, 1, anim_target - 1, anim_steps)
        client:geometry({ height = math.ceil(new_height) })
        current_step = current_step + 1
        return current_step <= anim_steps
    end)

    if self.visible then
        client.hidden = false
        client:raise()
        self.last_tag = self.screen.selected_tag
        client:tags({self.screen.selected_tag})
        capi.client.focus = client
    else
        client.hidden = true
        client:tags({})
    end

    return client
end

function Dropdown:compute_size()
    if not self.geometry[self.screen.index] then
        local geom = self.overlap and screen[self.screen.index].geometry or screen[self.screen.index].workarea

        local width = (self.width <= 1) and math.floor(geom.width * self.width) - 2 * self.border or self.width
        local height = (self.height <= 1) and math.floor(geom.height * self.height) or self.height

        local x = (self.horiz == "left") and geom.x or (self.horiz == "right") and geom.width + geom.x - width or geom.x + (geom.width - width) / 2
        local y = (self.vert == "top") and geom.y or (self.vert == "bottom") and geom.height + geom.y - height or geom.y + (geom.height - height) / 2

        self.geometry[self.screen.index] = {
            x = x,
            y = y,
            width = width,
            height = height
        }
    end
    return self.geometry[self.screen.index]
end

function Dropdown:toggle()
    if self.followtag then
        self.screen = awful.screen.focused()
    end
    local current_tag = self.screen.selected_tag
    if current_tag and self.last_tag ~= current_tag and self.visible then
        local c = self:display()
        if c then
            c:move_to_tag(current_tag)
        end
    else
        self.visible = not self.visible
        self:display()
    end
end

return setmetatable(Dropdown, {
    __call = function(_, ...)
        return Dropdown:new(...)
    end
})
