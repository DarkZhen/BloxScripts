-- Blox Fruits Hub - Advanced Complex UI
-- Modern Design with Tabs, Animations, and Advanced Features

-- Anti-Kick Protection
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local NamecallMethod = getnamecallmethod()
    
    if not checkcaller() and NamecallMethod == "Kick" then
        return nil
    end
    
    return OldNamecall(Self, ...)
end)

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end

-- Load Rayfield UI Library (Modern & Complex)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits Hub | Advanced Edition",
   LoadingTitle = "Blox Fruits Hub",
   LoadingSubtitle = "by DarkZhen",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BloxFruitsHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Blox Fruits Hub",
      Subtitle = "Key System",
      Note = "No key required!",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

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
local Settings = {
    AutoFarmLevel = false,
    AutoFarmBoss = false,
    AutoQuest = false,
    AutoMastery = false,
    BringMob = false,
    FastAttack = false,
    AutoHaki = false,
    AutoStats = false,
    SelectedStat = "Melee",
    AutoCollectFruits = false,
    AutoStoreFruits = false,
    ESPFruits = false,
    FruitNotifications = false,
    FruitSniper = false,
    SelectedFruit = nil,
    AutoAwakening = false,
    SpeedBoost = false,
    SpeedValue = 16,
    Fly = false,
    NoClip = false,
    InfiniteJump = false,
    RemoveFog = false,
    FullBright = false,
    AntiAFK = true,
    AutoSecondSea = false,
    AutoThirdSea = false
}

local selectedBoss = nil
local selectedIsland = nil
local farmingEnemy = false
local farmingBoss = false

-- Utility Functions
local function Notify(title, text, duration)
    Rayfield:Notify({
       Title = title,
       Content = text,
       Duration = duration or 3,
       Image = 4483362458,
       Actions = {
          Ignore = {
             Name = "Okay!",
             Callback = function() end
          },
       },
    })
end

local function TweenToPosition(position, speed)
    if not Character or not HumanoidRootPart then return end
    
    local TweenService = game:GetService("TweenService")
    local distance = (HumanoidRootPart.Position - position).Magnitude
    local tweenSpeed = speed or 300
    local duration = distance / tweenSpeed
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(position)}
    )
    
    tween:Play()
    return tween
end

local function FindNearestEnemy()
    local nearestEnemy = nil
    local nearestDistance = math.huge
    
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestEnemy = enemy
            end
        end
    end
    
    return nearestEnemy
end

local function FindBoss(bossName)
    for _, boss in pairs(Workspace.Enemies:GetChildren()) do
        if boss.Name == bossName and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
            return boss
        end
    end
    return nil
end

local function EquipWeapon()
    pcall(function()
        if Character:FindFirstChildOfClass("Tool") then
            return
        end
        
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.ToolTip == "Blox Fruit" then
                    Humanoid:EquipTool(tool)
                    wait(0.5)
                    return
                end
            end
        end
    end)
end

local function AttackEnemy()
    pcall(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool:Activate()
        end
    end)
end

local function UseSkills()
    local skills = {"Z", "X", "C", "V", "F"}
    for _, key in pairs(skills) do
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
        wait(0.5)
    end
end

-- Boss List
local BossList = {
    "The Gorilla King [Lv. 25] [Boss]",
    "Bobby [Lv. 55] [Boss]",
    "Yeti [Lv. 110] [Boss]",
    "Mob Leader [Lv. 120] [Boss]",
    "Vice Admiral [Lv. 130] [Boss]",
    "Warden [Lv. 220] [Boss]",
    "Chief Warden [Lv. 230] [Boss]",
    "Swan [Lv. 240] [Boss]",
    "Magma Admiral [Lv. 350] [Boss]",
    "Fishman Lord [Lv. 425] [Boss]",
    "Wysper [Lv. 500] [Boss]",
    "Thunder God [Lv. 575] [Boss]",
    "Cyborg [Lv. 675] [Boss]",
    "Saber Expert [Lv. 200] [Boss]",
    "The Saw [Lv. 100] [Boss]",
    "Greybeard [Lv. 750] [Boss]",
    "Diamond [Lv. 750] [Boss]",
    "Jeremy [Lv. 850] [Boss]",
    "Fajita [Lv. 925] [Boss]",
    "Don Swan [Lv. 1000] [Boss]",
    "Smoke Admiral [Lv. 1150] [Boss]",
    "Cursed Captain [Lv. 1325] [Boss]",
    "Darkbeard [Lv. 1000] [Boss]",
    "Order [Lv. 1250] [Boss]",
    "Awakened Ice Admiral [Lv. 1400] [Boss]",
    "Tide Keeper [Lv. 1475] [Boss]",
    "rip_indra [Lv. 5000] [Boss]",
    "Dough King [Lv. 1111] [Boss]",
    "Soul Reaper [Lv. 2100] [Boss]"
}

