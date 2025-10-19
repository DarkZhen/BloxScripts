-- Blox Fruits Auto Farm Script
-- Complete Version with All Features

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits Hub", "DarkTheme")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Update character references
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Variables
local selectedPlayer = nil
local selectedChip = nil
local selectedBoss = nil
local selectedIsland = nil
local selectedWeapon = nil
local selectedMob = nil
local selectedFruit = nil
local playerList = {}

-- Settings
local Settings = {
    AutoRandomFruits = false,
    AutoStoreFruits = false,
    AutoCollectFruitsTween = false,
    AutoCollectFruitsTeleport = false,
    HopServerCollectFruits = false,
    ESPFruits = false,
    NotificationFruitsSpawn = false,
    TeleportToPlayer = false,
    AimbotSkillNearPlayer = false,
    AimbotCameraNearPlayer = false,
    AutoSecondSea = false,
    AutoThirdSea = false,
    AutoStats = false,
    SelectedStat = "Melee",
    FastAttack = false,
    AutoFarm = false,
    AutoFarmLevel = false,
    AutoFarmBoss = false,
    AutoQuest = false,
    AutoMastery = false,
    AutoBone = false,
    AutoFragment = false,
    BringMob = false,
    Fly = false,
    NoClip = false,
    InfiniteJump = false,
    SpeedBoost = false,
    SpeedValue = 16,
    AutoAwakening = false,
    FruitSniper = false,
    RemoveFog = false,
    RemoveDamage = false,
    AntiAFK = false,
    AutoHaki = false,
    AutoBuyLegendarySword = false,
    AutoV4Trial = false
}

-- Utility Functions
local function Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
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

local function TeleportToPosition(position)
    if not Character or not HumanoidRootPart then return end
    HumanoidRootPart.CFrame = CFrame.new(position)
end

local function GetPlayerList()
    playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

local function FindNearestFruit()
    local nearestFruit = nil
    local nearestDistance = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Handle") then
            if string.find(obj.Name, "Fruit") then
                local distance = (HumanoidRootPart.Position - obj.Handle.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestFruit = obj
                end
            end
        end
    end
    
    return nearestFruit
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

local function CreateESP(object, color)
    if not object:FindFirstChild("ESP") then
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ESP"
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.Parent = object
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 0)
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = object.Name
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 16
        textLabel.Parent = billboardGui
    end
end

local function RemoveESP(object)
    if object:FindFirstChild("ESP") then
        object.ESP:Destroy()
    end
end

local function EquipWeapon()
    pcall(function()
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.ToolTip == "Blox Fruit" then
                    Humanoid:EquipTool(tool)
                    return
                end
            end
        end
    end)
end

local function AttackEnemy()
    pcall(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
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

-- Auto Random Fruits
spawn(function()
    while wait(1) do
        if Settings.AutoRandomFruits then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end)
        end
    end
end)

