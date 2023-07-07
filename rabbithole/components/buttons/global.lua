-- Standard awesome library
local gears = require("gears")
local awful = require("awful")


-- For when mouse is over the desktop
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
return setmetatable({}, {
    __constructor = function (
        rabbithole__components__menus__main
    )
        local globalbuttons = gears.table.join(
                awful.button({ }, 3, function () rabbithole__components__menus__main:toggle() end)
                --awful.button({ }, 4, awful.tag.viewnext),
                --awful.button({ }, 5, awful.tag.viewprev)
        )
            -- When a client is clicked with the right mouse button, activate dragging
--            client.connect_signal("button::press", function(c)
--                if awful.mouse.client_under_pointer() == c then
--                    client.focus = c
--                    awful.mouse.client.move(c)
--                end
--            end)
--
--            -- When the mouse button is released, move the client to the tag under the mouse
--            client.connect_signal("button::release", function(c)
--                local t = awful.screen.focused().selected_tag
--                if t then
--                    c:move_to_tag(t)
--                end
--            end)

        return globalbuttons
    end
})