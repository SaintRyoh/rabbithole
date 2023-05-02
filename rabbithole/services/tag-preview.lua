Module = {}

function Module.show(tag, screen)
    -- BLING: Only show widget when there are clients in the tag
    if #tag:clients() > 0 then
        -- BLING: Update the widget with the new tag
        awesome.emit_signal("bling::tag_preview::update", tag)
        -- BLING: Show the widget
        awesome.emit_signal("bling::tag_preview::visibility", screen, true)
    end
end

function Module.hide(tag, screen)
    -- BLING: Turn the widget off
    awesome.emit_signal("bling::tag_preview::visibility", screen, false)
end

return setmetatable(Module, {
    __constructor = function()
        return Module
    end
})