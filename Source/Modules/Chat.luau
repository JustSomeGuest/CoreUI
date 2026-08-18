local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G
local Env = Shared.CoreUI.Env

local Hui = Env.Hui
local CoreGui = Env.CoreGui
local TweenService = Env.TweenService
local Players = Env.Players
local StarterGui = Env.StarterGui
local TextChatService = Env.TextChatService
local UserInputService = Env.UserInputService

local ScreenGui = Env.ScreenGui
local UID = Env.UID
local Error = Env.Error
local Tween = Env.Tween
local Protect = Env.Protect
local RGBToHex = Env.RGBToHex
local FindDescendant = Env.FindDescendant
local UI = Env.Chat

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
local SlideInPos = UDim2.new(0, 16, 0, 2)
local SlideOutPos = UDim2.new(0, -320, 0, 2)

local function GetMessageLabels()
    local Labels = {}
    for _, Child in ipairs(UI["Messages"]:GetChildren()) do
        if Child:IsA("TextLabel") and Child.Name ~= UI["MessageTemplate"].Name then
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
    local Clone = UI["MessageTemplate"]:Clone()
    Clone.Text = string.format(
        [[<font color="%s">[%s]:</font> <font color="#FFFFFF">%s</font>]],
        NameColor,
        DisplayName,
        MessageText
    )
    Clone.Name = "Message_" .. tostring(UserId) .. "_" .. tostring(os.time())
    Clone.Visible = true
    Clone.LayoutOrder = #Labels + 1
    Clone.Parent = UI["Messages"]

    task.wait()
    UI["Messages"].CanvasPosition = Vector2.new(0, UI["Messages"].AbsoluteCanvasSize.Y)
end

local function ShowChat()
    ChatVisible = true
    UI["Chat"].Visible = true
    Tween(UI["Chat"], 0.35, {Position = SlideInPos}, "Back", "Out"):Play()
end

local function HideChat()
    ChatVisible = false
    local T = Tween(UI["Chat"], 0.25, {Position = SlideOutPos}, "Quad", "In")
    T:Play()
    T.Completed:Connect(function()
        if not ChatVisible then
            UI["Chat"].Visible = false
        end
    end)
end

local RBXGeneral = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

local function SendMessage()
    local Text = UI["Chatbox"].Text
    if Text == "" then return end
    UI["Chatbox"].Text = ""
    RBXGeneral:SendAsync(Text)
end

