-- Blox Fruits Hub - Solara Executor Compatible
-- No External Dependencies - Works on All Executors

repeat wait() until game:IsLoaded()
wait(1)

-- Anti-Kick Protection (Solara Compatible)
pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

-- Anti-AFK
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    v:Disable()
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
    AutoFarmLevel = false,
    AutoFarmBoss = false,
    FastAttack = false,
    BringMob = false,
    AutoHaki = false,
    AutoStats = false,
    SelectedStat = "Melee",
    AutoCollectFruits = false,
    AutoStoreFruits = false,
    ESPFruits = false,
    SpeedBoost = false,
    SpeedValue = 16,
    NoClip = false,
    InfiniteJump = false,
    RemoveFog = false,
    AntiAFK = true
}

local SelectedBoss = nil
local SelectedIsland = nil

-- Notification Function
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

-- Utility Functions
local function GetDistance(pos)
    return (HumanoidRootPart.Position - pos).Magnitude
end

local function Tween(cframe)
    local distance = GetDistance(cframe.Position)
    local speed = 300
    local time = distance / speed
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = cframe}
    )
    
    tween:Play()
    return tween
end

local function GetNearestMob()
    local nearestMob = nil
    local nearestDistance = math.huge
    
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            local distance = GetDistance(mob.HumanoidRootPart.Position)
            if distance < nearestDistance then
                nearestDistance = distance
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

local function Attack()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
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
    "rip_indra",
    "Dough King",
    "Soul Reaper"
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
    "Hydra Island",
    "Haunted Castle",
    "Sea Castle",
    "Tiki Outpost"
}

-- Auto Farm Level
spawn(function()
    while wait(0.1) do
        if _G.Settings.AutoFarmLevel then
            pcall(function()
                local mob = GetNearestMob()
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    repeat wait(0.1)
                        if not _G.Settings.AutoFarmLevel then break end
                        if not mob or not mob.Parent or mob.Humanoid.Health <= 0 then break end
                        
                        EquipTool()
                        
                        if _G.Settings.BringMob then
                            mob.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
                            mob.HumanoidRootPart.CanCollide = false
                            mob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            mob.Humanoid.WalkSpeed = 0
                        else
                            HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 3)
                        end
                        
                        Attack()
                        
                    until not mob or mob.Humanoid.Health <= 0 or not _G.Settings.AutoFarmLevel
                    
                    wait(0.5)
                end
            end)
        end
    end
end)

-- Auto Farm Boss
spawn(function()
    while wait(0.5) do
        if _G.Settings.AutoFarmBoss and SelectedBoss then
            pcall(function()
                local boss = GetBoss(SelectedBoss)
                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    repeat wait(0.1)
                        if not _G.Settings.AutoFarmBoss then break end
                        if not boss or not boss.Parent or boss.Humanoid.Health <= 0 then break end
                        
                        EquipTool()
                        HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 25, 5)
                        Attack()
                        
                    until not boss or boss.Humanoid.Health <= 0 or not _G.Settings.AutoFarmBoss
                    
                    Notify("Boss Defeated", SelectedBoss .. " defeated!")
                    wait(1)
                end
            end)
        end
    end
end)

-- Fast Attack
spawn(function()
    while wait(0.01) do
        if _G.Settings.FastAttack then
            pcall(function()
                Attack()
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
                    if string.find(fruit.Name, "Fruit") and fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                        HumanoidRootPart.CFrame = fruit.Handle.CFrame
                        wait(0.3)
                    end
                end
            end)
        end
    end
end)

-- Auto Store Fruits
spawn(function()
    while wait(0.5) do
        if _G.Settings.AutoStoreFruits then
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

-- Speed Boost
spawn(function()
    while wait() do
        if _G.Settings.SpeedBoost then
            pcall(function()
                Humanoid.WalkSpeed = _G.Settings.SpeedValue
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
    if _G.Settings.NoClip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.Settings.InfiniteJump then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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

-- Create UI (Solara Compatible)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Check if already exists
if game.CoreGui:FindFirstChild("BloxFruitsHub") then
    game.CoreGui:FindFirstChild("BloxFruitsHub"):Destroy()
end

ScreenGui.Parent = game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍇 Blox Fruits Hub | Solara"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeButton

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 500, 0, 40), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 500, 0, 600), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "-"
    end
end)

-- Content Container
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentFrame

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
end)

-- UI Creation Functions
local function CreateSection(name)
    local Section = Instance.new("TextLabel")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Section.BorderSizePixel = 0
    Section.Text = "=== " .. name .. " ==="
    Section.TextColor3 = Color3.fromRGB(100, 200, 255)
    Section.TextSize = 16
    Section.Font = Enum.Font.GothamBold
    Section.Parent = ContentFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    return Section
