function ClearAllActionBars()
	-- Iterate over all action bars
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		-- Clear each action bar
		ClearActionBar(i)
	end

	-- ElvUI adds extra action bars, so we need to clear those as well
	local numExtraBars = GetNumShapeshiftForms()
	for i = 1, numExtraBars do
		-- Clear each extra action bar
		ClearActionBar(i + NUM_ACTIONBAR_BUTTONS)
	end
end

function ClearActionBar(bar)
	-- Iterate over all buttons on the action bar
	for i = 1, 12 do
		-- Get the action ID for the button
		local actionID = (bar - 1) * 12 + i
		-- Clear the action
		PickupAction(actionID)
		ClearCursor()
	end
end
