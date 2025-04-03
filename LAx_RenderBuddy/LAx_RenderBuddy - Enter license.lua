-- @noindex

----------------------------------------------------------------------------------------
-- Run Shared
DTAV = _VERSION == 'Lua 5.3' and 'dta53' or 'dta'
local currentFolder = (debug.getinfo(1).source:match("@?(.*[\\|/])"))
currentFolder = currentFolder:gsub("\\", "/")
local parentFolder = currentFolder:match("(.*)/[^/]+/?$") or currentFolder:match("(.*)/")
parentFolder = parentFolder:gsub("\\", "/")

reaper.SetExtState("LAx_RenderBuddy", "Directory", currentFolder, false)
reaper.SetExtState("LAx_RenderBuddy", "MainDirectory", parentFolder, false)

local sep = package.config:sub(1, 1)
dofile((currentFolder or "") .. DTAV .. sep .. "runShared" .. (reaper.file_exists((currentFolder or "") .. DTAV .. sep .. "runShared.lua") and ".lua" or ".dat"))
openLicenseSettings(LAx_ProductData.name)