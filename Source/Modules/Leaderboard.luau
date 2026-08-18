local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G
local Env = Shared.CoreUI.Env

local CoreGui          = Env.CoreGui
local Players          = Env.Players
local ScreenGui        = Env.ScreenGui
local StarterGui       = Env.StarterGui
local UserInputService = Env.UserInputService
local Tween            = Env.Tween
local UI               = Env.Leaderboard

local WriteFile  = writefile  or function() end
local IsFile     = isfile     or function() return false end
local IsFolder   = isfolder   or function() return false end
local MakeFolder = makefolder or function() end
local LoadAsset  = getcustomasset or getsynasset

local BASE_URL = "https://raw.githubusercontent.com/JustSomeGuest/CoreUI/Main/Source/Assets/"

local ASSETS = {
    ["CoreUI/AddFriend.png"]  = BASE_URL .. "AddFriend.png",
    ["CoreUI/Unfriend.png"]   = BASE_URL .. "Unfriend.png",
    ["CoreUI/Block.png"]      = BASE_URL .. "Block.png",
    ["CoreUI/Examine.png"]    = BASE_URL .. "Examine.png",
    ["CoreUI/Goto.png"]       = BASE_URL .. "Goto.png",
    ["CoreUI/Report.png"]     = BASE_URL .. "Report.png",
    ["CoreUI/Spectate.png"]   = BASE_URL .. "Spectate.png",
    ["CoreUI/Unspectate.png"] = BASE_URL .. "Unspectate.png",
}

local function HttpGet(url)
    local RequestFunc = http_request or request or (syn and syn.request)

    if not RequestFunc then
        local ok, result = pcall(game.HttpGet, game, url)
        return ok and { Success = true, Body = result } or nil
    end

    local ok, result = pcall(RequestFunc, { Url = url, Method = "GET" })
    return ok and result or nil
end

local function GetAsset(path)
    if not LoadAsset then
        warn("[CoreUI] getcustomasset/getsynasset not supported by this executor")
        return nil
    end

    local remoteURL = ASSETS[path]
    if not remoteURL then
        warn("[CoreUI] No asset registered for path: " .. path)
        return nil
    end

    if remoteURL:match("^rbxassetid://") then
        return remoteURL
    end

    if not IsFile(path) then
        local folder = path:match("^(.+)/[^/]+$")
        if folder and not IsFolder(folder) then
            MakeFolder(folder)
        end

        local response = HttpGet(remoteURL)
        if not response or not response.Success or not response.Body then
            warn("[CoreUI] Failed to download asset: " .. path)
            return nil
        end

        WriteFile(path, response.Body)
    end

    local ok, result = pcall(LoadAsset, path)
    if ok then return result end

    warn("[CoreUI] Failed to load local asset: " .. path)
    return nil
end

UI["Leaderboard"] = Instance.new("CanvasGroup")
UI["Leaderboard"].Name                 = "Leaderboard"
UI["Leaderboard"].AnchorPoint          = Vector2.new(1, 0)
UI["Leaderboard"].AutomaticSize        = Enum.AutomaticSize.Y
UI["Leaderboard"].BackgroundColor3     = Color3.fromRGB(10, 10, 10)
UI["Leaderboard"].BackgroundTransparency = 0.08
UI["Leaderboard"].BorderSizePixel      = 0
UI["Leaderboard"].ClipsDescendants     = false
UI["Leaderboard"].Position             = UDim2.new(1, 8, 0, 8)
UI["Leaderboard"].Size                 = UDim2.new(0, 200, 0, 0)
UI["Leaderboard"].Visible              = false
UI["Leaderboard"].Parent               = ScreenGui

local leaderboardCorner = Instance.new("UICorner")
leaderboardCorner.CornerRadius = UDim.new(0, 8)
leaderboardCorner.Parent       = UI["Leaderboard"]

