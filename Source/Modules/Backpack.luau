if not game:IsLoaded() then
    game.Loaded:Wait()
end

local UI = Backpack

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TopbarPlus = PlayerGui:FindFirstChild("TopbarStandard")
if TopbarPlus and TopbarPlus:FindFirstChild("Holders") and TopbarPlus.Holders:FindFirstChild("Left") then
    TopbarPlus = TopbarPlus.Holders.Left
end

local isOpen = false
local currentSearch = ""
local toolOrder = setmetatable({}, {__mode = "k"})
local orderCounter = 0
local activeTweens = setmetatable({}, {__mode = "k"})
local lastEquippedTool = nil

local UnselectedColor = Color3.fromRGB(255, 255, 255)
local UnselectedTransparency = 0.88
local SelectedColor = Color3.fromRGB(120, 180, 255)
local SelectedTransparency = 0.6

UI.BackpackBtn = Instance.new("Frame")
UI.BackpackBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
UI.BackpackBtn.BackgroundTransparency = 0.08
UI.BackpackBtn.BorderSizePixel = 0
UI.BackpackBtn.LayoutOrder = -2147483647
UI.BackpackBtn.Name = "BackpackBtn"
UI.BackpackBtn.Position = UDim2.fromOffset(16, 4)
UI.BackpackBtn.Size = UDim2.fromOffset(44, 44)
UI.BackpackBtn.Parent = TopbarPlus or ScreenGui

UI.BackpackBtnCorner = Instance.new("UICorner")
UI.BackpackBtnCorner.CornerRadius = UDim.new(1, 0)
UI.BackpackBtnCorner.Name = "BackpackBtnCorner"
UI.BackpackBtnCorner.Parent = UI.BackpackBtn

UI.BackpackIcon = Instance.new("ImageButton")
UI.BackpackIcon.AnchorPoint = Vector2.new(0.5, 0.5)
UI.BackpackIcon.AutoButtonColor = false
UI.BackpackIcon.BackgroundTransparency = 1
UI.BackpackIcon.BorderSizePixel = 0
UI.BackpackIcon.Image = "rbxasset://textures/ui/TopBar/inventoryOff.png"
UI.BackpackIcon.Name = "BackpackIcon"
UI.BackpackIcon.Position = UDim2.fromScale(0.5, 0.5)
UI.BackpackIcon.Size = UDim2.fromOffset(36, 36)
UI.BackpackIcon.Parent = UI.BackpackBtn

UI.BackpackIconCorner = Instance.new("UICorner")
UI.BackpackIconCorner.CornerRadius = UDim.new(1, 0)
UI.BackpackIconCorner.Name = "BackpackIconCorner"
UI.BackpackIconCorner.Parent = UI.BackpackIcon

UI.Backpack = Instance.new("Frame")
UI.Backpack.AnchorPoint = Vector2.new(0.5, 1)
UI.Backpack.BackgroundTransparency = 1
UI.Backpack.BorderSizePixel = 0
UI.Backpack.Name = "Backpack"
UI.Backpack.Position = UDim2.new(0.5, 0, 1, -6)
UI.Backpack.Size = UDim2.new(0.5, 28, 0.9, 0)
UI.Backpack.Parent = ScreenGui

UI.BackpackLayout = Instance.new("UIListLayout")
UI.BackpackLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.BackpackLayout.Name = "BackpackLayout"
UI.BackpackLayout.Padding = UDim.new(0, 6)
UI.BackpackLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.BackpackLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UI.BackpackLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.BackpackLayout.Parent = UI.Backpack

UI.InventoryFrame = Instance.new("CanvasGroup")
UI.InventoryFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
UI.InventoryFrame.BackgroundTransparency = 0.08
UI.InventoryFrame.BorderSizePixel = 0
UI.InventoryFrame.LayoutOrder = 1
UI.InventoryFrame.Name = "InventoryFrame"
UI.InventoryFrame.Size = UDim2.new(1, 0, 0.3, 0)
UI.InventoryFrame.Visible = false
UI.InventoryFrame.GroupTransparency = 1
UI.InventoryFrame.Parent = UI.Backpack

UI.InventoryCorner = Instance.new("UICorner")
UI.InventoryCorner.CornerRadius = UDim.new(0, 14)
UI.InventoryCorner.Name = "InventoryCorner"
UI.InventoryCorner.Parent = UI.InventoryFrame