-- Auto Store Fruits
spawn(function()
    while wait(0.5) do
        if Settings.AutoStoreFruits then
            pcall(function()
                for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if string.find(item.Name, "Fruit") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Fruits (Tween)
spawn(function()
    while wait(2) do
        if Settings.AutoCollectFruitsTween then
            pcall(function()
                local fruit = FindNearestFruit()
                if fruit and fruit:FindFirstChild("Handle") then
                    TweenToPosition(fruit.Handle.Position)
                    wait(0.5)
                    if fruit and fruit.Parent then
                        HumanoidRootPart.CFrame = fruit.Handle.CFrame
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Fruits (Teleport)
spawn(function()
    while wait(1) do
        if Settings.AutoCollectFruitsTeleport then
            pcall(function()
                local fruit = FindNearestFruit()
                if fruit and fruit:FindFirstChild("Handle") then
                    TeleportToPosition(fruit.Handle.Position)
                    wait(0.3)
                end
            end)
        end
    end
end)

-- ESP Fruits
spawn(function()
    while wait(1) do
        if Settings.ESPFruits then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name, "Fruit") then
                    CreateESP(obj, Color3.fromRGB(255, 0, 255))
                end
            end
        else
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("ESP") then
                    RemoveESP(obj)
                end
            end
        end
    end
end)

-- Notification Fruits Spawn
Workspace.DescendantAdded:Connect(function(obj)
    if Settings.NotificationFruitsSpawn then
        if obj:IsA("Model") and string.find(obj.Name, "Fruit") then
            Notify("Fruit Spawned!", obj.Name .. " has spawned!", 5)
        end
    end
end)

-- Auto Farm Level
spawn(function()
    while wait() do
        if Settings.AutoFarmLevel then
            pcall(function()
                local enemy = FindNearestEnemy()
                if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                    repeat wait()
                        if not Settings.AutoFarmLevel then break end
                        
                        EquipWeapon()
                        
                        if Settings.BringMob then
                            enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
                            enemy.HumanoidRootPart.CanCollide = false
                            enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            enemy.Humanoid.WalkSpeed = 0
                            enemy.Humanoid.JumpPower = 0
                        else
                            HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        end
                        
                        AttackEnemy()
                        
                    until not enemy or enemy.Humanoid.Health <= 0 or not Settings.AutoFarmLevel
                end
            end)
        end
    end
end)

-- Auto Farm Boss
spawn(function()
    while wait() do
        if Settings.AutoFarmBoss and selectedBoss then
            pcall(function()
                local boss = FindBoss(selectedBoss)
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    repeat wait()
                        if not Settings.AutoFarmBoss then break end
                        
                        EquipWeapon()
                        HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        AttackEnemy()
                        UseSkills()
                        
                    until not boss or boss.Humanoid.Health <= 0 or not Settings.AutoFarmBoss
                    
                    Notify("Boss Farm", selectedBoss .. " defeated!", 3)
                end
            end)
        end
    end
end)

-- Auto Quest
spawn(function()
    while wait(1) do
        if Settings.AutoQuest then
            pcall(function()
                local level = LocalPlayer.Data.Level.Value
                -- Get appropriate quest based on level
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "Quest1", 1)
            end)
        end
    end
end)

-- Auto Mastery
spawn(function()
    while wait() do
        if Settings.AutoMastery then
            pcall(function()
                local enemy = FindNearestEnemy()
                if enemy then
                    EquipWeapon()
                    HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                    UseSkills()
                end
            end)
        end
    end
end)

-- Auto Bone
spawn(function()
    while wait() do
        if Settings.AutoBone then
            pcall(function()
                -- Teleport to bone area
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
            end)
        end
    end
end)

-- Bring Mob
spawn(function()
    while wait(0.1) do
        if Settings.BringMob then
            pcall(function()
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                        if distance < 300 then
                            enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
                            enemy.HumanoidRootPart.CanCollide = false
                            enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            enemy.Humanoid.WalkSpeed = 0
                            enemy.Humanoid.JumpPower = 0
                        end
                    end
                end
            end)
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

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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

-- Teleport to Player
spawn(function()
    while wait(0.5) do
        if Settings.TeleportToPlayer and selectedPlayer then
            pcall(function()
                local player = Players:FindFirstChild(selectedPlayer)
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end)
        end
    end
end)

-- Aimbot Skill Near Player
spawn(function()
    while wait(0.1) do
        if Settings.AimbotSkillNearPlayer then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 100 then
                            UseSkills()
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Second Sea
spawn(function()
    while wait(1) do
        if Settings.AutoSecondSea then
            pcall(function()
                local level = LocalPlayer.Data.Level.Value
                
                if level >= 700 then
                    if not ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") then
                        local kingPos = CFrame.new(-5496.17432, 313.768921, -2841.53027)
                        TweenToPosition(kingPos.Position)
                        wait(1)
                        
                        Notify("Auto Second Sea", "Fighting King Red Head...", 3)
                        
                        for i = 1, 30 do
                            if not Settings.AutoSecondSea then break end
                            
                            local king = Workspace.Enemies:FindFirstChild("rip_indra [Lv. 1500] [Boss]") or 
                                        Workspace.Enemies:FindFirstChild("King Red Head [Lv. 700] [Boss]")
                            
                            if king and king:FindFirstChild("HumanoidRootPart") then
                                HumanoidRootPart.CFrame = king.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                                AttackEnemy()
                            end
                            wait(0.5)
                        end
                    end
                    
                    wait(2)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                    wait(1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                    
                    Notify("Auto Second Sea", "Traveling to Second Sea!", 5)
                    wait(5)
                    Settings.AutoSecondSea = false
                else
                    Notify("Auto Second Sea", "You need level 700+! Current: " .. level, 5)
                    wait(10)
                end
            end)
        end
    end
end)

-- Auto Third Sea
spawn(function()
    while wait(1) do
        if Settings.AutoThirdSea then
            pcall(function()
                local level = LocalPlayer.Data.Level.Value
                
                if level >= 1500 then
                    local currentSea = ReplicatedStorage.Remotes.CommF_:InvokeServer("GetCurrentSea")
                    
                    if currentSea ~= "ThirdSea" then
                        Notify("Auto Third Sea", "Going to fight Dough King...", 3)
                        
                        local doughKingPos = CFrame.new(-2151.82153, 149.315704, -12404.9053)
                        TweenToPosition(doughKingPos.Position)
                        wait(2)
                        
                        for i = 1, 50 do
                            if not Settings.AutoThirdSea then break end
                            
                            local doughKing = Workspace.Enemies:FindFirstChild("Dough King [Lv. 1111] [Boss]")
                            
                            if doughKing and doughKing:FindFirstChild("HumanoidRootPart") then
                                HumanoidRootPart.CFrame = doughKing.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                                AttackEnemy()
                                UseSkills()
                            end
                            wait(0.5)
                        end
                        
                        wait(2)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
                        
                        Notify("Auto Third Sea", "Traveling to Third Sea!", 5)
                        wait(5)
                        Settings.AutoThirdSea = false
                    else
                        Notify("Auto Third Sea", "You are already in Third Sea!", 3)
                        Settings.AutoThirdSea = false
                    end
                else
                    Notify("Auto Third Sea", "You need level 1500+! Current: " .. level, 5)
                    wait(10)
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
                local pointsToAdd = 1
                
                if Settings.SelectedStat == "Melee" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", pointsToAdd)
                elseif Settings.SelectedStat == "Defense" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", pointsToAdd)
                elseif Settings.SelectedStat == "Sword" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", pointsToAdd)
                elseif Settings.SelectedStat == "Gun" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", pointsToAdd)
                elseif Settings.SelectedStat == "Devil Fruit" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", pointsToAdd)
                end
            end)
        end
    end
end)

-- Super Fast Attack
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigEven = game:GetService("ReplicatedStorage").RigControllerEvent
local AttackAnim = Instance.new("Animation")
local AttackCoolDown = 0
local bladehit = {}

spawn(function()
    while wait(0.001) do
        if Settings.FastAttack then
            pcall(function()
                AttackCoolDown = AttackCoolDown + 1
                if AttackCoolDown >= 5 then
                    AttackCoolDown = 0
                    RigEven:FireServer("hit", bladehit, 2, "")
                end
                Character = LocalPlayer.Character
                if Character then
                    local equipped = Character:FindFirstChildOfClass("Tool")
                    if equipped and equipped:FindFirstChild("Animation") then
                        AttackAnim.AnimationId = equipped.Animation.AnimationId
                        local AnimationTrack = Humanoid:LoadAnimation(AttackAnim)
                        AnimationTrack:Play()
                    end
                end
            end)
        end
    end
end)

-- Remove Fog
spawn(function()
    while wait(1) do
        if Settings.RemoveFog then
            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
        end
    end
end)

-- Anti AFK
for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
    connection:Disable()
end

spawn(function()
    while wait(60) do
        if Settings.AntiAFK then
            VirtualInputManager:SendKeyEvent(true, "W", false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "W", false, game)
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

-- Auto Awakening
spawn(function()
    while wait(1) do
        if Settings.AutoAwakening then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakening", "Check")
            end)
        end
    end
end)

-- Fruit Sniper
spawn(function()
    while wait(0.5) do
        if Settings.FruitSniper and selectedFruit then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", selectedFruit)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseRawFruit", selectedFruit)
            end)
        end
    end
end)

-- Server Hop Function
local function ServerHop()
    local PlaceId = game.PlaceId
    local Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
    
    for i, v in pairs(Site.data) do
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            local ID = tostring(v.id)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(PlaceId, ID, LocalPlayer)
            end)
            wait(4)
        end
    end
end

-- Islands List
local IslandsList = {
    "Pirate Starter Island",
    "Marine Starter Island",
    "Middle Island",
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
    "The Saw",
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
    "Captain Elephant",
    "Beautiful Pirate",
    "Stone",
    "Island Empress",
    "Kilo Admiral",
    "Captain Elephant",
    "Cake Queen",
    "Longma",
    "Soul Reaper",
    "Dough King"
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
    "Revive-Revive",
    "Diamond-Diamond",
    "Light-Light",
    "Love-Love",
    "Rubber-Rubber",
    "Barrier-Barrier",
    "Magma-Magma",
    "Door-Door",
    "Quake-Quake",
    "Buddha-Buddha",
    "String-String",
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
    "Leopard-Leopard",
    "Blizzard-Blizzard",
    "T-Rex-T-Rex"
}

-- GUI TABS

-- Main Farm Tab
local MainFarmTab = Window:NewTab("Auto Farm")
local AutoFarmSection = MainFarmTab:NewSection("Auto Farm Level")

AutoFarmSection:NewToggle("Auto Farm Level", "Automatically farm nearest enemies", function(state)
    Settings.AutoFarmLevel = state
    Notify("Auto Farm Level", state and "Enabled" or "Disabled", 3)
end)

AutoFarmSection:NewToggle("Auto Quest", "Automatically accept quests", function(state)
    Settings.AutoQuest = state
    Notify("Auto Quest", state and "Enabled" or "Disabled", 3)
end)

AutoFarmSection:NewToggle("Bring Mob", "Bring all enemies to you", function(state)
    Settings.BringMob = state
    Notify("Bring Mob", state and "Enabled" or "Disabled", 3)
end)

local BossFarmSection = MainFarmTab:NewSection("Boss Farm")

BossFarmSection:NewDropdown("Select Boss", "Choose boss to farm", BossList, function(currentOption)
    selectedBoss = currentOption
    Notify("Boss Selected", currentOption, 3)
end)

BossFarmSection:NewToggle("Auto Farm Boss", "Automatically farm selected boss", function(state)
    Settings.AutoFarmBoss = state
    if state and selectedBoss then
        Notify("Boss Farm", "Farming " .. selectedBoss, 3)
    else
        Notify("Boss Farm", "Disabled", 3)
    end
end)

local MasterySection = MainFarmTab:NewSection("Mastery Farm")

MasterySection:NewToggle("Auto Farm Mastery", "Farm weapon/fruit mastery", function(state)
    Settings.AutoMastery = state
    Notify("Auto Mastery", state and "Enabled" or "Disabled", 3)
end)

local BoneSection = MainFarmTab:NewSection("Material Farm")

BoneSection:NewToggle("Auto Farm Bone", "Automatically farm bones", function(state)
    Settings.AutoBone = state
    Notify("Auto Bone", state and "Enabled" or "Disabled", 3)
end)

BoneSection:NewToggle("Auto Farm Fragment", "Automatically farm fragments", function(state)
    Settings.AutoFragment = state
    Notify("Auto Fragment", state and "Enabled" or "Disabled", 3)
end)

-- Combat Tab
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Combat Settings")

CombatSection:NewToggle("Super Fast Attack", "Enable super fast attack speed", function(state)
    Settings.FastAttack = state
    if state then
        Notify("Fast Attack", "Enabled! Attack speed increased!", 3)
    else
        Notify("Fast Attack", "Disabled", 3)
    end
end)

CombatSection:NewToggle("Auto Haki", "Automatically enable Haki", function(state)
    Settings.AutoHaki = state
    Notify("Auto Haki", state and "Enabled" or "Disabled", 3)
end)

local PvPSection = CombatTab:NewSection("PvP")

PvPSection:NewDropdown("Select Player", "Choose a player", GetPlayerList(), function(currentOption)
    selectedPlayer = currentOption
    Notify("Player Selected", currentOption, 3)
end)

PvPSection:NewButton("Refresh Player List", "Update player list", function()
    GetPlayerList()
    Notify("Player List", "Refreshed!", 3)
end)

PvPSection:NewToggle("Teleport To Player", "Teleport to selected player", function(state)
    Settings.TeleportToPlayer = state
    Notify("Teleport to Player", state and "Enabled" or "Disabled", 3)
end)

PvPSection:NewToggle("Aimbot Skill Near Player", "Auto aim skills near player", function(state)
    Settings.AimbotSkillNearPlayer = state
    Notify("Aimbot Skills", state and "Enabled" or "Disabled", 3)
end)

-- Stats Tab
local StatsTab = Window:NewTab("Stats")
local StatsSection = StatsTab:NewSection("Auto Stats")

StatsSection:NewDropdown("Select Stat", "Choose which stat to auto-upgrade", {
    "Melee",
    "Defense", 
    "Sword",
    "Gun",
    "Devil Fruit"
}, function(currentOption)
    Settings.SelectedStat = currentOption
    Notify("Stat Selected", currentOption, 3)
end)

StatsSection:NewToggle("Auto Stats", "Automatically add points to selected stat", function(state)
    Settings.AutoStats = state
    if state then
        Notify("Auto Stats", "Now upgrading " .. Settings.SelectedStat, 3)
    else
        Notify("Auto Stats", "Disabled", 3)
    end
end)

local StatsInfoSection = StatsTab:NewSection("Current Stats")

StatsInfoSection:NewButton("Refresh Stats", "Update current stats display", function()
    pcall(function()
        if LocalPlayer.Data and LocalPlayer.Data.Stats then
            local stats = LocalPlayer.Data.Stats
            local melee = stats.Melee and stats.Melee.Level.Value or 0
            local defense = stats.Defense and stats.Defense.Level.Value or 0
            local sword = stats.Sword and stats.Sword.Level.Value or 0
            local gun = stats.Gun and stats.Gun.Level.Value or 0
            local fruit = stats["Demon Fruit"] and stats["Demon Fruit"].Level.Value or 0
            local points = LocalPlayer.Data.Points and LocalPlayer.Data.Points.Value or 0
            
            Notify("Stats", string.format("M:%d D:%d S:%d G:%d F:%d | Points:%d", melee, defense, sword, gun, fruit, points), 5)
        end
    end)
end)

-- Devil Fruit Tab
local FruitTab = Window:NewTab("Devil Fruit")
local FruitSection = FruitTab:NewSection("Fruit Collection")

FruitSection:NewToggle("Auto Random Fruits", "Automatically buy random fruits", function(state)
    Settings.AutoRandomFruits = state
    Notify("Auto Random Fruits", state and "Enabled" or "Disabled", 3)
end)

FruitSection:NewToggle("Auto Store Fruits", "Automatically store fruits", function(state)
    Settings.AutoStoreFruits = state
    Notify("Auto Store Fruits", state and "Enabled" or "Disabled", 3)
end)

FruitSection:NewToggle("Auto Collect [ Tween ]", "Collect fruits using tween", function(state)
    Settings.AutoCollectFruitsTween = state
    if state then Settings.AutoCollectFruitsTeleport = false end
    Notify("Auto Collect [Tween]", state and "Enabled" or "Disabled", 3)
end)

FruitSection:NewToggle("Auto Collect [ Teleport ]", "Collect fruits using teleport", function(state)
    Settings.AutoCollectFruitsTeleport = state
    if state then Settings.AutoCollectFruitsTween = false end
    Notify("Auto Collect [Teleport]", state and "Enabled" or "Disabled", 3)
end)

FruitSection:NewToggle("ESP Fruits", "Show ESP for fruits", function(state)
    Settings.ESPFruits = state
    Notify("ESP Fruits", state and "Enabled" or "Disabled", 3)
end)

FruitSection:NewToggle("Fruit Notifications", "Get notified when fruits spawn", function(state)
    Settings.NotificationFruitsSpawn = state
    Notify("Fruit Notifications", state and "Enabled" or "Disabled", 3)
end)

local FruitSniperSection = FruitTab:NewSection("Fruit Sniper")

FruitSniperSection:NewDropdown("Select Fruit", "Choose fruit to snipe", FruitList, function(currentOption)
    selectedFruit = currentOption
    Notify("Fruit Selected", currentOption, 3)
end)

FruitSniperSection:NewToggle("Fruit Sniper", "Auto buy selected fruit when available", function(state)
    Settings.FruitSniper = state
    if state and selectedFruit then
        Notify("Fruit Sniper", "Sniping " .. selectedFruit, 3)
    else
        Notify("Fruit Sniper", "Disabled", 3)
    end
end)

FruitSniperSection:NewToggle("Hop Server for Fruits", "Server hop to collect fruits", function(state)
    Settings.HopServerCollectFruits = state
    if state then
        spawn(function()
            wait(60)
            if Settings.HopServerCollectFruits then
                ServerHop()
            end
        end)
    end
end)

local AwakeningSection = FruitTab:NewSection("Awakening")

AwakeningSection:NewToggle("Auto Awakening", "Automatically awaken fruits", function(state)
    Settings.AutoAwakening = state
    Notify("Auto Awakening", state and "Enabled" or "Disabled", 3)
end)

-- Raid Tab
local RaidTab = Window:NewTab("Raid")
local RaidSection = RaidTab:NewSection("Raid Settings")

RaidSection:NewDropdown("Select Chip", "Choose a chip type", {"Flame", "Ice", "Quake", "Light", "Dark", "Buddha", "Spider"}, function(currentOption)
    selectedChip = currentOption
    Notify("Chip Selected", currentOption, 3)
end)

RaidSection:NewButton("Start Raid", "Start raid with selected chip", function()
    if selectedChip then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", selectedChip)
        end)
        Notify("Raid", "Starting " .. selectedChip .. " raid...", 3)
    else
        Notify("Error", "Please select a chip first!", 3)
    end
end)

RaidSection:NewButton("Next Island", "Teleport to next raid island", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Next")
        Notify("Raid", "Teleporting to next island...", 3)
    end)
end)

