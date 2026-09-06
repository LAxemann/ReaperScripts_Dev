--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 3.37
 Provides:
  [main] *.lua
  [data] toolbar_icons/**/*.png
  [nomain] images/*.png
  [nomain] *.pdf
  **/*.dat
 About:
  # LAx_RenderBuddy

  ## A lightning-fast, context-sensitive one-button render solution for SFX and library creation.

--[[
 * Changelog:
    * v3.37
      + General: Release Candidate
      + Added: Manual version check
      + Added: "Auto save after close" setting
      + Added: Warning when saving projects during rendering process
      + Tweaked: When switching projects with the render interface open, RenderBuddy should now properly shut down
      + Tweaked: Wildcard manager now shows the full wildcard when hovering
      + Fixed: Cancelling the render confirmation window would discard the saved original render matrix
      + Fixed: The settings would not toggle the action's icon state
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
