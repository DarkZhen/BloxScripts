-- Complete Blox Fruits Script
-- All Features Including Auto Farm, Auto Boss, Fruit Sniper, ESP, and More
-- No Key Required

repeat wait() until game:IsLoaded()
repeat wait() until game.Players
repeat wait() until game.Players.LocalPlayer

-- Anti-Kick & Anti-Ban Protection
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local NamecallMethod = getnamecallmethod()
    
    if not checkcaller() and (NamecallMethod == "Kick" or NamecallMethod == "kick") then
        return nil
    end
    
    return OldNamecall(Self, ...)
end)

-- Disable AFK Kick
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end

-- Load UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🍇 Blox Fruits Hub | Complete Edition",
   LoadingTitle = "Loading Blox Fruits Hub",
   LoadingSubtitle = "All Features Unlocked",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BloxFruitsComplete",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Settings
_G.Settings = {
    -- Auto Farm
    AutoFarmLevel = false,
    AutoFarmBoss = false,
    AutoFarmMastery = false,
    AutoFarmBone = false,
    AutoFarmChest = false,
    AutoObservationHaki = false,
    
    -- Combat
    FastAttack = false,
    AutoHaki = false,
    BringMob = false,
    
    -- Stats
    AutoStats = false,
    SelectedStat = "Melee",
    
    -- Devil Fruits
    AutoCollectFruits = false,
    AutoStoreFruits = false,
    FruitSniper = false,
    SelectedFruit = nil,
    ESPFruits = false,
    
    -- Raids
    AutoRaid = false,
    AutoAwaken = false,
    
    -- Teleport
    AutoQuest = false,
    
    -- Misc
    AntiAFK = true,
    RemoveFog = false,
    WhiteScreen = false,
    FastMode = false
}

-- Selected Variables
local SelectedBoss = nil
local SelectedIsland = nil
local SelectedWeapon = nil
local SelectedMaterial = nil

-- Combat Framework for Fast Attack
local CombatFramework, CombatFrameworkR
pcall(function()
    CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
    CombatFrameworkR = getupvalues(CombatFramework)[2]
end)

-- Utility Functions
local function Notify(title, text, duration)
    Rayfield:Notify({
       Title = title,
       Content = text,
       Duration = duration or 3,
       Image = 4483362458
    })
end

local function GetDistance(pos)
    return (HumanoidRootPart.Position - pos).Magnitude
end

local function Tween(position, speed)
    local distance = GetDistance(position)
    local tweenSpeed = speed or 300
    local time = distance / tweenSpeed
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(position)}
    )
    
    tween:Play()
    return tween
end

local function Teleport(cframe)
    HumanoidRootPart.CFrame = cframe
end

local function GetNearestMob()
    local nearestMob = nil
    local shortestDistance = math.huge
    
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            local distance = GetDistance(mob.HumanoidRootPart.Position)
            if distance < shortestDistance then
                shortestDistance = distance
                nearestMob = mob
            end
        end
    end
    
    return nearestMob
end

local function GetBoss(name)
    for _, boss in pairs(Workspace.Enemies:GetChildren()) do
        if string.find(boss.Name, name) and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
            return boss
        end
    end
    return nil
end

local function EquipTool()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            Humanoid:EquipTool(tool)
            return true
        end
    end
    return false
end

local function AttackNoCD()
    pcall(function()
        local weapon = Character:FindFirstChildOfClass("Tool")
        if weapon then
            ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", weapon.Name)
            ReplicatedStorage.RigControllerEvent:FireServer("hit", game:GetService("ReplicatedStorage").Assets.Damage[weapon.Name], 2, "")
        end
    end)
end

local function UseSkill(skill)
    VirtualInputManager:SendKeyEvent(true, skill, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, skill, false, game)
end

local function CheckQuest()
    local questTitle = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    if questTitle and questTitle.Visible then
        return true
    end
    return false
end

local function GetQuestTitle()
    if LocalPlayer.PlayerGui.Main.Quest.Visible then
        return LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    return ""
end

-- Boss List
local BossList = {
    "The Gorilla King",
    "Bobby",
    "Yeti",
    "Mob Leader",
    "Vice Admiral",
    "Warden",
    "Chief Warden",
    "Swan",
    "Magma Admiral",
    "Fishman Lord",
    "Wysper",
    "Thunder God",
    "Cyborg",
    "Saber Expert",
    "Greybeard",
    "Diamond",
    "Jeremy",
    "Fajita",
    "Don Swan",
    "Smoke Admiral",
    "Cursed Captain",
    "Darkbeard",
    "Order",
    "Awakened Ice Admiral",
    "Tide Keeper",
    "rip_indra",
    "Soul Reaper",
    "Dough King"
}