UI.InventoryStroke = Instance.new("UIStroke")
UI.InventoryStroke.Color = Color3.fromRGB(255, 255, 255)
UI.InventoryStroke.Transparency = 0.92
UI.InventoryStroke.Thickness = 0.5
UI.InventoryStroke.Name = "InventoryStroke"
UI.InventoryStroke.Parent = UI.InventoryFrame

UI.InventoryInnerLayout = Instance.new("UIListLayout")
UI.InventoryInnerLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.InventoryInnerLayout.Name = "InventoryInnerLayout"
UI.InventoryInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.InventoryInnerLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.InventoryInnerLayout.Parent = UI.InventoryFrame

UI.InventoryHeader = Instance.new("Frame")
UI.InventoryHeader.BackgroundTransparency = 1
UI.InventoryHeader.BorderSizePixel = 0
UI.InventoryHeader.LayoutOrder = 1
UI.InventoryHeader.Name = "InventoryHeader"
UI.InventoryHeader.Size = UDim2.new(1, 0, 0, 34)
UI.InventoryHeader.Parent = UI.InventoryFrame

UI.InventoryHeaderLayout = Instance.new("UIListLayout")
UI.InventoryHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
UI.InventoryHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.InventoryHeaderLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.InventoryHeaderLayout.Padding = UDim.new(0, 8)
UI.InventoryHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.InventoryHeaderLayout.Name = "InventoryHeaderLayout"
UI.InventoryHeaderLayout.Parent = UI.InventoryHeader

UI.InventoryHeaderPadding = Instance.new("UIPadding")
UI.InventoryHeaderPadding.PaddingLeft = UDim.new(0, 14)
UI.InventoryHeaderPadding.PaddingRight = UDim.new(0, 10)
UI.InventoryHeaderPadding.Name = "InventoryHeaderPadding"
UI.InventoryHeaderPadding.Parent = UI.InventoryHeader

UI.InventoryTitle = Instance.new("TextLabel")
UI.InventoryTitle.BackgroundTransparency = 1
UI.InventoryTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
UI.InventoryTitle.LayoutOrder = 1
UI.InventoryTitle.Name = "InventoryTitle"
UI.InventoryTitle.Size = UDim2.new(0, 80, 1, 0)
UI.InventoryTitle.Text = "Inventory"
UI.InventoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.InventoryTitle.TextTransparency = 0.45
UI.InventoryTitle.TextSize = 13
UI.InventoryTitle.TextXAlignment = Enum.TextXAlignment.Left
UI.InventoryTitle.Parent = UI.InventoryHeader

UI.SearchBox = Instance.new("TextBox")
UI.SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.SearchBox.BackgroundTransparency = 0.95
UI.SearchBox.BorderSizePixel = 0
UI.SearchBox.ClearTextOnFocus = false
UI.SearchBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.SearchBox.LayoutOrder = 2
UI.SearchBox.Name = "SearchBox"
UI.SearchBox.PlaceholderColor3 = Color3.fromRGB(160, 160, 165)
UI.SearchBox.PlaceholderText = "Search..."
UI.SearchBox.Size = UDim2.new(0, 140, 0, 24)
UI.SearchBox.Text = ""
UI.SearchBox.TextColor3 = Color3.fromRGB(230, 230, 235)
UI.SearchBox.TextSize = 12
UI.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
UI.SearchBox.Parent = UI.InventoryHeader

UI.SearchBoxCorner = Instance.new("UICorner")
UI.SearchBoxCorner.CornerRadius = UDim.new(0, 6)
UI.SearchBoxCorner.Name = "SearchBoxCorner"
UI.SearchBoxCorner.Parent = UI.SearchBox

UI.SearchBoxStroke = Instance.new("UIStroke")
UI.SearchBoxStroke.Color = Color3.fromRGB(255, 255, 255)
UI.SearchBoxStroke.Transparency = 0.91
UI.SearchBoxStroke.Thickness = 0.5
UI.SearchBoxStroke.Name = "SearchBoxStroke"
UI.SearchBoxStroke.Parent = UI.SearchBox

UI.SearchBoxPadding = Instance.new("UIPadding")
UI.SearchBoxPadding.PaddingLeft = UDim.new(0, 8)
UI.SearchBoxPadding.PaddingRight = UDim.new(0, 8)
UI.SearchBoxPadding.Name = "SearchBoxPadding"
UI.SearchBoxPadding.Parent = UI.SearchBox

