-- Mouse button logic in Rabbithole
-- Rabbithole should aim for consistency across not only itself, but across norms for other applications (right click menu, middle click delete, etc.
-- Eventually mouse buttons need to be refactored into a service

--[[
Mod4 is the key used in all forms of tag switching and tag manipulation
Ctrl selects multiple items

Left click selects an item
Right click always opens up possible menus for whatever object is clicked, up to the client level
Middle click deletes an item


The mouse buttons are as follows:
1. Left click: switch to tag
2. Middle click: delete tag
3. Right click: open menu
Thereforce,
1. Ctrl + Left click selects multiple tags
2. Mod4 + right click opens up the taglist menu
]]