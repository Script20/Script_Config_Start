-- Getting player and inventory information for inserting items into correct places
script.on_event(defines.events.on_cutscene_cancelled, function(event)
	local player = game.players[event.player_index]
	local inventories = {
		defines.inventory.player_armor,
		defines.inventory.player_main,
		defines.inventory.player_quickbar,
		defines.inventory.player_guns,
		defines.inventory.player_ammo,
		defines.inventory.player_tools,
		defines.inventory.player_vehicle,
		defines.inventory.player_player_trash
	}
	
	-- creating the presets of start items you can choose from
	local kits = {}
	
	kits["small"] = {}
	kits["small"]["quickbar"] = {
		{1, "transport-belt"},
		{2, "underground-belt"},
		{3, "splitter"},
		{4, "inserter"},
		{5, "medium-electric-pole"},
        {6, "burner-mining-drill"},
        {7, "stone-furnace"},
		{10, "car"}
	}
	kits["small"]["items"] = {
		{"iron-plate", 200},
		{"copper-plate", 200},
		{"iron-gear-wheel", 50},
		{"transport-belt", 500},
		{"splitter", 50},
		{"underground-belt", 50},
		{"burner-mining-drill", 20},
		{"stone-furnace", 20},
		{"coal", 100}
	}
	
	kits["medium"] = {}
	kits["medium"]["quickbar"] = {
		{1, "transport-belt"},
		{2, "underground-belt"},
		{3, "splitter"},
		{4, "inserter"},
		{5, "medium-electric-pole"},
        {6, "electric-mining-drill"},
		{10, "car"}
	}
	kits["medium"]["items"] = {
		{"iron-plate", 400},
		{"copper-plate", 400},
		{"transport-belt", 1000},
		{"underground-belt", 50},
		{"splitter", 50},
		{"stone-furnace", 100},
		{"assembling-machine-1", 50},
		{"inserter", 100},
		{"long-handed-inserter", 50},
		{"steel-chest", 50},
		{"electric-mining-drill", 50},
		{"medium-electric-pole", 200},
		{"boiler", 10},
		{"steam-engine", 20},
		{"offshore-pump", 1},
		{"pipe-to-ground", 50},
		{"pipe", 50},
		{"car", 1},
		{"coal", 200},
		{"lab", 8},
		{"power-armor", 1}
	}
	kits["medium"]["armorItems"] = {
		{"fusion-reactor-equipment"},
		{"personal-roboport-equipment"},
		{"personal-roboport-equipment"},
		{"battery-equipment"},
		{"battery-equipment"}
	}
	
	kits["big"] = {}
	kits["big"]["quickbar"] = {
		{1, "transport-belt"},
		{2, "underground-belt"},
		{3, "splitter"},
		{4, "inserter"},
		{5, "medium-electric-pole"},
		{10, "car"}
	}
	kits["big"]["items"] = {
		{"power-armor", 1},
		{"iron-plate", 400},
		{"copper-plate", 400},
		{"transport-belt", 1000},
		{"underground-belt", 50},
		{"splitter", 50},
		{"steel-furnace", 50},
		{"assembling-machine-2", 50},
		{"inserter", 50},
		{"iron-chest", 50},
		{"electric-mining-drill", 50},
		{"medium-electric-pole", 100},
		{"big-electric-pole", 10},
		{"boiler", 20},
		{"steam-engine", 40},
		{"offshore-pump", 1},
		{"pipe-to-ground", 100},
		{"pipe", 100},
		{"car", 1},
		{"lab", 10}
	}
	kits["big"]["armorItems"] = kits["medium"]["armorItems"]
	kits["big"]["technologies"] = {
		{"automation"}
	}
	
	-- Creating setting options and setting default option to "Medium"
	local kitSetting = settings.startup["script-config-start"].value
	local kit = kits[kitSetting]
	if kit == nil then
		kit = kits["medium"]
	end
	
	-- Setup quickbar favorites
    for k,v in pairs(kit["quickbar"]) do
        player.set_quick_bar_slot(v[1], v[2])
    end
    
    -- Removing stardard items
    local playerInventory = player.get_main_inventory()
    playerInventory.remove({name="iron-plate", count=8})
    playerInventory.remove({name="burner-mining-drill", count=1})
    playerInventory.remove({name="stone-furnace", count=1})
    playerInventory.remove({name="wood", count=1})
	
	-- Adding items to your inventory
	for k,v in pairs(kit["items"]) do
		player.insert{name = v[1], count = v[2]}
	end
	
	-- finding your armour slot but checking to see if it's there as sandbox doesn't have a armor slot
	-- Also adding items into your armors grid
	if kit["armorItems"] ~= nil then
		
		for k,v in pairs(inventories) do
			
			local inventory = player.get_inventory(v)
			if inventory ~= nil then
				
				local armor = inventory.find_item_stack("power-armor")
				if armor ~= nil then
					
					local grid = armor.grid
					for k,v in pairs(kit["armorItems"]) do
						grid.put{name = v[1]}
					end
					break
				end
			end
		end
	end
	
	-- Unlocking the technologie in config preset "Big"
	if kit["technologies"] ~= nil then
		
		for k,v in pairs(kit["technologies"]) do
			player.force.technologies[v[1]].researched = true
		end
	end
	
end)