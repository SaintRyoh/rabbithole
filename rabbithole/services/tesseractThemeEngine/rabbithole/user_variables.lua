-- User variables file. This will eventually be refactored for the settings manager

local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local home = os.getenv("HOME")

-- If you want different default programs, wallpaper path or modkey; edit this file.
user_vars = {

  -- Autotiling layouts
  layouts = {
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.floating,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.spiral.dwindle,
  },

  -- Icon theme from /usr/share/icons
  -- for some reason, BeautyLine icon pack wont load. I hate Papirus-Dark
  icon_theme = "Papirus-Dark",
  -- default icon does not work for some reason
  default_icon = "/usr/share/icons/BeautyLine/apps/scalable/org.xfce.panel.launcher.svg",
  -- Write the terminal command to start anything here
  autostart = {
    "picom --experimental-backends"
    --"nm-tray",
    --"volumeicon"
  },

  -- Type 'ip a' and check your wlan and ethernet name
  network = {
    wlan = "wlo1",
    ethernet = "eno1"
  },

  -- Set your font with this format:
  font = {
    regular = "Ubuntu, 14",
    bold = "Ubuntu, Bold 14",
    extrabold = "Ubuntu Mono, Bold 14",
    specify = "Ubuntu"
  },

  -- This is your default Terminal
  terminal = "qterminal",

  -- This is the modkey 'mod4' = Super/Mod/WindowsKey, 'mod3' = alt...
  modkey = "Mod4",

  -- place your wallpaper at this path with this name, you could also try to change the path
  wallpaper = home .. "/.config/awesome/src/assets/wallpapers/forest.jpg",

  -- Naming scheme for the powermenu, userhost = "user@hostname", fullname = "Firstname Surname", something else ...
  namestyle = "userhost",

  -- List every Keyboard layout you use here comma seperated. (run localectl list-keymaps to list all averiable keymaps)
  --kblayout = { "de", "ru" },

  -- Your filemanager that opens with super+e
  file_manager ="pcmanfm-qt",

  -- Screenshot program to make a screenshot when print is hit
  screenshot_program = "flameshot gui",

}
