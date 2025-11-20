--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 2.01
 Provides:
  [main] *.lua
  [data] toolbar_icons/**/*.png
  [nomain] images/*.png
  **/*.dat
 About:
  # LAx_RenderBuddy

  ## A lightning-fast, context-sensitive one-button render solution for SFX and library creation.

--[[
 * Changelog:
    * v2.01
      + Fixed: RenderBuddy could sometimes throw an error when Rendering multiple folders via the Manager
      + Fixed: "Only Create Regions" Action was not working
      + Tweaked: "Only Create Regions" can now create Regions for multiple selected folders or tracks
]] ----------------------------------------------------------------------------------------
-- Run Shared
DTAV = _VERSION == 'Lua 5.3' and 'dta53' or 'dta'
local currentFolder = (debug.getinfo(1).source:match("@?(.*[\\|/])"))
currentFolder = currentFolder:gsub("\\", "/")
local parentFolder = currentFolder:match("(.*)/[^/]+/?$") or currentFolder:match("(.*)/")
parentFolder = parentFolder:gsub("\\", "/")

-- Set ExtState values
local _, _, _, cmdID = reaper.get_action_context()
reaper.SetExtState("LAx_RenderBuddy", "MainCommandID", tostring(cmdID), true)
reaper.SetExtState("LAx_RenderBuddy", "Directory", currentFolder, false)
reaper.SetExtState("LAx_PremiumReaperScripts", "MainDirectory", parentFolder, false)

local sep = package.config:sub(1, 1)
dofile((currentFolder or "") .. DTAV .. sep .. "runShared" ..
    (reaper.file_exists((currentFolder or "") .. DTAV .. sep .. "runShared.lua") and ".lua" or ".dat"))

if not LAx_init then
    return
end

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
local file = isSubfolderRender() and "renderSubfolders" or "main"
runFile(reaper.GetExtState("LAx_RenderBuddy", "Directory") .. DTAV .. sep .. file, true)