UI.InventoryHeaderDivider = Instance.new("Frame")
UI.InventoryHeaderDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.InventoryHeaderDivider.BackgroundTransparency = 0.94
UI.InventoryHeaderDivider.BorderSizePixel = 0
UI.InventoryHeaderDivider.LayoutOrder = 2
UI.InventoryHeaderDivider.Name = "InventoryHeaderDivider"
UI.InventoryHeaderDivider.Size = UDim2.new(1, 0, 0, 1)
UI.InventoryHeaderDivider.Parent = UI.InventoryFrame

UI.ToolsFrame = Instance.new("Frame")
UI.ToolsFrame.BackgroundTransparency = 1
UI.ToolsFrame.BorderSizePixel = 0
UI.ToolsFrame.LayoutOrder = 3
UI.ToolsFrame.Name = "ToolsFrame"
UI.ToolsFrame.Size = UDim2.new(1, 0, 1, 0)
UI.ToolsFrame.Parent = UI.InventoryFrame

UI.Tools = Instance.new("ScrollingFrame")
UI.Tools.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.Tools.BackgroundTransparency = 1
UI.Tools.BorderSizePixel = 0
UI.Tools.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.Tools.Name = "Tools"
UI.Tools.ScrollBarThickness = 3
UI.Tools.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
UI.Tools.ScrollBarImageTransparency = 0.7
UI.Tools.ScrollingDirection = Enum.ScrollingDirection.Y
UI.Tools.Size = UDim2.new(1, 0, 1, 0)
UI.Tools.Parent = UI.ToolsFrame

UI.ToolsPadding = Instance.new("UIPadding")
UI.ToolsPadding.PaddingBottom = UDim.new(0, 10)
UI.ToolsPadding.PaddingLeft = UDim.new(0, 10)
UI.ToolsPadding.PaddingRight = UDim.new(0, 10)
UI.ToolsPadding.PaddingTop = UDim.new(0, 10)
UI.ToolsPadding.Name = "ToolsPadding"
UI.ToolsPadding.Parent = UI.Tools

UI.ToolsLayout = Instance.new("UIGridLayout")
UI.ToolsLayout.CellPadding = UDim2.new(0, 8, 0, 8)
UI.ToolsLayout.CellSize = UDim2.new(0, 60, 0, 60)
UI.ToolsLayout.Name = "ToolsLayout"
UI.ToolsLayout.Parent = UI.Tools

UI.HotbarFrame = Instance.new("Frame")
UI.HotbarFrame.BackgroundTransparency = 1
UI.HotbarFrame.BorderSizePixel = 0
UI.HotbarFrame.LayoutOrder = 2
UI.HotbarFrame.Name = "HotbarFrame"
UI.HotbarFrame.Size = UDim2.new(0, 386, 0, 52)
UI.HotbarFrame.Parent = UI.Backpack

UI.HotbarSizeCons = Instance.new("UISizeConstraint")
UI.HotbarSizeCons.MaxSize = Vector2.new(2147483648, 52)
UI.HotbarSizeCons.Name = "HotbarSizeCons"
UI.HotbarSizeCons.Parent = UI.HotbarFrame

UI.HotbarLayout = Instance.new("UIListLayout")
UI.HotbarLayout.FillDirection = Enum.FillDirection.Horizontal
UI.HotbarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UI.HotbarLayout.HorizontalFlex = Enum.UIFlexAlignment.None
UI.HotbarLayout.Name = "HotbarLayout"
UI.HotbarLayout.Padding = UDim.new(0, 6)
UI.HotbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.HotbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.HotbarLayout.Parent = UI.HotbarFrame

UI.SlotTemplate = Instance.new("ImageButton")
UI.SlotTemplate.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
UI.SlotTemplate.BackgroundTransparency = 0.08
UI.SlotTemplate.BorderSizePixel = 0
UI.SlotTemplate.LayoutOrder = -1
UI.SlotTemplate.Name = "SlotTemplate"
UI.SlotTemplate.Size = UDim2.new(0, 52, 1, 0)
UI.SlotTemplate.Visible = false
UI.SlotTemplate.Parent = UI.HotbarFrame

UI.SlotTemplateCorner = Instance.new("UICorner")
UI.SlotTemplateCorner.CornerRadius = UDim.new(0, 10)
UI.SlotTemplateCorner.Name = "SlotTemplateCorner"
UI.SlotTemplateCorner.Parent = UI.SlotTemplate