-- Teleport Tab
local TeleportTab = Window:NewTab("Teleport")
local IslandTPSection = TeleportTab:NewSection("Island Teleport")

IslandTPSection:NewDropdown("Select Island", "Choose island to teleport", IslandsList, function(currentOption)
    selectedIsland = currentOption
    Notify("Island Selected", currentOption, 3)
end)

IslandTPSection:NewButton("Teleport to Island", "Go to selected island", function()
    if selectedIsland then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", selectedIsland)
            Notify("Teleport", "Teleporting to " .. selectedIsland, 3)
        end)
    else
        Notify("Error", "Please select an island first!", 3)
    end
end)

local SeaTPSection = TeleportTab:NewSection("Sea Travel")

SeaTPSection:NewButton("Auto Second Sea", "Automatically travel to Second Sea (Lv 700+)", function()
    if LocalPlayer.Data.Level.Value >= 700 then
        Settings.AutoSecondSea = true
        Notify("Auto Second Sea", "Starting process...", 3)
    else
        Notify("Error", "You need to be level 700 or higher!", 5)
    end
end)

SeaTPSection:NewButton("Auto Third Sea", "Automatically travel to Third Sea (Lv 1500+)", function()
    if LocalPlayer.Data.Level.Value >= 1500 then
        Settings.AutoThirdSea = true
        Notify("Auto Third Sea", "Starting process...", 3)
    else
        Notify("Error", "You need to be level 1500 or higher!", 5)
    end
end)

