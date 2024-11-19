-- Calculator.lua
local Calculator = {}

function Calculator:CreateFrame()
	self.frame = CreateFrame("Frame", "CalculatorFrame", UIParent, "BasicFrameTemplateWithInset")
	self.frame:SetSize(255, 350)
	self.frame:SetPoint("CENTER")
	self.frame:Hide()

	self.frame.title = self.frame:CreateFontString(nil, "OVERLAY")
	self.frame.title:SetFontObject("GameFontHighlight")
	self.frame.title:SetPoint("CENTER", self.frame.TitleBg, "CENTER", 0, 0)
	self.frame.title:SetText("ChevKit Calculator")

	self.inputBox = CreateFrame("EditBox", nil, self.frame, "InputBoxTemplate")
	self.inputBox:SetSize(225, 30)
	self.inputBox:SetPoint("TOP", self.frame, "TOP", 0, -40)
	self.inputBox:SetAutoFocus(false)
	self.inputBox:SetScript("OnEnterPressed", function()
		self:EvaluateExpression()
	end)

	self:CreateButtons()
	self:MakeFrameDraggable()
end

function Calculator:CreateButton(label, x, y, width, height, onClick)
	local button = CreateFrame("Button", nil, self.frame, "GameMenuButtonTemplate")
	button:SetSize(width, height)
	button:SetPoint("TOPLEFT", x, y)
	button:SetText(label)
	button:SetNormalFontObject("GameFontNormalLarge")
	button:SetHighlightFontObject("GameFontHighlightLarge")
	button:SetScript("OnClick", onClick)
	return button
end

function Calculator:AppendToInput(text)
	self.inputBox:SetText(self.inputBox:GetText() .. text)
end

function Calculator:EvaluateExpression()
	local expression = self.inputBox:GetText()
	local result = self:EvaluateSimpleExpression(expression)
	if result then
		self.inputBox:SetText(result)
	else
		self.inputBox:SetText("Error")
	end
end

function Calculator:EvaluateSimpleExpression(expression)
	local func, err = loadstring("return " .. expression)
	if not func then
		return nil, err
	end
	local success, result = pcall(func)
	if not success then
		return nil, result
	end
	return result
end

function Calculator:CreateButtons()
	local buttons = {
		{ "7", 10, -80 },
		{ "8", 70, -80 },
		{ "9", 130, -80 },
		{ "/", 190, -80 },
		{ "4", 10, -130 },
		{ "5", 70, -130 },
		{ "6", 130, -130 },
		{ "*", 190, -130 },
		{ "1", 10, -180 },
		{ "2", 70, -180 },
		{ "3", 130, -180 },
		{ "-", 190, -180 },
		{ "0", 70, -230 },
		{ ".", 130, -230 },
		{ "+", 190, -230 },
		{
			"C",
			10,
			-230,
			function()
				self.inputBox:SetText("")
			end,
		},
		{
			"=",
			190,
			-280,
			function()
				self:EvaluateExpression()
			end,
		},
	}

	for _, button in ipairs(buttons) do
		local label, x, y, onClick = unpack(button)
		self:CreateButton(label, x, y, 50, 50, onClick or function()
			self:AppendToInput(label)
		end)
	end
end

function Calculator:MakeFrameDraggable()
	self.frame:SetMovable(true)
	self.frame:EnableMouse(true)
	self.frame:RegisterForDrag("LeftButton")
	self.frame:SetScript("OnDragStart", self.frame.StartMoving)
	self.frame:SetScript("OnDragStop", self.frame.StopMovingOrSizing)
end

SLASH_CALCULATOR1 = "/calc"
SlashCmdList["CALCULATOR"] = function()
	if Calculator.frame:IsShown() then
		Calculator.frame:Hide()
	else
		Calculator.frame:Show()
	end
end

Calculator:CreateFrame()
