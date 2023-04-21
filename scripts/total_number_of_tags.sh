send << EOF

local all_active_workspaces = wm:getAllActiveWorkspaces()
local all_tags = __.flatten(__.map(all_active_workspaces, function(workspace) return workspace:getAllTags() end))

naughty = require("naughty")
naughty.notify({
title="CLI Notification",
text="" .. #all_tags})
EOF

