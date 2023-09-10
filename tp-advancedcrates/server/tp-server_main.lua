TP                   = nil

local spawnedCoords, spawnedEntity, spawnedCrate  = {}, nil, false

local isLootSearched               = false

local crateInventoryType = nil
local crateInventory = {}

local spawnedHour = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    TP = obj 
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

    if spawnedCrate then
        DeleteEntity(spawnedEntity)
    end

end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(60000 * Config.SpawningTimeRefreshRate)
  
        time = os.date("*t") 
        local currentHour = table.concat({time.hour}, "-")
    
        if Config.CrateSpawningRealTime[currentHour] and spawnedHour ~= currentHour then
    
            if not spawnedCrate then
                spawnedCrate = true
                spawnedHour = currentHour

                startLootSpawning()

            else
                
                TriggerClientEvent('tp-advancedcrates:removeCrateInformation', -1)
                DeleteEntity(spawnedEntity)

                spawnedCoords                = nil
                spawnedCoords                = {}

                isLootSearched               = false

                crateInventory               = nil
                crateInventory               = {}

                spawnedEntity                = nil

                Wait(5000)
                spawnedHour = currentHour

                startLootSpawning()

            end
        end
    end
end)

function startLootSpawning()
    -- Creating random Coords for the crate to be spawned and the object that will be placed.
    local randomCoords    = Config.CrateLocations[math.random(#Config.CrateLocations)]
    local randomLootObject = Config.CrateObjects[math.random(#Config.CrateObjects)]
    
    -- Spawning object in a random location from Config.          
    local object = CreateObjectNoOffset(randomLootObject, randomCoords.x, randomCoords.y, randomCoords.z, true, false)
    FreezeEntityPosition(object, true)
    spawnedEntity = object
    
    -- Creating blip for the spawned crate location.

    spawnedCoords = {
        x = randomCoords.x, 
        y = randomCoords.y, 
        z = randomCoords.z
    }

    TriggerClientEvent('tp-advancedcrates:createLootObjectCoords', -1, spawnedCoords, false)
    TriggerClientEvent('tp-advancedcrates:createLootBlip', -1, spawnedCoords)
    

    local keyset = {}
  
    for k in pairs(Config.LootSupplies) do
        table.insert(keyset, k)
    end

    -- now you can reliably return a random key
    local crateType = keyset[math.random(#keyset)]


    crateInventoryType = crateType

    local itemsList = {}
    local weaponsList = {}

    for k,v in pairs(Config.LootSupplies) do
        if crateType == k then
            for _, item in pairs(v.items) do
    
                if item.count > 0 then

                    item.label = TP.GetItemLabel(item.name)
                    table.insert(itemsList, item)
                end
    
              end
    
              for _, weapon in pairs(v.weapons) do
    
                if weapon.count > 0 then

                    
                    weapon.label = TP.GetItemLabel(weapon.name)
                    table.insert(weaponsList, weapon)
                end
    
            end
        end

    end

    crateInventory = {
        money       = Config.LootSupplies[crateType].money,
        black_money = Config.LootSupplies[crateType].black_money,
        inventory   = itemsList,
        weapons     = weaponsList,


    }

    local currentTime = table.concat({time.hour, time.min}, ":")
    
    -- If Config.ServerConsoleMessages is enabled, it will print in the server console when a crate event started.
    if Config.ServerConsoleMessages then
        print("^2" .. _U('server_prefix') .. " - ["..currentTime.."] A new Daily Crate Event has been started.^7")
    end
    
    -- If Config.ChatMessages is enabled, there will be a notification for all the online players when a crate event started.
    if Config.ChatMessages then
    
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(86, 79, 151, 0.6); border-radius: 3px;">{0}: {1}</div>',
            args = { _U('server_prefix'), _U('daily_event_starting')}
        })
    
    end
end

RegisterServerEvent("tp-advancedcrates:setLootObjectAsSearched")
AddEventHandler("tp-advancedcrates:setLootObjectAsSearched", function()
	isLootSearched = true

    TriggerClientEvent("tp-advancedcrates:setClientLootObjectAsSearched", -1)
end)


TP.RegisterServerCallback("tp-advancedcrates:fetchLootInformation", function(source, cb)

    local data = {
        spawned = spawnedCrate, 
        coords = spawnedCoords, 
        searched = isLootSearched, 
    }

	cb(data)
end)


TP.RegisterServerCallback("tp-advancedcrates:getLootCrateInventory", function(source, cb, target)


    cb({inventory = crateInventory.inventory, money = crateInventory.money, black_money = crateInventory.black_money, weapons = crateInventory.weapons})

end)


RegisterServerEvent("tp-advancedcrates:tradePlayerItem")
AddEventHandler("tp-advancedcrates:tradePlayerItem", function(type, itemName, itemCount, clickedItemCount)
		local _source = source

		local targetXPlayer = TP.GetPlayerFromId(_source)

		if type == "item_standard" then

			local targetItem = targetXPlayer.getInventoryItem(itemName)

			if itemCount > 0 and clickedItemCount >= itemCount then

				targetXPlayer.addInventoryItem(itemName, itemCount)

                local inventory = crateInventory.inventory

                for key, value in pairs(inventory) do
                    if value.name == itemName then
                        value.count = value.count - itemCount
                    end
                end

			end

		elseif type == "item_money" then
			if itemCount > 0 and clickedItemCount >= itemCount then

				targetXPlayer.addMoney(itemCount)

                
                crateInventory.money = crateInventory.money - itemCount
            else
                TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")

            end
		elseif type == "item_black_money" then
			if itemCount > 0 and clickedItemCount >= itemCount then

				targetXPlayer.addAccountMoney("black_money", itemCount)

                crateInventory.black_money = crateInventory.black_money - itemCount
            else
                TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")
            end
		elseif type == "item_weapon" then
			if not targetXPlayer.hasWeapon(itemName) then

				targetXPlayer.addWeapon(itemName, itemCount)

                local inventory = crateInventory.weapons

                for key, value in pairs(inventory) do
                    if value.name == itemName then
                        value.label = "NOT_AVAILABLE"
                    end
                end
			else
                TriggerClientEvent('esx:showNotification', _source, "~r~You already carrying this weapon.")
            end
		end
	end
)