end

local function CreateToggle(name, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = ContentFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 60, 0, 30)
    Button.Position = UDim2.new(1, -70, 0.5, -15)
    Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Button.Text = "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Toggle
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            Button.Text = "ON"
        else
            Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            Button.Text = "OFF"
        end
        callback(enabled)
    end)
    
    return Toggle
end

local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ContentFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

local function CreateDropdown(name, options, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(1, 0, 0, 40)
    Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Dropdown.BorderSizePixel = 0
    Dropdown.Parent = ContentFrame
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = Dropdown
    
    local DropButton = Instance.new("TextButton")
    DropButton.Size = UDim2.new(1, -10, 1, -10)
    DropButton.Position = UDim2.new(0, 5, 0, 5)
    DropButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropButton.Text = name .. ": " .. options[1]
    DropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropButton.TextSize = 14
    DropButton.Font = Enum.Font.Gotham
    DropButton.Parent = Dropdown
    
    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 6)
    DropCorner.Parent = DropButton
    
    local currentIndex = 1
    DropButton.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then
            currentIndex = 1
        end
        DropButton.Text = name .. ": " .. options[currentIndex]
        callback(options[currentIndex])
    end)
    
    return Dropdown
end

-- Create UI Elements
CreateSection("HOME")
CreateButton("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton("Server Hop", function()
    local success, servers = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
    end)
    
    if success then
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
end)

CreateSection("AUTO FARM")
CreateToggle("Auto Farm Level", function(v)
    _G.Settings.AutoFarmLevel = v
    Notify("Auto Farm", v and "Enabled" or "Disabled")
end)

CreateToggle("Bring Mob", function(v)
    _G.Settings.BringMob = v
end)

CreateToggle("Fast Attack", function(v)
    _G.Settings.FastAttack = v
end)

CreateToggle("Auto Haki", function(v)
    _G.Settings.AutoHaki = v
end)

CreateDropdown("Select Boss", BossList, function(boss)
    SelectedBoss = boss
    Notify("Boss Selected", boss)
end)

CreateToggle("Auto Farm Boss", function(v)
    _G.Settings.AutoFarmBoss = v
end)

CreateSection("STATS")
CreateDropdown("Select Stat", {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"}, function(stat)
    _G.Settings.SelectedStat = stat
    Notify("Stat Selected", stat)
end)

CreateToggle("Auto Stats", function(v)
    _G.Settings.AutoStats = v
end)

CreateSection("DEVIL FRUITS")
CreateToggle("Auto Collect Fruits", function(v)
    _G.Settings.AutoCollectFruits = v
end)

CreateToggle("Auto Store Fruits", function(v)
    _G.Settings.AutoStoreFruits = v
end)

CreateToggle("Fruit ESP", function(v)
    _G.Settings.ESPFruits = v
end)

CreateSection("MOVEMENT")
CreateToggle("Speed Boost (100)", function(v)
    _G.Settings.SpeedBoost = v
    if v then
        _G.Settings.SpeedValue = 100
    else
        _G.Settings.SpeedValue = 16
    end
end)

CreateToggle("NoClip", function(v)
    _G.Settings.NoClip = v
end)

CreateToggle("Infinite Jump", function(v)
    _G.Settings.InfiniteJump = v
end)

CreateSection("TELEPORT")
CreateDropdown("Select Island", IslandsList, function(island)
    SelectedIsland = island
end)

CreateButton("Teleport to Island", function()
    if SelectedIsland then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", SelectedIsland)
            Notify("Teleport", "Going to " .. SelectedIsland)
        end)
    end
end)

CreateButton("Second Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
end)

CreateButton("Third Sea", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
end)

CreateSection("MISC")
CreateToggle("Remove Fog", function(v)
    _G.Settings.RemoveFog = v
end)

CreateButton("Low Graphics", function()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    settings().Rendering.QualityLevel = 1
    Notify("Performance", "Low graphics enabled!")
end)

CreateButton("Redeem All Codes", function()
    local codes = {"NEWTROLL", "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK"}
    for _, code in pairs(codes) do
        pcall(function()
            ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
            wait(0.5)
        end)
    end
    Notify("Codes", "All codes redeemed!")
end)

Notify("Script Loaded", "Blox Fruits Hub loaded! ✅")
print("=== Blox Fruits Hub - Solara Edition ===")
print("Status: Loaded Successfully")
print("Anti-Kick: Active")
print("Executor: Solara Compatible")
