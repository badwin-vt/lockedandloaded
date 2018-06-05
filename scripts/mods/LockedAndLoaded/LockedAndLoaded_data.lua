local mod = get_mod("LockedAndLoaded")

-- Everything here is optional. You can remove unused parts.
return {
	name = "LockedAndLoaded",                               -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	is_mutator = false,                             -- If the mod is mutator
	mutator_settings = {},                          -- Extra settings, if it's mutator
	options_widgets = {                             -- Widget settings for the mod options menu
	}
}