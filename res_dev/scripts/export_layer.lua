--[[

This is an export script for Aseprite

It takes the currently selected layer and exports it into ../res/textures/layername.tga

Frames with no pixel data on the layer are skipped automatically.
Multi-frame layers export individually: layername_1.tga, layername_2.tga, ...
For animations with tags: layername_tagname_1.tga, layername_tagname_2.tga, ...
Single-frame layers are exported without the index suffix.

Pass `exportAll=true` via script args or set the EXPORT_ALL variable below to export all layers.

Very helpful for quickly exporting with a keybind.

]]

-- Set this to true to export all layers instead of just the selected one.
-- When using two separate script files for keybinds, set to false in one and true in the other.
local EXPORT_ALL = false

-- Allow override via script params (e.g. when called programmatically)
if app.params and app.params["exportAll"] == "true" then
  EXPORT_ALL = true
end

local spr = app.activeSprite
if not spr then return print('No active sprite') end

-- Extract the current path and filename of the active sprite
local local_path, title, extension = spr.filename:match("^(.+[/\\])(.-)(%.[^.]*)$")

-- Construct export path by prefixing the current .aseprite file path
local export_path = local_path .. "../res/textures/"
local_path = export_path

local sprite_name = app.fs.fileTitle(app.activeSprite.filename)
local asset_path = local_path .. '/'

-- Recursively find a layer by name.
function find_layer(layers, name)
  for _, layer in ipairs(layers) do
    if layer.name == name then return layer end
    if layer.isGroup then
      local found = find_layer(layer.layers, name)
      if found then return found end
    end
  end
  return nil
end

-- Returns true if the given layer has any non-transparent pixel in the given frame (1-based).
function frame_has_data(layer, frame_idx)
  local cel = layer:cel(frame_idx)
  if not cel then return false end
  local img = cel.image
  for px in img:pixels() do
    if px() ~= 0 then return true end
  end
  return false
end

-- Collect the non-empty frame indices for a layer within an inclusive frame range.
function non_empty_frames(layer, from_idx, to_idx)
  local result = {}
  for i = from_idx, to_idx do
    if frame_has_data(layer, i) then
      table.insert(result, i)
    end
  end
  return result
end

-- Export one frame of a layer to a .tga file by saving the cel image directly.
function export_frame(layer_name, abs_frame, fn)
  local layer = find_layer(spr.layers, layer_name)
  local cel = layer and layer:cel(abs_frame)
  if not cel then
    print('  Skipping frame ' .. abs_frame .. ' (no cel)')
    return
  end
  cel.image:saveAs(fn .. '.tga')
end

-- Export a layer frame-by-frame, skipping frames with no data.
-- Single populated frame → layername.tga
-- Multiple populated frames → layername_1.tga, layername_2.tga, ...
function layer_export(layer_name)
  local layer = find_layer(spr.layers, layer_name)
  local populated = non_empty_frames(layer, 1, #spr.frames)
  local multi = #populated > 1
  for _, abs_frame in ipairs(populated) do
    local suffix = multi and ("_" .. abs_frame) or ""
    local fn = asset_path .. layer_name .. suffix
    print('Exporting layer: ' .. layer_name .. ' frame ' .. abs_frame)
    export_frame(layer_name, abs_frame, fn)
  end
end

-- Export each tag frame-by-frame, skipping frames with no data on the layer.
-- layer_name is optional; if nil, uses sprite_name as the base.
function do_animation_export(layer_name)
  local layer = layer_name and find_layer(spr.layers, layer_name) or nil
  for _, tag in ipairs(spr.tags) do
    local from_idx = tag.fromFrame.frameNumber
    local to_idx   = tag.toFrame.frameNumber
    local base = layer_name and (asset_path .. layer_name .. "_" .. tag.name)
                             or  (asset_path .. sprite_name .. "_" .. tag.name)
    local populated = layer and non_empty_frames(layer, from_idx, to_idx)
                            or  (function()
                                  -- No specific layer filter: export all frames in tag
                                  local t = {}
                                  for i = from_idx, to_idx do table.insert(t, i) end
                                  return t
                                end)()
    local multi = #populated > 1
    for pos, abs_frame in ipairs(populated) do
      local suffix = multi and ("_" .. pos) or ""
      local fn = base .. suffix
      print('Exporting tag: ' .. tag.name .. ' frame ' .. abs_frame
            .. (layer_name and (' (layer: ' .. layer_name .. ')') or ''))
      export_frame(layer_name, abs_frame, fn)
    end
  end
end

-- Recursively collect all visible, exportable layers (skips groups)
function collect_layers(layers, result)
  result = result or {}
  for _, layer in ipairs(layers) do
    if layer.isGroup then
      collect_layers(layer.layers, result)
    else
      table.insert(result, layer)
    end
  end
  return result
end

-- Export all layers in the sprite
function export_all_layers()
  local all_layers = collect_layers(spr.layers)
  print('Exporting all ' .. #all_layers .. ' layer(s)...')
  for _, layer in ipairs(all_layers) do
    if #spr.tags > 0 then
      do_animation_export(layer.name)
    else
      layer_export(layer.name)
    end
  end
  print('Done exporting all layers.')
end

-- Export only the currently selected layer
function export_selected_layer()
  local layer_name = app.activeLayer.name
  if #spr.tags > 0 then
    do_animation_export(layer_name)
  else
    layer_export(layer_name)
  end
end

-- Entry point
if EXPORT_ALL then
  export_all_layers()
else
  export_selected_layer()
end
