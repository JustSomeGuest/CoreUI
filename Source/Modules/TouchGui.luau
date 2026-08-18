local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G
local Env = Shared.CoreUI.Env

local UserInputService = Env.UserInputService
local Players = Env.Players

if not UserInputService.TouchEnabled then
    return
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TouchGui = PlayerGui:WaitForChild("TouchGui", 10)

if not TouchGui then
    warn("[CoreUI]: TouchGui not found, skipping touch controls")
    return
end

local TouchControlFrame = TouchGui:WaitForChild("TouchControlFrame", 10)
if not TouchControlFrame then
    warn("[CoreUI]: TouchControlFrame not found, skipping touch controls")
    return
end

local ThumbstickFrame = TouchControlFrame:WaitForChild("ThumbstickFrame", 10)
if not ThumbstickFrame then
    warn("[CoreUI]: ThumbstickFrame not found, skipping touch controls")
    return
end

local function ApplyThumb()
    local OuterImg = ThumbstickFrame:WaitForChild("OuterImage", 10)
    local StickImg = ThumbstickFrame:WaitForChild("StickImage", 10)

    if not OuterImg or not StickImg then
        warn("[CoreUI]: Thumbstick images not found")
        return
    end

    OuterImg.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    OuterImg.ImageColor3 = Color3.fromRGB(0, 0, 0)
    OuterImg.ImageRectOffset = Vector2.new(1, 1)
    OuterImg.ImageRectSize = Vector2.new(144, 144)

    StickImg.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
    StickImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    StickImg.ImageRectOffset = Vector2.new(1, 1)
    StickImg.ImageRectSize = Vector2.new(144, 144)
end

ApplyThumb()

LocalPlayer.CharacterAdded:Connect(function()
    local NewThumbstickFrame = TouchControlFrame:WaitForChild("ThumbstickFrame", 10)
    if NewThumbstickFrame then
        ThumbstickFrame = NewThumbstickFrame
        ApplyThumb()
    end
end)