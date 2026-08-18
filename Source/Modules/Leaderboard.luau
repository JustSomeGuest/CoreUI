local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G
local Env = Shared.CoreUI.Env

local CoreGui = Env.CoreGui
local Players = Env.Players
local ScreenGui = Env.ScreenGui
local StarterGui = Env.StarterGui
local UserInputService = Env.UserInputService
local Tween = Env.Tween
local UI = Env.Leaderboard

local WriteFile = writefile or function() end
local IsFile = isfile or function() return false end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() end
local LoadAsset = getcustomasset or getsynasset

local BASE_URL = "https://raw.githubusercontent.com/JustSomeGuest/CoreUI/Main/Source/Assets/"

local ASSETS = {
    ["CoreUI/AddFriend.png"] = BASE_URL .. "AddFriend.png",
    ["CoreUI/Unfriend.png"] = BASE_URL .. "Unfriend.png",
    ["CoreUI/Block.png"] = BASE_URL .. "Block.png",
    ["CoreUI/Examine.png"] = BASE_URL .. "Examine.png",
    ["CoreUI/Goto.png"] = BASE_URL .. "Goto.png",
    ["CoreUI/Report.png"] = BASE_URL .. "Report.png",
    ["CoreUI/Spectate.png"] = BASE_URL .. "Spectate.png",
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

local STROKE_COLOR = Color3.fromRGB(30, 30, 30)

UI["Leaderboard"] = Instance.new("CanvasGroup")
UI["Leaderboard"].Name = "Leaderboard"
UI["Leaderboard"].AnchorPoint = Vector2.new(1, 0)
UI["Leaderboard"].AutomaticSize = Enum.AutomaticSize.Y
UI["Leaderboard"].BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UI["Leaderboard"].BackgroundTransparency = 0.08
UI["Leaderboard"].BorderSizePixel = 0
UI["Leaderboard"].ClipsDescendants = false
UI["Leaderboard"].Position = UDim2.new(1, 8, 0, 8)
UI["Leaderboard"].Size = UDim2.new(0, 200, 0, 0)
UI["Leaderboard"].Visible = false
UI["Leaderboard"].Parent = ScreenGui

UI["LeaderboardCorner"] = Instance.new("UICorner")
UI["LeaderboardCorner"].CornerRadius = UDim.new(0, 8)
UI["LeaderboardCorner"].Parent = UI["Leaderboard"]

UI["LeaderboardSizeConstraint"] = Instance.new("UISizeConstraint")
UI["LeaderboardSizeConstraint"].MinSize = Vector2.new(200, 0)
UI["LeaderboardSizeConstraint"].Parent = UI["Leaderboard"]

UI["LeaderboardLayout"] = Instance.new("UIListLayout")
UI["LeaderboardLayout"].FillDirection = Enum.FillDirection.Vertical
UI["LeaderboardLayout"].HorizontalFlex = Enum.UIFlexAlignment.Fill
UI["LeaderboardLayout"].SortOrder = Enum.SortOrder.LayoutOrder
UI["LeaderboardLayout"].Parent = UI["Leaderboard"]

UI["Topbar"] = Instance.new("Frame")
UI["Topbar"].Name = "Topbar"
UI["Topbar"].AutomaticSize = Enum.AutomaticSize.Y
UI["Topbar"].BackgroundTransparency = 1
UI["Topbar"].BorderSizePixel = 0
UI["Topbar"].LayoutOrder = 1
UI["Topbar"].Size = UDim2.new(1, 0, 0, 36)
UI["Topbar"].Parent = UI["Leaderboard"]

UI["TopbarStroke"] = Instance.new("UIStroke")
UI["TopbarStroke"].Color = STROKE_COLOR
UI["TopbarStroke"].Parent = UI["Topbar"]

UI["TopbarPadding"] = Instance.new("UIPadding")
UI["TopbarPadding"].PaddingBottom = UDim.new(0, 8)
UI["TopbarPadding"].PaddingLeft = UDim.new(0, 16)
UI["TopbarPadding"].PaddingRight = UDim.new(0, 16)
UI["TopbarPadding"].PaddingTop = UDim.new(0, 8)
UI["TopbarPadding"].Parent = UI["Topbar"]

UI["TopbarLayout"] = Instance.new("UIListLayout")
UI["TopbarLayout"].FillDirection = Enum.FillDirection.Horizontal
UI["TopbarLayout"].HorizontalFlex = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"].Padding = UDim.new(0, 8)
UI["TopbarLayout"].SortOrder = Enum.SortOrder.LayoutOrder
UI["TopbarLayout"].VerticalAlignment = Enum.VerticalAlignment.Center
UI["TopbarLayout"].VerticalFlex = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"].Parent = UI["Topbar"]

UI["Title"] = Instance.new("TextLabel")
UI["Title"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
UI["Title"].LayoutOrder = 1
UI["Title"].BackgroundTransparency = 1
UI["Title"].Size = UDim2.new(0, 0, 0, 0)
UI["Title"].Text = "Leaderboard"
UI["Title"].TextColor3 = Color3.fromRGB(255, 255, 255)
UI["Title"].TextScaled = true
UI["Title"].TextXAlignment = Enum.TextXAlignment.Left
UI["Title"].TextYAlignment = Enum.TextYAlignment.Center
UI["Title"].Parent = UI["Topbar"]

UI["TitleSizeConstraint"] = Instance.new("UISizeConstraint")
UI["TitleSizeConstraint"].MaxSize = Vector2.new(1e6, 36)
UI["TitleSizeConstraint"].Parent = UI["Title"]

UI["Close"] = Instance.new("TextButton")
UI["Close"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
UI["Close"].LayoutOrder = 2
UI["Close"].BackgroundTransparency = 1
UI["Close"].Size = UDim2.new(0, 0, 0, 0)
UI["Close"].Text = "╳"
UI["Close"].TextColor3 = Color3.fromRGB(255, 255, 255)
UI["Close"].TextScaled = true
UI["Close"].Parent = UI["Topbar"]

UI["CloseRatio"] = Instance.new("UIAspectRatioConstraint")
UI["CloseRatio"].AspectRatio = 1
UI["CloseRatio"].Parent = UI["Close"]

UI["ClosePadding"] = Instance.new("UIPadding")
UI["ClosePadding"].PaddingBottom = UDim.new(0, 3)
UI["ClosePadding"].PaddingTop = UDim.new(0, 3)
UI["ClosePadding"].Parent = UI["Close"]

UI["Players"] = Instance.new("ScrollingFrame")
UI["Players"].Name = "Players"
UI["Players"].AutomaticCanvasSize = Enum.AutomaticSize.Y
UI["Players"].AutomaticSize = Enum.AutomaticSize.None
UI["Players"].BackgroundTransparency = 1
UI["Players"].BorderSizePixel = 0
UI["Players"].CanvasSize = UDim2.new(0, 0, 0, 0)
UI["Players"].LayoutOrder = 2
UI["Players"].ScrollBarThickness = 0
UI["Players"].ScrollingDirection = Enum.ScrollingDirection.Y
UI["Players"].Size = UDim2.new(1, 0, 0, 0)
UI["Players"].Parent = UI["Leaderboard"]

UI["PlayersLayout"] = Instance.new("UIListLayout")
UI["PlayersLayout"].HorizontalFlex = Enum.UIFlexAlignment.Fill
UI["PlayersLayout"].Padding = UDim.new(0, 1)
UI["PlayersLayout"].SortOrder = Enum.SortOrder.LayoutOrder
UI["PlayersLayout"].Parent = UI["Players"]

UI["PlayerTemplate"] = Instance.new("TextButton")
UI["PlayerTemplate"].Name = "PlayerTemplate"
UI["PlayerTemplate"].AutomaticSize = Enum.AutomaticSize.Y
UI["PlayerTemplate"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI["PlayerTemplate"].BackgroundTransparency = 1
UI["PlayerTemplate"].BorderSizePixel = 0
UI["PlayerTemplate"].FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI["PlayerTemplate"].Size = UDim2.new(0, 100, 0, 0)
UI["PlayerTemplate"].Text = "Display Name"
UI["PlayerTemplate"].TextColor3 = Color3.fromRGB(230, 230, 230)
UI["PlayerTemplate"].TextSize = 16
UI["PlayerTemplate"].TextXAlignment = Enum.TextXAlignment.Left
UI["PlayerTemplate"].Visible = false
UI["PlayerTemplate"].Parent = UI["Players"]

UI["TemplatePadding"] = Instance.new("UIPadding")
UI["TemplatePadding"].PaddingBottom = UDim.new(0, 8)
UI["TemplatePadding"].PaddingLeft = UDim.new(0, 16)
UI["TemplatePadding"].PaddingRight = UDim.new(0, 16)
UI["TemplatePadding"].PaddingTop = UDim.new(0, 8)
UI["TemplatePadding"].Parent = UI["PlayerTemplate"]

UI["PlayerDividerTemplate"] = Instance.new("Frame")
UI["PlayerDividerTemplate"].Name = "PlayerDivider"
UI["PlayerDividerTemplate"].BackgroundColor3 = STROKE_COLOR
UI["PlayerDividerTemplate"].BorderSizePixel = 0
UI["PlayerDividerTemplate"].Size = UDim2.new(1, 0, 0, 1)
UI["PlayerDividerTemplate"].Visible = false
UI["PlayerDividerTemplate"].Parent = UI["Players"]

UI["LeaderboardProfile"] = Instance.new("CanvasGroup")
UI["LeaderboardProfile"].Name = "LeaderboardProfile"
UI["LeaderboardProfile"].AnchorPoint = Vector2.new(1, 0)
UI["LeaderboardProfile"].AutomaticSize = Enum.AutomaticSize.None
UI["LeaderboardProfile"].BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UI["LeaderboardProfile"].BackgroundTransparency = 0.08
UI["LeaderboardProfile"].BorderSizePixel = 0
UI["LeaderboardProfile"].Position = UDim2.new(1, -214, 0, 8)
UI["LeaderboardProfile"].Size = UDim2.new(0, 240, 1, -16)
UI["LeaderboardProfile"].Visible = false
UI["LeaderboardProfile"].Parent = ScreenGui

UI["ProfileCorner"] = Instance.new("UICorner")
UI["ProfileCorner"].CornerRadius = UDim.new(0, 8)
UI["ProfileCorner"].Parent = UI["LeaderboardProfile"]

UI["ProfilePadding"] = Instance.new("UIPadding")
UI["ProfilePadding"].PaddingBottom = UDim.new(0, 8)
UI["ProfilePadding"].PaddingLeft = UDim.new(0, 8)
UI["ProfilePadding"].PaddingRight = UDim.new(0, 8)
UI["ProfilePadding"].PaddingTop = UDim.new(0, 8)
UI["ProfilePadding"].Parent = UI["LeaderboardProfile"]

UI["ProfileLayout"] = Instance.new("UIListLayout")
UI["ProfileLayout"].FillDirection = Enum.FillDirection.Vertical
UI["ProfileLayout"].HorizontalFlex = Enum.UIFlexAlignment.Fill
UI["ProfileLayout"].Padding = UDim.new(0, 10)
UI["ProfileLayout"].SortOrder = Enum.SortOrder.LayoutOrder
UI["ProfileLayout"].Parent = UI["LeaderboardProfile"]

UI["PlayerInfo"] = Instance.new("Frame")
UI["PlayerInfo"].Name = "PlayerInfo"
UI["PlayerInfo"].AutomaticSize = Enum.AutomaticSize.None
UI["PlayerInfo"].BackgroundTransparency = 1
UI["PlayerInfo"].LayoutOrder = 1
UI["PlayerInfo"].Size = UDim2.new(0, 100, 0, 100)
UI["PlayerInfo"].Parent = UI["LeaderboardProfile"]

UI["PlayerInfoLayout"] = Instance.new("UIListLayout")
UI["PlayerInfoLayout"].FillDirection = Enum.FillDirection.Horizontal
UI["PlayerInfoLayout"].HorizontalFlex = Enum.UIFlexAlignment.Fill
UI["PlayerInfoLayout"].Padding = UDim.new(0, 6)
UI["PlayerInfoLayout"].VerticalFlex = Enum.UIFlexAlignment.Fill
UI["PlayerInfoLayout"].Parent = UI["PlayerInfo"]

UI["Headshot"] = Instance.new("ImageLabel")
UI["Headshot"].Name = "Headshot"
UI["Headshot"].BackgroundTransparency = 1
UI["Headshot"].Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
UI["Headshot"].LayoutOrder = 1
UI["Headshot"].Size = UDim2.new(0, 100, 0, 100)
UI["Headshot"].Parent = UI["PlayerInfo"]

UI["HeadshotRatio"] = Instance.new("UIAspectRatioConstraint")
UI["HeadshotRatio"].AspectRatio = 1
UI["HeadshotRatio"].Parent = UI["Headshot"]

UI["HeadshotCorner"] = Instance.new("UICorner")
UI["HeadshotCorner"].CornerRadius = UDim.new(1, 0)
UI["HeadshotCorner"].Parent = UI["Headshot"]

UI["Info"] = Instance.new("Frame")
UI["Info"].Name = "Info"
UI["Info"].BackgroundTransparency = 1
UI["Info"].LayoutOrder = 2
UI["Info"].Size = UDim2.new(0, 0, 0, 0)
UI["Info"].Parent = UI["PlayerInfo"]

UI["InfoLayout"] = Instance.new("UIListLayout")
UI["InfoLayout"].FillDirection = Enum.FillDirection.Vertical
UI["InfoLayout"].HorizontalFlex = Enum.UIFlexAlignment.Fill
UI["InfoLayout"].Padding = UDim.new(0, 2)
UI["InfoLayout"].VerticalFlex = Enum.UIFlexAlignment.Fill
UI["InfoLayout"].Parent = UI["Info"]

local function MakeInfoLabel(name, defaultText, textSize, layoutOrder)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.BackgroundTransparency = 1
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
    lbl.LayoutOrder = layoutOrder
    lbl.Size = UDim2.new(0, 100, 0, 50)
    lbl.Text = defaultText
    lbl.TextColor3 = Color3.fromRGB(layoutOrder == 1 and 240 or 230, layoutOrder == 1 and 240 or 230, layoutOrder == 1 and 240 or 230)
    lbl.TextSize = textSize
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Parent = UI["Info"]
    return lbl
end

UI["DisplayName"] = MakeInfoLabel("DisplayName", "DisplayName", 16, 1)
UI["Username"] = MakeInfoLabel("Username", "@Username", 14, 2)
UI["UserId"] = MakeInfoLabel("UserId", "1", 14, 3)

UI["Divider"] = Instance.new("Frame")
UI["Divider"].Name = "Divider"
UI["Divider"].BackgroundColor3 = STROKE_COLOR
UI["Divider"].BorderSizePixel = 0
UI["Divider"].LayoutOrder = 2
UI["Divider"].Size = UDim2.new(1, 0, 0, 1)
UI["Divider"].Parent = UI["LeaderboardProfile"]

UI["Actions"] = Instance.new("Frame")
UI["Actions"].Name = "Actions"
UI["Actions"].AutomaticSize = Enum.AutomaticSize.Y
UI["Actions"].BackgroundTransparency = 1
UI["Actions"].LayoutOrder = 3
UI["Actions"].Size = UDim2.new(0, 0, 0, 0)
UI["Actions"].Parent = UI["LeaderboardProfile"]

UI["ActionsLayout"] = Instance.new("UIListLayout")
UI["ActionsLayout"].FillDirection = Enum.FillDirection.Vertical
UI["ActionsLayout"].HorizontalFlex = Enum.UIFlexAlignment.Fill
UI["ActionsLayout"].Padding = UDim.new(0, 2)
UI["ActionsLayout"].SortOrder = Enum.SortOrder.LayoutOrder
UI["ActionsLayout"].Parent = UI["Actions"]

local function MakeAction(name, label, iconPath, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.AutomaticSize = Enum.AutomaticSize.Y
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
    btn.LayoutOrder = layoutOrder
    btn.Size = UDim2.new(0, 0, 0, 0)
    btn.Text = ""
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Parent = UI["Actions"]

    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingTop = UDim.new(0, 6)
    btnPadding.PaddingBottom = UDim.new(0, 6)
    btnPadding.PaddingLeft = UDim.new(0, 6)
    btnPadding.PaddingRight = UDim.new(0, 6)
    btnPadding.Parent = btn

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    btnLayout.Padding = UDim.new(0, 4)
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Name = "ActionIcon"
    icon.BackgroundTransparency = 1
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    icon.LayoutOrder = 1
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Parent = btn

    local iconRatio = Instance.new("UIAspectRatioConstraint")
    iconRatio.AspectRatio = 1
    iconRatio.Parent = icon

    task.spawn(function()
        local asset = GetAsset(iconPath)
        if asset then icon.Image = asset end
    end)

    local lbl = Instance.new("TextLabel")
    lbl.Name = "ActionLabel"
    lbl.BackgroundTransparency = 1
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
    lbl.LayoutOrder = 2
    lbl.Size = UDim2.new(0.9, 0, 0, 30)
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Parent = btn

    return btn, lbl
end

UI["AddFriendBtn"], UI["AddFriendLbl"] = MakeAction("AddFriend", "Add Friend", "CoreUI/AddFriend.png", 1)
UI["ExamineBtn"], UI["ExamineLbl"] = MakeAction("Examine", "Examine", "CoreUI/Examine.png", 2)
UI["BlockBtn"], UI["BlockLbl"] = MakeAction("Block", "Block", "CoreUI/Block.png", 3)
UI["GotoBtn"], UI["GotoLbl"] = MakeAction("Goto", "Goto", "CoreUI/Goto.png", 4)
UI["ReportBtn"], UI["ReportLbl"] = MakeAction("Report", "Report", "CoreUI/Report.png", 5)
UI["SpectateBtn"], UI["SpectatelLbl"] = MakeAction("Spectate", "Spectate", "CoreUI/Spectate.png", 6)

local LeaderboardVisible = false
local SelectedPlayer = nil
local SelectedEntry = nil
local IsSpectating = false

local OPEN_POS = UDim2.new(1, -8, 0, 8)
local CLOSED_POS = UDim2.new(1, 208, 0, 8)

local PROFILE_OPEN_POS = UDim2.new(1, -214, 0, 8)
local PROFILE_CLOSED_POS = UDim2.new(1, 34, 0, 8)

local function SyncSizes()
    local maxH = ScreenGui.AbsoluteSize.Y - 108
    local content = UI["PlayersLayout"].AbsoluteContentSize.Y
    local topH = UI["Topbar"].AbsoluteSize.Y
    UI["LeaderboardSizeConstraint"].MaxSize = Vector2.new(200, maxH)
    UI["Players"].Size = UDim2.new(1, 0, 0, math.min(content, maxH - topH))
end

UI["PlayersLayout"]:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(SyncSizes)
UI["Topbar"]:GetPropertyChangedSignal("AbsoluteSize"):Connect(SyncSizes)
ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(SyncSizes)
task.defer(SyncSizes)

local function ShowLeaderboard()
    LeaderboardVisible = true
    UI["Leaderboard"].Visible = true
    Tween(UI["Leaderboard"], 0.35, { Position = OPEN_POS }, "Back", "Out"):Play()
end

local function HideLeaderboardProfile()
    if not UI["LeaderboardProfile"].Visible then return end

    local t = Tween(UI["LeaderboardProfile"], 0.2, { Position = PROFILE_CLOSED_POS, GroupTransparency = 1 }, "Quad", "In")
    t:Play()
    t.Completed:Connect(function()
        UI["LeaderboardProfile"].Visible = false
    end)
end

local function HideLeaderboard()
    LeaderboardVisible = false
    HideLeaderboardProfile()

    local t = Tween(UI["Leaderboard"], 0.25, { Position = CLOSED_POS }, "Quad", "In")
    t:Play()
    t.Completed:Connect(function()
        if not LeaderboardVisible then
            UI["Leaderboard"].Visible = false
        end
    end)
end

local function SetSelectedEntry(entry)
    if SelectedEntry then
        SelectedEntry.BackgroundTransparency = 1
    end
    SelectedEntry = entry
    if SelectedEntry then
        SelectedEntry.BackgroundTransparency = 0.95
    end
end

local function ShowLeaderboardProfile(player)
    SelectedPlayer = player

    local localPlayer = Players.LocalPlayer
    local isSelf = player.UserId == localPlayer.UserId
    local isFriend = localPlayer:IsFriendsWith(player.UserId)

    UI["DisplayName"].Text = player.DisplayName
    UI["Username"].Text = "@" .. player.Name
    UI["UserId"].Text = tostring(player.UserId)

    UI["Headshot"].Image = Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )

    UI["AddFriendLbl"].Text = isFriend and "Unfriend" or "Add Friend"
    UI["SpectatelLbl"].Text = IsSpectating and "Unspectate" or "Spectate"

    UI["AddFriendBtn"].Visible = not isSelf
    UI["GotoBtn"].Visible = not isSelf
    UI["SpectateBtn"].Visible = not isSelf
    UI["ReportBtn"].Visible = not isSelf

    UI["LeaderboardProfile"].Position = PROFILE_CLOSED_POS
    UI["LeaderboardProfile"].GroupTransparency = 1
    UI["LeaderboardProfile"].Visible = true
    Tween(UI["LeaderboardProfile"], 0.3, { Position = PROFILE_OPEN_POS, GroupTransparency = 0 }, "Back", "Out"):Play()
end

local function RefreshPlayers()
    for _, child in ipairs(UI["Players"]:GetChildren()) do
        if child ~= UI["PlayerTemplate"]
            and child ~= UI["PlayerDividerTemplate"]
            and child ~= UI["PlayersLayout"] then

            child:Destroy()
        end
    end

    local sortedPlayers = Players:GetPlayers()
    table.sort(sortedPlayers, function(a, b)
        return a.DisplayName:lower() < b.DisplayName:lower()
    end)

    SelectedEntry = nil

    for i, player in ipairs(sortedPlayers) do
        local entry = UI["PlayerTemplate"]:Clone()
        entry.Name = player.Name
        entry.Text = player.DisplayName
        entry.LayoutOrder = (i - 1) * 2
        entry.Visible = true
        entry.Parent = UI["Players"]

        if SelectedPlayer and player.UserId == SelectedPlayer.UserId then
            entry.BackgroundTransparency = 0.95
            SelectedEntry = entry
        end

        entry.Activated:Connect(function()
            SetSelectedEntry(entry)
            ShowLeaderboardProfile(player)
        end)

        if i < #sortedPlayers then
            local divider = UI["PlayerDividerTemplate"]:Clone()
            divider.LayoutOrder = (i - 1) * 2 + 1
            divider.Visible = true
            divider.Parent = UI["Players"]
        end
    end
end

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(player)
    if SelectedPlayer == player then
        HideLeaderboardProfile()
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

UI["AddFriendBtn"].Activated:Connect(function()
    if not SelectedPlayer then return end
    if Players.LocalPlayer:IsFriendsWith(SelectedPlayer.UserId) then
        UI["AddFriendLbl"].Text = "Add Friend"
    else
        StarterGui:SetCore("PromptSendFriendRequest", SelectedPlayer)
        UI["AddFriendLbl"].Text = "Unfriend"
    end
end)

UI["ExamineBtn"].Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("InspectPlayerFromHumanoidDescription",
        Players:GetHumanoidDescriptionFromUserId(SelectedPlayer.UserId),
        SelectedPlayer.Name
    )
end)

UI["BlockBtn"].Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("PromptBlockPlayer", SelectedPlayer)
end)

UI["GotoBtn"].Activated:Connect(function()
    if not SelectedPlayer then return end
    local targetChar = SelectedPlayer.Character
    local localChar = Players.LocalPlayer.Character

    if targetChar and localChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 3)
        end
    end
end)

UI["ReportBtn"].Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("PromptReportPlayer", SelectedPlayer)
end)