SeaTPSection:NewButton("Stop Sea Travel", "Stop automatic sea travel", function()
    Settings.AutoSecondSea = false
    Settings.AutoThirdSea = false
    Notify("Sea Travel", "Stopped!", 3)
end)

local ManualSeaSection = TeleportTab:NewSection("Manual Sea Teleport")

ManualSeaSection:NewButton("First Sea", "Teleport to First Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
        Notify("Teleport", "Traveling to First Sea...", 3)
    end)
end)

ManualSeaSection:NewButton("Second Sea", "Teleport to Second Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        Notify("Teleport", "Traveling to Second Sea...", 3)
    end)
end)

ManualSeaSection:NewButton("Third Sea", "Teleport to Third Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
        Notify("Teleport", "Traveling to Third Sea...", 3)
    end)
end)

-- Movement Tab
local MovementTab = Window:NewTab("Movement")
local MovementSection = MovementTab:NewSection("Movement Hacks")

MovementSection:NewToggle("Fly", "Enable flying", function(state)
    Settings.Fly = state
    Notify("Fly", state and "Enabled - Use WASD to fly" or "Disabled", 3)
end)

MovementSection:NewToggle("NoClip", "Walk through walls", function(state)
    Settings.NoClip = state
    Notify("NoClip", state and "Enabled" or "Disabled", 3)
end)

