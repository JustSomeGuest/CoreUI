# CoreUI

A small project that redesigns different parts of Roblox's CoreGui to make them look and feel cleaner.

## Currently Redesigned

- **Backpack**
- **Chat**
- **Leaderboard**
- **TouchGui** (Classic thumbstick)

## Loader

### Main

```lua
getgenv().__CoreUI = {
    Backpack = true,
    Chat = true,
    Leaderboard = true,
    TouchGui = true
}
loadstring(game:HttpGet("https://rbxscriptz.pages.dev/scripts/coreui"))()
```

### Alternative

```lua
getgenv().__CoreUI = {
    Backpack = true,
    Chat = true,
    Leaderboard = true,
    TouchGui = true
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustSomeGuest/CoreUI/Main/Source/Init.lua"))()
```

## Status

In Development

## Credits

Made by *JustSomeGuest*.
