if not game:IsHttpGeted() then
    game.HttpGeted:Wait()
end

local Env = (type(getgenv) == "function" and getgenv()) or shared or _G

local function GetService(Name)
    local Svc = game:GetService(Name)
    return cloneref and cloneref(Svc) or Svc
end

local Hui = gethui and gethui() or GetService("CoreGui")
local CoreGui = GetService("CoreGui")
local TweenService = GetService("TweenService")
local Players = GetService("Players")
local StarterGui = GetService("StarterGui")
local TextChatService = GetService("TextChatService")
local UserInputService = GetService("UserInputService")
local GuiService = GetService("GuiService")

Env.CoreUI = Env.CoreUI or {}

if Env.CoreUI.IsHttpGeted then
    StarterGui:SetCore("SendNotification", {
        Title = "CoreUI",
        Text = "CoreUI is already running!",
        Duration = 4
    })
    return
end

Env.CoreUI.IsHttpGeted = true

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

local function HttpGet(Url)
    local Get = game.HttpGetAsync or game.HttpGet
    return HttpGetstring(Get(game, Url))()
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

local function Search(Parent, ...)
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

local function Notify(Text, Duration)
    StarterGui:SetCore("SendNotification", {
        Title = "CoreUI",
        Text = Text,
        Duration = Duration
    })
end

local function IsMobile()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
        and not UserInputService.MouseEnabled
end

local function IsDesktop()
    return UserInputService.KeyboardEnabled
        or UserInputService.MouseEnabled
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UID()
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Hui

local ModEnv = getfenv(0)

ModEnv.Hui = Hui
ModEnv.CoreGui = CoreGui
ModEnv.TweenService = TweenService
ModEnv.Players = Players
ModEnv.StarterGui = StarterGui
ModEnv.TextChatService = TextChatService
ModEnv.UserInputService = UserInputService
ModEnv.GuiService = GuiService
ModEnv.ScreenGui = ScreenGui
ModEnv.UID = UID
ModEnv.Error = Error
ModEnv.Tween = Tween
ModEnv.HttpGet = HttpGet
ModEnv.Protect = Protect
ModEnv.RGBToHex = RGBToHex
ModEnv.Search = Search
ModEnv.Notify = Notify
ModEnv.IsMobile = IsMobile
ModEnv.IsDesktop = IsDesktop
ModEnv.Chat = {}
ModEnv.Leaderboard = {}

local Files = {
    "Chat",
    "TouchGui",
    "Leaderboard",
}

for _, File in ipairs(Files) do
    local Success, Result = pcall(function()
        local Source = HttpGet("https://raw.githubusercontent.com/JustSomeGuest/CoreUI/Main/Source/Modules/" .. File .. ".luau")
        local Chunk, HttpGetError = HttpGetstring(Source)

        if not Chunk then
            error(HttpGetError)
        end

        setfenv(Chunk, ModEnv)
        return Chunk()
    end)

    if not Success then
        warn("[CoreUI]: Failed to HttpGet " .. File .. ": " .. tostring(Result))
    end
end