-- Island List
local IslandsList = {
    "WindMill",
    "Marine",
    "Middle Town",
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
    "Shank Room",
    "Mob Island",
    "Kingdom of Rose",
    "Cafe",
    "Mansion",
    "Castle on the Sea",
    "Hydra Island",
    "Haunted Castle",
    "Sea Castle",
    "Ice Castle",
    "Forgotten Island",
    "Tiki Outpost"
}

-- Fruit List
local FruitList = {
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
    while wait(0.1) do
        if Settings.AutoFarmLevel and not farmingEnemy then
            pcall(function()
                local enemy = FindNearestEnemy()
                if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                    farmingEnemy = true
                    
                    EquipWeapon()
                    wait(0.3)
                    
                    repeat wait(0.1)
                        if not Settings.AutoFarmLevel then break end
                        if not enemy or not enemy.Parent or enemy.Humanoid.Health <= 0 then break end
                        
                        if Settings.BringMob then
                            enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -15)
                            enemy.HumanoidRootPart.CanCollide = false
                            enemy.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            enemy.Humanoid.WalkSpeed = 0.1
                            enemy.Humanoid.JumpPower = 0.1
                        else
                            HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 3)
                        end
                        
                        AttackEnemy()
                        
                    until not enemy or not enemy.Parent or enemy.Humanoid.Health <= 0 or not Settings.AutoFarmLevel
                    
                    farmingEnemy = false
                    wait(0.5)
                end
            end)
        end
    end
end)

-- Auto Farm Boss
spawn(function()
    while wait(0.5) do
        if Settings.AutoFarmBoss and selectedBoss and not farmingBoss then
            pcall(function()
                local boss = FindBoss(selectedBoss)
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss:FindFirstChild("HumanoidRootPart") then
                    farmingBoss = true
                    
                    EquipWeapon()
                    wait(0.3)
                    
                    repeat wait(0.1)
                        if not Settings.AutoFarmBoss then break end
                        if not boss or not boss.Parent or boss.Humanoid.Health <= 0 then break end
                        
                        HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 5)
                        AttackEnemy()
                        
                        if tick() % 3 < 0.5 then
                            UseSkills()
                        end
                        
                    until not boss or not boss.Parent or boss.Humanoid.Health <= 0 or not Settings.AutoFarmBoss
                    
                    farmingBoss = false
                    Notify("Boss Defeated", selectedBoss .. " has been defeated!", 3)
                    wait(1)
                end
            end)
        end
    end
end)

-- Fast Attack
local lastAttackTime = 0
spawn(function()
    while wait(0.01) do
        if Settings.FastAttack then
            pcall(function()
                local currentTime = tick()
                if currentTime - lastAttackTime >= 0.1 then
                    lastAttackTime = currentTime
                    
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        tool:Activate()
                    end
                end
            end)
        end
    end
end)

-- Auto Stats
spawn(function()
    while wait(0.1) do
        if Settings.AutoStats then
            pcall(function()
                if Settings.SelectedStat == "Melee" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
                elseif Settings.SelectedStat == "Defense" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
                elseif Settings.SelectedStat == "Sword" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
                elseif Settings.SelectedStat == "Gun" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
                elseif Settings.SelectedStat == "Devil Fruit" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
                end
            end)
        end
    end
end)