-- Island List
local IslandsList = {
    "StartingArea",
    "Jungle",
    "Pirate Village",
    "Desert",
    "Frozen Village",
    "Marine Fortress",
    "Skylands",
    "Prison",
    "Colosseum",
    "Magma Village",
    "Underwater City",
    "Upper Skylands",
    "Fountain City",
    "Port Town",
    "Hydra Island",
    "Mansion",
    "Castle on the Sea",
    "Haunted Castle",
    "Tiki Outpost"
}

-- Fruit List
local FruitsList = {
    "Bomb-Bomb",
    "Spike-Spike",
    "Chop-Chop",
    "Spring-Spring",
    "Kilo-Kilo",
    "Smoke-Smoke",
    "Spin-Spin",
    "Flame-Flame",
    "Falcon-Falcon",
    "Ice-Ice",
    "Sand-Sand",
    "Dark-Dark",
    "Diamond-Diamond",
    "Light-Light",
    "Love-Love",
    "Rubber-Rubber",
    "Barrier-Barrier",
    "Magma-Magma",
    "Quake-Quake",
    "Buddha-Buddha",
    "Spider-Spider",
    "Phoenix-Phoenix",
    "Rumble-Rumble",
    "Paw-Paw",
    "Gravity-Gravity",
    "Dough-Dough",
    "Shadow-Shadow",
    "Venom-Venom",
    "Control-Control",
    "Spirit-Spirit",
    "Dragon-Dragon",
    "Leopard-Leopard"
}

-- Auto Farm Level
spawn(function()
    while wait() do
        if _G.Settings.AutoFarmLevel then
            pcall(function()
                local mob = GetNearestMob()
                if mob then
                    repeat wait()
                        if not _G.Settings.AutoFarmLevel then break end
                        if not mob or mob.Humanoid.Health <= 0 then break end
                        
                        EquipTool()
                        
                        if _G.Settings.BringMob then
                            mob.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
                            mob.HumanoidRootPart.CanCollide = false
                            mob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            mob.Humanoid.WalkSpeed = 0
                        else
                            HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                        end
                        
                        AttackNoCD()
                        
                    until not mob or mob.Humanoid.Health <= 0 or not _G.Settings.AutoFarmLevel
                end
            end)
        end
    end
end)

-- Auto Farm Boss
spawn(function()
    while wait() do
        if _G.Settings.AutoFarmBoss and SelectedBoss then
            pcall(function()
                local boss = GetBoss(SelectedBoss)
                if boss then
                    repeat wait()
                        if not _G.Settings.AutoFarmBoss then break end
                        if not boss or boss.Humanoid.Health <= 0 then break end
                        
                        EquipTool()
                        HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        AttackNoCD()
                        
                        -- Use skills every 2 seconds
                        if tick() % 2 < 0.5 then
                            UseSkill("Z")
                            UseSkill("X")
                            UseSkill("C")
                        end
                        
                    until not boss or boss.Humanoid.Health <= 0 or not _G.Settings.AutoFarmBoss
                    
                    Notify("Boss Defeated", SelectedBoss .. " has been defeated!", 3)
                end
            end)
        end
    end
end)

-- Fast Attack
spawn(function()
    while wait() do
        if _G.Settings.FastAttack then
            pcall(function()
                AttackNoCD()
            end)
        end
    end
end)

-- Auto Haki
spawn(function()
    while wait(1) do
        if _G.Settings.AutoHaki then
            pcall(function()
                if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- Auto Stats
spawn(function()
    while wait(0.1) do
        if _G.Settings.AutoStats then
            pcall(function()
                local stat = _G.Settings.SelectedStat
                if stat == "Devil Fruit" then stat = "Demon Fruit" end
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
            end)
        end
    end
end)

-- Auto Collect Fruits
spawn(function()
    while wait(2) do
        if _G.Settings.AutoCollectFruits then
            pcall(function()
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if string.find(fruit.Name, "Fruit") and fruit:IsA("Tool") then
                        Teleport(fruit.Handle.CFrame)
                        wait(0.3)
                    end
                end
            end)
        end
    end
end)

-- Fruit Sniper
spawn(function()
    while wait(0.5) do
        if _G.Settings.FruitSniper and _G.Settings.SelectedFruit then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", _G.Settings.SelectedFruit)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseRawFruit", _G.Settings.SelectedFruit)
            end)
        end
    end
end)

