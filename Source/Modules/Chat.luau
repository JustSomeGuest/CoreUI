if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G
local Env = Shared.CoreUI.Env

local CoreGui = Env.CoreGui
local Players = Env.Players
local TextChatService = Env.TextChatService
local UserInputService = Env.UserInputService

local ScreenGui = Env.ScreenGui
local Tween = Env.Tween
local Protect = Env.Protect
local RGBToHex = Env.RGBToHex
local FindDescendant = Env.FindDescendant
local IsMobile = Env.IsMobile
local IsDesktop = Env.IsDesktop
local UI = {}

local SECONDARY_COLOR = Color3.fromRGB(50, 50, 50)

local NameColors = {
    Color3.fromRGB(255, 100, 100),
    Color3.fromRGB(255, 160, 80),
    Color3.fromRGB(255, 220, 80),
    Color3.fromRGB(120, 220, 80),
    Color3.fromRGB(80, 220, 160),
    Color3.fromRGB(80, 200, 255),
    Color3.fromRGB(100, 140, 255),
    Color3.fromRGB(160, 100, 255),
    Color3.fromRGB(220, 80, 255),
    Color3.fromRGB(255, 80, 200),
    Color3.fromRGB(255, 80, 130),
    Color3.fromRGB(255, 140, 180),
    Color3.fromRGB(140, 255, 180),
    Color3.fromRGB(80, 255, 220),
    Color3.fromRGB(180, 255, 100),
    Color3.fromRGB(255, 200, 120),
    Color3.fromRGB(120, 180, 255),
    Color3.fromRGB(200, 120, 255),
    Color3.fromRGB(255, 120, 80),
    Color3.fromRGB(80, 255, 140)
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
local SlideOutPos = UDim2.new(0, -340, 0, 60)

UI.Chat = Instance.new("CanvasGroup")
UI.Chat.Name = "Chat"
UI.Chat.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UI.Chat.BackgroundTransparency = 0.08
UI.Chat.Position = UDim2.new(0, -340, 0, 60)
UI.Chat.Size = IsMobile() and UDim2.new(0, 360, 0, 220) or IsDesktop() and UDim2.new(0, 540, 0, 330)
UI.Chat.Visible = false
UI.Chat.Parent = ScreenGui

UI.ChatCorner = Instance.new("UICorner")
UI.ChatCorner.Name = "ChatCorner"
UI.ChatCorner.CornerRadius = UDim.new(0, 8)
UI.ChatCorner.Parent = UI.Chat

UI.ChatLayout = Instance.new("UIListLayout")
UI.ChatLayout.Name = "ChatLayout"
UI.ChatLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ChatLayout.Padding = UDim.new(0, 0)
UI.ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ChatLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.ChatLayout.Parent = UI.Chat

UI.Messages = Instance.new("ScrollingFrame")
UI.Messages.Name = "Messages"
UI.Messages.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.Messages.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.Messages.BackgroundTransparency = 1
UI.Messages.ScrollBarThickness = 0
UI.Messages.ScrollingDirection = Enum.ScrollingDirection.Y
UI.Messages.Size = UDim2.fromScale(1, 1)
UI.Messages.Parent = UI.Chat

UI.MessagesLayout = Instance.new("UIListLayout")
UI.MessagesLayout.Name = "MessagesLayout"
UI.MessagesLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.MessagesLayout.Padding = UDim.new(0, 1)
UI.MessagesLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.MessagesLayout.Parent = UI.Messages

UI.MessagesPadding = Instance.new("UIPadding")
UI.MessagesPadding.Name = "MessagesPadding"
UI.MessagesPadding.PaddingBottom = UDim.new(0, 8)
UI.MessagesPadding.PaddingLeft = UDim.new(0, 8)
UI.MessagesPadding.PaddingRight = UDim.new(0, 8)
UI.MessagesPadding.PaddingTop = UDim.new(0, 8)
UI.MessagesPadding.Parent = UI.Messages

UI.MessageTemplate = Instance.new("TextLabel")
UI.MessageTemplate.Name = "MessageTemplate"
UI.MessageTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.MessageTemplate.BackgroundTransparency = 1
UI.MessageTemplate.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.MessageTemplate.RichText = true
UI.MessageTemplate.Size = UDim2.new(1, 0, 0, 0)
UI.MessageTemplate.TextSize = 14
UI.MessageTemplate.TextWrapped = true
UI.MessageTemplate.TextXAlignment = Enum.TextXAlignment.Left
UI.MessageTemplate.TextYAlignment = Enum.TextYAlignment.Top
UI.MessageTemplate.Visible = false
UI.MessageTemplate.Parent = UI.Messages

UI.Divider = Instance.new("Frame")
UI.Divider.Name = "Divider"
UI.Divider.BackgroundColor3 = SECONDARY_COLOR
UI.Divider.BorderSizePixel = 0
UI.Divider.LayoutOrder = 2
UI.Divider.Size = UDim2.new(1, 0, 0, 1)
UI.Divider.Parent = UI.Chat

UI.ChatboxInner = Instance.new("Frame")
UI.ChatboxInner.Name = "ChatboxInner"
UI.ChatboxInner.BackgroundTransparency = 1
UI.ChatboxInner.LayoutOrder = 3
UI.ChatboxInner.Size = UDim2.new(1, 0, 0, 44)
UI.ChatboxInner.Parent = UI.Chat

UI.ChatboxInnerConst = Instance.new("UISizeConstraint")
UI.ChatboxInnerConst.Name = "ChatboxInnerConst"
UI.ChatboxInnerConst.MaxSize = Vector2.new(1e9, 44)
UI.ChatboxInnerConst.Parent = UI.ChatboxInner

UI.ChatboxInnerPadding = Instance.new("UIPadding")
UI.ChatboxInnerPadding.Name = "ChatboxInnerPadding"
UI.ChatboxInnerPadding.PaddingLeft = UDim.new(0, 16)
UI.ChatboxInnerPadding.PaddingRight = UDim.new(0, 8)
UI.ChatboxInnerPadding.PaddingTop = UDim.new(0, 6)
UI.ChatboxInnerPadding.PaddingBottom = UDim.new(0, 6)
UI.ChatboxInnerPadding.Parent = UI.ChatboxInner

UI.ChatboxInnerLayout = Instance.new("UIListLayout")
UI.ChatboxInnerLayout.Name = "ChatboxInnerLayout"
UI.ChatboxInnerLayout.FillDirection = Enum.FillDirection.Horizontal
UI.ChatboxInnerLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ChatboxInnerLayout.Padding = UDim.new(0, 8)
UI.ChatboxInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ChatboxInnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.ChatboxInnerLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.ChatboxInnerLayout.Parent = UI.ChatboxInner

UI.Chatbox = Instance.new("TextBox")
UI.Chatbox.Name = "Chatbox"
UI.Chatbox.BackgroundTransparency = 1
UI.Chatbox.ClearTextOnFocus = false
UI.Chatbox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.Chatbox.LayoutOrder = 1
UI.Chatbox.MultiLine = false
UI.Chatbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
UI.Chatbox.Text = ""
UI.Chatbox.PlaceholderText = "Send a message..."
UI.Chatbox.Size = UDim2.new(1, 0, 1, 0)
UI.Chatbox.TextColor3 = Color3.fromRGB(230, 230, 230)
UI.Chatbox.TextSize = 16
UI.Chatbox.TextTruncate = Enum.TextTruncate.AtEnd
UI.Chatbox.TextXAlignment = Enum.TextXAlignment.Left
UI.Chatbox.TextYAlignment = Enum.TextYAlignment.Center
UI.Chatbox.Parent = UI.ChatboxInner

UI.Send = Instance.new("TextButton")
UI.Send.Name = "Send"
UI.Send.BackgroundTransparency = 1
UI.Send.LayoutOrder = 2
UI.Send.Modal = true
UI.Send.Text = "↑"
UI.Send.TextColor3 = Color3.fromRGB(100, 100, 100)
UI.Send.TextScaled = true
UI.Send.Parent = UI.ChatboxInner

UI.SendRatio = Instance.new("UIAspectRatioConstraint")
UI.SendRatio.Name = "SendRatio"
UI.SendRatio.AspectRatio = 1
UI.SendRatio.Parent = UI.Send

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
        [[<font color="%s">%s:</font> <font color="#E6E6E6">%s</font>]],
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
    local TargetColor = HasText and Color3.fromRGB(247, 247, 248) or Color3.fromRGB(100, 100, 100)
    Tween(UI.Send, 0.15, {TextColor3 = TargetColor}):Play()
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

local TopBarApp = FindDescendant(CoreGui, "TopBarApp")
local TopBarAppInner = FindDescendant(TopBarApp, "TopBarApp")
local UnibarLeftFrame = FindDescendant(TopBarAppInner, "UnibarLeftFrame")
local UnibarMenu = FindDescendant(UnibarLeftFrame, "UnibarMenu")
local MenuBtn = FindDescendant(UnibarMenu, "2", "2")
local MenuIconHolder = FindDescendant(TopBarAppInner, "MenuIconHolder")
local TriggerPoint = FindDescendant(MenuIconHolder, "TriggerPoint")
local EscBtn = FindDescendant(TriggerPoint, "IconHitArea")

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