local leaderboardSizeConstraint = Instance.new("UISizeConstraint")
leaderboardSizeConstraint.MinSize = Vector2.new(200, 0)
leaderboardSizeConstraint.Parent  = UI["Leaderboard"]

UI["Topbar"] = Instance.new("Frame")
UI["Topbar"].Name                 = "Topbar"
UI["Topbar"].AutomaticSize        = Enum.AutomaticSize.Y
UI["Topbar"].BackgroundTransparency = 1
UI["Topbar"].BorderSizePixel      = 0
UI["Topbar"].Size                 = UDim2.new(1, 0, 0, 36)
UI["Topbar"].Parent               = UI["Leaderboard"]

local topbarStroke = Instance.new("UIStroke")
topbarStroke.Color  = Color3.fromRGB(30, 30, 30)
topbarStroke.Parent = UI["Topbar"]

local topbarPadding = Instance.new("UIPadding")
topbarPadding.PaddingBottom = UDim.new(0, 8)
topbarPadding.PaddingLeft   = UDim.new(0, 16)
topbarPadding.PaddingRight  = UDim.new(0, 16)
topbarPadding.PaddingTop    = UDim.new(0, 8)
topbarPadding.Parent        = UI["Topbar"]

local topbarLayout = Instance.new("UIListLayout")
topbarLayout.FillDirection      = Enum.FillDirection.Horizontal
topbarLayout.HorizontalFlex     = Enum.UIFlexAlignment.Fill
topbarLayout.Padding            = UDim.new(0, 8)
topbarLayout.SortOrder          = Enum.SortOrder.LayoutOrder
topbarLayout.VerticalAlignment  = Enum.VerticalAlignment.Center
topbarLayout.VerticalFlex       = Enum.UIFlexAlignment.Fill
topbarLayout.Parent             = UI["Topbar"]

UI["Title"] = Instance.new("TextLabel")
UI["Title"].FontFace        = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
UI["Title"].LayoutOrder     = 1
UI["Title"].BackgroundTransparency = 1
UI["Title"].Size            = UDim2.new(0, 0, 0, 0)
UI["Title"].Text            = "Leaderboard"
UI["Title"].TextColor3      = Color3.fromRGB(255, 255, 255)
UI["Title"].TextScaled      = true
UI["Title"].TextXAlignment  = Enum.TextXAlignment.Left
UI["Title"].TextYAlignment  = Enum.TextYAlignment.Center
UI["Title"].Parent          = UI["Topbar"]

local titleSizeConstraint = Instance.new("UISizeConstraint")
titleSizeConstraint.MaxSize = Vector2.new(1e6, 36)
titleSizeConstraint.Parent  = UI["Title"]

UI["Close"] = Instance.new("TextButton")
UI["Close"].FontFace        = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
UI["Close"].LayoutOrder     = 2
UI["Close"].BackgroundTransparency = 1
UI["Close"].Size            = UDim2.new(0, 0, 0, 0)
UI["Close"].Text            = "╳"
UI["Close"].TextColor3      = Color3.fromRGB(255, 255, 255)
UI["Close"].TextScaled      = true
UI["Close"].Parent          = UI["Topbar"]

local closeRatio = Instance.new("UIAspectRatioConstraint")
closeRatio.AspectRatio = 1
closeRatio.Parent      = UI["Close"]

local closePadding = Instance.new("UIPadding")
closePadding.PaddingBottom = UDim.new(0, 3)
closePadding.PaddingTop    = UDim.new(0, 3)
closePadding.Parent        = UI["Close"]

UI["Players"] = Instance.new("ScrollingFrame")
UI["Players"].Name                  = "Players"
UI["Players"].AutomaticCanvasSize   = Enum.AutomaticSize.Y
UI["Players"].AutomaticSize         = Enum.AutomaticSize.Y
UI["Players"].BackgroundTransparency = 1
UI["Players"].BorderSizePixel       = 0
UI["Players"].CanvasSize            = UDim2.new(0, 0, 0, 0)
UI["Players"].ScrollBarThickness    = 0
UI["Players"].ScrollingDirection    = Enum.ScrollingDirection.Y
UI["Players"].Size                  = UDim2.new(0, 0, 0, 0)
UI["Players"].Parent                = UI["Leaderboard"]

