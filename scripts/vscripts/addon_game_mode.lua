-- Generated from template

if BrewlitGameMode == nil then
	_G.BrewlitGameMode = class({})
end

if Brewlit == nil then
	_G.Brewlit = class ({})
end

--used for built-in engine events
if Event == nil then
	_G.Event = class ({})
end

--used for game state events
if GameState == nil then
	_G.GameState = class ({})
end

require('main')
require('brewlit/setup')
require('brewlit/event')
require('brewlit/game_state_manager')
require('brewlit/player_helper')
require('brewlit/game_time')
require('brewlit/item_manager')
require('brewlit/helper')
require('brewlit/find')
require('brewlit/hud')
require('brewlit/ability')
require('brewlit/task')
require('brewlit/camera')
require('brewlit/input')
require('brewlit/animation')
require('brewlit/quests')

_G.debugging = true

function Precache(context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	--PrecacheResource( "model", "models/heroes/dragon_knight/dragon_knight.vmdl", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = BrewlitGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function BrewlitGameMode:InitGameMode()
	ListenToGameEvent("game_rules_state_change", GameStateManager.OnChangeState, nil)
	
	--listen to commands form the HUD
	CustomGameEventManager:RegisterListener("debug", DebuggerCommand)
	
	--start scripting
	Brewlit:Start()
	
	--create listener for same abilities mode when units spawn
	Event:OnUnitSpawned(
		function(event)
			Ability:UseSameAbilities(event.unit)
		end)
	
	--initalize GameStateManager
	GameStateManager:Init()
	
	--initalize task updating
	local gameMode = GameRules:GetGameModeEntity()
	gameMode:SetContextThink("Tasks", Task.update, 0.03)
	
	--listens to changes to input
	CustomGameEventManager:RegisterListener("input", Input.Update)
end

--[[
	input.playerid : playerid of this input
	input.move_x : horizontal input (-1, 0 or 1) i.e A,D
	input.move_y : vertical input (-1, 0 or 1) i.e. W,S
	input.cursor_x : cursor horizonal position (value from -1 to 1 and 0 is center) 
	input.cursor_y : cursor vertical position (value from -1 to 1 and zero is center) 
	
	To remove/change direction input keys change addoninfo.txt
]]

function clockTest()
	print("testing")
end

--Logs a message to the debugger
function Brewlit:Log(msg, logType)
	if logType == nil then
		logType = "default";
	end
	
	CustomNetTables:SetTableValue("debug", "log", {logType = logType, msg = msg, t = GameTime:SinceStart()})
end

--logs a vector into the debugger
function Brewlit:LogVector(vec, vecName, logType)
	local msg = vecName .. ": (" .. string.format("%.1f", vec.x) .. ", " .. string.format("%.1f", vec.x) .. ", " .. string.format("%.1f", vec.x) .. ")"
	Brewlit:Log(msg, logType)
end

--Callback function for commands issued by the user from the debugger
function DebuggerCommand(index, data)
	if data['command'] == "pause" then
		PauseGame(not GameRules:IsGamePaused())
	end
end