UI["Chat"] = Instance.new("CanvasGroup")
UI["Chat"]["AnchorPoint"] = Vector2.new(0, 0)
UI["Chat"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
UI["Chat"]["BackgroundTransparency"] = 0.1
UI["Chat"]["BorderSizePixel"] = 0
UI["Chat"]["ClipsDescendants"] = true
UI["Chat"]["Name"] = "Chat"
UI["Chat"]["Position"] = UDim2.new(0, 16, 0, 60)
UI["Chat"]["Size"] = UDim2.new(0, 308, 0, 188)
UI["Chat"]["Visible"] = true
UI["Chat"]["Parent"] = ScreenGui

UI["ChatShadow"] = Instance.new("UIShadow")
UI["ChatShadow"]["BlurRadius"] = UDim.new(0, 8)
UI["ChatShadow"]["Color"] = Color3.fromRGB(0, 0, 0)
UI["ChatShadow"]["Transparency"] = 0.5
UI["ChatShadow"]["Parent"] = UI["Chat"]

UI["ChatCorner"] = Instance.new("UICorner")
UI["ChatCorner"]["Name"] = "ChatCorner"
UI["ChatCorner"]["CornerRadius"] = UDim.new(0, 8)
UI["ChatCorner"]["Parent"] = UI["Chat"]

UI["ChatLayout"] = Instance.new("UIListLayout")
UI["ChatLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ChatLayout"]["Name"] = "ChatLayout"
UI["ChatLayout"]["Padding"] = UDim.new(0, 2)
UI["ChatLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ChatLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ChatLayout"]["Parent"] = UI["Chat"]

UI["ChatPadding"] = Instance.new("UIPadding")
UI["ChatPadding"]["Name"] = "ChatPadding"
UI["ChatPadding"]["PaddingBottom"] = UDim.new(0, 4)
UI["ChatPadding"]["PaddingLeft"] = UDim.new(0, 4)
UI["ChatPadding"]["PaddingRight"] = UDim.new(0, 4)
UI["ChatPadding"]["PaddingTop"] = UDim.new(0, 4)
UI["ChatPadding"]["Parent"] = UI["Chat"]

UI["Messages"] = Instance.new("ScrollingFrame")
UI["Messages"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
UI["Messages"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["Messages"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Messages"]["BackgroundTransparency"] = 1
UI["Messages"]["BorderSizePixel"] = 0
UI["Messages"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
UI["Messages"]["LayoutOrder"] = 1
UI["Messages"]["Name"] = "Messages"
UI["Messages"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
UI["Messages"]["ScrollBarThickness"] = 4
UI["Messages"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["Messages"]["Size"] = UDim2.new(1, -8, 1, -8)
UI["Messages"]["Parent"] = UI["Chat"]

UI["MessagesLayout"] = Instance.new("UIListLayout")
UI["MessagesLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["MessagesLayout"]["Name"] = "MessagesLayout"
UI["MessagesLayout"]["Padding"] = UDim.new(0, 2)
UI["MessagesLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["MessagesLayout"]["Parent"] = UI["Messages"]

UI["MessagesPadding"] = Instance.new("UIPadding")
UI["MessagesPadding"]["Name"] = "MessagesPadding"
UI["MessagesPadding"]["PaddingRight"] = UDim.new(0, 6)
UI["MessagesPadding"]["Parent"] = UI["Messages"]

UI["MessageTemplate"] = Instance.new("TextLabel")
UI["MessageTemplate"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["MessageTemplate"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["MessageTemplate"]["BackgroundTransparency"] = 1
UI["MessageTemplate"]["BorderSizePixel"] = 0
UI["MessageTemplate"]["FontFace"] = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["MessageTemplate"]["Name"] = "MessageTemplate"
UI["MessageTemplate"]["Position"] = UDim2.new(0, 0, 0, 0)
UI["MessageTemplate"]["RichText"] = true
UI["MessageTemplate"]["Size"] = UDim2.new(1, 0, 0, 0)
UI["MessageTemplate"]["Text"] = [[<font color="#4DA6FF">[DisplayName]:</font> <font color="#FFFFFF">Message</font>]]
UI["MessageTemplate"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["MessageTemplate"]["TextSize"] = 18
UI["MessageTemplate"]["TextWrapped"] = true
UI["MessageTemplate"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["MessageTemplate"]["TextYAlignment"] = Enum.TextYAlignment.Top
UI["MessageTemplate"]["Visible"] = false
UI["MessageTemplate"]["Parent"] = UI["Messages"]

UI["ChatFrame"] = Instance.new("Frame")
UI["ChatFrame"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["ChatFrame"]["BackgroundTransparency"] = 0.9
UI["ChatFrame"]["BorderSizePixel"] = 0
UI["ChatFrame"]["LayoutOrder"] = 2
UI["ChatFrame"]["Name"] = "ChatFrame"
UI["ChatFrame"]["Size"] = UDim2.new(1, 0, 0, 44)
UI["ChatFrame"]["Parent"] = UI["Chat"]

UI["ChatFrameCorner"] = Instance.new("UICorner")
UI["ChatFrameCorner"]["Name"] = "ChatFrameCorner"
UI["ChatFrameCorner"]["CornerRadius"] = UDim.new(0, 6)
UI["ChatFrameCorner"]["Parent"] = UI["ChatFrame"]

UI["ChatFrameStroke"] = Instance.new("UIStroke")
UI["ChatFrameStroke"]["Color"] = Color3.fromRGB(60, 60, 70)
UI["ChatFrameStroke"]["Name"] = "ChatFrameStroke"
UI["ChatFrameStroke"]["Parent"] = UI["ChatFrame"]

UI["ChatFrameLayout"] = Instance.new("UIListLayout")
UI["ChatFrameLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["ChatFrameLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ChatFrameLayout"]["Name"] = "ChatFrameLayout"
UI["ChatFrameLayout"]["Padding"] = UDim.new(0, 4)
UI["ChatFrameLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ChatFrameLayout"]["VerticalAlignment"] = Enum.VerticalAlignment.Center
UI["ChatFrameLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["ChatFrameLayout"]["Parent"] = UI["ChatFrame"]

UI["ChatFramePadding"] = Instance.new("UIPadding")
UI["ChatFramePadding"]["Name"] = "ChatFramePadding"
UI["ChatFramePadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["ChatFramePadding"]["PaddingLeft"] = UDim.new(0, 10)
UI["ChatFramePadding"]["PaddingRight"] = UDim.new(0, 2)
UI["ChatFramePadding"]["PaddingTop"] = UDim.new(0, 2)
UI["ChatFramePadding"]["Parent"] = UI["ChatFrame"]

UI["Chatbox"] = Instance.new("TextBox")
UI["Chatbox"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Chatbox"]["BackgroundTransparency"] = 1
UI["Chatbox"]["BorderSizePixel"] = 0
UI["Chatbox"]["FontFace"] = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Chatbox"]["LayoutOrder"] = 1
UI["Chatbox"]["Name"] = "Chatbox"
UI["Chatbox"]["PlaceholderColor3"] = Color3.fromRGB(114, 114, 114)
UI["Chatbox"]["PlaceholderText"] = "Tap here to chat"
UI["Chatbox"]["Text"] = ""
UI["Chatbox"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Chatbox"]["TextScaled"] = true
UI["Chatbox"]["TextSize"] = 18
UI["Chatbox"]["TextWrapped"] = true
UI["Chatbox"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Chatbox"]["Parent"] = UI["ChatFrame"]

UI["TextConstraint"] = Instance.new("UITextSizeConstraint")
UI["TextConstraint"]["MaxTextSize"] = 22
UI["TextConstraint"]["Name"] = "TextConstraint"
UI["TextConstraint"]["Parent"] = UI["Chatbox"]

UI["Send"] = Instance.new("TextButton")
UI["Send"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
UI["Send"]["BackgroundTransparency"] = 1
UI["Send"]["BorderSizePixel"] = 0
UI["Send"]["FontFace"] = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Send"]["LayoutOrder"] = 2
UI["Send"]["Name"] = "Send"
UI["Send"]["Size"] = UDim2.new(0, 36, 0, 36)
UI["Send"]["Text"] = "↑"
UI["Send"]["TextColor3"] = Color3.fromRGB(114, 114, 114)
UI["Send"]["TextScaled"] = true
UI["Send"]["TextWrapped"] = true
UI["Send"]["Parent"] = UI["ChatFrame"]

UI["SendRatio"] = Instance.new("UIAspectRatioConstraint")
UI["SendRatio"]["AspectRatio"] = 1
UI["SendRatio"]["Name"] = "SendRatio"
UI["SendRatio"]["Parent"] = UI["Send"]

UI["SendPadding"] = Instance.new("UIPadding")
UI["SendPadding"]["Name"] = "SendPadding"
UI["SendPadding"]["PaddingBottom"] = UDim.new(0, 2)
UI["SendPadding"]["PaddingLeft"] = UDim.new(0, 2)
UI["SendPadding"]["PaddingRight"] = UDim.new(0, 2)
UI["SendPadding"]["PaddingTop"] = UDim.new(0, 2)
UI["SendPadding"]["Parent"] = UI["Send"]

UI["Chatbox"]:GetPropertyChangedSignal("Text"):Connect(function()
    local TargetColor = UI["Chatbox"].Text ~= "" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(114, 114, 114)
    Tween(UI["Send"], 0.2, {TextColor3 = TargetColor}):Play()
end)

UI["Send"]["Activated"]:Connect(SendMessage)

UI["Chatbox"]["FocusLost"]:Connect(function(EnterPressed)
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

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Error("LocalPlayer was not found")
end

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not PlayerGui then
    Error("PlayerGui was not found")
end

local TopbarStandard = FindDescendant(PlayerGui, "TopbarStandard")
local Holders = FindDescendant(TopbarStandard, "Holders")
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