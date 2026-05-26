--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 3.06
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
    * v3.06
      + Added: Custom, user-defined wildcards, configurable globally or per-project via the new WildcardManager
      + Added: ConfigItems (Via 'Create or edit ConfigItem') for item-based folder-specific rendering configuration
      + Added: Ability to set render patterns per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set render channel count per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set the render directory per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set the default Render Pattern in Settings
      + Added: Region creation can now be previewed per-folder before rendering
      + Added: Startup Action (Allowing to edit ConigItems via double-click)
      + Added: Custom Render overview displaying all files-to-be-rendered, highlighting potential overwrites
      + Added: Render overview allows to only display new or only display overwritten files
      + Added: Custom post-render window, optionally gathering and combining renderStats
      + Added: Manager: Ability to quickly render a single track/folder from Manager via right-click menu
      + Added: Optional settings to make folders flash when selecting them in the Manager
      + Added: Right-click context menu in empty Manager field to select all folders
      + Added: Ability to check for script version updates
      + Added: Ability to blacklist tracks for rendering
      + Tweaked: Manager: The selection is now cleared when clicking into empty space
      + Tweaked: Overall color scheme (Old one is available as "RenderBuddy (Legacy)"" in the options)
      + Tweaked: RenderBuddy wildcards now work properly in the "Render to" field
      + Tweaked: Reaper region indices are now created in order
      + Tweaked: Manager: Groups interface
      + Tweaked: Manager: Now auto-updates after certain changes in the project
      + Tweaked: Manager: Selecting or deselecting for rendering will now apply to all selected rows
      + Tweaked: Project default settings have a dedicated editing area for less ambiguity
      + Tweaked: Various small changes to the Reaper rendering interface (When rendering via RenderBuddy)
      + Tweaked: Complete code refactor
      + Tweaked: Major performance improvements (40.000+ items + region creation in < 0.1s)
      + Tweaked: Manager data is no longer stored in ExtState
      + Tweaked: Links should open faster
      + Fixed: The Manager will now register newly created tracks on the first click
      + Fixed: The Manager's "Scroll mode" now works properly
      + Fixed: The Manager "Folder" column would be wider than the input field
      + Fixed: The Manager would not save its docking ID when closed via script termination
      + Removed: Manual naming mode/shortcut (Obsolete due to nameSwitches etc)
      + Removed: Render Subfolders Action (Many other options including the Manager)
      + Removed: "Only Create Regions" Action (Regions can now be "baked" from the Render Window)
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