local playersLayout = Instance.new("UIListLayout")
playersLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
playersLayout.Padding        = UDim.new(0, 1)
playersLayout.SortOrder      = Enum.SortOrder.Name
playersLayout.Parent         = UI["Players"]

UI["PlayerTemplate"] = Instance.new("TextButton")
UI["PlayerTemplate"].Name               = "PlayerTemplate"
UI["PlayerTemplate"].AutomaticSize      = Enum.AutomaticSize.Y
UI["PlayerTemplate"].BackgroundTransparency = 1
UI["PlayerTemplate"].BorderSizePixel    = 0
UI["PlayerTemplate"].FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI["PlayerTemplate"].Size               = UDim2.new(0, 100, 0, 0)
UI["PlayerTemplate"].Text               = "Display Name"
UI["PlayerTemplate"].TextColor3         = Color3.fromRGB(230, 230, 230)
UI["PlayerTemplate"].TextSize           = 16
UI["PlayerTemplate"].TextXAlignment     = Enum.TextXAlignment.Left
UI["PlayerTemplate"].Visible            = false
UI["PlayerTemplate"].Parent             = UI["Players"]

local templatePadding = Instance.new("UIPadding")
templatePadding.PaddingBottom = UDim.new(0, 8)
templatePadding.PaddingLeft   = UDim.new(0, 16)
templatePadding.PaddingRight  = UDim.new(0, 16)
templatePadding.PaddingTop    = UDim.new(0, 8)
templatePadding.Parent        = UI["PlayerTemplate"]

UI["ProfileTemplate"] = Instance.new("CanvasGroup")
UI["ProfileTemplate"].Name               = "ProfileTemplate"
UI["ProfileTemplate"].AnchorPoint        = Vector2.new(1, 0)
UI["ProfileTemplate"].AutomaticSize      = Enum.AutomaticSize.Y
UI["ProfileTemplate"].BackgroundColor3   = Color3.fromRGB(10, 10, 10)
UI["ProfileTemplate"].BackgroundTransparency = 0.08
UI["ProfileTemplate"].BorderSizePixel    = 0
UI["ProfileTemplate"].Position           = UDim2.new(1, -214, 0, 8)
UI["ProfileTemplate"].Size               = UDim2.new(0, 240, 0, 0)
UI["ProfileTemplate"].Visible            = false
UI["ProfileTemplate"].Parent             = ScreenGui

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 8)
profileCorner.Parent       = UI["ProfileTemplate"]

local profilePadding = Instance.new("UIPadding")
profilePadding.PaddingBottom = UDim.new(0, 8)
profilePadding.PaddingLeft   = UDim.new(0, 8)
profilePadding.PaddingRight  = UDim.new(0, 8)
profilePadding.PaddingTop    = UDim.new(0, 8)
profilePadding.Parent        = UI["ProfileTemplate"]

local profileLayout = Instance.new("UIListLayout")
profileLayout.FillDirection  = Enum.FillDirection.Vertical
profileLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
profileLayout.Padding        = UDim.new(0, 10)
profileLayout.SortOrder      = Enum.SortOrder.LayoutOrder
profileLayout.Parent         = UI["ProfileTemplate"]

UI["PlayerInfo"] = Instance.new("Frame")
UI["PlayerInfo"].Name               = "PlayerInfo"
UI["PlayerInfo"].AutomaticSize      = Enum.AutomaticSize.None
UI["PlayerInfo"].BackgroundTransparency = 1
UI["PlayerInfo"].LayoutOrder        = 1
UI["PlayerInfo"].Size               = UDim2.new(0, 100, 0, 100)
UI["PlayerInfo"].Parent             = UI["ProfileTemplate"]

