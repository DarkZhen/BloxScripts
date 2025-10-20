-- Blox Fruits Hub - Mobile Optimized for Delta Executor
-- Lightweight version compatible with mobile executors

-- Check if mobile
local isMobile = game:GetService("UserInputService").TouchEnabled

-- Simple UI Library for Mobile
local Library = {}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloxFruitsHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Check if it already exists
    if game.CoreGui:FindFirstChild("BloxFruitsHub") then
        game.CoreGui:FindFirstChild("BloxFruitsHub"):Destroy()
    end
    
    ScreenGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.BorderSizePixel = 0
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Title
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 6
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = TabContainer
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    return {
        Container = TabContainer,
        Frame = MainFrame
    }
end

function Library:CreateToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
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

function Library:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

function Library:CreateLabel(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent
    
    return Label
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

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
    FastAttack = false,
    AutoStats = false,
    SelectedStat = "Melee",
    BringMob = false,
    AutoCollectFruits = false,
    AutoHaki = false,
    SpeedBoost = false,
    NoClip = false
}

-- Utility Functions
local function Notify(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blox Fruits Hub",
        Text = text,
        Duration = 3
    })
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

local function EquipWeapon()
    pcall(function()
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                Humanoid:EquipTool(tool)
                return
            end
        end
    end)
end

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
                        else
                            HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        end
                        
                        local tool = Character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                        
                    until not enemy or enemy.Humanoid.Health <= 0 or not Settings.AutoFarmLevel
                end
            end)
        end
    end
end)

-- Fast Attack
spawn(function()
    while wait() do
        if Settings.FastAttack then
            pcall(function()
                local tool = Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
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
                elseif Settings.SelectedStat == "Fruit" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
                end
            end)
        end
    end
end)

-- Auto Collect Fruits
spawn(function()
    while wait(2) do
        if Settings.AutoCollectFruits then
            pcall(function()
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if string.find(fruit.Name, "Fruit") and fruit:FindFirstChild("Handle") then
                        HumanoidRootPart.CFrame = fruit.Handle.CFrame
                        wait(0.3)
                    end
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
                Humanoid.WalkSpeed = 100
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

-- Anti AFK
for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
    connection:Disable()
end

-- Create UI
wait(1)

local Window = Library:CreateWindow("Blox Fruits Hub - Mobile")
local Container = Window.Container

-- Auto Farm Section
Library:CreateLabel(Container, "=== AUTO FARM ===")
Library:CreateToggle(Container, "Auto Farm Level", function(state)
    Settings.AutoFarmLevel = state
    Notify(state and "Auto Farm: ON" or "Auto Farm: OFF")
end)

Library:CreateToggle(Container, "Bring Mob", function(state)
    Settings.BringMob = state
    Notify(state and "Bring Mob: ON" or "Bring Mob: OFF")
end)

Library:CreateToggle(Container, "Fast Attack", function(state)
    Settings.FastAttack = state
    Notify(state and "Fast Attack: ON" or "Fast Attack: OFF")
end)

Library:CreateToggle(Container, "Auto Haki", function(state)
    Settings.AutoHaki = state
    Notify(state and "Auto Haki: ON" or "Auto Haki: OFF")
end)

-- Stats Section
Library:CreateLabel(Container, "")
Library:CreateLabel(Container, "=== AUTO STATS ===")

Library:CreateButton(Container, "Stat: Melee", function()
    Settings.SelectedStat = "Melee"
    Notify("Selected: Melee")
end)

Library:CreateButton(Container, "Stat: Defense", function()
    Settings.SelectedStat = "Defense"
    Notify("Selected: Defense")
end)

Library:CreateButton(Container, "Stat: Sword", function()
    Settings.SelectedStat = "Sword"
    Notify("Selected: Sword")
end)

Library:CreateButton(Container, "Stat: Gun", function()
    Settings.SelectedStat = "Gun"
    Notify("Selected: Gun")
end)

Library:CreateButton(Container, "Stat: Fruit", function()
    Settings.SelectedStat = "Fruit"
    Notify("Selected: Fruit")
end)

Library:CreateToggle(Container, "Auto Stats", function(state)
    Settings.AutoStats = state
    Notify(state and "Auto Stats: ON (" .. Settings.SelectedStat .. ")" or "Auto Stats: OFF")
end)

-- Fruit Section
Library:CreateLabel(Container, "")
Library:CreateLabel(Container, "=== FRUITS ===")

Library:CreateToggle(Container, "Auto Collect Fruits", function(state)
    Settings.AutoCollectFruits = state
    Notify(state and "Auto Collect: ON" or "Auto Collect: OFF")
end)

Library:CreateButton(Container, "Store All Fruits", function()
    pcall(function()
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if string.find(item.Name, "Fruit") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
            end
        end
        Notify("Fruits Stored!")
    end)
end)

-- Movement Section
Library:CreateLabel(Container, "")
Library:CreateLabel(Container, "=== MOVEMENT ===")

Library:CreateToggle(Container, "Speed Boost (100)", function(state)
    Settings.SpeedBoost = state
    Notify(state and "Speed: ON" or "Speed: OFF")
end)

Library:CreateToggle(Container, "NoClip", function(state)
    Settings.NoClip = state
    Notify(state and "NoClip: ON" or "NoClip: OFF")
end)

-- Teleport Section
Library:CreateLabel(Container, "")
Library:CreateLabel(Container, "=== TELEPORT ===")

Library:CreateButton(Container, "Second Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        Notify("Traveling to Second Sea...")
    end)
end)

Library:CreateButton(Container, "Third Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
        Notify("Traveling to Third Sea...")
    end)
end)

-- Server Section
Library:CreateLabel(Container, "")
Library:CreateLabel(Container, "=== SERVER ===")

Library:CreateButton(Container, "Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

Library:CreateButton(Container, "Redeem All Codes", function()
    local codes = {"NEWTROLL", "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK"}
    for _, code in pairs(codes) do
        pcall(function()
            ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
            wait(0.5)
        end)
    end
    Notify("All codes redeemed!")
end)

Library:CreateLabel(Container, "")
Library:CreateLabel(Container, "Mobile Optimized | Delta Compatible")

Notify("Script Loaded! ✅")
print("Blox Fruits Hub Mobile - Loaded Successfully!")
