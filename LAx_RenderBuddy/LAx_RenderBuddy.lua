--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 2.00
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
    * v2.00
      + Added: The "RenderBuddy Manager" which allows for a persistent managing of folders and all NameSwitch regions
      + Added: A "Groups" functionality as part of the Manager, enabling saving and recalling render selections
      + Added: "Always render in track mode" setting, which lets you ignore selected items and removes the need to de-select them first before rendering a track or folder
      + Added: Optional render preview UI for rendering, listing all rendered tracks/folders and NameSwitch regions
      + Added: Toolbar icons for Settings, creating NameSwitches and the Manager
      + Added: License Manager GUI
      + Tweaked: Renderbuddy now properly supports wildcards while maintaining the ability to use e.g. $track and $folders wildcards
      + Tweaked: New settings menu with custom UI
      + Tweaked: Regular rendering and using RenderBuddy will both preserve their render patterns individually
      + Tweaked: The $folders wildcard now behaves like in vanilla Reaper (no separator at the end)
      + Tweaked: Batch-rendering to work with language packs
      + Tweaked: The default Reaper render window will be slightly adjusted when rendering via RenderBuddy
      + Tweaked: NameSwitches will no longer be considered for context-sensitivity
      + Tweaked: Removed intrusive free trial popup reminders
      + Tweaked: Numerous under-the-hood code changes
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
