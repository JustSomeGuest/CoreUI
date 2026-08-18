if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Shared = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Service)
    local Service = game:GetService(Service)
    return cloneref and cloneref(Service) or Service
end

local Hui = gethui and gethui() or GetService("CoreGui")
local CoreGui = GetService("CoreGui")
local TweenService = GetService("TweenService")
local Players = GetService("Players")
local StarterGui = GetService("StarterGui")
local TextChatService = GetService("TextChatService")
local UserInputService = GetService("UserInputService")

Shared.CoreUI = Shared.CoreUI or {}

if Shared.CoreUI.IsLoaded then
    StarterGui:SetCore("SendNotification", {
        Title = "CoreUI",
        Text = "CoreUI is already running!",
        Duration = 4
    })
    return
end

Shared.CoreUI.IsLoaded = true

local function UID(Length)
    Length = Length or 64
    local Chars = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]
    local Id = table.create(Length)
    for i = 1, Length do
        local Rand = math.random(1, #Chars)
        Id[i] = Chars:sub(Rand, Rand)
    end
    return table.concat(Id)
end

local function Error(Reason)
    error("[CoreUI]: " .. Reason, 2)
end

local function Tween(Object, Speed, Props, Style, Dir)
    return TweenService:Create(
        Object,
        TweenInfo.new(
            Speed,
            Enum.EasingStyle[Style or "Quad"],
            Enum.EasingDirection[Dir or "Out"]
        ),
        Props
    )
end

local function Protect(Object, Property, Value)
    Object[Property] = Value
    Object:GetPropertyChangedSignal(Property):Connect(function()
        if Object[Property] ~= Value then
            Object[Property] = Value
        end
    end)
end

local function RGBToHex(Color)
    return string.format(
        "#%02X%02X%02X",
        math.floor(Color.R * 255),
        math.floor(Color.G * 255),
        math.floor(Color.B * 255)
    )
end

local function FindDescendant(Parent, ...)
    local Current = Parent
    for _, Name in ipairs({...}) do
        local Previous = Current
        Current = Current and Current:FindFirstChild(Name)
        if not Current then
            Error(string.format("'%s' was not found in '%s'", Name, Previous.Name))
        end
    end
    return Current
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UID()
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Hui

Shared.CoreUI.Env = {
    Hui = Hui,
    CoreGui = CoreGui,
    TweenService = TweenService,
    Players = Players,
    StarterGui = StarterGui,
    TextChatService = TextChatService,
    UserInputService = UserInputService,
    ScreenGui = ScreenGui,
    UID = UID,
    Error = Error,
    Tween = Tween,
    Protect = Protect,
    RGBToHex = RGBToHex,
    FindDescendant = FindDescendant,
    Chat = {},
    Leaderboard = {}
}

local Files = {
    "Chat",
    -- "Leaderboard"
}

for _, File in ipairs(Files) do
    local Success, Result = pcall(function()
        local Source = game:HttpGet(
            "https://raw.githubusercontent.com/JustSomeGuest/CoreUI/Main/Source/Modules/" .. File .. ".luau"
        )
        local LoadedFunction, LoadError = loadstring(Source)
        if not LoadedFunction then
            error(LoadError)
        end
        return LoadedFunction()
    end)

    if not Success then
        warn("[CoreUI]: Failed to load " .. File .. ": " .. tostring(Result))
    end
end