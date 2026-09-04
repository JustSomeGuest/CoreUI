if not game:IsLoaded() then
    game.Loaded:Wait()
end

local UI = Leaderboard

local WriteFile = writefile or function() end
local IsFile = isfile or function() return false end
local IsFolder = isfolder or function() return false end
local MakeFolder = makefolder or function() end
local LoadAsset = getcustomasset or getsynasset
local SetClipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set)

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

local SECONDARY_COLOR = Color3.fromRGB(50, 50, 50)

UI.Folder = Instance.new("Folder")
UI.Folder.Name = "Leaderboard"
UI.Folder.Parent = ScreenGui

UI.PlayersList = Instance.new("CanvasGroup")
UI.PlayersList.Name = "PlayersList"
UI.PlayersList.AnchorPoint = Vector2.new(1, 0)
UI.PlayersList.AutomaticSize = Enum.AutomaticSize.None
UI.PlayersList.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UI.PlayersList.BackgroundTransparency = 0.08
UI.PlayersList.BorderSizePixel = 0
UI.PlayersList.ClipsDescendants = false
UI.PlayersList.Position = UDim2.new(1, 8, 0, 8)
UI.PlayersList.Size = IsMobile() and UDim2.new(0, 200, 0, 314) or IsDesktop() and UDim2.new(0, 200, 0, 414)
UI.PlayersList.Visible = false
UI.PlayersList.Parent = UI.Folder

UI.LeaderboardCorner = Instance.new("UICorner")
UI.LeaderboardCorner.CornerRadius = UDim.new(0, 8)
UI.LeaderboardCorner.Parent = UI.PlayersList

UI.LeaderboardLayout = Instance.new("UIListLayout")
UI.LeaderboardLayout.FillDirection = Enum.FillDirection.Vertical
UI.LeaderboardLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.LeaderboardLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.LeaderboardLayout.Parent = UI.PlayersList

UI.Topbar = Instance.new("Frame")
UI.Topbar.Name = "Topbar"
UI.Topbar.AutomaticSize = Enum.AutomaticSize.Y
UI.Topbar.BackgroundTransparency = 1
UI.Topbar.BorderSizePixel = 0
UI.Topbar.LayoutOrder = 1
UI.Topbar.Size = UDim2.new(1, 0, 0, 36)
UI.Topbar.Parent = UI.PlayersList

UI.TopbarStroke = Instance.new("UIStroke")
UI.TopbarStroke.Color = SECONDARY_COLOR
UI.TopbarStroke.Parent = UI.Topbar

UI.TopbarPadding = Instance.new("UIPadding")
UI.TopbarPadding.PaddingBottom = UDim.new(0, 8)
UI.TopbarPadding.PaddingLeft = UDim.new(0, 16)
UI.TopbarPadding.PaddingRight = UDim.new(0, 16)
UI.TopbarPadding.PaddingTop = UDim.new(0, 8)
UI.TopbarPadding.Parent = UI.Topbar

UI.TopbarLayout = Instance.new("UIListLayout")
UI.TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
UI.TopbarLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.TopbarLayout.Padding = UDim.new(0, 8)
UI.TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.TopbarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UI.TopbarLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.TopbarLayout.Parent = UI.Topbar

UI.Title = Instance.new("TextLabel")
UI.Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
UI.Title.LayoutOrder = 1
UI.Title.BackgroundTransparency = 1
UI.Title.Size = UDim2.new(0, 0, 0, 0)
UI.Title.Text = "Leaderboard"
UI.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.Title.TextScaled = true
UI.Title.TextXAlignment = Enum.TextXAlignment.Left
UI.Title.TextYAlignment = Enum.TextYAlignment.Center
UI.Title.Parent = UI.Topbar

UI.TitleConst = Instance.new("UISizeConstraint")
UI.TitleConst.MaxSize = Vector2.new(1e6, 36)
UI.TitleConst.Parent = UI.Title

UI.Close = Instance.new("TextButton")
UI.Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
UI.Close.LayoutOrder = 2
UI.Close.BackgroundTransparency = 1
UI.Close.Size = UDim2.new(0, 0, 0, 0)
UI.Close.Text = "╳"
UI.Close.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.Close.TextScaled = true
UI.Close.Parent = UI.Topbar

UI.CloseRatio = Instance.new("UIAspectRatioConstraint")
UI.CloseRatio.AspectRatio = 1
UI.CloseRatio.Parent = UI.Close

