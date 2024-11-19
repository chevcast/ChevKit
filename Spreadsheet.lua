-- Spreadsheet.lua
local Spreadsheet = {}
Spreadsheet.__index = Spreadsheet

function Spreadsheet:CreateFrame()
	self.frame = CreateFrame("Frame", "SpreadsheetFrame", UIParent, "BasicFrameTemplateWithInset")
	self.frame:SetSize(600, 400)
	self.frame:SetPoint("CENTER")
	self.frame:Hide()

	self.frame.title = self.frame:CreateFontString(nil, "OVERLAY")
	self.frame.title:SetFontObject("GameFontHighlight")
	self.frame.title:SetPoint("CENTER", self.frame.TitleBg, "CENTER", 0, 0)
	self.frame.title:SetText("ChevKit Spreadsheet")

	self:CreateTabs()
	self:MakeFrameDraggable()
end

function Spreadsheet:CreateTabs()
	self.tabs = {}
	self.currentTab = nil

	self.tabFrame = CreateFrame("Frame", nil, self.frame)
	self.tabFrame:SetSize(580, 30)
	self.tabFrame:SetPoint("TOP", self.frame, "TOP", 0, -30)

	self.newTabButton = CreateFrame("Button", nil, self.tabFrame, "GameMenuButtonTemplate")
	self.newTabButton:SetSize(30, 30)
	self.newTabButton:SetPoint("RIGHT", self.tabFrame, "RIGHT", -5, 0)
	self.newTabButton:SetText("+")
	self.newTabButton:SetScript("OnClick", function()
		self:AddTab()
	end)

	-- Create a default tab
	self:AddTab()
end