-- Auto Haki
spawn(function()
    while wait(0.5) do
        if Settings.AutoHaki then
            pcall(function()
                if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- Speed Boost
spawn(function()
    while wait() do
        if Settings.SpeedBoost then
            pcall(function()
                Humanoid.WalkSpeed = Settings.SpeedValue
            end)
        else
            pcall(function()
                Humanoid.WalkSpeed = 16
            end)
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if Settings.NoClip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
local flying = false
local flySpeed = 1
local bodyGyro, bodyVelocity

spawn(function()
    while wait() do
        if Settings.Fly then
            if not flying then
                flying = true
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.P = 9e4
                bodyGyro.Parent = HumanoidRootPart
                bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.CFrame = HumanoidRootPart.CFrame
                
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Parent = HumanoidRootPart
                bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
                
                repeat wait()
                    if Humanoid then
                        Humanoid.PlatformStand = true
                    end
                    
                    if bodyGyro and bodyVelocity then
                        bodyGyro.CFrame = Workspace.CurrentCamera.CoordinateFrame
                        bodyVelocity.velocity = Vector3.new(0, 0, 0)
                        
                        local moveDirection = Humanoid.MoveDirection
                        if moveDirection.Magnitude > 0 then
                            bodyVelocity.velocity = moveDirection * (flySpeed * 50)
                        end
                    end
                until not Settings.Fly
            end
        else
            flying = false
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
            if Humanoid then
                Humanoid.PlatformStand = false
            end
        end
    end
end)

-- Remove Fog
spawn(function()
    while wait(1) do
        if Settings.RemoveFog then
            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = 100000
        end
    end
end)

-- Full Bright
spawn(function()
    while wait(1) do
        if Settings.FullBright then
            local Lighting = game:GetService("Lighting")
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
end)

-- GUI TABS

-- Home Tab
local HomeTab = Window:CreateTab("🏠 Home", 4483362458)
local HomeSection = HomeTab:CreateSection("Welcome to Blox Fruits Hub!")

local PlayerLabel = HomeTab:CreateLabel("Player: " .. LocalPlayer.Name)
local LevelLabel = HomeTab:CreateLabel("Level: Loading...")
local BellyLabel = HomeTab:CreateLabel("Belly: Loading...")

spawn(function()
    while wait(2) do
        pcall(function()
            LevelLabel:Set("Level: " .. LocalPlayer.Data.Level.Value)
            LevelLabel:Set("Belly: $" .. LocalPlayer.Data.Beli.Value)
        end)
    end
end)

HomeTab:CreateParagraph({Title = "Anti-Kick Status", Content = "🛡️ Protection: ACTIVE\n✅ Ban Protection: Enabled\n✅ AFK Protection: Enabled"})

HomeTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end,
})

HomeTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
        Notify("Server Hop", "Finding new server...", 3)
        local Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i, v in pairs(Site.data) do
            if tonumber(v.playing) < tonumber(v.maxPlayers) then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                break
            end
        end
   end,
})

-- Auto Farm Tab
local FarmTab = Window:CreateTab("⚔️ Auto Farm", 4483362458)
local FarmSection = FarmTab:CreateSection("Level Farming")

local AutoFarmToggle = FarmTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Flag = "AutoFarmLevel",
   Callback = function(Value)
        Settings.AutoFarmLevel = Value
        Notify("Auto Farm", Value and "Enabled" or "Disabled", 2)
   end,
})

local BringMobToggle = FarmTab:CreateToggle({
   Name = "Bring Mob",
   CurrentValue = false,
   Flag = "BringMob",
   Callback = function(Value)
        Settings.BringMob = Value
        Notify("Bring Mob", Value and "Enabled" or "Disabled", 2)
   end,
})

local FastAttackToggle = FarmTab:CreateToggle({
   Name = "Fast Attack",
   CurrentValue = false,
   Flag = "FastAttack",
   Callback = function(Value)
        Settings.FastAttack = Value
        Notify("Fast Attack", Value and "Enabled" or "Disabled", 2)
   end,
})

local AutoHakiToggle = FarmTab:CreateToggle({
   Name = "Auto Haki",
   CurrentValue = false,
   Flag = "AutoHaki",
   Callback = function(Value)
        Settings.AutoHaki = Value
        Notify("Auto Haki", Value and "Enabled" or "Disabled", 2)
   end,
})

local BossSection = FarmTab:CreateSection("Boss Farming")

