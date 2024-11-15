local mechanicalGroundMounts = {
	"Mechacycle Model W",
	"Warlord's Deathwheel",
	"X-995 Mechanocat",
	"Scrapforged Mechaspider",
}

local mechanicalFlyingMounts = {
	"Steamscale Incinerator",
	"Delver's Dirigible",
	"Scrapforged Mechaspider",
	"Rustbolt Resistor",
}

local mechanicalPassengerMounts = {
	"Delver's Dirigible",
	"X-53 Touring Rocket",
	"Orgrimmar Interceptor",
}

local mechanicalGroundPets = {
	"Alloyed Alleyrat",
	"Arachnoid Skitterbot",
	"Iron Starlette",
	"Stonegrinder",
	"Clanking Scrapsorter",
	"H4ND-EE",
	"Malfunctioning Microbot",
	"Specimen 97",
	"Cogblade Raptor",
	"Anodized Robo Cub",
	"Robo-Chick",
	"Tiny Harvester",
	"Fluxfire Feline",
	"Gilded Mechafrog",
	"Lifelike Mechanical Frostboar",
	"Lil' Bling",
	"Lost Robogrip",
	"Microbot XD",
	"OOX-35/MG",
	"Spraybot 0D",
	"Warbot",
	"Mechanopeep",
	"Utility Mechanoclaw",
	"Blue Clockwork Rocket Bot",
}

local mechanicalFlyingPets = {
	"Timeless Mechanical Dragonling",
	"Feathers",
}

local usedMounts = {}

function SummonRandomMechanicalMount()
	if IsFlyableArea() then
		SummonRandomMechanicalFlyingMount()
	else
		SummonRandomMechanicalGroundMount()
	end
end

function SummonRandomMechanicalGroundMount()
	SummonRandomPet(mechanicalGroundPets)
	SummonRandomMount(mechanicalGroundMounts)
end

function SummonRandomMechanicalFlyingMount()
	SummonRandomPet(mechanicalFlyingPets)
	SummonRandomMount(mechanicalFlyingMounts)
end

function SummonRandomMechanicalPassengerMount()
	SummonRandomPet(mechanicalFlyingPets)
	SummonRandomMount(mechanicalPassengerMounts)
end

function GetMountIDByName(name)
	local mountIDs = C_MountJournal.GetMountIDs()
	for _, mountID in ipairs(mountIDs) do
		local mountName = C_MountJournal.GetMountInfoByID(mountID)
		if mountName == name then
			return mountID
		end
	end
	return nil
end

function SummonRandomMount(mounts)
	if IsMounted() then
		Dismount()
		return
	end
	local filteredMounts = {}
	for _, mountName in ipairs(mounts) do
		if not tContains(usedMounts, mountName) then
			table.insert(filteredMounts, mountName)
		end
	end
	if #filteredMounts == 0 then
		usedMounts = {}
		filteredMounts = mounts
	end
	local mountName = filteredMounts[math.random(#filteredMounts)]
	local mountID = GetMountIDByName(mountName)
	if mountID then
		C_MountJournal.SummonByID(mountID)
		table.insert(usedMounts, mountName)
	else
		print("Mount not found: " .. mountName)
	end
end

function SummonRandomPet(pets)
	if IsMounted() then
		return
	end
	local petName = pets[math.random(#pets)]
	local petID
	local numPets = C_PetJournal.GetNumPets()
	for i = 1, numPets do
		local petGUID, _, _, _, _, _, _, petNameFromJournal = C_PetJournal.GetPetInfoByIndex(i)
		if petNameFromJournal == petName then
			petID = petGUID
			break
		end
	end
	if petID and petID ~= C_PetJournal.GetSummonedPetGUID() then
		C_PetJournal.SummonPetByGUID(petID)
	end
end
