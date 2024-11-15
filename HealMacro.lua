local macroName = "HealMacro"

local inCombat = {
	{ "Crimson Vial", "spell" },
	{ "Healthstone", "item" },
	{ '"Third Wind" Potion', "item" },
	{ "Cavedweller's Delight", "item" },
	{ "Algari Healing Potion", "item" },
}

local outOfCombat = {
	{ "Crimson Vial", "spell" },
	{ "Conjured Mana Bun", "food" },
	{ "Beledar's Bounty", "food" },
	{ "Chalcocite Lava Cake", "food" },
	{ "Rocky Road", "food" },
	{ "Stone Soup", "food" },
	{ "Crystal Tots", "food" },
	{ "Granite Salad", "food" },
}

function HealMacro()
	C_Timer.After(0.1, function()
		local isInCombat = UnitAffectingCombat("player")
		print("isInCombat: " .. tostring(isInCombat))
		local abilities = isInCombat and inCombat or outOfCombat
		for _, ability in ipairs(abilities) do
			local abilityName = ability[1]
			local abilityType = ability[2]
			local isActive = false
			if abilityType == "spell" then
				local spellInfo = C_Spell.GetSpellCooldown(abilityName)
				isActive = spellInfo.isEnabled == true
					and (spellInfo.startTime == 0 or (spellInfo.startTime + spellInfo.duration - GetTime()) <= 0)
			elseif abilityType == "item" then
				local itemID = GetItemInfoInstant(abilityName)
				local start, duration, enabled = C_Item.GetItemCooldown(itemID)
				isActive = enabled == 1 and (start == 0 or (start + duration - GetTime()) <= 0)
			elseif abilityType == "food" then
				isActive = GetItemCount(abilityName) > 0
			end
			if isActive then
				local macroIndex = GetMacroIndexByName(macroName)
				local macroBody = "#showtooltip "
					.. abilityName
					.. "\n\n/cast "
					.. abilityName
					.. "\n\n/script HealMacro()"
				if macroIndex == 0 then
					CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroBody, 1)
				else
					EditMacro(macroName, nil, nil, macroBody)
				end
				return true
			end
		end
	end)
end

local frame = CreateFrame("Frame")

local events = {
	"UNIT_AURA",
	"ACTIONBAR_UPDATE_COOLDOWN",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
}

for _, event in ipairs(events) do
	frame:RegisterEvent(event)
end

frame:SetScript("OnEvent", function(self, event, ...)
	if tContains(events, event) then
		HealMacro()
	end
end)