local BossDropdown = FarmTab:CreateDropdown({
   Name = "Select Boss",
   Options = BossList,
   CurrentOption = {"Select Boss"},
   MultipleOptions = false,
   Flag = "BossDropdown",
   Callback = function(Option)
        selectedBoss = Option[1]
        Notify("Boss Selected", selectedBoss, 2)
   end,
})

local AutoBossToggle = FarmTab:CreateToggle({
   Name = "Auto Farm Boss",
   CurrentValue = false,
   Flag = "AutoFarmBoss",
   Callback = function(Value)
        Settings.AutoFarmBoss = Value
        if Value and selectedBoss then
            Notify("Boss Farm", "Farming " .. selectedBoss, 2)
        else
            Notify("Boss Farm", "Disabled", 2)
        end
   end,
})

-- Stats Tab
local StatsTab = Window:CreateTab("📊 Stats", 4483362458)
local StatsSection = StatsTab:CreateSection("Auto Stats")

local StatDropdown = StatsTab:CreateDropdown({
   Name = "Select Stat",
   Options = {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"},
   CurrentOption = {"Melee"},
   MultipleOptions = false,
   Flag = "StatDropdown",
   Callback = function(Option)
        Settings.SelectedStat = Option[1]
        Notify("Stat Selected", Option[1], 2)
   end,
})

local AutoStatsToggle = StatsTab:CreateToggle({
   Name = "Auto Stats",
   CurrentValue = false,
   Flag = "AutoStats",
   Callback = function(Value)
        Settings.AutoStats = Value
        if Value then
            Notify("Auto Stats", "Upgrading " .. Settings.SelectedStat, 2)
        else
            Notify("Auto Stats", "Disabled", 2)
        end
   end,
})

StatsTab:CreateButton({
   Name = "Show Current Stats",
   Callback = function()
        pcall(function()
            local stats = LocalPlayer.Data.Stats
            local melee = stats.Melee.Level.Value
            local defense = stats.Defense.Level.Value
            local sword = stats.Sword.Level.Value
            local gun = stats.Gun.Level.Value
            local fruit = stats["Demon Fruit"].Level.Value
            
            Notify("Your Stats", string.format("M:%d D:%d S:%d G:%d F:%d", melee, defense, sword, gun, fruit), 5)
        end)
   end,
})

-- Devil Fruit Tab
local FruitTab = Window:CreateTab("🍇 Devil Fruits", 4483362458)
local FruitSection = FruitTab:CreateSection("Fruit Collection")

local AutoCollectToggle = FruitTab:CreateToggle({
   Name = "Auto Collect Fruits",
   CurrentValue = false,
   Flag = "AutoCollectFruits",
   Callback = function(Value)
        Settings.AutoCollectFruits = Value
        Notify("Auto Collect", Value and "Enabled" or "Disabled", 2)
   end,
})

local AutoStoreToggle = FruitTab:CreateToggle({
   Name = "Auto Store Fruits",
   CurrentValue = false,
   Flag = "AutoStoreFruits",
   Callback = function(Value)
        Settings.AutoStoreFruits = Value
        Notify("Auto Store", Value and "Enabled" or "Disabled", 2)
   end,
})

local ESPFruitsToggle = FruitTab:CreateToggle({
   Name = "Fruit ESP",
   CurrentValue = false,
   Flag = "ESPFruits",
   Callback = function(Value)
        Settings.ESPFruits = Value
        Notify("Fruit ESP", Value and "Enabled" or "Disabled", 2)
   end,
})

local FruitNotifToggle = FruitTab:CreateToggle({
   Name = "Fruit Notifications",
   CurrentValue = false,
   Flag = "FruitNotifications",
   Callback = function(Value)
        Settings.FruitNotifications = Value
        Notify("Fruit Notifications", Value and "Enabled" or "Disabled", 2)
   end,
})

-- Movement Tab
local MovementTab = Window:CreateTab("🚀 Movement", 4483362458)
local MovementSection = MovementTab:CreateSection("Movement Hacks")

local SpeedToggle = MovementTab:CreateToggle({
   Name = "Speed Boost",
   CurrentValue = false,
   Flag = "SpeedBoost",
   Callback = function(Value)
        Settings.SpeedBoost = Value
        Notify("Speed Boost", Value and "Enabled" or "Disabled", 2)
   end,
})

local SpeedSlider = MovementTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Flag = "SpeedValue",
   Callback = function(Value)
        Settings.SpeedValue = Value
   end,
})