UI.SlotTemplateIcon = Instance.new("ImageLabel")
UI.SlotTemplateIcon.AnchorPoint = Vector2.new(0.5, 0.5)
UI.SlotTemplateIcon.BackgroundTransparency = 1
UI.SlotTemplateIcon.BorderSizePixel = 0
UI.SlotTemplateIcon.Interactable = false
UI.SlotTemplateIcon.Name = "SlotIcon"
UI.SlotTemplateIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.SlotTemplateIcon.ScaleType = Enum.ScaleType.Fit
UI.SlotTemplateIcon.Size = UDim2.new(1, -12, 1, -12)
UI.SlotTemplateIcon.Parent = UI.SlotTemplate

UI.SlotTemplateStroke = Instance.new("UIStroke")
UI.SlotTemplateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UI.SlotTemplateStroke.Color = UnselectedColor
UI.SlotTemplateStroke.Name = "SlotStroke"
UI.SlotTemplateStroke.Thickness = 1.5
UI.SlotTemplateStroke.Transparency = UnselectedTransparency
UI.SlotTemplateStroke.Parent = UI.SlotTemplate

UI.SlotTemplateLabel = Instance.new("TextLabel")
UI.SlotTemplateLabel.AnchorPoint = Vector2.new(0.5, 0.5)
UI.SlotTemplateLabel.BackgroundTransparency = 1
UI.SlotTemplateLabel.BorderSizePixel = 0
UI.SlotTemplateLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
UI.SlotTemplateLabel.Interactable = false
UI.SlotTemplateLabel.Name = "SlotLabel"
UI.SlotTemplateLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.SlotTemplateLabel.Size = UDim2.new(1, -8, 1, -8)
UI.SlotTemplateLabel.Text = ""
UI.SlotTemplateLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
UI.SlotTemplateLabel.TextScaled = true
UI.SlotTemplateLabel.TextWrapped = true
UI.SlotTemplateLabel.Parent = UI.SlotTemplate

UI.SlotTemplateRatio = Instance.new("UIAspectRatioConstraint")
UI.SlotTemplateRatio.Name = "SlotRatio"
UI.SlotTemplateRatio.Parent = UI.SlotTemplate

UI.BackpackSlotTemplate = UI.SlotTemplate:Clone()
UI.BackpackSlotTemplate.Size = UDim2.new(0, 60, 0, 60)
UI.BackpackSlotTemplate.Visible = false
UI.BackpackSlotTemplate.Name = "BackpackSlotTemplate"
UI.BackpackSlotTemplate.Parent = UI.Tools

local function applySlotSelection(slot, selected)
    local stroke = slot:FindFirstChild("SlotStroke")
    if not stroke then return end

    if activeTweens[stroke] then
        activeTweens[stroke]:Cancel()
    end

    local t = Tween(
        stroke,
        0.2,
        {
            Color = selected and SelectedColor or UnselectedColor,
            Transparency = selected and SelectedTransparency or UnselectedTransparency
        }
    )
    activeTweens[stroke] = t
    t:Play()
end

