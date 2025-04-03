--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API
 Version: 0.92
 Provides:
  [main] *.lua
  [data] toolbar_icons/**/*.png
  [nomain] *.pdf
  **/*.dat
 About:
  # LAx_RenderBuddy
  
  ## A lightning-fast, context-sensitive one-button render solution for SFX and library creation.

--[[
 * Changelog:
    * v0.92
      + PDF Testing
]]

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
dofile((currentFolder or "") .. DTAV .. sep .. "runShared" ..
           (reaper.file_exists((currentFolder or "") .. DTAV .. sep .. "runShared.lua") and ".lua" or ".dat"))

----------------------------------------------------------------------------------------
-- Settings
LAx_RenderBuddySettings = {}
LAx_RenderBuddySettings.settings = {
    doRender = true
}

-- Check the state of keyboard keys
local function isSubfolderRender()
    local keyRenderSubfolders = tonumber(reaper.GetExtState("LAx_RenderBuddy", "RenderSubfoldersModifier")) or 20
    local keyboardState = reaper.JS_VKeys_GetState(reaper.time_precise() - 1)

    return keyboardState:byte(keyRenderSubfolders) & 1 ~= 0
end

----------------------------------------------------------------------------------------
-- Run main file
local file = isSubfolderRender() and "renderSubfolders" or "functions"
runFile(reaper.GetExtState("LAx_RenderBuddy", "Directory", "") .. DTAV .. sep .. file, true)
