local awful = require("awful")

local dragndrop = {}

function dragndrop.enableDrag(c)
    -- When the client is clicked with the left mouse button, activate dragging
    c:connect_signal("button::press", function(cli, lx, ly, button)
        if button == 1 then
            awful.mouse.client.move(cli)
        end
    end)

    -- When the mouse button is released, ungrab the pointer and keyboard
    c:connect_signal("button::release", function(cli, lx, ly, button)
        if button == 1 then
            awful.mouse.client.stop_move()
        end
    end)
end

return dragndrop
