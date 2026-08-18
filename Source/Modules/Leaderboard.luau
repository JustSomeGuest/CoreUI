local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G
local Env = Shared.CoreUI.Env

local CoreGui = Env.CoreGui
local Players = Env.Players
local TweenService = Env.TweenService
local ScreenGui = Env.ScreenGui
local StarterGui = Env.StarterGui
local Tween = Env.Tween
local Protect = Env.Protect
local FindDescendant = Env.FindDescendant
local UI = Env.Leaderboard

local WriteFile = writefile or function() end
local IsFile = isfile or function() return false end
local ReadFile = readfile or function() return "" end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() end
local LoadAsset = getcustomasset or getsynasset

local BaseURL = "https://raw.githubusercontent.com/JustSomeGuest/CoreUI/Main/Source/Assets/"

local Assets = {
    ["CoreUI/AddFriend.png"]   = BaseURL .. "AddFriend.png",
    ["CoreUI/Unfriend.png"]    = BaseURL .. "Unfriend.png",
    ["CoreUI/Block.png"]       = BaseURL .. "Block.png",
    ["CoreUI/Examine.png"]     = BaseURL .. "Examine.png",
    ["CoreUI/Goto.png"]        = BaseURL .. "Goto.png",
    ["CoreUI/Report.png"]      = BaseURL .. "Report.png",
    ["CoreUI/Spectate.png"]    = BaseURL .. "Spectate.png",
    ["CoreUI/Unspectate.png"]  = BaseURL .. "Unspectate.png",
}

local function HttpGet(url)
    local RequestFunc = http_request or request or (syn and syn.request)

    if not RequestFunc then
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success then
            return { Success = true, Body = result }
        end
        return nil
    end

    local success, result = pcall(function()
        return RequestFunc({ Url = url, Method = "GET" })
    end)

    return success and result or nil
end

local function GetAsset(Path)
    if not LoadAsset then
        warn("[CoreUI] getcustomasset/getsynasset not supported by this executor")
        return nil
    end

    local RemoteURL = Assets[Path]
    if not RemoteURL then
        warn("[CoreUI] No asset registered for path: " .. Path)
        return nil
    end

    if RemoteURL:match("^rbxassetid://") then
        return RemoteURL
    end

    if not IsFile(Path) then
        local Folder = Path:match("^(.+)/[^/]+$")
        if Folder and not IsFolder(Folder) then
            MakeFolder(Folder)
        end

        local Response = HttpGet(RemoteURL)
        if not Response or not Response.Success or not Response.Body then
            warn("[CoreUI] Failed to download asset: " .. Path)
            return nil
        end
        WriteFile(Path, Response.Body)
    end

    local success, result = pcall(function()
        return LoadAsset(Path)
    end)

    if success then
        return result
    end

    warn("[CoreUI] Failed to load local asset: " .. Path)
    return nil
end

