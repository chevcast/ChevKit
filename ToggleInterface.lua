function SetLayoutProfileByName(layoutName)
	local layouts = C_EditMode.GetLayouts().layouts
	for index, layout in ipairs(layouts) do
		if layout.layoutName == layoutName then
			C_EditMode.SetActiveLayout(index + 2)
			return
		end
	end
end

function ActivateControllerMode(layoutName)
	if not C_AddOns.IsAddOnLoaded("ConsolePort") then
		C_AddOns.EnableAddOn("ConsolePort")
	end
	SetLayoutProfileByName(layoutName or "PC")
	SetActionBarToggles(false, false, false, false, false, false, false)
	MultiActionBar_Update()
	ClassTalentHelper.SwitchToLoadoutByName("Controller")
	ReloadUI()
end

function ActivateKeypadMode(layoutName)
	if C_AddOns.IsAddOnLoaded("ConsolePort") then
		C_AddOns.DisableAddOn("ConsolePort")
	end
	SetLayoutProfileByName(layoutName or "PC")
	for i = 2, 8 do
		SetActionBarToggles(i, true)
	end
	SetActionBarToggles(true, true, true, true, true, true, true)
	MultiActionBar_Update()
	ClassTalentHelper.SwitchToLoadoutByName("Keypad")
	ReloadUI()
end