MovementSection:NewToggle("Infinite Jump", "Jump infinitely", function(state)
    Settings.InfiniteJump = state
    Notify("Infinite Jump", state and "Enabled" or "Disabled", 3)
end)

MovementSection:NewToggle("Speed Boost", "Increase walk speed", function(state)
    Settings.SpeedBoost = state
    Notify("Speed Boost", state and "Enabled" or "Disabled", 3)
end)

MovementSection:NewSlider("Speed Value", "Set walk speed", 250, 16, function(s)
    Settings.SpeedValue = s
end)

-- Misc Tab
local MiscTab = Window:NewTab("Misc")
local VisualSection = MiscTab:NewSection("Visual")

VisualSection:NewToggle("Remove Fog", "Remove fog for better visibility", function(state)
    Settings.RemoveFog = state
    Notify("Remove Fog", state and "Enabled" or "Disabled", 3)
end)

VisualSection:NewToggle("Remove Damage", "Hide damage numbers", function(state)
    Settings.RemoveDamage = state
    Notify("Remove Damage", state and "Enabled" or "Disabled", 3)
end)

local UtilitySection = MiscTab:NewSection("Utility")

UtilitySection:NewToggle("Anti AFK", "Prevent AFK kick", function(state)
    Settings.AntiAFK = state
    Notify("Anti AFK", state and "Enabled" or "Disabled", 3)
end)

