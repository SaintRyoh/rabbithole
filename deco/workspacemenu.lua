-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local __ = require("lodash")
-- }}}

local _M = {}



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local WorkspaceMenuController = { }
WorkspaceMenuController.__index = WorkspaceMenuController

function WorkspaceMenuController:new(tagService)
    self = {}
    setmetatable(self, WorkspaceMenuController)

    self.tagService = tagService
    self.workspace_menu = self:generate_menu()

    return self
end

function WorkspaceMenuController:generate_menu()
    local menu = awful.menu({
        items = gears.table.join(__.map(self:get_all_workspaces(),
                function(workspace, index)
                    return {
                        workspace.name or ("workspace: " .. index),
                        {
                            { "switch", function() self:switch_to(workspace) end},
                            { "rename", function() self:rename_workspace(workspace) end},
                            { "remove", function()  self:remove_workspace(workspace) end}
                        }
                    }
                end))
    })
    menu:add({ "add workspace", function () self:add_workspace() end})
    return menu
end

function WorkspaceMenuController:get_all_workspaces()
    return self.tagService:get_all_workspaces()
end

function WorkspaceMenuController:switch_to(workspace)
    self.tagService:switch_to(workspace)
end

function WorkspaceMenuController:add_workspace()
    self.tagService:add_workspace()
    self:updateMenu()
end

function WorkspaceMenuController:remove_workspace(workspace)
    -- if the workspace if active don't delete it
    if workspace:getStatus() then
        naughty.notify({
            title="switch to another workspace before removing it",
            timeout=0
        })
        return
    end

    self.tagService:remove_workspace(workspace)

    -- regenerate menu
    self:updateMenu()

    naughty.notify({
        title="removed workspace",
        timeout=0
    })
end

function WorkspaceMenuController:updateMenu()
    self.workspace_menu = self:generate_menu()
end

function WorkspaceMenuController:rename_workspace(workspace)
    awful.prompt.run {
        prompt       = "Rename workspace: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            if not workspace then return end
            workspace.name = new_name
            self:updateMenu()
        end
    }
end

function _M.get(tagService)
    local wmc = WorkspaceMenuController:new(tagService)

    -- {{{ workspace dropdownmenu
    local workspace_menu_view = {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.widget.textbox,
            text = "   workspace: X   ",
            buttons = gears.table.join(
                    awful.button({ }, 1,
                            function ()
                                wmc.workspace_menu:toggle()
                            end)
            )
        }
    }

    return workspace_menu_view

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, tagService) return _M.get(tagService) end })