local playerInfoLayout = Instance.new("UIListLayout")
playerInfoLayout.FillDirection  = Enum.FillDirection.Horizontal
playerInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
playerInfoLayout.Padding        = UDim.new(0, 6)
playerInfoLayout.VerticalFlex   = Enum.UIFlexAlignment.Fill
playerInfoLayout.Parent         = UI["PlayerInfo"]

UI["Headshot"] = Instance.new("ImageLabel")
UI["Headshot"].Name               = "Headshot"
UI["Headshot"].BackgroundTransparency = 1
UI["Headshot"].Image              = "rbxasset://textures/ui/GuiImagePlaceholder.png"
UI["Headshot"].LayoutOrder        = 1
UI["Headshot"].Size               = UDim2.new(0, 100, 0, 100)
UI["Headshot"].Parent             = UI["PlayerInfo"]

local headshotRatio = Instance.new("UIAspectRatioConstraint")
headshotRatio.AspectRatio = 1
headshotRatio.Parent      = UI["Headshot"]

local headshotCorner = Instance.new("UICorner")
headshotCorner.CornerRadius = UDim.new(1, 0)
headshotCorner.Parent       = UI["Headshot"]

UI["Info"] = Instance.new("Frame")
UI["Info"].Name               = "Info"
UI["Info"].BackgroundTransparency = 1
UI["Info"].LayoutOrder        = 2
UI["Info"].Size               = UDim2.new(0, 0, 0, 0)
UI["Info"].Parent             = UI["PlayerInfo"]

local infoLayout = Instance.new("UIListLayout")
infoLayout.FillDirection  = Enum.FillDirection.Vertical
infoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
infoLayout.Padding        = UDim.new(0, 2)
infoLayout.VerticalFlex   = Enum.UIFlexAlignment.Fill
infoLayout.Parent         = UI["Info"]

local function MakeInfoLabel(name, defaultText, textSize, layoutOrder)
    local lbl = Instance.new("TextLabel")
    lbl.Name               = name
    lbl.BackgroundTransparency = 1
    lbl.FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json")
    lbl.LayoutOrder        = layoutOrder
    lbl.Size               = UDim2.new(0, 100, 0, 50)
    lbl.Text               = defaultText
    lbl.TextColor3         = Color3.fromRGB(layoutOrder == 1 and 240 or 230, layoutOrder == 1 and 240 or 230, layoutOrder == 1 and 240 or 230)
    lbl.TextSize           = textSize
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.TextYAlignment     = Enum.TextYAlignment.Center
    lbl.Parent             = UI["Info"]
    return lbl
end

UI["DisplayName"] = MakeInfoLabel("DisplayName", "DisplayName", 16, 1)
UI["Username"]    = MakeInfoLabel("Username",    "@Username",   14, 2)
UI["UserId"]      = MakeInfoLabel("UserId",      "1",           14, 3)

