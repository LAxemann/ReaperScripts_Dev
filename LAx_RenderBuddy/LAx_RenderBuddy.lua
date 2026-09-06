--[[
 ReaScript Name:LAx_RenderBuddy
 Author: Leon 'LAxemann' Beilmann
 REAPER: 6
 Extensions: SWS, JS_ReaScript_API, ReaImGui
 Version: 3.39
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
    * v3.39
	  + General: V3 is a complete, ground-up rewrite of RenderBuddy. Many thanks to all testers, allowing others to enjoy a more polished release!
      + Added: Custom, user-defined wildcards, configurable globally or per-project via the new WildcardManager. These wildcards can also be nested.
      + Added: ConfigItems (Via 'LAx_RenderBuddy - Create or edit ConfigItem.lua') for item-based folder-specific rendering configuration
      + Added: Ability to set the render directory per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set render file names per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set render channel count per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set sample rate per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set single file variation numbering per track/folder (Via ConfigItem or directly in Manager)
	  + Added: Ability to set render tails per track/folder (Via ConfigItem or directly in Manager)
	  + Added: Ability to set the render format per track/folder (Via ConfigItem or directly in Manager)
      + Added: Ability to set the default Render Pattern in Settings
	  + Added: A reworked render window, allowing to see more details as well as edit the project's render defaults
      + Added: Region creation can now be previewed per-folder before rendering
      + Added: Custom Render overview displaying all files-to-be-rendered, highlighting potential overwrites
      + Added: Render overview allows to only display new or only display overwritten files
      + Added: Custom post-render statistics window, including rendered file preview and optionally gathering and combining renderStats.htmls
      + Added: Manager: Ability to quickly render a single track/folder from Manager via right-click menu
      + Added: Optional settings to make folders flash when selecting them in the Manager
      + Added: Right-click context menu in empty Manager field to select all folders
      + Added: Ability to check for script version updates upon launch
      + Added: Ability to blacklist tracks or folders for rendering
      + Added: Custom NameSwitch Gui
      + Added: Startup Action (Allowing you to edit ConfigItems and NameSwitches via double-click and more)
	  + Added: On first launch, RenderBuddy will ask once if the user would like to automatically run the startup action
      + Added: Ability to automatically add all RenderBuddy actions to a (selectable) toolbar in Settings
      + Added: On first launch, RenderBuddy will ask once if the user would like to add all actions to a (selectable) toolbar 
	  + Added: $rbregionnumber wildcard which will always number RenderBuddy regions correctly even if there are other regions present
      + Added: A custom welcome window
      + Added: User guide to package distribution
      + Added: Ability to view the user guide via each window's options
      + Added: A "Autosave after close" setting
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
      + Tweaked: Major performance improvements (70.000+ items + region creation in ~ 0.01s)
      + Tweaked: Manager data is no longer stored in ExtState
      + Tweaked: Links should open faster
	  + Tweaked: Most windows can now be closed with the ESC key
	  + Tweaked: More robust handling of user-made changes to items and tracks during the render process
      + Fixed: The Manager will now register newly created tracks on the first click
      + Fixed: The Manager's "Scroll mode" now works properly
      + Fixed: The Manager "Folder" column would be wider than the input field
      + Fixed: The Manager would not save its docking ID when closed via script termination
	  + Fixed: Render window positioning on MacOS
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
