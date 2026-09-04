if not game:IsLoaded() then
    game.Loaded:Wait()
end

local UI = Chat

local NameColors = {
    Color3.fromRGB(91, 200, 255),
    Color3.fromRGB(126, 224, 90),
    Color3.fromRGB(255, 130, 202),
    Color3.fromRGB(204, 136, 255),
    Color3.fromRGB(255, 180, 80),
    Color3.fromRGB(80, 220, 180),
    Color3.fromRGB(255, 120, 120),
    Color3.fromRGB(120, 180, 255),
    Color3.fromRGB(255, 200, 100),
    Color3.fromRGB(100, 255, 180),
    Color3.fromRGB(255, 140, 160),
    Color3.fromRGB(160, 255, 120),
    Color3.fromRGB(200, 160, 255),
    Color3.fromRGB(80, 200, 255),
    Color3.fromRGB(255, 160, 120),
    Color3.fromRGB(120, 255, 200),
    Color3.fromRGB(255, 100, 160),
    Color3.fromRGB(180, 220, 255),
    Color3.fromRGB(255, 220, 100),
    Color3.fromRGB(140, 255, 160)
}

local PlayerNameColors = {}

local function GetNameColor(UserId)
    if not PlayerNameColors[UserId] then
        PlayerNameColors[UserId] = NameColors[(UserId % #NameColors) + 1]
    end
    return PlayerNameColors[UserId]
end

local MaxMessages = 20
local ChatVisible = false
local SlideInPos = UDim2.new(0, 16, 0, 60)
local SlideOutPos = UDim2.new(0, -400, 0, 60)

local function UpdatePlayerCount()
    UI.CountLabel.Text = #Players:GetPlayers() .. " online"
end

UI.Chat = Instance.new("CanvasGroup")
UI.Chat.Name = "Chat"
UI.Chat.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
UI.Chat.BackgroundTransparency = 0.08
UI.Chat.Position = UDim2.new(0, -400, 0, 60)
UI.Chat.Size = IsMobile() and UDim2.new(0, 340, 0, 240) or UDim2.new(0, 380, 0, 300)
UI.Chat.Visible = false
UI.Chat.Parent = ScreenGui

UI.ChatCorner = Instance.new("UICorner")
UI.ChatCorner.CornerRadius = UDim.new(0, 14)
UI.ChatCorner.Parent = UI.Chat

UI.ChatStroke = Instance.new("UIStroke")
UI.ChatStroke.Color = Color3.fromRGB(255, 255, 255)
UI.ChatStroke.Transparency = 0.92
UI.ChatStroke.Thickness = 0.5
UI.ChatStroke.Parent = UI.Chat

UI.ChatLayout = Instance.new("UIListLayout")
UI.ChatLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ChatLayout.Padding = UDim.new(0, 0)
UI.ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ChatLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.ChatLayout.Parent = UI.Chat

UI.ChatHeader = Instance.new("Frame")
UI.ChatHeader.Name = "ChatHeader"
UI.ChatHeader.BackgroundTransparency = 1
UI.ChatHeader.LayoutOrder = 1
UI.ChatHeader.Size = UDim2.new(1, 0, 0, 34)
UI.ChatHeader.Parent = UI.Chat

UI.ChatHeaderLayout = Instance.new("UIListLayout")
UI.ChatHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
UI.ChatHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.ChatHeaderLayout.Padding = UDim.new(0, 7)
UI.ChatHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ChatHeaderLayout.Parent = UI.ChatHeader

UI.ChatHeaderPadding = Instance.new("UIPadding")
UI.ChatHeaderPadding.PaddingLeft = UDim.new(0, 14)
UI.ChatHeaderPadding.Parent = UI.ChatHeader

UI.HeaderDot = Instance.new("Frame")
UI.HeaderDot.Name = "HeaderDot"
UI.HeaderDot.BackgroundColor3 = Color3.fromRGB(62, 207, 74)
UI.HeaderDot.Size = UDim2.new(0, 7, 0, 7)
UI.HeaderDot.LayoutOrder = 1
UI.HeaderDot.Parent = UI.ChatHeader

UI.HeaderDotCorner = Instance.new("UICorner")
UI.HeaderDotCorner.CornerRadius = UDim.new(1, 0)
UI.HeaderDotCorner.Parent = UI.HeaderDot

UI.TitleLabel = Instance.new("TextLabel")
UI.TitleLabel.Name = "TitleLabel"
UI.TitleLabel.BackgroundTransparency = 1
UI.TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
UI.TitleLabel.Text = "General"
UI.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.TitleLabel.TextTransparency = 0.45
UI.TitleLabel.TextSize = 13
UI.TitleLabel.Size = UDim2.new(0, 60, 1, 0)
UI.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
UI.TitleLabel.LayoutOrder = 2
UI.TitleLabel.Parent = UI.ChatHeader

UI.CountLabel = Instance.new("TextLabel")
UI.CountLabel.Name = "CountLabel"
UI.CountLabel.BackgroundTransparency = 1
UI.CountLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.CountLabel.Text = "0 online"
UI.CountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.CountLabel.TextTransparency = 0.75
UI.CountLabel.TextSize = 11
UI.CountLabel.Size = UDim2.new(1, -100, 1, 0)
UI.CountLabel.TextXAlignment = Enum.TextXAlignment.Right
UI.CountLabel.LayoutOrder = 3
UI.CountLabel.Parent = UI.ChatHeader

UI.HeaderDivider = Instance.new("Frame")
UI.HeaderDivider.Name = "HeaderDivider"
UI.HeaderDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.HeaderDivider.BackgroundTransparency = 0.94
UI.HeaderDivider.BorderSizePixel = 0
UI.HeaderDivider.LayoutOrder = 2
UI.HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
UI.HeaderDivider.Parent = UI.Chat

UI.Messages = Instance.new("ScrollingFrame")
UI.Messages.Name = "Messages"
UI.Messages.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.Messages.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.Messages.BackgroundTransparency = 1
UI.Messages.ScrollBarThickness = 0
UI.Messages.ScrollingDirection = Enum.ScrollingDirection.Y
UI.Messages.Size = UDim2.fromScale(1, 1)
UI.Messages.LayoutOrder = 3
UI.Messages.Parent = UI.Chat

UI.MessagesLayout = Instance.new("UIListLayout")
UI.MessagesLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.MessagesLayout.Padding = UDim.new(0, 1)
UI.MessagesLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.MessagesLayout.Parent = UI.Messages

UI.MessagesPadding = Instance.new("UIPadding")
UI.MessagesPadding.PaddingBottom = UDim.new(0, 10)
UI.MessagesPadding.PaddingLeft = UDim.new(0, 10)
UI.MessagesPadding.PaddingRight = UDim.new(0, 10)
UI.MessagesPadding.PaddingTop = UDim.new(0, 10)
UI.MessagesPadding.Parent = UI.Messages

UI.MessageTemplate = Instance.new("TextLabel")
UI.MessageTemplate.Name = "MessageTemplate"
UI.MessageTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.MessageTemplate.BackgroundTransparency = 1
UI.MessageTemplate.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.MessageTemplate.RichText = true
UI.MessageTemplate.Size = UDim2.new(1, 0, 0, 0)
UI.MessageTemplate.TextSize = 13
UI.MessageTemplate.TextWrapped = true
UI.MessageTemplate.TextXAlignment = Enum.TextXAlignment.Left
UI.MessageTemplate.TextYAlignment = Enum.TextYAlignment.Top
UI.MessageTemplate.Visible = false
UI.MessageTemplate.Parent = UI.Messages

UI.BottomDivider = Instance.new("Frame")
UI.BottomDivider.Name = "BottomDivider"
UI.BottomDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.BottomDivider.BackgroundTransparency = 0.94
UI.BottomDivider.BorderSizePixel = 0
UI.BottomDivider.LayoutOrder = 4
UI.BottomDivider.Size = UDim2.new(1, 0, 0, 1)
UI.BottomDivider.Parent = UI.Chat

UI.ChatboxInner = Instance.new("Frame")
UI.ChatboxInner.Name = "ChatboxInner"
UI.ChatboxInner.BackgroundTransparency = 1
UI.ChatboxInner.LayoutOrder = 5
UI.ChatboxInner.Size = UDim2.new(1, 0, 1, 0)
UI.ChatboxInner.Parent = UI.Chat

UI.ChatboxInnerConst = Instance.new("UISizeConstraint")
UI.ChatboxInnerConst.MaxSize = Vector2.new(1e9, 70)
UI.ChatboxInnerConst.Parent = UI.ChatboxInner

UI.ChatboxInnerPadding = Instance.new("UIPadding")
UI.ChatboxInnerPadding.PaddingLeft = UDim.new(0, 10)
UI.ChatboxInnerPadding.PaddingRight = UDim.new(0, 10)
UI.ChatboxInnerPadding.PaddingTop = UDim.new(0, 7)
UI.ChatboxInnerPadding.PaddingBottom = UDim.new(0, 7)
UI.ChatboxInnerPadding.Parent = UI.ChatboxInner

UI.ChatboxInnerLayout = Instance.new("UIListLayout")
UI.ChatboxInnerLayout.FillDirection = Enum.FillDirection.Horizontal
UI.ChatboxInnerLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ChatboxInnerLayout.Padding = UDim.new(0, 6)
UI.ChatboxInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ChatboxInnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.ChatboxInnerLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.ChatboxInnerLayout.Parent = UI.ChatboxInner

UI.ChatboxBg = Instance.new("Frame")
UI.ChatboxBg.Name = "ChatboxBg"
UI.ChatboxBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.ChatboxBg.BackgroundTransparency = 0.95
UI.ChatboxBg.LayoutOrder = 1
UI.ChatboxBg.Size = UDim2.new(1, 0, 1, 0)
UI.ChatboxBg.Parent = UI.ChatboxInner

UI.ChatboxBgCorner = Instance.new("UICorner")
UI.ChatboxBgCorner.CornerRadius = UDim.new(0, 8)
UI.ChatboxBgCorner.Parent = UI.ChatboxBg

UI.ChatboxBgStroke = Instance.new("UIStroke")
UI.ChatboxBgStroke.Color = Color3.fromRGB(255, 255, 255)
UI.ChatboxBgStroke.Transparency = 0.91
UI.ChatboxBgStroke.Thickness = 0.5
UI.ChatboxBgStroke.Parent = UI.ChatboxBg

UI.ChatboxBgLayout = Instance.new("UIListLayout")
UI.ChatboxBgLayout.FillDirection = Enum.FillDirection.Horizontal
UI.ChatboxBgLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ChatboxBgLayout.Padding = UDim.new(0, 0)
UI.ChatboxBgLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ChatboxBgLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.ChatboxBgLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.ChatboxBgLayout.Parent = UI.ChatboxBg

UI.ChatboxBgPadding = Instance.new("UIPadding")
UI.ChatboxBgPadding.PaddingLeft = UDim.new(0, 12)
UI.ChatboxBgPadding.PaddingRight = UDim.new(0, 2)
UI.ChatboxBgPadding.Parent = UI.ChatboxBg

UI.Chatbox = Instance.new("TextBox")
UI.Chatbox.Name = "Chatbox"
UI.Chatbox.BackgroundTransparency = 1
UI.Chatbox.ClearTextOnFocus = false
UI.Chatbox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.Chatbox.LayoutOrder = 1
UI.Chatbox.MultiLine = false
UI.Chatbox.PlaceholderColor3 = Color3.fromRGB(160, 160, 165)
UI.Chatbox.PlaceholderText = "Send a message..."
UI.Chatbox.Text = ""
UI.Chatbox.Size = UDim2.new(1, 0, 1, 0)
UI.Chatbox.TextColor3 = Color3.fromRGB(230, 230, 235)
UI.Chatbox.TextSize = 13
UI.Chatbox.TextTruncate = Enum.TextTruncate.AtEnd
UI.Chatbox.TextXAlignment = Enum.TextXAlignment.Left
UI.Chatbox.TextYAlignment = Enum.TextYAlignment.Center
UI.Chatbox.Parent = UI.ChatboxBg

UI.Send = Instance.new("TextButton")
UI.Send.Name = "Send"
UI.Send.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.Send.BackgroundTransparency = 0.93
UI.Send.LayoutOrder = 2
UI.Send.Modal = true
UI.Send.Text = "↑"
UI.Send.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.Send.TextTransparency = 0.65
UI.Send.TextScaled = true
UI.Send.Parent = UI.ChatboxBg

UI.SendCorner = Instance.new("UICorner")
UI.SendCorner.CornerRadius = UDim.new(0, 6)
UI.SendCorner.Parent = UI.Send

UI.SendStroke = Instance.new("UIStroke")
UI.SendStroke.Color = Color3.fromRGB(255, 255, 255)
UI.SendStroke.Transparency = 0.9
UI.SendStroke.Thickness = 0.5
UI.SendStroke.Parent = UI.Send

UI.SendRatio = Instance.new("UIAspectRatioConstraint")
UI.SendRatio.AspectRatio = 1
UI.SendRatio.Parent = UI.Send

UI.HotkeyLabel = Instance.new("TextLabel")
UI.HotkeyLabel.Name = "HotkeyLabel"
UI.HotkeyLabel.BackgroundTransparency = 1
UI.HotkeyLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.HotkeyLabel.RichText = true
UI.HotkeyLabel.Text = "Press <b><font color=\"#FFFFFF\">'</font></b> to focus chat"
UI.HotkeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.HotkeyLabel.TextTransparency = 0.82
UI.HotkeyLabel.TextSize = 10
UI.HotkeyLabel.Size = UDim2.new(1, 0, 0, 16)
UI.HotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
UI.HotkeyLabel.LayoutOrder = 6
UI.HotkeyLabel.Parent = UI.Chat

UI.HotkeyPadding = Instance.new("UIPadding")
UI.HotkeyPadding.PaddingLeft = UDim.new(0, 14)
UI.HotkeyPadding.PaddingBottom = UDim.new(0, 8)
UI.HotkeyPadding.Parent = UI.HotkeyLabel

local function GetMessageLabels()
    local Labels = {}
    for _, Child in ipairs(UI.Messages:GetChildren()) do
        if Child:IsA("TextLabel") and Child.Name ~= UI.MessageTemplate.Name then
            table.insert(Labels, Child)
        end
    end
    return Labels
end

local function AddMessage(DisplayName, MessageText, UserId)
    local Labels = GetMessageLabels()

    table.sort(Labels, function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)

    while #Labels >= MaxMessages do
        Labels[1]:Destroy()
        table.remove(Labels, 1)
    end

    Labels = GetMessageLabels()
    table.sort(Labels, function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)
    for i, Label in ipairs(Labels) do
        Label.LayoutOrder = i
    end

    local NameColor = RGBToHex(GetNameColor(UserId or 0))
    local Clone = UI.MessageTemplate:Clone()
    Clone.Text = string.format(
        [[<font color="%s"><b>%s:</b></font> <font color="#DCDCE0">%s</font>]],
        NameColor,
        DisplayName,
        MessageText
    )
    Clone.Name = "Message_" .. tostring(UserId) .. "_" .. tostring(os.time())
    Clone.Visible = true
    Clone.LayoutOrder = #Labels + 1
    Clone.Parent = UI.Messages

    task.wait()
    UI.Messages.CanvasPosition = Vector2.new(0, UI.Messages.AbsoluteCanvasSize.Y)
end

local function ShowChat()
    ChatVisible = true
    UI.Chat.Visible = true
    Tween(UI.Chat, 0.35, {Position = SlideInPos}, "Back", "Out"):Play()
end

local function HideChat()
    ChatVisible = false
    local T = Tween(UI.Chat, 0.25, {Position = SlideOutPos}, "Quad", "In")
    T:Play()
    T.Completed:Connect(function()
        if not ChatVisible then
            UI.Chat.Visible = false
        end
    end)
end

local RBXGeneral = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

local function SendMessage()
    local Text = UI.Chatbox.Text
    if Text == "" then return end
    UI.Chatbox.Text = ""
    RBXGeneral:SendAsync(Text)
end

UI.Chatbox:GetPropertyChangedSignal("Text"):Connect(function()
    local HasText = UI.Chatbox.Text ~= ""
    local TargetTransparency = HasText and 0.2 or 0.65
    Tween(UI.Send, 0.15, {TextTransparency = TargetTransparency}):Play()
end)

UI.Send.Activated:Connect(SendMessage)

UI.Chatbox.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        SendMessage()
    end
end)

RBXGeneral.MessageReceived:Connect(function(Message)
    local Source = Message.TextSource
    if not Source then return end
    local Player = Players:GetPlayerByUserId(Source.UserId)
    local DisplayName = Player and Player.DisplayName or tostring(Source.UserId)
    AddMessage(DisplayName, Message.Text, Source.UserId)
end)

UpdatePlayerCount()
Players.PlayerAdded:Connect(UpdatePlayerCount)
Players.PlayerRemoving:Connect(UpdatePlayerCount)

local TopBarApp = Search(CoreGui, "TopBarApp")
local TopBarAppInner = Search(TopBarApp, "TopBarApp")
local UnibarLeftFrame = Search(TopBarAppInner, "UnibarLeftFrame")
local UnibarMenu = Search(UnibarLeftFrame, "UnibarMenu")
local MenuBtn = Search(UnibarMenu, "2", "2")
local MenuIconHolder = Search(TopBarAppInner, "MenuIconHolder")
local TriggerPoint = Search(MenuIconHolder, "TriggerPoint")
local EscBtn = Search(TriggerPoint, "IconHitArea")

EscBtn.Activated:Connect(function()
    if ChatVisible then
        HideChat()
    end
end)

local OriginalChat = CoreGui:FindFirstChild("ExperienceChat")
if OriginalChat then
    Protect(OriginalChat, "Enabled", false)
end

local ChatBtn = UnibarMenu:FindFirstChild("IconHitArea_chat", true)
if not ChatBtn then
    warn("[CoreUI]: ChatBtn not found, chat toggle will not work")
else
    ChatBtn.Activated:Connect(function()
        if ChatVisible then
            HideChat()
        else
            ShowChat()
        end
    end)
end

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.Quote then
        if not ChatVisible then ShowChat() end
        UI.Chatbox:CaptureFocus()
    elseif Input.KeyCode == Enum.KeyCode.Escape then
        if ChatVisible then HideChat() end
    end
end)