UI["Leaderboard"] = Instance.new("CanvasGroup")
UI["Leaderboard"]["Name"] = "Leaderboard"
UI["Leaderboard"]["AnchorPoint"] = Vector2.new(1, 0)
UI["Leaderboard"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["Leaderboard"]["BackgroundColor3"] = Color3.fromRGB(10, 10, 10)
UI["Leaderboard"]["BackgroundTransparency"] = 0.08
UI["Leaderboard"]["BorderSizePixel"] = 0
UI["Leaderboard"]["ClipsDescendants"] = false
UI["Leaderboard"]["Position"] = UDim2.new(1, 8, 0, 8)
UI["Leaderboard"]["Size"] = UDim2.new(0, 200, 0, 0)
UI["Leaderboard"]["Visible"] = false
UI["Leaderboard"]["Parent"] = ScreenGui

UI["UICorner"] = Instance.new("UICorner")
UI["UICorner"]["CornerRadius"] = UDim.new(0, 8)
UI["UICorner"]["Parent"] = UI["Leaderboard"]

UI["UISizeConstraint"] = Instance.new("UISizeConstraint")
UI["UISizeConstraint"]["MinSize"] = Vector2.new(200, 0)
UI["UISizeConstraint"]["Parent"] = UI["Leaderboard"]

UI["Topbar"] = Instance.new("Frame")
UI["Topbar"]["Name"] = "Topbar"
UI["Topbar"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["Topbar"]["BackgroundTransparency"] = 1
UI["Topbar"]["BorderSizePixel"] = 0
UI["Topbar"]["Size"] = UDim2.new(1, 0, 0, 36)
UI["Topbar"]["Parent"] = UI["Leaderboard"]

UI["TopbarStroke"] = Instance.new("UIStroke")
UI["TopbarStroke"]["Color"] = Color3.fromRGB(30, 30, 30)
UI["TopbarStroke"]["Parent"] = UI["Topbar"]

UI["TopbarPadding"] = Instance.new("UIPadding")
UI["TopbarPadding"]["PaddingBottom"] = UDim.new(0, 8)
UI["TopbarPadding"]["PaddingLeft"] = UDim.new(0, 16)
UI["TopbarPadding"]["PaddingRight"] = UDim.new(0, 16)
UI["TopbarPadding"]["PaddingTop"] = UDim.new(0, 8)
UI["TopbarPadding"]["Parent"] = UI["Topbar"]

UI["TopbarLayout"] = Instance.new("UIListLayout")
UI["TopbarLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["TopbarLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"]["Padding"] = UDim.new(0, 8)
UI["TopbarLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["TopbarLayout"]["VerticalAlignment"] = Enum.VerticalAlignment.Center
UI["TopbarLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["TopbarLayout"]["Parent"] = UI["Topbar"]

UI["Title"] = Instance.new("TextLabel")
UI["Title"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI["Title"]["LayoutOrder"] = 1
UI["Title"]["BackgroundTransparency"] = 1
UI["Title"]["Size"] = UDim2.new(0, 0, 0, 0)
UI["Title"]["Text"] = "Leaderboard"
UI["Title"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Title"]["TextScaled"] = true
UI["Title"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Title"]["TextYAlignment"] = Enum.TextYAlignment.Center
UI["Title"]["Parent"] = UI["Topbar"]

UI["TitleSizeConstraint"] = Instance.new("UISizeConstraint")
UI["TitleSizeConstraint"]["MaxSize"] = Vector2.new(1000000, 36)
UI["TitleSizeConstraint"]["Parent"] = UI["Topbar"]

UI["Close"] = Instance.new("TextButton")
UI["Close"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
UI["Close"]["LayoutOrder"] = 2
UI["Close"]["BackgroundTransparency"] = 1
UI["Close"]["Size"] = UDim2.new(0, 0, 0, 0)
UI["Close"]["Text"] = "╳"
UI["Close"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
UI["Close"]["TextScaled"] = true
UI["Close"]["Parent"] = UI["Topbar"]

UI["CloseRatio"] = Instance.new("UIAspectRatioConstraint")
UI["CloseRatio"]["AspectRatio"] = 1
UI["CloseRatio"]["Parent"] = UI["Close"]

UI["ClosePadding"] = Instance.new("UIPadding")
UI["ClosePadding"]["PaddingBottom"] = UDim.new(0, 3)
UI["ClosePadding"]["PaddingTop"] = UDim.new(0, 3)
UI["ClosePadding"]["Parent"] = UI["Close"]

UI["Players"] = Instance.new("ScrollingFrame")
UI["Players"]["Name"] = "Players"
UI["Players"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y
UI["Players"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["Players"]["BackgroundTransparency"] = 1
UI["Players"]["BorderSizePixel"] = 0
UI["Players"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
UI["Players"]["ScrollBarThickness"] = 0
UI["Players"]["ScrollingDirection"] = Enum.ScrollingDirection.Y
UI["Players"]["Size"] = UDim2.new(0, 0, 0, 0)
UI["Players"]["Parent"] = UI["Leaderboard"]

UI["PlayersLayout"] = Instance.new("UIListLayout")
UI["PlayersLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["PlayersLayout"]["Padding"] = UDim.new(0, 1)
UI["PlayersLayout"]["SortOrder"] = Enum.SortOrder.Name
UI["PlayersLayout"]["Parent"] = UI["Players"]

UI["PlayerTemplate"] = Instance.new("TextButton")
UI["PlayerTemplate"]["Name"] = "PlayerTemplate"
UI["PlayerTemplate"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["PlayerTemplate"]["BackgroundTransparency"] = 1
UI["PlayerTemplate"]["BorderSizePixel"] = 0
UI["PlayerTemplate"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["PlayerTemplate"]["Size"] = UDim2.new(0, 100, 0, 0)
UI["PlayerTemplate"]["Text"] = "Display Name"
UI["PlayerTemplate"]["TextColor3"] = Color3.fromRGB(230, 230, 230)
UI["PlayerTemplate"]["TextSize"] = 16
UI["PlayerTemplate"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["PlayerTemplate"]["Visible"] = false
UI["PlayerTemplate"]["Parent"] = UI["Players"]

UI["PlayerTemplatePadding"] = Instance.new("UIPadding")
UI["PlayerTemplatePadding"]["PaddingBottom"] = UDim.new(0, 8)
UI["PlayerTemplatePadding"]["PaddingLeft"] = UDim.new(0, 16)
UI["PlayerTemplatePadding"]["PaddingRight"] = UDim.new(0, 16)
UI["PlayerTemplatePadding"]["PaddingTop"] = UDim.new(0, 8)
UI["PlayerTemplatePadding"]["Parent"] = UI["PlayerTemplate"]

UI["ProfileTemplate"] = Instance.new("CanvasGroup")
UI["ProfileTemplate"]["Name"] = "ProfileTemplate"
UI["ProfileTemplate"]["AnchorPoint"] = Vector2.new(1, 0)
UI["ProfileTemplate"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["ProfileTemplate"]["BackgroundColor3"] = Color3.fromRGB(10, 10, 10)
UI["ProfileTemplate"]["BackgroundTransparency"] = 0.08
UI["ProfileTemplate"]["BorderSizePixel"] = 0
UI["ProfileTemplate"]["Position"] = UDim2.new(1, -214, 0, 8)
UI["ProfileTemplate"]["Size"] = UDim2.new(0, 240, 0, 0)
UI["ProfileTemplate"]["Visible"] = false
UI["ProfileTemplate"]["Parent"] = ScreenGui

UI["ProfileCorner"] = Instance.new("UICorner")
UI["ProfileCorner"]["CornerRadius"] = UDim.new(0, 8)
UI["ProfileCorner"]["Parent"] = UI["ProfileTemplate"]

UI["ProfilePadding"] = Instance.new("UIPadding")
UI["ProfilePadding"]["PaddingBottom"] = UDim.new(0, 8)
UI["ProfilePadding"]["PaddingLeft"] = UDim.new(0, 8)
UI["ProfilePadding"]["PaddingRight"] = UDim.new(0, 8)
UI["ProfilePadding"]["PaddingTop"] = UDim.new(0, 8)
UI["ProfilePadding"]["Parent"] = UI["ProfileTemplate"]

UI["ProfileLayout"] = Instance.new("UIListLayout")
UI["ProfileLayout"]["FillDirection"] = Enum.FillDirection.Vertical
UI["ProfileLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ProfileLayout"]["Padding"] = UDim.new(0, 10)
UI["ProfileLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ProfileLayout"]["Parent"] = UI["ProfileTemplate"]

UI["PlayerInfo"] = Instance.new("Frame")
UI["PlayerInfo"]["Name"] = "PlayerInfo"
UI["PlayerInfo"]["AutomaticSize"] = Enum.AutomaticSize.None
UI["PlayerInfo"]["BackgroundTransparency"] = 1
UI["PlayerInfo"]["LayoutOrder"] = 1
UI["PlayerInfo"]["Size"] = UDim2.new(0, 100, 0, 100)
UI["PlayerInfo"]["Parent"] = UI["ProfileTemplate"]

UI["PlayerInfoLayout"] = Instance.new("UIListLayout")
UI["PlayerInfoLayout"]["FillDirection"] = Enum.FillDirection.Horizontal
UI["PlayerInfoLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["PlayerInfoLayout"]["Padding"] = UDim.new(0, 6)
UI["PlayerInfoLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["PlayerInfoLayout"]["Parent"] = UI["PlayerInfo"]

UI["Headshot"] = Instance.new("ImageLabel")
UI["Headshot"]["Name"] = "Headshot"
UI["Headshot"]["BackgroundTransparency"] = 1
UI["Headshot"]["Image"] = "rbxasset://textures/ui/GuiImagePlaceholder.png"
UI["Headshot"]["LayoutOrder"] = 1
UI["Headshot"]["Size"] = UDim2.new(0, 100, 0, 100)
UI["Headshot"]["Parent"] = UI["PlayerInfo"]

UI["HeadshotRatio"] = Instance.new("UIAspectRatioConstraint")
UI["HeadshotRatio"]["AspectRatio"] = 1
UI["HeadshotRatio"]["Parent"] = UI["Headshot"]

UI["HeadshotCorner"] = Instance.new("UICorner")
UI["HeadshotCorner"]["CornerRadius"] = UDim.new(1, 0)
UI["HeadshotCorner"]["Parent"] = UI["Headshot"]

UI["Info"] = Instance.new("Frame")
UI["Info"]["Name"] = "Info"
UI["Info"]["BackgroundTransparency"] = 1
UI["Info"]["LayoutOrder"] = 2
UI["Info"]["Size"] = UDim2.new(0, 0, 0, 0)
UI["Info"]["Parent"] = UI["PlayerInfo"]

UI["InfoLayout"] = Instance.new("UIListLayout")
UI["InfoLayout"]["FillDirection"] = Enum.FillDirection.Vertical
UI["InfoLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["InfoLayout"]["Padding"] = UDim.new(0, 2)
UI["InfoLayout"]["VerticalFlex"] = Enum.UIFlexAlignment.Fill
UI["InfoLayout"]["Parent"] = UI["Info"]

UI["DisplayName"] = Instance.new("TextLabel")
UI["DisplayName"]["Name"] = "DisplayName"
UI["DisplayName"]["BackgroundTransparency"] = 1
UI["DisplayName"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["DisplayName"]["LayoutOrder"] = 1
UI["DisplayName"]["Size"] = UDim2.new(0, 100, 0, 50)
UI["DisplayName"]["Text"] = "DisplayName"
UI["DisplayName"]["TextColor3"] = Color3.fromRGB(240, 240, 240)
UI["DisplayName"]["TextSize"] = 16
UI["DisplayName"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["DisplayName"]["TextYAlignment"] = Enum.TextYAlignment.Center
UI["DisplayName"]["Parent"] = UI["Info"]

UI["Username"] = Instance.new("TextLabel")
UI["Username"]["Name"] = "Username"
UI["Username"]["BackgroundTransparency"] = 1
UI["Username"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["Username"]["LayoutOrder"] = 2
UI["Username"]["Size"] = UDim2.new(0, 100, 0, 50)
UI["Username"]["Text"] = "@Username"
UI["Username"]["TextColor3"] = Color3.fromRGB(230, 230, 230)
UI["Username"]["TextSize"] = 14
UI["Username"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["Username"]["TextYAlignment"] = Enum.TextYAlignment.Center
UI["Username"]["Parent"] = UI["Info"]

UI["UserId"] = Instance.new("TextLabel")
UI["UserId"]["Name"] = "UserId"
UI["UserId"]["BackgroundTransparency"] = 1
UI["UserId"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
UI["UserId"]["LayoutOrder"] = 3
UI["UserId"]["Size"] = UDim2.new(0, 100, 0, 50)
UI["UserId"]["Text"] = "1"
UI["UserId"]["TextColor3"] = Color3.fromRGB(230, 230, 230)
UI["UserId"]["TextSize"] = 14
UI["UserId"]["TextXAlignment"] = Enum.TextXAlignment.Left
UI["UserId"]["TextYAlignment"] = Enum.TextYAlignment.Center
UI["UserId"]["Parent"] = UI["Info"]

UI["Divider"] = Instance.new("Frame")
UI["Divider"]["Name"] = "Divider"
UI["Divider"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30)
UI["Divider"]["BorderSizePixel"] = 0
UI["Divider"]["LayoutOrder"] = 2
UI["Divider"]["Size"] = UDim2.new(1, 0, 0, 1)
UI["Divider"]["Parent"] = UI["ProfileTemplate"]

UI["Actions"] = Instance.new("Frame")
UI["Actions"]["Name"] = "Actions"
UI["Actions"]["AutomaticSize"] = Enum.AutomaticSize.Y
UI["Actions"]["BackgroundTransparency"] = 1
UI["Actions"]["LayoutOrder"] = 3
UI["Actions"]["Size"] = UDim2.new(0, 0, 0, 0)
UI["Actions"]["Parent"] = UI["ProfileTemplate"]

UI["ActionsLayout"] = Instance.new("UIListLayout")
UI["ActionsLayout"]["FillDirection"] = Enum.FillDirection.Vertical
UI["ActionsLayout"]["HorizontalFlex"] = Enum.UIFlexAlignment.Fill
UI["ActionsLayout"]["Padding"] = UDim.new(0, 8)
UI["ActionsLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder
UI["ActionsLayout"]["Parent"] = UI["Actions"]

local function MakeAction(Name, Label, IconPath, LayoutOrder)
    local Btn = Instance.new("TextButton")
    Btn.Name = Name
    Btn.AutomaticSize = Enum.AutomaticSize.Y
    Btn.BackgroundTransparency = 1
    Btn.BorderSizePixel = 0
    Btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Btn.LayoutOrder = LayoutOrder
    Btn.Size = UDim2.new(0, 0, 0, 0)
    Btn.Text = ""
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    Btn.Parent = UI["Actions"]

    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    BtnLayout.Padding = UDim.new(0, 4)
    BtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnLayout.Parent = Btn

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "ActionIcon"
    Icon.BackgroundTransparency = 1
    Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Icon.LayoutOrder = 1
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Parent = Btn

    local IconRatio = Instance.new("UIAspectRatioConstraint")
    IconRatio.AspectRatio = 1
    IconRatio.Parent = Icon

    task.spawn(function()
        local Asset = GetAsset(IconPath)
        if Asset then
            Icon.Image = Asset
        end
    end)

    local Lbl = Instance.new("TextLabel")
    Lbl.Name = "ActionLabel"
    Lbl.BackgroundTransparency = 1
    Lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Lbl.LayoutOrder = 2
    Lbl.Size = UDim2.new(0.9, 0, 0, 30)
    Lbl.Text = Label
    Lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    Lbl.TextSize = 16
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextYAlignment = Enum.TextYAlignment.Center
    Lbl.Parent = Btn

    return Btn, Lbl, Icon
end

local AddFriendBtn, AddFriendLbl = MakeAction("AddFriend", "Add Friend", "CoreUI/AddFriend.png", 1)
local ExamineBtn, ExamineLbl = MakeAction("Examine", "Examine", "CoreUI/Examine.png", 2)
local BlockBtn, BlockLbl = MakeAction("Block", "Block", "CoreUI/Block.png", 3)
local GotoBtn, GotoLbl = MakeAction("Goto", "Goto", "CoreUI/Goto.png", 4)
local ReportBtn, ReportLbl = MakeAction("Report", "Report", "CoreUI/Report.png", 5)
local SpectateBtn, SpectatelLbl = MakeAction("Spectate", "Spectate", "CoreUI/Spectate.png", 6)

local LeaderboardVisible = false
local SelectedPlayer = nil
local IsSpectating = false
local OpenPos = UDim2.new(1, -8, 0, 8)
local ClosedPos = UDim2.new(1, 208, 0, 8)

local function ShowLeaderboard()
    LeaderboardVisible = true
    UI["Leaderboard"].Visible = true
    Tween(UI["Leaderboard"], 0.35, {Position = OpenPos}, "Back", "Out"):Play()
end

local function HideLeaderboard()
    LeaderboardVisible = false
    UI["ProfileTemplate"].Visible = false
    local T = Tween(UI["Leaderboard"], 0.25, {Position = ClosedPos}, "Quad", "In")
    T:Play()
    T.Completed:Connect(function()
        if not LeaderboardVisible then
            UI["Leaderboard"].Visible = false
        end
    end)
end

local function ShowProfile(Player)
    SelectedPlayer = Player

    UI["DisplayName"].Text = Player.DisplayName
    UI["Username"].Text = "@" .. Player.Name
    UI["UserId"].Text = tostring(Player.UserId)

    local HeadshotUrl = Players:GetUserThumbnailAsync(
        Player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
    UI["Headshot"].Image = HeadshotUrl

    local LocalPlayer = Players.LocalPlayer
    local IsFriend = LocalPlayer:IsFriendsWith(Player.UserId)
    AddFriendLbl.Text = IsFriend and "Unfriend" or "Add Friend"

    SpectatelLbl.Text = IsSpectating and "Unspectate" or "Spectate"

    local IsSelf = Player.UserId == LocalPlayer.UserId
    AddFriendBtn.Visible = not IsSelf
    GotoBtn.Visible = not IsSelf
    SpectateBtn.Visible = not IsSelf
    ReportBtn.Visible = not IsSelf

    UI["ProfileTemplate"].Visible = true
end

local function RefreshPlayers()
    for _, Child in ipairs(UI["Players"]:GetChildren()) do
        if Child:IsA("TextButton") and Child.Name ~= "PlayerTemplate" then
            Child:Destroy()
        end
    end

    for _, Player in ipairs(Players:GetPlayers()) do
        local Entry = UI["PlayerTemplate"]:Clone()
        Entry.Name = Player.Name
        Entry.Text = Player.DisplayName
        Entry.Visible = true
        Entry.Parent = UI["Players"]

        Entry.Activated:Connect(function()
            ShowProfile(Player)
        end)
    end
end

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(Player)
    if SelectedPlayer == Player then
        UI["ProfileTemplate"].Visible = false
        SelectedPlayer = nil
    end
    RefreshPlayers()
end)

RefreshPlayers()

UI["UserId"].InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        local SetClip = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if SetClip then
            SetClip(UI["UserId"].Text)
        end
    end
end)

AddFriendBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    local LocalPlayer = Players.LocalPlayer
    if LocalPlayer:IsFriendsWith(SelectedPlayer.UserId) then
        AddFriendLbl.Text = "Add Friend"
    else
        StarterGui:SetCore("PromptSendFriendRequest", SelectedPlayer)
        AddFriendLbl.Text = "Unfriend"
    end
end)

ExamineBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    local StarterGui = StarterGui
    StarterGui:SetCore("PromptUnfriendPlayer", SelectedPlayer)
end)

BlockBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("PromptBlockPlayer", SelectedPlayer)
end)

GotoBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    local Char = SelectedPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local LocalChar = Players.LocalPlayer.Character
        if LocalChar and LocalChar:FindFirstChild("HumanoidRootPart") then
            LocalChar.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame + Vector3.new(0, 0, 3)
        end
    end
end)

ReportBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    StarterGui:SetCore("PromptReportPlayer", SelectedPlayer)
end)

SpectateBtn.Activated:Connect(function()
    if not SelectedPlayer then return end
    if IsSpectating then
        IsSpectating = false
        SpectatelLbl.Text = "Spectate"
        local Camera = workspace.CurrentCamera
        Camera.CameraSubject = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
    else
        IsSpectating = true
        SpectatelLbl.Text = "Unspectate"
        local Camera = workspace.CurrentCamera
        local TargetChar = SelectedPlayer.Character
        if TargetChar then
            local Humanoid = TargetChar:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Camera.CameraSubject = Humanoid
                Camera.CameraType = Enum.CameraType.Custom
            end
        end
    end
end)

UI["Close"].Activated:Connect(HideLeaderboard)

local StarterGuiService = StarterGui
pcall(function()
    StarterGuiService:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end)

local TopBarApp = CoreGui:WaitForChild("TopBarApp", 10)
if TopBarApp then
    local TopBarAppInner = TopBarApp:WaitForChild("TopBarApp", 10)
    if TopBarAppInner then
        local UnibarLeftFrame = TopBarAppInner:WaitForChild("UnibarLeftFrame", 10)
        if UnibarLeftFrame then
            local UnibarMenu = UnibarLeftFrame:WaitForChild("UnibarMenu", 10)
            if UnibarMenu then
                local function TryHookLeaderboardBtn()
                    local Children = UnibarMenu:GetChildren()
                    local Btn = Children[4]
                    if Btn then
                        local NineDot = Btn:FindFirstChild("nine_dot", true)
                        if NineDot then
                            local ScrollFrame = NineDot:FindFirstChild("ScrollingFrame", true)
                            if ScrollFrame then
                                local MainCanvas = ScrollFrame:FindFirstChild("MainCanvas", true)
                                if MainCanvas then
                                    local LeaderboardBtn = MainCanvas:FindFirstChild("leaderboard", true)
                                    if LeaderboardBtn then
                                        LeaderboardBtn.Activated:Connect(function()
                                            if LeaderboardVisible then
                                                HideLeaderboard()
                                            else
                                                ShowLeaderboard()
                                            end
                                        end)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    return false
                end

                if not TryHookLeaderboardBtn() then
                    local Conn
                    Conn = UnibarMenu.ChildAdded:Connect(function()
                        if TryHookLeaderboardBtn() then
                            Conn:Disconnect()
                        end
                    end)
                end
            end
        end
    end
end