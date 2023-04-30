return setmetatable({}, {
    __constructor = function ()
        return require("rabbithole.wibox.modal.modal")
    end
})