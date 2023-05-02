return setmetatable({}, {
    __constructor = function ()
        return require("rabbithole.services.modal.modal")
    end
})