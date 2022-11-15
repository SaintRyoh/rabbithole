-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")
local common = require("awful.widget.common")
local beautiful = require("beautiful")
-- Wibox handling library
local wibox = require("wibox")

-- Grab environment we need
local capi = { screen = screen,
               awesome = awesome,
               client = client }
local ipairs = ipairs
local tag = require("awful.tag")
local surface = require("gears.surface")
local gcolor = require("gears.color")
local gstring = require("gears.string")

local workspaceManagerService = RC.workspaceManagerService

-- Custom Local Library: Common Functional Decoration
local deco = {
    wallpaper = require("deco.wallpaper"),
    taglist   = require("deco.taglist"),
    tasklist  = require("deco.tasklist"),
    workspaceMenu = require("deco.workspacemenu")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()
local workspaceMenu = deco.workspaceMenu(workspaceManagerService)

local __ = require("lodash")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    --     end

    -- tag setup
    workspaceManagerService:setupTagsOnScreen(s)


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))


     s.mytaglist = awful.widget.taglist {
         screen  = s,
         filter  = awful.widget.taglist.filter.all,
         --style   = {
         --    shape = gears.shape.powerline
         --},
         --layout   = {
         --    spacing = -12,
         --    spacing_widget = {
         --        color  = '#dddddd',
         --        shape  = gears.shape.powerline,
         --        widget = wibox.widget.separator,
         --    },
         --    layout  = wibox.layout.fixed.horizontal
         --},
         --widget_template = {
         --    {
         --        {
         --            {
         --                {
         --                    {
         --                        id     = 'index_role',
         --                        widget = wibox.widget.textbox,
         --                    },
         --                    margins = 4,
         --                    widget  = wibox.container.margin,
         --                },
         --                bg     = '#dddddd',
         --                shape  = gears.shape.circle,
         --                widget = wibox.container.background,
         --            },
         --            {
         --                {
         --                    id     = 'icon_role',
         --                    widget = wibox.widget.imagebox,
         --                },
         --                margins = 2,
         --                widget  = wibox.container.margin,
         --            },
         --            {
         --                id     = 'text_role',
         --                widget = wibox.widget.textbox,
         --            },
         --            layout = wibox.layout.fixed.horizontal,
         --        },
         --        left  = 18,
         --        right = 18,
         --        widget = wibox.container.margin
         --    },
         --    id     = 'background_role',
         --    widget = wibox.container.background,
         --    -- Add support for hover colors and an index label
         --    create_callback = function(self, c3, index, objects) --luacheck: no unused args
         --        self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
         --        self:connect_signal('mouse::enter', function()
         --            if self.bg ~= '#ff0000' then
         --                self.backup     = self.bg
         --                self.has_backup = true
         --            end
         --            self.bg = '#ff0000'
         --        end)
         --        self:connect_signal('mouse::leave', function()
         --            if self.has_backup then self.bg = self.backup end
         --        end)
         --    end,
         --    update_callback = function(self, c3, index, objects) --luacheck: no unused args
         --        self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
         --        self.bg = '#00ff00'
         --    end,
         --},
         buttons = taglist_buttons,
         source = function() return root.tags() end,
         update_function = function(w, buttons, label, data, objects, args)
             local taglist_label = function(t, args)
                 if not args then args = {} end
                 local theme = beautiful.get()
                 local fg_focus = args.fg_focus or theme.taglist_fg_focus or theme.fg_focus
                 local bg_focus = args.bg_focus or theme.taglist_bg_focus or theme.bg_focus
                 local fg_urgent = args.fg_urgent or theme.taglist_fg_urgent or theme.fg_urgent
                 local bg_urgent = args.bg_urgent or theme.taglist_bg_urgent or theme.bg_urgent
                 local bg_occupied = args.bg_occupied or theme.taglist_bg_occupied
                 local fg_occupied = args.fg_occupied or theme.taglist_fg_occupied
                 local bg_empty = args.bg_empty or theme.taglist_bg_empty
                 local fg_empty = args.fg_empty or theme.taglist_fg_empty
                 local bg_volatile = args.bg_volatile or theme.taglist_bg_volatile
                 local fg_volatile = args.fg_volatile or theme.taglist_fg_volatile
                 local taglist_squares_sel = args.squares_sel or theme.taglist_squares_sel
                 local taglist_squares_unsel = args.squares_unsel or theme.taglist_squares_unsel
                 local taglist_squares_sel_empty = args.squares_sel_empty or theme.taglist_squares_sel_empty
                 local taglist_squares_unsel_empty = args.squares_unsel_empty or theme.taglist_squares_unsel_empty
                 local taglist_squares_resize = theme.taglist_squares_resize or args.squares_resize or "true"
                 local taglist_disable_icon = args.taglist_disable_icon or theme.taglist_disable_icon or false
                 local font = args.font or theme.taglist_font or theme.font or ""
                 local text = nil
                 local sel = capi.client.focus
                 local bg_color = nil
                 local fg_color = nil
                 local bg_image
                 local icon
                 local shape              = args.shape or theme.taglist_shape
                 local shape_border_width = args.shape_border_width or theme.taglist_shape_border_width
                 local shape_border_color = args.shape_border_color or theme.taglist_shape_border_color
                 -- TODO: Re-implement bg_resize
                 local bg_resize = false -- luacheck: ignore
                 local is_selected = false
                 local cls = t:clients()
                 local samescreen = true
                 local s = s

                 if t.screen == s then samescreen = true else samescreen = false end
                 if sel and taglist_squares_sel then
                     -- Check that the selected client is tagged with 't'.
                     local seltags = sel:tags()
                     for _, v in ipairs(seltags) do
                         if v == t then
                             bg_image = taglist_squares_sel
                             bg_resize = taglist_squares_resize == "true"
                             is_selected = true
                             break
                         end
                     end
                 end
                 if #cls == 0 and t.selected and taglist_squares_sel_empty then
                     bg_image = taglist_squares_sel_empty
                     bg_resize = taglist_squares_resize == "true"
                 elseif not is_selected then
                     if #cls > 0 then
                         if taglist_squares_unsel then
                             bg_image = taglist_squares_unsel
                             bg_resize = taglist_squares_resize == "true"
                         end
                         if bg_occupied then bg_color = bg_occupied end
                         if fg_occupied then fg_color = fg_occupied end
                     else
                         if taglist_squares_unsel_empty then
                             bg_image = taglist_squares_unsel_empty
                             bg_resize = taglist_squares_resize == "true"
                         end
                         if bg_empty then bg_color = bg_empty end
                         if fg_empty then fg_color = fg_empty end

                         if args.shape_empty or theme.taglist_shape_empty then
                             shape = args.shape_empty or theme.taglist_shape_empty
                         end

                         if args.shape_border_width_empty or theme.taglist_shape_border_width_empty then
                             shape_border_width = args.shape_border_width_empty or theme.taglist_shape_border_width_empty
                         end

                         if args.shape_border_color_empty or theme.taglist_shape_border_color_empty then
                             shape_border_color = args.shape_border_color_empty or theme.taglist_shape_border_color_empty
                         end
                     end
                 end
                 if t.selected and samescreen then
                     bg_color = bg_focus
                     fg_color = fg_focus

                     if args.shape_focus or theme.taglist_shape_focus then
                         shape = args.shape_focus or theme.taglist_shape_focus
                     end

                     if args.shape_border_width_focus or theme.taglist_shape_border_width_focus then
                         shape_border_width = args.shape_border_width_focus or theme.taglist_shape_border_width_focus
                     end

                     if args.shape_border_color_focus or theme.taglist_shape_border_color_focus then
                         shape_border_color = args.shape_border_color_focus or theme.taglist_shape_border_color_focus
                     end

                 elseif tag.getproperty(t, "urgent") then
                     if bg_urgent then bg_color = bg_urgent end
                     if fg_urgent then fg_color = fg_urgent end

                     if args.shape_urgent or theme.taglist_shape_urgent then
                         shape = args.shape_urgent or theme.taglist_shape_urgent
                     end

                     if args.shape_border_width_urgent or theme.taglist_shape_border_width_urgent then
                         shape_border_width = args.shape_border_width_urgent or theme.taglist_shape_border_width_urgent
                     end

                     if args.shape_border_color_urgent or theme.taglist_shape_border_color_urgent then
                         shape_border_color = args.shape_border_color_urgent or theme.taglist_shape_border_color_urgent
                     end

                 elseif t.volatile then
                     if bg_volatile then bg_color = bg_volatile end
                     if fg_volatile then fg_color = fg_volatile end

                     if args.shape_volatile or theme.taglist_shape_volatile then
                         shape = args.shape_volatile or theme.taglist_shape_volatile
                     end

                     if args.shape_border_width_volatile or theme.taglist_shape_border_width_volatile then
                         shape_border_width = args.shape_border_width_volatile or theme.taglist_shape_border_width_volatile
                     end

                     if args.shape_border_color_volatile or theme.taglist_shape_border_color_volatile then
                         shape_border_color = args.shape_border_color_volatile or theme.taglist_shape_border_color_volatile
                     end
                 end

                 if not tag.getproperty(t, "icon_only") then
                     text = "<span font_desc='"..font.."'>"
                     if fg_color then
                         text = text .. "<span color='" .. gcolor.ensure_pango_color(fg_color) ..
                                 "'>" .. (gstring.xml_escape(t.name) or "") .. "</span>"
                     else
                         text = text .. (gstring.xml_escape(t.name) or "")
                     end
                     text = text .. "</span>"
                 end
                 if not taglist_disable_icon then
                     if t.icon then
                         icon = surface.load(t.icon)
                     end
                 end

                 local other_args = {
                     shape              = shape,
                     shape_border_width = shape_border_width,
                     shape_border_color = shape_border_color,
                 }

                 --naughty.notify({
                 --    title="Same screen",
                 --    text=string.format("tscreen: %s, tselected: %d, wscreen: %d, same screen: %d ", t.name, t.selected and 1, s and 1, samescreen),
                 --    timeout=0
                 --})
                 --naughty.notify({
                 --    title="Same screen",
                 --    text=string.format("bg color: %s", bg_color),
                 --    timeout=0
                 --})
                 return text, bg_color, bg_image, not taglist_disable_icon and icon or nil, other_args
             end
             return common.list_update(w, buttons, taglist_label, data, objects, args)
         end

    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibar = awful.wibar({ position = "top", screen = s })



    -- Create a textclock widget
    local mytextclock = wibox.widget.textclock()

    -- Add widgets to the wibox
    s.mywibar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            RC.launcher,
            workspaceMenu,
            s.mytaglist,
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}
