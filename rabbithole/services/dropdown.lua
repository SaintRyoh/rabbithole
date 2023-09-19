--[[

     Licensed under GNU General Public License v2
      * (c) 2016, Luca CPZ
      * (c) 2015, unknown

--]]

local awful        = require("awful")
local capi         = { client = client }
local math         = math
local string       = string
local pairs        = pairs
local screen       = screen
local setmetatable = setmetatable
local gears = require("gears")


local function outCubic(t, b, c, d)
    t = t / d - 1
    return c * (t * t * t + 1) + b
end

-- Quake-like Dropdown application spawn
local Dropdown = {}

-- If you have a rule like "awful.client.setslave" for your terminals,
-- ensure you use an exception for QuakeDD. Otherwise, you may
-- run into problems with focus.

function Dropdown:display()
    if self.followtag then self.screen = awful.screen.focused() end

    -- First, we locate the client
    local client = nil
    local i = 0
    for c in awful.client.iterate(function (c)
        -- c.name may be changed!
        return c.instance == self.name
    end)
    do
        i = i + 1
        if i == 1 then
            client = c
        else
            -- Additional matching clients, let's remove the sticky bit
            -- which may persist between awesome restarts. We don't close
            -- them as they may be valuable. They will just turn into
            -- normal clients.
            c.sticky = false
            c.ontop = false
            c.above = false
        end
    end

    if not client and not self.visible then return end

    if not client then
        -- The client does not exist, we spawn it
        local cmd = string.format("%s %s %s", self.app,
              string.format(self.argname, self.name), self.extra)
        awful.spawn(cmd, { tag = self.screen.selected_tag })
        return
    end

    -- Set geometry
    client.floating = true
    client.border_width = self.border
    client.size_hints_honor = false
    client:geometry(self.geometry[self.screen.index] or self:compute_size())

    -- Set not sticky and on top
    client.sticky = false
    client.ontop = true
    client.above = true
    client.skip_taskbar = true

    -- Additional user settings
    if self.settings then self.settings(client) end

    -- Set the initial geometry
    local target_geometry = self.geometry[self.screen.index] or self:compute_size()

    -- Animation parameters
    local anim_duration = 0.3  -- 300ms, adjust to your preference
    local anim_steps = 30
    local step_delay = anim_duration / anim_steps

    if not self.visible then
        -- Hiding animation, animate from full height to 0
        local current_step = 0
        gears.timer.start_new(step_delay, function()
            local new_height = outCubic(current_step, target_geometry.height, -target_geometry.height, anim_steps)
            client:geometry({y = target_geometry.y + target_geometry.height - math.ceil(new_height), height = math.ceil(new_height)})
            current_step = current_step + 1
            if current_step > anim_steps then
                client.hidden = true
            end
            return current_step <= anim_steps
        end)
    else
        client:geometry({height = 1})
        client.hidden = false

        local current_step = 0
        gears.timer.start_new(step_delay, function()
            local new_height = outCubic(current_step, 1, target_geometry.height - 1, anim_steps)
            client:geometry({height = math.ceil(new_height)})
            current_step = current_step + 1
            return current_step <= anim_steps
        end)
    end

    if self.visible then
        client.hidden = false
        client:raise()
        self.last_tag = self.screen.selected_tag
        client:tags({self.screen.selected_tag})
        capi.client.focus = client
   else
        client.hidden = true
        local ctags = client:tags()
        for i, t in pairs(ctags) do
            ctags[i] = nil
        end
        client:tags(ctags)
    end

    return client
end

function Dropdown:compute_size()
    -- skip if we already have a geometry for this screen
    if not self.geometry[self.screen.index] then
        local geom
        if not self.overlap then
            geom = screen[self.screen.index].workarea
        else
            geom = screen[self.screen.index].geometry
        end
        local width, height = self.width, self.height
        if width  <= 1 then width = math.floor(geom.width * width) - 2 * self.border end
        if height <= 1 then height = math.floor(geom.height * height) end
        local x, y
        if     self.horiz == "left"  then x = geom.x
        elseif self.horiz == "right" then x = geom.width + geom.x - width
        else   x = geom.x + (geom.width - width)/2 end
        if     self.vert == "top"    then y = geom.y
        elseif self.vert == "bottom" then y = geom.height + geom.y - height
        else   y = geom.y + (geom.height - height)/2 end
        self.geometry[self.screen.index] = { x = x, y = y, width = width, height = height }
    end
    return self.geometry[self.screen.index]
end

function Dropdown:new(config)
    local conf = config or {}

    conf.app        = conf.app       or "xterm"    -- application to spawn
    conf.name       = conf.name      or "Dropdown"  -- window name
    conf.argname    = conf.argname   or "-name %s" -- how to specify window name
    conf.extra      = conf.extra     or ""         -- extra arguments
    conf.border     = conf.border    or 1          -- client border width
    conf.visible    = conf.visible   or false      -- initially not visible
    conf.followtag  = conf.followtag or false      -- spawn on currently focused screen
    conf.overlap    = conf.overlap   or false      -- overlap wibox
    conf.screen     = conf.screen    or awful.screen.focused()
    conf.settings   = conf.settings

    -- If width or height <= 1 this is a proportion of the workspace
    conf.height     = conf.height    or 0.25       -- height
    conf.width      = conf.width     or 0.75          -- width
    conf.vert       = conf.vert      or "top"      -- top, bottom or center
    conf.horiz      = conf.horiz     or "center"     -- left, right or center
    conf.geometry   = {}                           -- internal use

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

function Dropdown:toggle()
     if self.followtag then self.screen = awful.screen.focused() end
     local current_tag = self.screen.selected_tag
     if current_tag and self.last_tag ~= current_tag and self.visible then
         local c=self:display()
         if c then
            c:move_to_tag(current_tag)
        end
     else
         self.visible = not self.visible
         self:display()
     end
end

return setmetatable(Dropdown, { __call = function(_, ...) return Dropdown:new(...) end })