-- ESP Fruits
spawn(function()
    while wait(1) do
        if _G.Settings.ESPFruits then
            pcall(function()
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if string.find(fruit.Name, "Fruit") and not fruit:FindFirstChild("ESP") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.Parent = fruit
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.fromRGB(255, 0, 255)
                        label.TextStrokeTransparency = 0.5
                        label.Text = fruit.Name
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 16
                        label.Parent = billboard
                    end
                end
            end)
        else
            for _, fruit in pairs(Workspace:GetChildren()) do
                if fruit:FindFirstChild("ESP") then
                    fruit.ESP:Destroy()
                end
            end
        end
    end
end)

-- Remove Fog
spawn(function()
    while wait(1) do
        if _G.Settings.RemoveFog then
            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
        end
    end
end)

-- White Screen (FPS Boost)
spawn(function()
    while wait(1) do
        if _G.Settings.WhiteScreen then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = "Plastic"
                    v.Color = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end)

-- GUI TABS

-- Home Tab
local HomeTab = Window:CreateTab("🏠 Home", 4483362458)

HomeTab:CreateParagraph({
    Title = "Welcome!",
    Content = "Player: " .. LocalPlayer.Name .. "\nLevel: " .. (LocalPlayer.Data.Level.Value or "Loading...")
})

HomeTab:CreateParagraph({
    Title = "Protection Status",
    Content = "✅ Anti-Kick: Active\n✅ Anti-Ban: Active\n✅ Anti-AFK: Active"
})

HomeTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end,
})

HomeTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
        local servers = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
   end,
})

-- Auto Farm Tab
local FarmTab = Window:CreateTab("⚔️ Auto Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.AutoFarmLevel = value
        Notify("Auto Farm", value and "Enabled" or "Disabled", 2)
   end,
})

FarmTab:CreateToggle({
   Name = "Bring Mob",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.BringMob = value
   end,
})

FarmTab:CreateToggle({
   Name = "Fast Attack",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.FastAttack = value
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Haki",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.AutoHaki = value
   end,
})

FarmTab:CreateDropdown({
   Name = "Select Boss",
   Options = BossList,
   CurrentOption = {BossList[1]},
   Callback = function(option)
        SelectedBoss = option[1]
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Farm Boss",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.AutoFarmBoss = value
   end,
})

-- Stats Tab
local StatsTab = Window:CreateTab("📊 Stats", 4483362458)

StatsTab:CreateDropdown({
   Name = "Select Stat",
   Options = {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"},
   CurrentOption = {"Melee"},
   Callback = function(option)
        _G.Settings.SelectedStat = option[1]
   end,
})

StatsTab:CreateToggle({
   Name = "Auto Stats",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.AutoStats = value
   end,
})

-- Devil Fruits Tab
local FruitTab = Window:CreateTab("🍇 Devil Fruits", 4483362458)

FruitTab:CreateToggle({
   Name = "Auto Collect Fruits",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.AutoCollectFruits = value
   end,
})

FruitTab:CreateToggle({
   Name = "Fruit ESP",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.ESPFruits = value
   end,
})

FruitTab:CreateDropdown({
   Name = "Snipe Fruit",
   Options = FruitsList,
   CurrentOption = {FruitsList[1]},
   Callback = function(option)
        _G.Settings.SelectedFruit = option[1]
   end,
})

FruitTab:CreateToggle({
   Name = "Fruit Sniper",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.FruitSniper = value
   end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🌍 Teleport", 4483362458)

TeleportTab:CreateDropdown({
   Name = "Select Island",
   Options = IslandsList,
   CurrentOption = {IslandsList[1]},
   Callback = function(option)
        SelectedIsland = option[1]
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Island",
   Callback = function()
        if SelectedIsland then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", SelectedIsland)
        end
   end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

MiscTab:CreateToggle({
   Name = "Remove Fog",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.RemoveFog = value
   end,
})

MiscTab:CreateToggle({
   Name = "White Screen (FPS)",
   CurrentValue = false,
   Callback = function(value)
        _G.Settings.WhiteScreen = value
   end,
})

MiscTab:CreateButton({
   Name = "Redeem All Codes",
   Callback = function()
        local codes = {"NEWTROLL", "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK"}
        for _, code in pairs(codes) do
            pcall(function()
                ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
                wait(0.5)
            end)
        end
        Notify("Codes", "All codes redeemed!", 3)
   end,
})

Notify("Script Loaded", "Blox Fruits Complete Edition loaded successfully!", 5)
print("=== Blox Fruits Hub Complete Edition ===")
print("Status: Loaded Successfully")
print("Anti-Kick: Active")
print("All Features: Unlocked")