UI["SpectateBtn"].Activated:Connect(function()
    if not SelectedPlayer then return end
    local camera = workspace.CurrentCamera

    if IsSpectating then
        IsSpectating = false
        UI["SpectatelLbl"].Text = "Spectate"
        camera.CameraSubject = Players.LocalPlayer.Character
            and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        camera.CameraType = Enum.CameraType.Custom
    else
        local targetChar = SelectedPlayer.Character
        local humanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        IsSpectating = true
        UI["SpectatelLbl"].Text = "Unspectate"
        camera.CameraSubject = humanoid
        camera.CameraType = Enum.CameraType.Custom
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

local function HookLeaderboardBtn()
    local btn = topbarMenu:GetChildren()[4]
    local lbButton = btn and btn:FindFirstChild("leaderboard", true)
    if not lbButton then return false end

    local clone = lbButton:Clone()
    clone.Name = "LeaderboardBtn"
    clone.Parent = lbButton.Parent

    lbButton.Visible = false

    clone.Activated:Connect(function()
        if LeaderboardVisible then HideLeaderboard() else ShowLeaderboard() end
    end)

    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    end)

    return true
end

if not HookLeaderboardBtn() then
    local conn
    conn = topbarMenu.ChildAdded:Connect(function()
        if HookLeaderboardBtn() then conn:Disconnect() end
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