local mod = get_mod("LockedAndLoaded")

mod.reloaded_ready = false
mod.reloaded_gui = nil

--[[
	Functions
--]]

mod.check_if_range_is_reloaded = function()
	if Managers and Managers.player then
		local local_player = Managers.player:local_player()

		if local_player and local_player.player_unit then
			local inventory_extension = ScriptUnit.extension(local_player.player_unit, "inventory_system")

			if inventory_extension then
				local equipment = inventory_extension.equipment(inventory_extension)

				if equipment then
					local slot_ranged = equipment.slots["slot_ranged"]

					if slot_ranged then
						local slot_data = slot_ranged.item_data
						local item_type = slot_data.item_type

						local right = slot_ranged.right_unit_1p
						local left = slot_ranged.left_unit_1p

						local ammo_ext = GearUtils.get_ammo_extension(right, left)

						if ammo_ext then
							local ammo_loaded = ammo_ext:ammo_count()

							local icon_size = math.floor(32 * RESOLUTION_LOOKUP.scale)
							local icon_x = math.floor(RESOLUTION_LOOKUP.res_w - icon_size - (RESOLUTION_LOOKUP.res_w *  RESOLUTION_LOOKUP.scale * 0.075))
							local icon_y = math.floor(icon_size + (RESOLUTION_LOOKUP.res_h *  RESOLUTION_LOOKUP.scale * 0.1))

							if ammo_loaded > 0 then
									Gui.bitmap(mod.reloaded_gui, 'reloaded_yes', Vector2(icon_x, icon_y), Vector2(icon_size, icon_size), Color(150,0,255,0))
							else
									Gui.bitmap(mod.reloaded_gui, 'reloaded_nope', Vector2(icon_x, icon_y), Vector2(icon_size, icon_size), Color(150,255,0,0))
							end

						end
					end
				end
			end
		end
	end
end

mod.create_gui = function(self)
	if Managers.world:world("top_ingame_view") then
		local top_world = Managers.world:world("top_ingame_view")

		-- Create a screen overlay with specific materials we want to render
		mod.reloaded_gui = World.create_screen_gui(top_world, "immediate",
			"material", "materials/LockedAndLoaded/reloaded"
		)
	end
end

mod.destroy_gui = function(self)
	if Managers.world:world("top_ingame_view") then
		local top_world = Managers.world:world("top_ingame_view")
		World.destroy_gui(top_world, mod.reloaded_gui)
		mod.reloaded_gui = nil
	end
end

--[[
	Hooks
--]]

-- Hook to perform updates to UI
mod:hook("MatchmakingManager.update", function(func, self, dt, ...)
	if mod.reloaded_ready and Managers.world:world("level_world") then
		if not mod.reloaded_gui and Managers.world:world("top_ingame_view") then
			mod:create_gui()
		end

		mod.check_if_range_is_reloaded()
	end

	func(self, dt, ...)
end)

mod.mission_windows = {
	"MatchmakingStateIngame",
	"StartGameView", --Select Mission screens
	"VMFOptionsView", --VMF options
	--[["StartGameWindowAdventure",
	"StartGameWindowAdventureSettings",
	"StartGameWindowDifficulty",
	"StartGameWindowGameMode",
	"StartGameWindowLobbyBrowser",
	"StartGameWindowMission",
	"StartGameWindowMissionSelection",
	"StartGameWindowMutator",
	"StartGameWindowMutatorGrid",
	"StartGameWindowMutatorList",
	"StartGameWindowMutatorSummary",
	"StartGameWindowSettings",
	"StartGameWindowTwitchGameSettings",
	"StartGameWindowTwitchLogin",--]]

	"StateTitleScreenMainMenu",
	"CharacterSelectionView",
	"StartMenuView",
	"OptionsView",
	"HeroView"
}

for _, i in pairs(mod.mission_windows) do
	mod:hook(i ..".on_enter", function(func, ...)
		func(...)

		mod.reloaded_ready = false
	end)

	mod:hook(i ..".on_exit", function(func, ...)
		func(...)
		mod.reloaded_ready = true
	end)
end

mod:hook("StateInGameRunning.on_exit", function(func, ...)
	func(...)

	mod.reloaded_ready = false
end)

mod:hook("StateInGameRunning.event_game_started", function(func, ...)
	func(...)

	mod.reloaded_ready = true
end)

--[[
	Callback
--]]

-- Call on every update to mods
mod.update = function(dt)
	return
end

-- Call when all mods are being unloaded
mod.on_unload = function(exit_game)
	if mod.reloaded_gui and Managers.world:world("top_ingame_view") then
		mod:destroy_gui()
	end

	return
end

-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
	return
end

-- Call when setting is changed in mod settings
mod.on_setting_changed = function(setting_name)
	return
end

-- Call when governing settings checkbox is unchecked
mod.on_disabled = function(is_first_call)
	mod.reloaded_ready = true
	mod:disable_all_hooks()
end

-- Call when governing settings checkbox is checked
mod.on_enabled = function(is_first_call)
	mod:echo('LockedAndLoaded Initialized')
	mod.reloaded_ready = true
	mod:enable_all_hooks()
end


--[[
	Execution
--]]
