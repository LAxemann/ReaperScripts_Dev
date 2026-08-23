--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 3.31
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
    * v3.31
      + Added: RenderStats now show the rendered waveform, including preview functionality by clicking and using spacebar
      + Added: c_MutationJournal now handles and tracks project mutations, allowing it to identify and keep user-intended changes 
      + Added: Toolbar icons for all actions that were missing them
      + Tweaked: Made preview track deletion handling more robust
      + TWeaked: Existing toolbar icons
      + Fixed: Setting the preview track height to 0 did not actually disable the creation of a preview track
      + Fixed: The Config Item GUI could save the wrong render format value
      + Fixed: The manager tooltip example for numbering single files was reversed
      + Fixed: Double-clicking a specific Config Item would always open the settings of the first Config Item on the track
      + Fixed: (Project) Wildcards should no longer carry over into new/empty projects and cause trouble 
      + Fixed: CTRL + A selection now also allows for batch-render selection within the Manager
      + Fixed: Interplay between setting changes of folder using project defaults and project default settings
      + Fixed: RenderStats should no longer put info in the wrong line when not normalizing files
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
