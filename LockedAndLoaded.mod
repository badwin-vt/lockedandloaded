return {
	run = function()
		fassert(rawget(_G, "new_mod"), "LockedAndLoaded must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("LockedAndLoaded", {
			mod_script       = "scripts/mods/LockedAndLoaded/LockedAndLoaded",
			mod_data         = "scripts/mods/LockedAndLoaded/LockedAndLoaded_data",
			mod_localization = "scripts/mods/LockedAndLoaded/LockedAndLoaded_localization"
		})
	end,
	packages = {
		"resource_packages/LockedAndLoaded/LockedAndLoaded"
	}
}
