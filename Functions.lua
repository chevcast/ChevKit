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

--------------------------------------

-- -- Create a minimap button
-- local minimapButton = CreateFrame("Button", "StateMachineMinimapButton", Minimap)
-- minimapButton:SetSize(32, 32)
-- minimapButton:SetFrameStrata("MEDIUM")
-- minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT")
--
-- -- Set the button textures
-- local icon = minimapButton:CreateTexture(nil, "BACKGROUND")
-- icon:SetTexture("Interface\\Icons\\INV_Misc_Map_01")
-- icon:SetSize(20, 20)
-- icon:SetPoint("CENTER")
--
-- local overlay = minimapButton:CreateTexture(nil, "OVERLAY")
-- overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
-- overlay:SetSize(54, 54)
-- overlay:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", -10, 10)
--
-- -- Make the button draggable
-- minimapButton:SetMovable(true)
-- minimapButton:EnableMouse(true)
-- minimapButton:RegisterForDrag("LeftButton")
-- minimapButton:SetScript("OnDragStart", function(self)
-- 	self:StartMoving()
-- end)
-- minimapButton:SetScript("OnDragStop", function(self)
-- 	self:StopMovingOrSizing()
-- end)
--
-- -- Create the main frame for the state machine visualizer
-- local function createStateMachineVisualizer()
-- 	local frame = CreateFrame("Frame", "StateMachineVisualizerFrame", UIParent, "BackdropTemplate")
-- 	frame:SetSize(600, 400)
-- 	frame:SetPoint("CENTER")
-- 	frame:SetBackdrop({
-- 		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
-- 		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
-- 		tile = true,
-- 		tileSize = 32,
-- 		edgeSize = 32,
-- 		insets = { left = 11, right = 12, top = 12, bottom = 11 },
-- 	})
-- 	frame:SetMovable(true)
-- 	frame:EnableMouse(true)
-- 	frame:RegisterForDrag("LeftButton")
-- 	frame:SetScript("OnDragStart", function(self)
-- 		self:StartMoving()
-- 	end)
-- 	frame:SetScript("OnDragStop", function(self)
-- 		self:StopMovingOrSizing()
-- 	end)
--
-- 	-- Close button
-- 	local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
-- 	closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
-- 	closeButton:SetScript("OnClick", function()
-- 		frame:Hide()
-- 	end)
--
-- 	-- Title
-- 	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
-- 	title:SetPoint("TOP", frame, "TOP", 0, -16)
-- 	title:SetText("State Machine Visualizer")
--
-- 	-- Dummy state machine data
-- 	local states = {
-- 		{ name = "Idle", x = -200, y = 50 },
-- 		{ name = "Scanning", x = 0, y = 100 },
-- 		{ name = "Processing", x = 200, y = 50 },
-- 		{ name = "Error", x = 0, y = -50 },
-- 	}
--
-- 	local transitions = {
-- 		{ from = "Idle", to = "Scanning", event = "Start Scan" },
-- 		{ from = "Scanning", to = "Processing", event = "Data Found" },
-- 		{ from = "Processing", to = "Idle", event = "Process Complete" },
-- 		{ from = "Processing", to = "Error", event = "Process Failed" },
-- 		{ from = "Error", to = "Idle", event = "Reset" },
-- 	}
--
-- 	-- Create state nodes
-- 	local nodeFrames = {}
-- 	for _, state in ipairs(states) do
-- 		local node = CreateFrame("Frame", nil, frame, "BackdropTemplate")
-- 		node:SetSize(100, 50)
-- 		node:SetPoint("CENTER", frame, "CENTER", state.x, state.y)
-- 		node:SetBackdrop({
-- 			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
-- 			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
-- 			tile = true,
-- 			tileSize = 16,
-- 			edgeSize = 12,
-- 			insets = { left = 4, right = 4, top = 4, bottom = 4 },
-- 		})
-- 		node:SetBackdropColor(0, 0.4, 0.8, 0.8)
-- 		node:SetBackdropBorderColor(0, 0, 0, 1)
--
-- 		local nodeText = node:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- 		nodeText:SetPoint("CENTER", node, "CENTER")
-- 		nodeText:SetText(state.name)
--
-- 		nodeFrames[state.name] = node
-- 	end
--
-- 	-- Function to draw lines (transitions)
-- 	local function drawLine(parent, x1, y1, x2, y2, text)
-- 		local line = parent:CreateLine(nil, "ARTWORK")
-- 		line:SetStartPoint("CENTER", x1, y1)
-- 		line:SetEndPoint("CENTER", x2, y2)
-- 		line:SetThickness(2)
-- 		line:SetColorTexture(1, 1, 0, 1) -- Yellow line
--
-- 		-- Arrowhead
-- 		local angle = math.atan2(y2 - y1, x2 - x1)
-- 		local arrowLength = 10
-- 		local arrowAngle = math.rad(20)
--
-- 		local arrowX1 = x2 - arrowLength * math.cos(angle - arrowAngle)
-- 		local arrowY1 = y2 - arrowLength * math.sin(angle - arrowAngle)
-- 		local arrowX2 = x2 - arrowLength * math.cos(angle + arrowAngle)
-- 		local arrowY2 = y2 - arrowLength * math.sin(angle + arrowAngle)
--
-- 		local arrowLine1 = parent:CreateLine(nil, "ARTWORK")
-- 		arrowLine1:SetStartPoint("CENTER", x2, y2)
-- 		arrowLine1:SetEndPoint("CENTER", arrowX1, arrowY1)
-- 		arrowLine1:SetThickness(2)
-- 		arrowLine1:SetColorTexture(1, 1, 0, 1)
--
-- 		local arrowLine2 = parent:CreateLine(nil, "ARTWORK")
-- 		arrowLine2:SetStartPoint("CENTER", x2, y2)
-- 		arrowLine2:SetEndPoint("CENTER", arrowX2, arrowY2)
-- 		arrowLine2:SetThickness(2)
-- 		arrowLine2:SetColorTexture(1, 1, 0, 1)
--
-- 		-- Event text
-- 		local eventText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
-- 		eventText:SetPoint("CENTER", parent, "CENTER", (x1 + x2) / 2, (y1 + y2) / 2 + 10)
-- 		eventText:SetText(text)
-- 	end
--
-- 	-- Draw transitions
-- 	for _, transition in ipairs(transitions) do
-- 		local fromNode = nodeFrames[transition.from]
-- 		local toNode = nodeFrames[transition.to]
-- 		if fromNode and toNode then
-- 			local x1, y1 = fromNode:GetCenter()
-- 			local x2, y2 = toNode:GetCenter()
-- 			x1, y1 = x1 - frame:GetLeft() - frame:GetWidth() / 2, y1 - frame:GetBottom() - frame:GetHeight() / 2
-- 			x2, y2 = x2 - frame:GetLeft() - frame:GetWidth() / 2, y2 - frame:GetBottom() - frame:GetHeight() / 2
-- 			drawLine(frame, x1, y1, x2, y2, transition.event)
-- 		end
-- 	end
--
-- 	frame:Hide()
-- 	return frame
-- end
--
-- -- Create the visualizer frame
-- local visualizerFrame = createStateMachineVisualizer()
--
-- -- Show the frame when the minimap button is clicked
-- minimapButton:SetScript("OnClick", function()
-- 	if visualizerFrame:IsShown() then
-- 		visualizerFrame:Hide()
-- 	else
-- 		visualizerFrame:Show()
-- 	end
-- end)