function Spreadsheet:AddTab(name)
	local tab = {}
	tab.name = name or "Sheet " .. (#self.tabs + 1)
	tab.frame = CreateFrame("Frame", nil, self.frame)
	tab.frame:SetSize(580, 320)
	tab.frame:SetPoint("TOP", self.tabFrame, "BOTTOM", 0, -50) -- Adjusted Y offset
	tab.frame:Hide()

	tab.button = CreateFrame("Button", nil, self.tabFrame, "GameMenuButtonTemplate")
	tab.button:SetSize(100, 30)
	tab.button:SetPoint("LEFT", #self.tabs * 105, 0)
	tab.button:SetText(tab.name)
	tab.button:SetScript("OnClick", function()
		self:SelectTab(tab)
	end)

	-- Create a container frame for the grid, headers, and buttons
	tab.container = CreateFrame("Frame", nil, tab.frame)
	tab.container:SetSize(580, 320)
	tab.container:SetPoint("TOPLEFT", 0, 0)

	tab.cells = {}
	tab.numRows = 10
	tab.numCols = 10
	self:CreateGrid(tab)

	table.insert(self.tabs, tab)
	self:SelectTab(tab)
end

function Spreadsheet:CreateGrid(tab)
	local cellWidth, cellHeight = 50, 20

	for row = 1, tab.numRows do
		tab.cells[row] = {}
		for col = 1, tab.numCols do
			local cell = CreateFrame("EditBox", nil, tab.container, "InputBoxTemplate")
			cell:SetSize(cellWidth, cellHeight)
			cell:SetPoint("TOPLEFT", (col - 1) * cellWidth, -((row - 1) * cellHeight) - cellHeight)
			cell:SetAutoFocus(false)
			cell:SetText("")
			tab.cells[row][col] = cell
		end

		-- Add a minus button to remove the row
		local removeRowButton = CreateFrame("Button", nil, tab.container, "UIPanelButtonTemplate")
		removeRowButton:SetSize(20, 20)
		removeRowButton:SetText("-")
		removeRowButton:SetPoint("LEFT", tab.cells[row][tab.numCols], "RIGHT", 5, 0)
		removeRowButton:SetScript("OnClick", function()
			self:RemoveSpecificRow(row)
		end)
		tab.cells[row].removeButton = removeRowButton
	end

	self:CreateHeaders(tab)

	-- Add a plus button to add a new row
	local addRowButton = CreateFrame("Button", nil, tab.container, "UIPanelButtonTemplate")
	addRowButton:SetSize(20, 20)
	addRowButton:SetPoint("TOPLEFT", tab.cells[tab.numRows][1], "BOTTOMLEFT", 0, -5)
	addRowButton:SetText("+")
	addRowButton:SetScript("OnClick", function()
		self:AddRow()
	end)
	tab.addRowButton = addRowButton
end

function Spreadsheet:CreateHeaders(tab)
	local cellWidth, cellHeight = 50, 20

	-- Create column headers
	tab.headers = {}
	for col = 1, tab.numCols do
		local header = CreateFrame("EditBox", nil, tab.container, "InputBoxTemplate")
		header:SetSize(cellWidth, cellHeight)
		header:SetPoint("TOPLEFT", (col - 1) * cellWidth, 0)
		header:SetAutoFocus(false)
		header:SetText("Col " .. col)
		header:SetScript("OnEditFocusGained", function(self)
			if self:GetText() == "Col " .. col then
				self:SetText("")
			end
		end)
		header:SetScript("OnEditFocusLost", function(self)
			if self:GetText() == "" then
				self:SetText("Col " .. col)
			end
		end)
		tab.headers[col] = header

		-- Add a minus button to remove the column
		local removeColumnButton = CreateFrame("Button", nil, tab.container, "UIPanelButtonTemplate")
		removeColumnButton:SetSize(20, 20)
		removeColumnButton:SetText("-")
		removeColumnButton:SetPoint("BOTTOM", header, "TOP", 0, -10) -- Adjusted Y offset
		removeColumnButton:SetScript("OnClick", function()
			self:RemoveSpecificColumn(col)
		end)
		tab.headers[col].removeButton = removeColumnButton
	end

	-- Add a plus button to add a new column
	local addColumnButton = CreateFrame("Button", nil, tab.container, "UIPanelButtonTemplate")
	addColumnButton:SetSize(20, 20)
	addColumnButton:SetPoint("TOPLEFT", tab.headers[tab.numCols], "TOPRIGHT", 5, 0)
	addColumnButton:SetText("+")
	addColumnButton:SetScript("OnClick", function()
		self:AddColumn()
	end)
	tab.addColumnButton = addColumnButton
end

function Spreadsheet:AddRow()
	if not self.currentTab then
		return
	end

	local tab = self.currentTab
	tab.numRows = tab.numRows + 1
	tab.cells[tab.numRows] = {}

	local cellWidth, cellHeight = 50, 20
	for col = 1, tab.numCols do
		local cell = CreateFrame("EditBox", nil, tab.container, "InputBoxTemplate")
		cell:SetSize(cellWidth, cellHeight)
		cell:SetPoint("TOPLEFT", (col - 1) * cellWidth, -((tab.numRows - 1) * cellHeight) - cellHeight)
		cell:SetAutoFocus(false)
		cell:SetText("")
		tab.cells[tab.numRows][col] = cell
	end

	-- Add a minus button to remove the row
	local removeRowButton = CreateFrame("Button", nil, tab.container, "UIPanelButtonTemplate")
	removeRowButton:SetSize(20, 20)
	removeRowButton:SetText("-")
	removeRowButton:SetPoint("LEFT", tab.cells[tab.numRows][tab.numCols], "RIGHT", 5, 0)
	removeRowButton:SetScript("OnClick", function()
		self:RemoveSpecificRow(tab.numRows)
	end)
	tab.cells[tab.numRows].removeButton = removeRowButton

	-- Adjust the position of the add row button
	tab.addRowButton:SetPoint("TOPLEFT", tab.cells[tab.numRows][1], "BOTTOMLEFT", 0, -5)
end

function Spreadsheet:RemoveRow()
	if not self.currentTab or self.currentTab.numRows <= 1 then
		return
	end

	local tab = self.currentTab
	for col = 1, tab.numCols do
		tab.cells[tab.numRows][col]:Hide()
		tab.cells[tab.numRows][col] = nil
	end
	tab.cells[tab.numRows].removeButton:Hide()
	tab.cells[tab.numRows].removeButton = nil
	tab.numRows = tab.numRows - 1

	-- Adjust the position of the add row button
	tab.addRowButton:SetPoint("TOPLEFT", tab.cells[tab.numRows][1], "BOTTOMLEFT", 0, -5)
end

function Spreadsheet:RemoveSpecificRow(row)
	if not self.currentTab or self.currentTab.numRows <= 1 then
		return
	end

	local tab = self.currentTab
	for col = 1, tab.numCols do
		tab.cells[row][col]:Hide()
		tab.cells[row][col] = nil
	end
	tab.cells[row].removeButton:Hide()
	tab.cells[row].removeButton = nil

	-- Shift rows up
	for r = row, tab.numRows - 1 do
		tab.cells[r] = tab.cells[r + 1]
		for col = 1, tab.numCols do
			tab.cells[r][col]:SetPoint("TOPLEFT", (col - 1) * 50, -((r - 1) * 20) - 20)
		end
		tab.cells[r].removeButton:SetPoint("LEFT", tab.cells[r][tab.numCols], "RIGHT", 5, 0)
	end

	tab.cells[tab.numRows] = nil
	tab.numRows = tab.numRows - 1

	-- Adjust the position of the add row button
	tab.addRowButton:SetPoint("TOPLEFT", tab.cells[tab.numRows][1], "BOTTOMLEFT", 0, -5)
end

function Spreadsheet:AddColumn()
	if not self.currentTab then
		return
	end

	local tab = self.currentTab
	tab.numCols = tab.numCols + 1

	local cellWidth, cellHeight = 50, 20
	for row = 1, tab.numRows do
		local cell = CreateFrame("EditBox", nil, tab.container, "InputBoxTemplate")
		cell:SetSize(cellWidth, cellHeight)
		cell:SetPoint("TOPLEFT", (tab.numCols - 1) * cellWidth, -((row - 1) * cellHeight) - cellHeight)
		cell:SetAutoFocus(false)
		cell:SetText("")
		tab.cells[row][tab.numCols] = cell
	end

	local header = CreateFrame("EditBox", nil, tab.container, "InputBoxTemplate")
	header:SetSize(cellWidth, cellHeight)
	header:SetPoint("TOPLEFT", (tab.numCols - 1) * cellWidth, 0)
	header:SetAutoFocus(false)
	header:SetText("Col " .. tab.numCols)
	header:SetScript("OnEditFocusGained", function(self)
		if self:GetText() == "Col " .. tab.numCols then
			self:SetText("")
		end
	end)
	header:SetScript("OnEditFocusLost", function(self)
		if self:GetText() == "" then
			self:SetText("Col " .. tab.numCols)
		end
	end)
	tab.headers[tab.numCols] = header

	-- Add a minus button to remove the column
	local removeColumnButton = CreateFrame("Button", nil, tab.container, "UIPanelButtonTemplate")
	removeColumnButton:SetSize(20, 20)
	removeColumnButton:SetText("-")
	removeColumnButton:SetPoint("BOTTOM", header, "TOP", 0, -10) -- Adjusted Y offset
	removeColumnButton:SetScript("OnClick", function()
		self:RemoveSpecificColumn(tab.numCols)
	end)
	tab.headers[tab.numCols].removeButton = removeColumnButton

	-- Adjust the position of the add column button
	tab.addColumnButton:SetPoint("TOPLEFT", tab.headers[tab.numCols], "TOPRIGHT", 5, 0)
end

function Spreadsheet:RemoveColumn()
	if not self.currentTab or self.currentTab.numCols <= 1 then
		return
	end

	local tab = self.currentTab
	for row = 1, tab.numRows do
		tab.cells[row][tab.numCols]:Hide()
		tab.cells[row][tab.numCols] = nil
	end
	tab.headers[tab.numCols]:Hide()
	tab.headers[tab.numCols] = nil
	tab.numCols = tab.numCols - 1

	-- Adjust the position of the add column button
	tab.addColumnButton:SetPoint("TOPLEFT", tab.headers[tab.numCols], "TOPRIGHT", 5, 0)
end

function Spreadsheet:RemoveSpecificColumn(col)
	if not self.currentTab or self.currentTab.numCols <= 1 then
		return
	end

	local tab = self.currentTab
	for row = 1, tab.numRows do
		tab.cells[row][col]:Hide()
		tab.cells[row][col] = nil
	end
	tab.headers[col]:Hide()
	tab.headers[col] = nil
	tab.headers[col].removeButton:Hide()
	tab.headers[col].removeButton = nil

	-- Shift columns left
	for c = col, tab.numCols - 1 do
		tab.headers[c] = tab.headers[c + 1]
		tab.headers[c]:SetPoint("TOPLEFT", (c - 1) * 50, 0)
		tab.headers[c].removeButton:SetPoint("BOTTOM", tab.headers[c], "TOP", 0, -10) -- Adjusted Y offset
		for row = 1, tab.numRows do
			tab.cells[row][c] = tab.cells[row][c + 1]
			tab.cells[row][c]:SetPoint("TOPLEFT", (c - 1) * 50, -((row - 1) * 20) - 20)
		end
	end

	tab.headers[tab.numCols] = nil
	for row = 1, tab.numRows do
		tab.cells[row][tab.numCols] = nil
	end
	tab.numCols = tab.numCols - 1

	-- Adjust the position of the add column button
	tab.addColumnButton:SetPoint("TOPLEFT", tab.headers[tab.numCols], "TOPRIGHT", 5, 0)
end

function Spreadsheet:SelectTab(tab)
	if self.currentTab then
		self.currentTab.frame:Hide()
	end
	self.currentTab = tab
	self.currentTab.frame:Show()
end

function Spreadsheet:MakeFrameDraggable()
	self.frame:SetMovable(true)
	self.frame:EnableMouse(true)
	self.frame:RegisterForDrag("LeftButton")
	self.frame:SetScript("OnDragStart", self.frame.StartMoving)
	self.frame:SetScript("OnDragStop", self.frame.StopMovingOrSizing)
end

function Spreadsheet:Save()
	-- Implement save functionality
end

function Spreadsheet:Load()
	-- Implement load functionality
end

function Spreadsheet:Delete()
	-- Implement delete functionality
end

SLASH_SPREADSHEET1 = "/spreadsheet"
SlashCmdList["SPREADSHEET"] = function()
	if Spreadsheet.frame:IsShown() then
		Spreadsheet.frame:Hide()
	else
		Spreadsheet.frame:Show()
	end
end

Spreadsheet:CreateFrame()
