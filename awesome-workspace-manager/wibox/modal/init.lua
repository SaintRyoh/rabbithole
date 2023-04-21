return setmetatable({}, {
    __constructor = function ()
        return require("awesome-workspace-manager.wibox.modal.modal")
    end
})