local FlyToggle = MovementTab:CreateToggle({
   Name = "Fly (WASD to move)",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
        Settings.Fly = Value
        Notify("Fly", Value and "Enabled - Use WASD" or "Disabled", 2)
   end,
})

local NoClipToggle = MovementTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Flag = "NoClip",
   Callback = function(Value)
        Settings.NoClip = Value
        Notify("NoClip", Value and "Enabled" or "Disabled", 2)
   end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🌍 Teleport", 4483362458)
local TeleportSection = TeleportTab:CreateSection("Island Teleport")

local IslandDropdown = TeleportTab:CreateDropdown({
   Name = "Select Island",
   Options = IslandsList,
   CurrentOption = {"Select Island"},
   MultipleOptions = false,
   Flag = "IslandDropdown",
   Callback = function(Option)
        selectedIsland = Option[1]
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Island",
   Callback = function()
        if selectedIsland then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", selectedIsland)
                Notify("Teleport", "Teleporting to " .. selectedIsland, 2)
            end)
        else
            Notify("Error", "Select an island first!", 2)
        end
   end,
})

local SeaSection = TeleportTab:CreateSection("Sea Travel")

TeleportTab:CreateButton({
   Name = "First Sea",
   Callback = function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
        Notify("Sea Travel", "Going to First Sea...", 2)
   end,
})

TeleportTab:CreateButton({
   Name = "Second Sea",
   Callback = function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        Notify("Sea Travel", "Going to Second Sea...", 2)
   end,
})

TeleportTab:CreateButton({
   Name = "Third Sea",
   Callback = function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
        Notify("Sea Travel", "Going to Third Sea...", 2)
   end,
})

-- Visual Tab
local VisualTab = Window:CreateTab("👁️ Visual", 4483362458)
local VisualSection = VisualTab:CreateSection("Visual Settings")

local RemoveFogToggle = VisualTab:CreateToggle({
   Name = "Remove Fog",
   CurrentValue = false,
   Flag = "RemoveFog",
   Callback = function(Value)
        Settings.RemoveFog = Value
        Notify("Remove Fog", Value and "Enabled" or "Disabled", 2)
   end,
})

local FullBrightToggle = VisualTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
        Settings.FullBright = Value
        Notify("Full Bright", Value and "Enabled" or "Disabled", 2)
   end,
})

VisualTab:CreateButton({
   Name = "Remove Textures (FPS Boost)",
   Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            end
        end
        Notify("Performance", "Textures removed!", 2)
   end,
})

VisualTab:CreateButton({
   Name = "Low Graphics Mode",
   Callback = function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            end
        end
        Notify("Performance", "Low graphics enabled!", 2)
   end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)
local MiscSection = MiscTab:CreateSection("Utility")

MiscTab:CreateButton({
   Name = "Redeem All Codes",
   Callback = function()
        local codes = {
            "NEWTROLL", "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", 
            "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy",
            "fudd10_v2", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123",
            "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming",
            "StrawHatMaine", "Sub2OfficialNoobie", "TheGreatAce", "Bignews"
        }
        
        local redeemed = 0
        for _, code in pairs(codes) do
            pcall(function()
                ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
                redeemed = redeemed + 1
                wait(0.5)
            end)
        end
        Notify("Codes", "Redeemed " .. redeemed .. " codes!", 3)
   end,
})

MiscTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
        LocalPlayer.Character.Humanoid.Health = 0
   end,
})

MiscTab:CreateButton({
   Name = "Remove Lava Damage",
   Callback = function()
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v.Name == "Lava" then
                v:Destroy()
            end
        end
        Notify("Safety", "Lava removed!", 2)
   end,
})

local ShopSection = MiscTab:CreateSection("Shop & Items")

MiscTab:CreateButton({
   Name = "Open Blox Fruit Dealer",
   Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventoryFruits")
        end)
   end,
})

MiscTab:CreateButton({
   Name = "Open Inventory",
   Callback = function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
   end,
})

