-- @description A lightning-fast, context-sensitive one-button render solution for SFX and library creation.
-- @author Leon 'LAxemann' Beilmann
-- @version 0.90
-- @about
-- # About
-- Key features include:
-- -Automatic detection and clustering of SFX variations
-- -Context-sensitivity: A single click can allow you to render based on selected items, selected tracks or track folders and their children
-- -Support for sequential batch-rendering of multiple track folders
-- -No real previous project preparation, no real workflow adherence required
-- -Key modifiers for setting custom names before rendering, using previous settings, keeping the created render regions or processing and rendering all subfolders of selected folders in sequence
--
--  # Requirements
--  JS_ReaScriptAPI, SWS Extension
-- @links
--  Website https://www.youtube.com/@LAxemann
-- @provides 
--    **/*.dat
--   [main] *.lua
--   [nomain] ReadMe.txt TODO: PDF?
--   [nomain] Changelog.txt
--   [data] toolbar_icons/**/*.png
-- @changelog
--	 0.90 Release staging


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
