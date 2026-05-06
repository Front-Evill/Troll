local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Front-Evill/Troll/refs/heads/main/main.luau"))()

local Window = Library:CreateWindow({
    Title       = "My Script",
    SubTitle    = "v1.0",
    WelcomeText = "Welcome back",
    LoadingTime = 3,
    Theme       = "Dark",
    Size        = UDim2.fromOffset(580, 460),
    MinimizeKey = Enum.KeyCode.RightShift,
    IconImage   = "rbxassetid://10734950309",
})

local Tab1 = Window:AddTab({Title = "Main",Icon  = "home",})
local Tab2 = Window:AddTab({Title = "Settings",Icon  = "settings",})

local Sec1 = Tab1:AddSection("Player")

Sec1:AddToggle("GodMode", {
    Title       = "God Mode",
    Description = "Makes you invincible",
    Default     = false,
    Callback    = function(value)
        print("GodMode:", value)
    end,
})

Sec1:AddSlider("WalkSpeed", {
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 500,
    Default  = 16,
    Rounding = 1,
    Suffix   = " studs",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})

Sec1:AddSlider("JumpPower", {
    Title    = "Jump Power",
    Min      = 50,
    Max      = 500,
    Default  = 50,
    Rounding = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end,
})

local Sec2 = Tab1:AddSection("Visual")

Sec2:AddDropdown("Teams", {
    Title       = "Select Team",
    Description = "Choose your team",
    Values      = {"Red", "Blue", "Green", "Yellow"},
    Default     = 1,
    Callback    = function(value)
        print("Team:", value)
    end,
})

Sec2:AddDropdown("Items", {
    Title  = "Select Items",
    Values = {"Sword", "Gun", "Knife", "Bow"},
    Multi  = true,
    Callback = function(values)
        print("Items:", table.concat(values, ", "))
    end,
})

Sec2:AddButton({
    Title       = "Teleport to Spawn",
    Description = "Teleports you back to spawn",
    Confirm     = false,
    Callback    = function()
        print("Teleporting...")
    end,
})

Sec2:AddButton({
    Title   = "Dangerous Action",
    Confirm = true,
    Callback = function()
        print("Confirmed!")
    end,
})

local Sec3 = Tab1:AddSection("Info")

Sec3:AddParagraph({
    Title   = "About",
    Content = "This is FRontEVill GUI library. A clean and lightweight Roblox UI library inspired by Fluent.",
})

local SettingsSec = Tab2:AddSection("Interface")

SettingsSec:AddInput("Username", {
    Title       = "Custom Name",
    Description = "Set a display name",
    Placeholder = "Enter name...",
    Finished    = true,
    Callback    = function(value)
        print("Name:", value)
    end,
})

SettingsSec:AddInput("Number", {
    Title    = "Port Number",
    Numeric  = true,
    Default  = "8080",
    Callback = function(value)
        print("Port:", value)
    end,
})

Window:Notify({
    Title    = "Script Loaded",
    Content  = "FRONT GUI loaded successfully!",
    Duration = 5,
    Color    = Library.Themes.Dark.Success,
})
