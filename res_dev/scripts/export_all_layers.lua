--[[
  export_all_layers.lua
  Keybind companion to export_layer.lua — exports ALL layers.
  Assign this script a keybind in Aseprite: Edit > Keyboard Shortcuts > Scripts
]]

app.params = app.params or {}
app.params["exportAll"] = "true"

-- Resolve the path to export_layer.lua (assumed to be in the same scripts folder)
local script_dir = debug.getinfo(1, "S").source:match("^@(.+[/\\])")
dofile(script_dir .. "export_layer.lua")