UI["Divider"] = Instance.new("Frame")
UI["Divider"].Name             = "Divider"
UI["Divider"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UI["Divider"].BorderSizePixel  = 0
UI["Divider"].LayoutOrder      = 2
UI["Divider"].Size             = UDim2.new(1, 0, 0, 1)
UI["Divider"].Parent           = UI["ProfileTemplate"]

UI["Actions"] = Instance.new("Frame")
UI["Actions"].Name               = "Actions"
UI["Actions"].AutomaticSize      = Enum.AutomaticSize.Y
UI["Actions"].BackgroundTransparency = 1
UI["Actions"].LayoutOrder        = 3
UI["Actions"].Size               = UDim2.new(0, 0, 0, 0)
UI["Actions"].Parent             = UI["ProfileTemplate"]

local actionsLayout = Instance.new("UIListLayout")
actionsLayout.FillDirection  = Enum.FillDirection.Vertical
actionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
actionsLayout.Padding        = UDim.new(0, 8)
actionsLayout.SortOrder      = Enum.SortOrder.LayoutOrder
actionsLayout.Parent         = UI["Actions"]

local function MakeAction(name, label, iconPath, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Name               = name
    btn.AutomaticSize      = Enum.AutomaticSize.Y
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel    = 0
    btn.FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json")
    btn.LayoutOrder        = layoutOrder
    btn.Size               = UDim2.new(0, 0, 0, 0)
    btn.Text               = ""
    btn.TextColor3         = Color3.fromRGB(255, 255, 255)
    btn.TextSize           = 14
    btn.Parent             = UI["Actions"]

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection     = Enum.FillDirection.Horizontal
    btnLayout.HorizontalFlex    = Enum.UIFlexAlignment.Fill
    btnLayout.Padding           = UDim.new(0, 4)
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Parent            = btn

    local icon = Instance.new("ImageLabel")
    icon.Name               = "ActionIcon"
    icon.BackgroundTransparency = 1
    icon.ImageColor3        = Color3.fromRGB(255, 255, 255)
    icon.LayoutOrder        = 1
    icon.Size               = UDim2.new(0, 30, 0, 30)
    icon.Parent             = btn

    local iconRatio = Instance.new("UIAspectRatioConstraint")
    iconRatio.AspectRatio = 1
    iconRatio.Parent      = icon

    task.spawn(function()
        local asset = GetAsset(iconPath)
        if asset then icon.Image = asset end
    end)

    local lbl = Instance.new("TextLabel")
    lbl.Name               = "ActionLabel"
    lbl.BackgroundTransparency = 1
    lbl.FontFace           = Font.new("rbxasset://fonts/families/GothamSSm.json")
    lbl.LayoutOrder        = 2
    lbl.Size               = UDim2.new(0.9, 0, 0, 30)
    lbl.Text               = label
    lbl.TextColor3         = Color3.fromRGB(230, 230, 230)
    lbl.TextSize           = 16
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.TextYAlignment     = Enum.TextYAlignment.Center
    lbl.Parent             = btn

    return btn, lbl, icon
end

local AddFriendBtn, AddFriendLbl = MakeAction("AddFriend", "Add Friend", "CoreUI/AddFriend.png", 1)
local ExamineBtn,   ExamineLbl   = MakeAction("Examine",   "Examine",   "CoreUI/Examine.png",   2)
local BlockBtn,     BlockLbl     = MakeAction("Block",     "Block",     "CoreUI/Block.png",     3)
local GotoBtn,      GotoLbl      = MakeAction("Goto",      "Goto",      "CoreUI/Goto.png",      4)
local ReportBtn,    ReportLbl    = MakeAction("Report",    "Report",    "CoreUI/Report.png",    5)
local SpectateBtn,  SpectatelLbl = MakeAction("Spectate",  "Spectate",  "CoreUI/Spectate.png",  6)

local LeaderboardVisible = false
local SelectedPlayer     = nil
local IsSpectating       = false

local OPEN_POS   = UDim2.new(1, -8,  0, 8)
local CLOSED_POS = UDim2.new(1, 208, 0, 8)

local function ShowLeaderboard()
    LeaderboardVisible = true
    UI["Leaderboard"].Visible = true
    Tween(UI["Leaderboard"], 0.35, { Position = OPEN_POS }, "Back", "Out"):Play()
end

local function HideLeaderboard()
    LeaderboardVisible = false
    UI["ProfileTemplate"].Visible = false

    local t = Tween(UI["Leaderboard"], 0.25, { Position = CLOSED_POS }, "Quad", "In")
    t:Play()
    t.Completed:Connect(function()
        if not LeaderboardVisible then
            UI["Leaderboard"].Visible = false
        end
    end)
end

local function ShowProfile(player)
    SelectedPlayer = player

    local localPlayer = Players.LocalPlayer
    local isSelf      = player.UserId == localPlayer.UserId
    local isFriend    = localPlayer:IsFriendsWith(player.UserId)

    UI["DisplayName"].Text = player.DisplayName
    UI["Username"].Text    = "@" .. player.Name
    UI["UserId"].Text      = tostring(player.UserId)

    UI["Headshot"].Image = Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )

    AddFriendLbl.Text   = isFriend and "Unfriend" or "Add Friend"
    SpectatelLbl.Text   = IsSpectating and "Unspectate" or "Spectate"

    AddFriendBtn.Visible = not isSelf
    GotoBtn.Visible      = not isSelf
    SpectateBtn.Visible  = not isSelf
    ReportBtn.Visible    = not isSelf

    UI["ProfileTemplate"].Visible = true
end

local function RefreshPlayers()
    for _, child in ipairs(UI["Players"]:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "PlayerTemplate" then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        local entry = UI["PlayerTemplate"]:Clone()
        entry.Name    = player.Name
        entry.Text    = player.DisplayName
        entry.Visible = true
        entry.Parent  = UI["Players"]

        entry.Activated:Connect(function()
            ShowProfile(player)
        end)
    end
end

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(player)
    if SelectedPlayer == player then
        UI["ProfileTemplate"].Visible = false
        SelectedPlayer = nil
    end
    RefreshPlayers()
end)

RefreshPlayers()

UI["UserId"].InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        local SetClip = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if SetClip then SetClip(UI["UserId"].Text) end
    end
end)

AddFriendBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    if Players.LocalPlayer:IsFriendsWith(SelectedPlayer.UserId) then
        AddFriendLbl.Text = "Add Friend"
    else
        StarterGui:SetCore("PromptSendFriendRequest", SelectedPlayer)
        AddFriendLbl.Text = "Unfriend"
    end
end)

ExamineBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("InspectPlayerFromHumanoidDescription",
        Players:GetHumanoidDescriptionFromUserId(SelectedPlayer.UserId),
        SelectedPlayer.Name
    )
end)

BlockBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("PromptBlockPlayer", SelectedPlayer)
end)

GotoBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    local targetChar = SelectedPlayer.Character
    local localChar  = Players.LocalPlayer.Character

    if targetChar and localChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local localRoot  = localChar:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 3)
        end
    end
end)

ReportBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("PromptReportPlayer", SelectedPlayer)
end)

SpectateBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    local camera = workspace.CurrentCamera

    if IsSpectating then
        IsSpectating     = false
        SpectatelLbl.Text = "Spectate"
        camera.CameraSubject = Players.LocalPlayer.Character
            and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        camera.CameraType = Enum.CameraType.Custom
    else
        local targetChar = SelectedPlayer.Character
        local humanoid   = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        IsSpectating      = true
        SpectatelLbl.Text = "Unspectate"
        camera.CameraSubject = humanoid
        camera.CameraType    = Enum.CameraType.Custom
    end
end)

UI["Close"].Activated:Connect(HideLeaderboard)

pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end)

local topbarMenu = CoreGui
    :WaitForChild("TopBarApp", 10)
    :WaitForChild("TopBarApp", 10)
    :WaitForChild("UnibarLeftFrame", 10)
    :WaitForChild("UnibarMenu", 10)

local function HookLeaderboardButton()
    local btn        = topbarMenu:GetChildren()[4]
    local lbButton   = btn and btn:FindFirstChild("leaderboard", true)
    if not lbButton then return false end

    lbButton.Activated:Connect(function()
        if LeaderboardVisible then HideLeaderboard() else ShowLeaderboard() end
    end)
    return true
end

if not HookLeaderboardButton() then
    local conn
    conn = topbarMenu.ChildAdded:Connect(function()
        if HookLeaderboardButton() then conn:Disconnect() end
    end)
end

local tabDebounce = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or input.KeyCode ~= Enum.KeyCode.Tab or tabDebounce then return end

    tabDebounce = true
    if LeaderboardVisible then HideLeaderboard() else ShowLeaderboard() end

    task.delay(LeaderboardVisible and 0.35 or 0.25, function()
        tabDebounce = false
    end)
end)