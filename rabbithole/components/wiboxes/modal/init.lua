return setmetatable({}, {
    __constructor = function ()
        return require("rabbithole.components.wiboxes.modal.modal")
    end
})