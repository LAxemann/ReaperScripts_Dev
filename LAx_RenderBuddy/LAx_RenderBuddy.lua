--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 3.27
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
    * v3.27
      + Added: Ability to automatically add all RenderBuddy actions to a (selectable) toolbar in Settings
      + Added: On startup, RenderBuddy will ask once if the user would like to add all actions to a (selectable) toolbar 
      + Tweaked: Children of blacklisted folders will no longer be considered for rendering
      + Tweaked: ConfigItem UI now shows track indices without a trailing .0
      + Fixed: ConfigItem UI would not show the "human-readable" file format name
      + Fixed: Regular item notes would trigger the NameSwitch dialogue
      + Fixed: Selecting tracks (not folders) would result in a batch render instead of a single file render
      + Fixed: $tracknameornumber could be overwritten by the regular $track wildcard
      + Fixed: Folders removed from the Manager would use their stored manager settings for rendering
      + Fixed: Changing the opened project would not immediately load the project's Manager group data
      + Fixed: Various other, smaller bugfixes
]] ----------------------------------------------------------------------------------------

SkipLicenseGui = false
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

-- Run Shared
local sep = package.config:sub(1, 1)
dofile((currentFolder or "") .. DTAV .. sep .. "runShared" ..
    (reaper.file_exists((currentFolder or "") .. DTAV .. sep .. "runShared.lua") and ".lua" or ".dat"))

if not LAx_init then
    return
end

----------------------------------------------------------------------------------------
-- Run main file
runFile(reaper.GetExtState("LAx_RenderBuddy", "Directory") .. DTAV .. sep .. "rendering" .. sep .. "render", true)