UI.ClosePadding = Instance.new("UIPadding")
UI.ClosePadding.PaddingBottom = UDim.new(0, 3)
UI.ClosePadding.PaddingTop = UDim.new(0, 3)
UI.ClosePadding.Parent = UI.Close

UI.Players = Instance.new("ScrollingFrame")
UI.Players.Name = "Players"
UI.Players.AutomaticCanvasSize = Enum.AutomaticSize.Y
UI.Players.AutomaticSize = Enum.AutomaticSize.None
UI.Players.BackgroundTransparency = 1
UI.Players.BorderSizePixel = 0
UI.Players.CanvasSize = UDim2.new(0, 0, 0, 0)
UI.Players.LayoutOrder = 2
UI.Players.ScrollBarThickness = 0
UI.Players.ScrollingDirection = Enum.ScrollingDirection.Y
UI.Players.Size = UDim2.new(1, 0, 1, -37)
UI.Players.Parent = UI.PlayersList

UI.PlayersLayout = Instance.new("UIListLayout")
UI.PlayersLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.PlayersLayout.Padding = UDim.new(0, 1)
UI.PlayersLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.PlayersLayout.Parent = UI.Players

UI.PlayerTemplate = Instance.new("TextButton")
UI.PlayerTemplate.Name = "PlayerTemplate"
UI.PlayerTemplate.AutomaticSize = Enum.AutomaticSize.Y
UI.PlayerTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UI.PlayerTemplate.BackgroundTransparency = 1
UI.PlayerTemplate.BorderSizePixel = 0
UI.PlayerTemplate.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
UI.PlayerTemplate.Size = UDim2.new(0, 100, 0, 0)
UI.PlayerTemplate.Text = "Display Name"
UI.PlayerTemplate.TextColor3 = Color3.fromRGB(230, 230, 230)
UI.PlayerTemplate.TextSize = 16
UI.PlayerTemplate.TextXAlignment = Enum.TextXAlignment.Left
UI.PlayerTemplate.Visible = false
UI.PlayerTemplate.Parent = UI.Players

UI.TemplatePadding = Instance.new("UIPadding")
UI.TemplatePadding.PaddingBottom = UDim.new(0, 8)
UI.TemplatePadding.PaddingLeft = UDim.new(0, 16)
UI.TemplatePadding.PaddingRight = UDim.new(0, 16)
UI.TemplatePadding.PaddingTop = UDim.new(0, 8)
UI.TemplatePadding.Parent = UI.PlayerTemplate

UI.PlayerDividerTemplate = Instance.new("Frame")
UI.PlayerDividerTemplate.Name = "PlayerDivider"
UI.PlayerDividerTemplate.BackgroundColor3 = SECONDARY_COLOR
UI.PlayerDividerTemplate.BorderSizePixel = 0
UI.PlayerDividerTemplate.Size = UDim2.new(1, 0, 0, 1)
UI.PlayerDividerTemplate.Visible = false
UI.PlayerDividerTemplate.Parent = UI.Players

UI.Profile = Instance.new("CanvasGroup")
UI.Profile.Name = "Profile"
UI.Profile.AnchorPoint = Vector2.new(1, 0)
UI.Profile.AutomaticSize = Enum.AutomaticSize.None
UI.Profile.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UI.Profile.BackgroundTransparency = 0.08
UI.Profile.BorderSizePixel = 0
UI.Profile.Position = UDim2.new(1, -214, 0, 8)
UI.Profile.Size = UDim2.new(0, 240, 0, 414)
UI.Profile.Visible = false
UI.Profile.Parent = UI.Folder

UI.ProfileCorner = Instance.new("UICorner")
UI.ProfileCorner.CornerRadius = UDim.new(0, 8)
UI.ProfileCorner.Parent = UI.Profile

UI.ProfilePadding = Instance.new("UIPadding")
UI.ProfilePadding.PaddingBottom = UDim.new(0, 8)
UI.ProfilePadding.PaddingLeft = UDim.new(0, 8)
UI.ProfilePadding.PaddingRight = UDim.new(0, 8)
UI.ProfilePadding.PaddingTop = UDim.new(0, 8)
UI.ProfilePadding.Parent = UI.Profile

