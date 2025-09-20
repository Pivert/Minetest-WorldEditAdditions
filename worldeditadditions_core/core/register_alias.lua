
local wea_c = worldeditadditions_core

local function register_alias(cmdname_target, cmdname_source, override)
	if override == nil then override = false end
	
	local def_source = wea_c.fetch_command_def(cmdname_source)
	
	if not def_source then
		minetest.log("error", "worldeditadditions_core: Failed to register alias for "..cmdname_source.." → "..cmdname_target..", as the source command doesn't exist.")
		-- Clean up any existing nil entries that might have been created
		wea_c.registered_commands[cmdname_target] = nil
		if minetest.global_exists("worldedit") then
			worldedit.registered_commands[cmdname_target] = nil
		end
		return false
	end
	
	if wea_c.fetch_command_def(cmdname_target) and not override then
		minetest.log("error", "worldeditadditions_core: Failed to register alias for "..cmdname_source.." → "..cmdname_target..", as the target command exists and override wasn't set to true.")
		return false
	end
	
	-- print("DEBUG ALIAS source "..cmdname_source.." target "..cmdname_target)
	
	if minetest.registered_chatcommands["/" .. cmdname_target] then
		minetest.override_chatcommand(
			"/"..cmdname_target,
			minetest.registered_chatcommands["/" .. cmdname_source]
		)
	else
		minetest.register_chatcommand(
			"/"..cmdname_target,
			minetest.registered_chatcommands["/" .. cmdname_source]
		)
	end
	-- Only register the alias if the source command exists in our registry
	local source_def = wea_c.registered_commands[cmdname_source]
	if source_def then
		wea_c.registered_commands[cmdname_target] = source_def
	else
		-- Fallback to WorldEdit registry
		if minetest.global_exists("worldedit") and worldedit.registered_commands then
			source_def = worldedit.registered_commands[cmdname_source]
			if source_def then
				worldedit.registered_commands[cmdname_target] = source_def
			end
		end
	end
end


return register_alias
