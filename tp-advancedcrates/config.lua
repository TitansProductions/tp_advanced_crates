Config                            = {}

Config.Locale                     = 'en'

-- ESX_Version: 1.1 or legacy, Example:  Config.ESX_Version = "1.1" / Config.ESX_Version = "legacy"
Config.ESX_Version = "1.1"    

Config.UseTestCommands            = true

Config.BlipComponents             = { title = "Daily Crate Event", circleRadious = 250.0, alpha = 128, sprite = 587, scale = 1.0, colour = 1 }

Config.CrateSpawningRealTime      = { ['23'] = 1, ['18'] = 2}

-- Checking every 15 minutes when the realtime-clock hits the CrateSpawningRealTime (Preferred: 15-30 minutes for avoiding running often tasks).
Config.SpawningTimeRefreshRate    = 1

Config.ServerConsoleMessages      = true
Config.ChatMessages               = true

Config.CrateSearchTime            = 2000

Config.OpeningCrateProgressBars   = true
Config.OpeningCratePBText         = " "

Config.CrateParticleSmokes        = true

-- When enabled, system is not allowing more than 1 players to open the Crate. This system made for avoiding any kind of glitch (suggested).
Config.ClosestPlayersCheck        = true

-- Objects found and located at   : https://forge.plebmasters.de/

-- [102012783]   (hei_prop_carrier_cargo_03a)  : https://assets.plebmasters.de/objects/MzMwODkwMDk3Mw.webm
-- [-1709880394] (hei_prop_carrier_cargo_04a)  : https://assets.plebmasters.de/objects/NTY4NDA5OTk1.webm
-- [388384482]   (hei_prop_carrier_cargo_05a)  : https://assets.plebmasters.de/objects/NDA1NjU3MjY5OQ.webm

Config.CrateObjects               = {102012783, -1709880394, 388384482}  

Config.CrateLocations = { 
    [1]  =  {  x = 2951.48, y = 1017.72, z = 9.72  },
    [2]  =  {  x = 3479.44, y = 2582.0,  z = 13.76  },
    [3]  =  {  x = 170.56,  y = 2263.84, z = 91.4   },
    [4]  =  {  x = -488.64, y = 5344.52, z = 81.6   },
	[5]  =  {  x = 2820.4,  y = -747.68, z = 15.84  },
	[6]  =  {  x = -373.12, y = 4710.76, z = 259.52 },
}

-- Crates Inventory

-- Include money in inventory?
Config.Includemoney = true
-- Include weapons in inventory?
Config.IncludeWeapons = true

Config.Limit = 30000
Config.DefaultWeight = 10
Config.userSpeed = false

Config.localWeight = {
    bread = 50,
    water = 50,
}

-- You can change your custom / replacement weapon names in inventory when displayed.
Config.WeaponLabelNames = {

    ['WEAPON_ADVANCEDRIFLE']  = "AUG",
    ['WEAPON_ASSAULTRIFLE']   = "AK47",
    ['WEAPON_COMPACTRIFLE']   = "AKS-74U",
    ['WEAPON_CARBINERIFLE']   = "M4A1",
    ['WEAPON_SPECIALCARBINE'] = "SCAR",
    ['WEAPON_COMBATPDW']      = "UMP .45",
    ['WEAPON_MICROSMG']       = "UZI",
    ['WEAPON_SMG']            = "MP5",

}


-- WEAPONS : All weapon model names can be found here: https://www.vespura.com/fivem/weapons/

-- count  : If you want a specific item or weapon to not always given to the player when opening a loot, mostly like randomly, 
-- you have to use ` math.random(0, 1) `, this is creating a random number between 0-1, 0 will return false and the item / weapon will not be given when opening a loot.

Config.LootSupplies   = {

	['A'] = {


		black_money = 0,
		money       = math.random(100, 500),


		items = {
            {name = 'water', label = "", count = math.random(1, 2)},
            {name = 'vest',  label = "", count = 1},
		},

		weapons = {
            {name = 'WEAPON_MINISMG',      label = "", count = math.random(0, 1), ammo = 0},
			{name = 'WEAPON_COMBATPISTOL', label = "", count = math.random(0, 1), ammo = 0},
			{name = 'WEAPON_HATCHET',      label = "", count = math.random(0, 1), ammo = 0},
		},

	},

	['B'] = {

		black_money = math.random(100, 500),
		money       = math.random(100, 500),

		items = {
            {name = 'water', label = "", count = math.random(1, 5)},
            {name = 'vest',  label = "",  count = 1},

		},

		weapons = {
            {name = 'WEAPON_MICROSMG', label = "", count = math.random(0, 1), ammo = 0},
			{name = 'WEAPON_SMG',      label = "", count = math.random(0, 1), ammo = 0},
			{name = 'WEAPON_MACHETE',  label = "", count = math.random(0, 1), ammo = 0},
		},
	},

	['C'] = {

		black_money = 0,
		money       = math.random(100, 500),

		items = {
            {name = 'water', label = "", count = math.random(1, 3)},
            {name = 'vest',  label = "", count = 1},

		},

		weapons = {
            {name = 'WEAPON_MACHINEPISTOL', label = "", count = math.random(0, 1), ammo = 0},
			{name = 'WEAPON_ASSAULTRIFLE',  label = "", count = math.random(0, 1), ammo = 0},
			{name = 'WEAPON_BAT',           label = "", count = math.random(0, 1), ammo = 0},
		},
	},

}