UI.ProfileLayout = Instance.new("UIListLayout")
UI.ProfileLayout.FillDirection = Enum.FillDirection.Vertical
UI.ProfileLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ProfileLayout.Padding = UDim.new(0, 10)
UI.ProfileLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ProfileLayout.Parent = UI.Profile

UI.PlayerInfo = Instance.new("Frame")
UI.PlayerInfo.Name = "PlayerInfo"
UI.PlayerInfo.AutomaticSize = Enum.AutomaticSize.None
UI.PlayerInfo.BackgroundTransparency = 1
UI.PlayerInfo.LayoutOrder = 1
UI.PlayerInfo.Size = UDim2.new(0, 100, 0, 100)
UI.PlayerInfo.Parent = UI.Profile

UI.PlayerInfoLayout = Instance.new("UIListLayout")
UI.PlayerInfoLayout.FillDirection = Enum.FillDirection.Horizontal
UI.PlayerInfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.PlayerInfoLayout.Padding = UDim.new(0, 6)
UI.PlayerInfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.PlayerInfoLayout.Parent = UI.PlayerInfo

UI.Headshot = Instance.new("ImageLabel")
UI.Headshot.Name = "Headshot"
UI.Headshot.BackgroundTransparency = 1
UI.Headshot.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
UI.Headshot.LayoutOrder = 1
UI.Headshot.Size = UDim2.new(0, 100, 0, 100)
UI.Headshot.Parent = UI.PlayerInfo

UI.HeadshotRatio = Instance.new("UIAspectRatioConstraint")
UI.HeadshotRatio.AspectRatio = 1
UI.HeadshotRatio.Parent = UI.Headshot

UI.HeadshotCorner = Instance.new("UICorner")
UI.HeadshotCorner.CornerRadius = UDim.new(1, 0)
UI.HeadshotCorner.Parent = UI.Headshot

UI.Info = Instance.new("Frame")
UI.Info.Name = "Info"
UI.Info.BackgroundTransparency = 1
UI.Info.LayoutOrder = 2
UI.Info.Size = UDim2.new(0, 0, 0, 0)
UI.Info.Parent = UI.PlayerInfo

UI.InfoLayout = Instance.new("UIListLayout")
UI.InfoLayout.FillDirection = Enum.FillDirection.Vertical
UI.InfoLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.InfoLayout.Padding = UDim.new(0, 2)
UI.InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.InfoLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
UI.InfoLayout.Parent = UI.Info

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
	lbl.Parent = UI.Info
	return lbl
end

UI.DisplayName = MakeInfoLabel("DisplayName", "DisplayName", 16, 1)
UI.Username = MakeInfoLabel("Username", "@Username", 14, 2)
UI.UserId = MakeInfoLabel("UserId", "1", 14, 3)

UI.Divider = Instance.new("Frame")
UI.Divider.Name = "Divider"
UI.Divider.BackgroundColor3 = SECONDARY_COLOR
UI.Divider.BorderSizePixel = 0
UI.Divider.LayoutOrder = 2
UI.Divider.Size = UDim2.new(1, 0, 0, 1)
UI.Divider.Parent = UI.Profile

UI.Actions = Instance.new("Frame")
UI.Actions.Name = "Actions"
UI.Actions.AutomaticSize = Enum.AutomaticSize.Y
UI.Actions.BackgroundTransparency = 1
UI.Actions.LayoutOrder = 3
UI.Actions.Size = UDim2.new(0, 0, 0, 0)
UI.Actions.Parent = UI.Profile

UI.ActionsLayout = Instance.new("UIListLayout")
UI.ActionsLayout.FillDirection = Enum.FillDirection.Vertical
UI.ActionsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
UI.ActionsLayout.Padding = UDim.new(0, 6)
UI.ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
UI.ActionsLayout.Parent = UI.Actions

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
	btn.Parent = UI.Actions

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

	return btn, lbl, icon
end

UI.AddFriendBtn, UI.AddFriendLbl, UI.AddFriendIcon = MakeAction("AddFriend", "Add Friend", "CoreUI/AddFriend.png", 1)
UI.ExamineBtn, UI.ExamineLbl = MakeAction("Examine", "Examine", "CoreUI/Examine.png", 2)
UI.BlockBtn, UI.BlockLbl = MakeAction("Block", "Block", "CoreUI/Block.png", 3)
UI.GotoBtn, UI.GotoLbl = MakeAction("Goto", "Goto", "CoreUI/Goto.png", 4)
UI.ReportBtn, UI.ReportLbl = MakeAction("Report", "Report", "CoreUI/Report.png", 5)
UI.SpectateBtn, UI.SpectatelLbl, UI.SpectateIcon = MakeAction("Spectate", "Spectate", "CoreUI/Spectate.png", 6)