local function updateInventory()
    for _, child in ipairs(UI.HotbarFrame:GetChildren()) do
        if child:IsA("ImageButton") and child ~= UI.SlotTemplate then
            child:Destroy()
        end
    end
    for _, child in ipairs(UI.Tools:GetChildren()) do
        if child:IsA("ImageButton") and child ~= UI.BackpackSlotTemplate then
            child:Destroy()
        end
    end

    local ch = LocalPlayer.Character
    local equippedTool = ch and ch:FindFirstChildOfClass("Tool")

    local allTools = {}
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then table.insert(allTools, tool) end
    end
    if equippedTool then
        table.insert(allTools, equippedTool)
    end

    for _, tool in ipairs(allTools) do
        if not toolOrder[tool] then
            orderCounter = orderCounter + 1
            toolOrder[tool] = orderCounter
        end
    end

    table.sort(allTools, function(a, b)
        return (toolOrder[a] or 0) < (toolOrder[b] or 0)
    end)

    local hotbarCount = math.min(#allTools, 6)
    UI.HotbarFrame.Size = UDim2.new(0, (hotbarCount * 52) + (math.max(0, hotbarCount - 1) * 6), 0, 52)

    for i = 1, hotbarCount do
        local tool = allTools[i]
        local slot = UI.SlotTemplate:Clone()
        slot.Visible = true
        slot.LayoutOrder = i
        slot.Name = "HotbarSlot_" .. i
        slot.Parent = UI.HotbarFrame

        if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
            slot.SlotIcon.Image = tool.TextureId
            slot.SlotLabel.Text = ""
        else
            slot.SlotIcon.Image = ""
            slot.SlotLabel.Text = tool.Name
        end

        applySlotSelection(slot, tool == equippedTool)

        slot.MouseButton1Click:Connect(function()
            if tool.Parent == ch then
                tool.Parent = LocalPlayer.Backpack
            else
                if equippedTool then equippedTool.Parent = LocalPlayer.Backpack end
                tool.Parent = ch
            end
        end)
    end

    local bpIndex = 1
    for i = 7, #allTools do
        local tool = allTools[i]
        local matches = true
        if currentSearch ~= "" then
            if not string.find(string.lower(tool.Name), string.lower(currentSearch), 1, true) then
                matches = false
            end
        end

        if matches then
            local slot = UI.BackpackSlotTemplate:Clone()
            slot.Visible = true
            slot.LayoutOrder = bpIndex
            slot.Name = "BackpackSlot_" .. bpIndex
            slot.Parent = UI.Tools
            bpIndex = bpIndex + 1

            if tool.TextureId ~= "" and tool.TextureId ~= "rbxasset://textures/Unknown.png" then
                slot.SlotIcon.Image = tool.TextureId
                slot.SlotLabel.Text = ""
            else
                slot.SlotIcon.Image = ""
                slot.SlotLabel.Text = tool.Name
            end

            applySlotSelection(slot, tool == equippedTool)

            slot.MouseButton1Click:Connect(function()
                if tool.Parent == ch then
                    tool.Parent = LocalPlayer.Backpack
                else
                    if equippedTool then equippedTool.Parent = LocalPlayer.Backpack end
                    tool.Parent = ch
                end
            end)
        end
    end

    lastEquippedTool = equippedTool
end

local updateQueued = false
local function updateInv()
    if updateQueued then return end
    updateQueued = true
    task.defer(function()
        updateQueued = false
        updateInventory()
    end)
end

local function toggleBackpack()
    isOpen = not isOpen
    if isOpen then
        UI.BackpackIcon.Image = "rbxasset://textures/ui/TopBar/inventoryOn.png"
        UI.InventoryFrame.Visible = true
        Tween(UI.InventoryFrame, 0.25, {GroupTransparency = 0}, "Back", "Out"):Play()
    else
        UI.BackpackIcon.Image = "rbxasset://textures/ui/TopBar/inventoryOff.png"
        local t = Tween(UI.InventoryFrame, 0.2, {GroupTransparency = 1}, "Quad", "In")
        t:Play()
        t.Completed:Connect(function()
            if not isOpen then
                UI.InventoryFrame.Visible = false
            end
        end)
    end
end

UI.BackpackIcon.MouseButton1Click:Connect(toggleBackpack)

pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

LocalPlayer.Backpack.ChildAdded:Connect(updateInv)
LocalPlayer.Backpack.ChildRemoved:Connect(updateInv)

local function hookChar(char)
    char.ChildAdded:Connect(updateInv)
    char.ChildRemoved:Connect(updateInv)
    updateInventory()
end

if LocalPlayer.Character then
    task.spawn(hookChar, LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(hookChar)

UI.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentSearch = UI.SearchBox.Text
    updateInventory()
end)

local hotbarKeys = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5,
    [Enum.KeyCode.Six] = 6,
}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local slotNum = hotbarKeys[input.KeyCode]
    if slotNum then
        local ch = LocalPlayer.Character
        local equippedTool = ch and ch:FindFirstChildOfClass("Tool")
        local allTools = {}
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then table.insert(allTools, tool) end
        end
        if equippedTool then table.insert(allTools, equippedTool) end

        table.sort(allTools, function(a, b)
            return (toolOrder[a] or 0) < (toolOrder[b] or 0)
        end)

        local tool = allTools[slotNum]
        if tool then
            if tool.Parent == ch then
                tool.Parent = LocalPlayer.Backpack
            else
                if equippedTool then equippedTool.Parent = LocalPlayer.Backpack end
                tool.Parent = ch
            end
        end
    end
end)

updateInventory()