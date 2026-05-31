--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 3.09
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
    * v3.09
      + Added: Ability to set per-folder sample rate
      + Tweaked: Most windows can now be closed with ESC
      + Tweaked: When previewing a track that is registered in the Manager, the settings will now be saved in the Manager
      + Tweaked: Render preview gui now has scrollable file preview (if there are enough files/regions to be rendered)
      + Fixed: Saving settings in RenderSettings would save all settings on a ConfigItm, not just the changed one(s)
      + Fixed: Crashes when no settings where set and switching to Project Defaults in the render window
      + Fixed: Possible crash when having "collapse folders during preview" enabled
      + Fixed: Various other bug fixes and code hygiene
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