local LeaderboardVisible = false
local SelectedPlayer = nil
local SelectedEntry = nil
local IsSpectating = false

local AddFriendAsset = nil
local UnfriendAsset = nil
local SpectateAsset = nil
local UnspectateAsset = nil

task.spawn(function()
	AddFriendAsset = GetAsset("CoreUI/AddFriend.png")
	UnfriendAsset = GetAsset("CoreUI/Unfriend.png")
	SpectateAsset = GetAsset("CoreUI/Spectate.png")
	UnspectateAsset = GetAsset("CoreUI/Unspectate.png")
end)

local OPEN_POS = UDim2.new(1, -8, 0, 8)
local CLOSED_POS = UDim2.new(1, 208, 0, 8)

local PROFILE_OPEN_POS = UDim2.new(1, -214, 0, 8)
local PROFILE_CLOSED_POS = UDim2.new(1, 34, 0, 8)

local function ShowLeaderboard()
	LeaderboardVisible = true
	UI.PlayersList.Visible = true
	Tween(UI.PlayersList, 0.35, { Position = OPEN_POS }, "Back", "Out"):Play()
end

local function HideProfile()
	if not UI.Profile.Visible then return end

	local t = Tween(UI.Profile, 0.2, { Position = PROFILE_CLOSED_POS, GroupTransparency = 1 }, "Quad", "In")
	t:Play()
	t.Completed:Connect(function()
		UI.Profile.Visible = false
	end)
end

local function HideLeaderboard()
	LeaderboardVisible = false
	HideProfile()

	local t = Tween(UI.PlayersList, 0.25, { Position = CLOSED_POS }, "Quad", "In")
	t:Play()
	t.Completed:Connect(function()
		if not LeaderboardVisible then
			UI.PlayersList.Visible = false
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

local function UpdateAddFriendButton(isFriend)
	UI.AddFriendLbl.Text = isFriend and "Unfriend" or "Add Friend"
	if UI.AddFriendIcon then
		if isFriend and UnfriendAsset then
			UI.AddFriendIcon.Image = UnfriendAsset
		elseif not isFriend and AddFriendAsset then
			UI.AddFriendIcon.Image = AddFriendAsset
		end
	end
end

local function ShowProfile(player)
	SelectedPlayer = player

	local localPlayer = Players.LocalPlayer
	local isSelf = player.UserId == localPlayer.UserId
	local isFriend = localPlayer:IsFriendsWith(player.UserId)

	UI.DisplayName.Text = player.DisplayName
	UI.Username.Text = "@" .. player.Name
	UI.UserId.Text = tostring(player.UserId)

	UI.Headshot.Image = Players:GetUserThumbnailAsync(
		player.UserId,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size100x100
	)

	UpdateAddFriendButton(isFriend)

	UI.SpectatelLbl.Text = IsSpectating and "Unspectate" or "Spectate"
	if UI.SpectateIcon then
		UI.SpectateIcon.Image = (IsSpectating and UnspectateAsset) or SpectateAsset or UI.SpectateIcon.Image
	end

	UI.AddFriendBtn.Visible = not isSelf
	UI.GotoBtn.Visible = not isSelf
	UI.SpectateBtn.Visible = not isSelf
	UI.ReportBtn.Visible = not isSelf

	UI.Profile.Position = PROFILE_CLOSED_POS
	UI.Profile.GroupTransparency = 1
	UI.Profile.Visible = true
	Tween(UI.Profile, 0.3, { Position = PROFILE_OPEN_POS, GroupTransparency = 0 }, "Back", "Out"):Play()
end

local function RefreshPlayers()
	for _, child in ipairs(UI.Players:GetChildren()) do
		if child ~= UI.PlayerTemplate
			and child ~= UI.PlayerDividerTemplate
			and child ~= UI.PlayersLayout then
			child:Destroy()
		end
	end

	local sortedPlayers = Players:GetPlayers()
	table.sort(sortedPlayers, function(a, b)
		return a.DisplayName:lower() < b.DisplayName:lower()
	end)

	SelectedEntry = nil

	for i, player in ipairs(sortedPlayers) do
		local entry = UI.PlayerTemplate:Clone()
		entry.Name = player.Name
		entry.Text = player.DisplayName
		entry.LayoutOrder = (i - 1) * 2
		entry.Visible = true
		entry.Parent = UI.Players

		if SelectedPlayer and player.UserId == SelectedPlayer.UserId then
			entry.BackgroundTransparency = 0.95
			SelectedEntry = entry
		end

		entry.Activated:Connect(function()
			if SelectedPlayer and player.UserId == SelectedPlayer.UserId then
				SetSelectedEntry(nil)
				SelectedPlayer = nil
				HideProfile()
			else
				SetSelectedEntry(entry)
				ShowProfile(player)
			end
		end)

		if i < #sortedPlayers then
			local divider = UI.PlayerDividerTemplate:Clone()
			divider.LayoutOrder = (i - 1) * 2 + 1
			divider.Visible = true
			divider.Parent = UI.Players
		end
	end
end

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(player)
	if SelectedPlayer == player then
		HideProfile()
		SelectedPlayer = nil
	end
	RefreshPlayers()
end)

