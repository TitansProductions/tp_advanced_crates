local TP                              = nil


local spawnedCoords                   = {}

local isLootSearched, spawnedCrate    = false, false

local blipA, blipB                    = nil, nil

local isPlayerDead = false

TriggerEvent('esx:getSharedObject', function(obj) 
    TP = obj 

    Citizen.Wait(5000)

    TP.TriggerServerCallback('tp-advancedcrates:fetchLootInformation', function(data)

        if data.spawned then

            spawnedCrate     = data.spawned
            spawnedCoords    = data.coords
            isLootSearched   = data.searched

            TriggerEvent('tp-advancedcrates:createLootBlip', spawnedCoords)
        end
    end)

end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isPlayerDead = true
end)

AddEventHandler('playerSpawned', function()
    isPlayerDead = false
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	RemoveBlip(blipA) RemoveBlip(blipB)
	
	spawnedCoords                   = {}

end)

RegisterNetEvent('tp-advancedcrates:createLootObjectCoords')
AddEventHandler('tp-advancedcrates:createLootObjectCoords', function(coords, searched)
    spawnedCrate   = true

    spawnedCoords  = {
        x = coords.x,
        y = coords.y,
        z = coords.z
    }

    isLootSearched = false

end)

RegisterNetEvent("tp-advancedcrates:setClientLootObjectAsSearched")
AddEventHandler("tp-advancedcrates:setClientLootObjectAsSearched", function()
    isLootSearched = true
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local sleep = true

		if spawnedCrate and not isLootSearched then

			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local lootFound = false

			local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, spawnedCoords.x, spawnedCoords.y, spawnedCoords.z, true)
	
			if dist < 3.0  then
				sleep = false

				TP.ShowHelpNotification(_U("start_crate_searching"))
	  
				if IsControlJustReleased(0, 38) then

					if Config.ClosestPlayersCheck then
						local closestPlayer, closestDistance = TP.Game.GetClosestPlayer()
		
						if closestPlayer == -1 or closestDistance > 3.0 then
							startSearching(Config.CrateSearchTime, 'amb@prop_human_bum_bin@base', 'base')
						else
							TP.ShowNotification("~r~You cannot do this action while there is another player interacting with you.")
						end
					else
						startSearching(Config.CrateSearchTime, 'amb@prop_human_bum_bin@base', 'base')
					end

				end
			end
		end

		if sleep then
			Citizen.Wait(2000)
		end
	end
end)

function startSearching(time, dict, anim)
	local animDict = dict
	local animation = anim
	local ped = PlayerPedId()
  
	canSearch = false
  
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Wait(100)
		RequestAnimDict(animDict)
	end
  
	if Config.OpeningCrateProgressBars then
		exports['progressBars']:startUI(time, Config.OpeningCratePBText)
	end

	TaskPlayAnim(ped, animDict, animation, 8.0, 8.0, time, 1, 1, 0, 0, 0)
  
	local ped = PlayerPedId()
  
	Wait(time)

	TriggerEvent("tp-advancedcrates:openBasedUI")
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		if spawnedCrate and not isLootSearched then

			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)

			local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, spawnedCoords.x, spawnedCoords.y, spawnedCoords.z, true)
	
			if dist <= 100.0  then
				startParticleSmoke(spawnedCoords.x, spawnedCoords.y, spawnedCoords.z, true)
			end
		end

	end
end)


function startParticleSmoke(posx, posy, posz)

	if Config.CrateParticleSmokes then

		if not HasNamedPtfxAssetLoaded("scr_gr_def") then
			RequestNamedPtfxAsset("scr_gr_def")
			while not HasNamedPtfxAssetLoaded("scr_gr_def") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("scr_gr_def")
		local smoke = StartParticleFxLoopedAtCoord("scr_gr_def_package_flare", posx, posy, posz, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 1.0)
		SetParticleFxLoopedColour(smoke, 255, 0, 0, 0)
		Citizen.Wait(22000)
		StopParticleFxLooped(smoke, 0)

	end

end

RegisterNetEvent('tp-advancedcrates:createLootBlip')
AddEventHandler('tp-advancedcrates:createLootBlip', function(randomCoords)

	blipA = AddBlipForRadius(randomCoords.x, randomCoords.y, randomCoords.z, Config.BlipComponents.circleRadious)

	SetBlipHighDetail(blipA, true)
	SetBlipDisplay(blipA, 4)
	SetBlipColour(blipA, Config.BlipComponents.colour)
	SetBlipAlpha (blipA, Config.BlipComponents.alpha)

	blipB = AddBlipForCoord(randomCoords.x, randomCoords.y, randomCoords.z)
	SetBlipSprite(blipB, Config.BlipComponents.sprite)
	SetBlipDisplay(blipB, 4)
	SetBlipScale(blipB, Config.BlipComponents.scale)
	SetBlipColour(blipB, Config.BlipComponents.colour)
	SetBlipAsShortRange(blipB, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.BlipComponents.title)
	EndTextCommandSetBlipName(blipB)
end)

RegisterNetEvent('tp-advancedcrates:removeCrateInformation')
AddEventHandler('tp-advancedcrates:removeCrateInformation', function()

	RemoveBlip(blipA) RemoveBlip(blipB)

	spawnedCrate                    = false

	spawnedCoords                   = nil
	spawnedCoords                   = {}

	closeBaseUI()
end)