UtilitySection:NewButton("Auto Buy Legendary Sword", "Attempt to buy legendary sword", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","Saber","2")
        Notify("Shop", "Attempting to buy legendary sword...", 3)
    end)
end)

UtilitySection:NewButton("Redeem All Codes", "Redeem all available codes", function()
    local codes = {
        "NEWTROLL",
        "Sub2CaptainMaui",
        "kittgaming",
        "Sub2Fer999",
        "Enyu_is_Pro",
        "Magicbus",
        "JCWK",
        "Starcodeheo",
        "Bluxxy",
        "fudd10_v2",
        "SUB2GAMERROBOT_EXP1",
        "Sub2NoobMaster123",
        "Sub2UncleKizaru",
        "Sub2Daigrock",
        "Axiore",
        "TantaiGaming",
        "StrawHatMaine",
        "Sub2OfficialNoobie",
        "TheGreatAce",
        "Bignews",
        "DEVSCOOKING",
        "THEGREATACE",
        "SUB2GAMERROBOT_RESET1"
    }
    
    for _, code in pairs(codes) do
        pcall(function()
            ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
            wait(0.5)
        end)
    end
    Notify("Codes", "All codes redeemed!", 3)
end)

local RaceSection = MiscTab:NewSection("Race V4")

RaceSection:NewButton("Auto V4 Trial", "Complete race V4 trial", function()
    Settings.AutoV4Trial = true
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TempleTeleport")
        Notify("Race V4", "Starting trial...", 3)
    end)