RefreshPlayers()

UI.DisplayName.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then
		if SetClipboard then
			SetClipboard(UI.DisplayName.Text)
			Notify("Display name copied!", 2)
		end
	end
end)

UI.Username.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then
		if SetClipboard then
			SetClipboard(UI.Username.Text:sub(2))
			Notify("Username copied!", 2)
		end
	end
end)

UI.UserId.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then
		if SetClipboard then
			SetClipboard(UI.UserId.Text)
			Notify("UserId copied!", 2)
		end
	end
end)

UI.AddFriendBtn.Activated:Connect(function()
	if not SelectedPlayer then return end
	local isFriend = Players.LocalPlayer:IsFriendsWith(SelectedPlayer.UserId)
	if isFriend then
		StarterGui:SetCore("PromptUnfriend", SelectedPlayer)
	else
		StarterGui:SetCore("PromptSendFriendRequest", SelectedPlayer)
	end
	task.delay(1, function()
		if not SelectedPlayer then return end
		local nowFriend = Players.LocalPlayer:IsFriendsWith(SelectedPlayer.UserId)
		UpdateAddFriendButton(nowFriend)
	end)
end)

UI.ExamineBtn.Activated:Connect(function()
	if not SelectedPlayer then return end
	GuiService:InspectPlayerFromUserId(SelectedPlayer.UserId)
end)

UI.BlockBtn.Activated:Connect(function()
	if not SelectedPlayer then return end
	StarterGui:SetCore("PromptBlockPlayer", SelectedPlayer)
end)