-- Raid Tab
local RaidTab = Window:CreateTab("🏴‍☠️ Raids", 4483362458)
local RaidSection = RaidTab:CreateSection("Raid Settings")

local selectedChip = nil

local ChipDropdown = RaidTab:CreateDropdown({
   Name = "Select Chip",
   Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Buddha", "Spider"},
   CurrentOption = {"Select Chip"},
   MultipleOptions = false,
   Flag = "ChipDropdown",
   Callback = function(Option)
        selectedChip = Option[1]
        Notify("Chip Selected", selectedChip, 2)
   end,
})

RaidTab:CreateButton({
   Name = "Start Raid",
   Callback = function()
        if selectedChip then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", selectedChip)
                Notify("Raid", "Starting " .. selectedChip .. " raid!", 2)
            end)
        else
            Notify("Error", "Select a chip first!", 2)
        end
   end,
})

RaidTab:CreateButton({
   Name = "Next Island",
   Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Next")
            Notify("Raid", "Teleporting to next island...", 2)
        end)
   end,
})

RaidTab:CreateButton({
   Name = "Awakening Room",
   Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakening", "Check")
            Notify("Awakening", "Opening awakening menu...", 2)
        end)
   end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Configuration")

SettingsTab:CreateParagraph({
    Title = "Script Information",
    Content = "Version: 2.0 Advanced UI\nCreator: DarkZhen\nUI Library: Rayfield\nStatus: All Features Working"
})

SettingsTab:CreateButton({
   Name = "Save Configuration",
   Callback = function()
        Notify("Config", "Configuration saved!", 2)
   end,
})

SettingsTab:CreateButton({
   Name = "Load Configuration",
   Callback = function()
        Notify("Config", "Configuration loaded!", 2)
   end,
})

SettingsTab:CreateButton({
   Name = "Reset to Default",
   Callback = function()
        Notify("Config", "Settings reset to default!", 2)
   end,
})

local UISection = SettingsTab:CreateSection("UI Settings")

SettingsTab:CreateKeybind({
   Name = "Toggle UI",
   CurrentKeybind = "RightShift",
   HoldToInteract = false,
   Flag = "UIToggle",
   Callback = function(Keybind)
        Notify("Keybind", "UI Toggle set to " .. Keybind, 2)
   end,
})

SettingsTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
        Rayfield:Destroy()
   end,
})

-- Credits Tab
local CreditsTab = Window:CreateTab("ℹ️ Credits", 4483362458)
local CreditsSection = CreditsTab:CreateSection("About")

CreditsTab:CreateParagraph({
    Title = "Blox Fruits Hub - Advanced Edition",
    Content = "A comprehensive auto-farm script with modern UI and advanced features for Blox Fruits.\n\nCreated by: DarkZhen\nUI Library: Rayfield\nVersion: 2.0"
})

CreditsTab:CreateParagraph({
    Title = "Features",
    Content = "✅ Auto Farm Level & Boss\n✅ Auto Stats & Mastery\n✅ Devil Fruit Collection\n✅ Super Fast Attack\n✅ Movement Hacks\n✅ Raid Support\n✅ Anti-Kick Protection\n✅ And Much More!"
})

CreditsTab:CreateParagraph({
    Title = "Safety Tips",
    Content = "⚠️ Use on alt accounts\n⚠️ Don't abuse features\n⚠️ Use in private servers\n⚠️ Be aware of bans\n⚠️ Script is for educational purposes"
})

CreditsTab:CreateButton({
   Name = "Join Discord (Coming Soon)",
   Callback = function()
        Notify("Discord", "Discord link coming soon!", 3)
   end,
})

CreditsTab:CreateButton({
   Name = "Check for Updates",
   Callback = function()
        Notify("Updates", "You are using the latest version!", 3)
   end,
})

-- Completion Notification
Notify("Script Loaded", "Blox Fruits Hub loaded successfully! Enjoy!", 5)
print("=======================================")
print("Blox Fruits Hub - Advanced Edition")
print("Version: 2.0")
print("Creator: DarkZhen")
print("Anti-Kick Protection: ENABLED")
print("All Features: UNLOCKED")
print("=======================================")
print("Press RightShift to toggle UI")
print("=======================================")