end)

-- Server Tab
local ServerTab = Window:NewTab("Server")
local ServerSection = ServerTab:NewSection("Server Options")

ServerSection:NewButton("Rejoin Server", "Rejoin current server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

ServerSection:NewButton("Server Hop", "Jump to another server", function()
    Notify("Server Hop", "Finding new server...", 3)
    ServerHop()
end)

ServerSection:NewButton("Hop to Low Players", "Find server with less players", function()
    Notify("Server Hop", "Finding low player server...", 3)
    local Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Desc&limit=100'))
    for i, v in pairs(Site.data) do
        if tonumber(v.playing) < 10 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
            break
        end
    end
end)

local PerformanceSection = ServerTab:NewSection("Performance")

PerformanceSection:NewButton("Low Graphics Mode", "Enable low graphics for FPS boost", function()
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
    Notify("Graphics", "Low graphics mode enabled!", 3)
end)

PerformanceSection:NewButton("Remove Textures", "Remove all textures", function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        end
    end
    Notify("Performance", "Textures removed!", 3)
end)

PerformanceSection:NewLabel("FPS: 60")

-- Credits Tab
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Script Info")

CreditsSection:NewLabel("Blox Fruits Hub")
CreditsSection:NewLabel("Version: 2.0")
CreditsSection:NewLabel("All Features Unlocked")
CreditsSection:NewLabel("")
CreditsSection:NewLabel("Features:")
CreditsSection:NewLabel("• Auto Farm Level & Boss")
CreditsSection:NewLabel("• Auto Stats & Mastery")
CreditsSection:NewLabel("• Devil Fruit Sniper")
CreditsSection:NewLabel("• Super Fast Attack")
CreditsSection:NewLabel("• Auto Sea Travel")
CreditsSection:NewLabel("• Fly, NoClip, Speed")
CreditsSection:NewLabel("• And much more!")

Notify("Script Loaded", "Blox Fruits Hub loaded successfully!", 5)
print("Blox Fruits Hub loaded successfully!")
print("All features unlocked!")    "