UI.GotoBtn.Activated:Connect(function()
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

UI.ReportBtn.Activated:Connect(function()
	if not SelectedPlayer then return end
	StarterGui:SetCore("PromptReportPlayer", SelectedPlayer)
end)

UI.SpectateBtn.Activated:Connect(function()
	if not SelectedPlayer then return end
	local camera = workspace.CurrentCamera

	if IsSpectating then
		IsSpectating = false
		UI.SpectatelLbl.Text = "Spectate"
		if UI.SpectateIcon and SpectateAsset then
			UI.SpectateIcon.Image = SpectateAsset
		end
		camera.CameraSubject = Players.LocalPlayer.Character
			and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		camera.CameraType = Enum.CameraType.Custom
	else
		local targetChar = SelectedPlayer.Character
		local humanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end

		IsSpectating = true
		UI.SpectatelLbl.Text = "Unspectate"
		if UI.SpectateIcon and UnspectateAsset then
			UI.SpectateIcon.Image = UnspectateAsset
		end
		camera.CameraSubject = humanoid
		camera.CameraType = Enum.CameraType.Custom
	end
end)

UI.Close.Activated:Connect(HideLeaderboard)

local topbarMenu = CoreGui
	:WaitForChild("TopBarApp", 10)
	:WaitForChild("TopBarApp", 10)
	:WaitForChild("UnibarLeftFrame", 10)
	:WaitForChild("UnibarMenu", 10)

local subMenuHost = topbarMenu:WaitForChild("SubMenuHost", 10)

local function GetMainCanvas()
	local nineDot = subMenuHost:FindFirstChild("nine_dot")
	if not nineDot then return nil end
	local sf = nineDot:FindFirstChild("ScrollingFrame")
	if not sf then return nil end
	return sf:FindFirstChild("MainCanvas")
end

local function CreateLB(mainCanvas)
	local existing = mainCanvas:FindFirstChild("leaderboard")
	if existing then existing:Destroy() end

	local btn = Instance.new("ImageButton")
	btn.Name = "leaderboard"
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.LayoutOrder = 1
	btn.Size = UDim2.new(1, 0, 0, 56)

	local corner = Instance.new("UICorner")
	corner.Parent = btn

	local rowLabel = Instance.new("Frame")
	rowLabel.Name = "RowLabel"
	rowLabel.BackgroundTransparency = 1
	rowLabel.BorderSizePixel = 0
	rowLabel.LayoutOrder = 1
	rowLabel.Size = UDim2.new(1, 0, 1, 0)
	rowLabel.Parent = btn

	local rowLayout = Instance.new("UIListLayout")
	rowLayout.FillDirection = Enum.FillDirection.Horizontal
	rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	rowLayout.Padding = UDim.new(0, 8)
	rowLayout.Parent = rowLabel

	local rowPadding = Instance.new("UIPadding")
	rowPadding.PaddingLeft = UDim.new(0, 8)
	rowPadding.PaddingRight = UDim.new(0, 8)
	rowPadding.Parent = rowLabel

	local iconHost = Instance.new("Frame")
	iconHost.Name = "IconHost"
	iconHost.BackgroundTransparency = 1
	iconHost.BorderSizePixel = 0
	iconHost.LayoutOrder = 1
	iconHost.Size = UDim2.new(0, 44, 0, 44)
	iconHost.Parent = rowLabel

	local iconFrame = Instance.new("Frame")
	iconFrame.Name = "IntegrationIconFrame"
	iconFrame.BackgroundTransparency = 1
	iconFrame.BorderSizePixel = 0
	iconFrame.Size = UDim2.new(1, 0, 1, 0)
	iconFrame.Parent = iconHost

	local iconFrameLayout = Instance.new("UIListLayout")
	iconFrameLayout.FillDirection = Enum.FillDirection.Horizontal
	iconFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	iconFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	iconFrameLayout.Parent = iconFrame

	local icon = Instance.new("TextLabel")
	icon.Name = "IntegrationIcon"
	icon.BackgroundTransparency = 1
	icon.FontFace = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json")
	icon.Text = "trophy"
	icon.TextColor3 = Color3.fromRGB(247, 247, 248)
	icon.TextSize = 24
	icon.Size = UDim2.new(0, 36, 0, 36)
	icon.Parent = iconFrame

	local label = Instance.new("Frame")
	label.Name = "Label"
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Size = UDim2.new(0, 0, 1, 0)
	label.Parent = rowLabel

	local flexItem = Instance.new("UIFlexItem")
	flexItem.FlexMode = Enum.UIFlexMode.Fill
	flexItem.Parent = label

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "StyledTextLabel"
	textLabel.BackgroundTransparency = 1
	textLabel.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
	textLabel.RichText = true
	textLabel.Text = "Leaderboard"
	textLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
	textLabel.TextScaled = true
	textLabel.TextSize = 20
	textLabel.TextTruncate = Enum.TextTruncate.AtEnd
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Parent = label

	local textConstraint = Instance.new("UITextSizeConstraint")
	textConstraint.MaxTextSize = 20
	textConstraint.MinTextSize = 20
	textConstraint.Parent = textLabel

	btn.Activated:Connect(function()
		if LeaderboardVisible then
			HideLeaderboard()
		else
			ShowLeaderboard()
		end
	end)

	btn.Parent = mainCanvas
end

local function TryBuild()
	local mainCanvas = GetMainCanvas()
	if mainCanvas then
		CreateLB(mainCanvas)
	end
end

local function HookLB()
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	end)

	TryBuild()

	subMenuHost.ChildAdded:Connect(function(child)
		if child.Name == "nine_dot" then
			task.defer(TryBuild)
		end
	end)
end

HookLB()

local tabDebounce = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or input.KeyCode ~= Enum.KeyCode.Tab or tabDebounce then return end

	tabDebounce = true
	if LeaderboardVisible then HideLeaderboard() else ShowLeaderboard() end

	task.delay(LeaderboardVisible and 0.35 or 0.25, function()
		tabDebounce = false
	end)
end)