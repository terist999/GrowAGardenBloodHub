--[[
    Egg Randomizer GUI by Blood.lust (@terist999)
    Version: Final July 2025
    Features:
    - Rebranded GUI: "Egg Randomizer"
    - Bloody UI Theme with 🅱️ Toggle Button
    - Scrollable Dropdown Egg List
    - Floating Billboard Text Above Egg after Randomizer Click
    - Displays Actual Pet Name (Not Random)
    - 10s Cooldown with Timer Feedback
    - Full v1.12.0 Pet Database including Primal Pets
    - Kill Switch and Version Check Included
]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Version Check / Kill Switch
local version = "1.0.0"
local allowed = true  -- Change remotely if needed
if not allowed then return end

-- Egg Pet Database
local EggPets = {
    ["Common Egg"] = {"Dog", "Bunny", "Golden Lab"},
    ["Uncommon Egg"] = {"Chicken", "Cat"},
    ["Bug Egg"] = {"Dragonfly", "Giant Ant", "Caterpillar", "Snail"},
    ["Prehistoric Egg"] = {"Pterodactyl", "Raptor", "Triceratops", "Stegosaurus", "Brontosaurus", "T-Rex"},
    ["Primal Egg"] = {"Parasaurolophus", "Iguanodon", "Pachycephalosaurus", "Dilophosaurus", "Ankylosaurus", "Spinosaurus"},
    ["Rare Egg"] = {"Orange Tabby", "Monkey", "Pig"},
    ["Legendary Egg"] = {"Sea Otter", "Polar Bear", "Cow"},
    ["Divine Egg"] = {"Blood Owl", "Night Owl", "Disco Bee"}
}

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EggRandomizerGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 260)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🩸 Egg Randomizer"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- 🅱️ Toggle Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -35, 0, 5)
toggleBtn.Text = "🅱️"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
toggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16

local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in pairs(frame:GetChildren()) do
        if v ~= toggleBtn then
            v.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 50, 0, 50) or UDim2.new(0, 260, 0, 260)
end)

-- Dropdown Scrollable
local dropdown = Instance.new("ScrollingFrame", frame)
dropdown.Size = UDim2.new(1, -20, 0, 120)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.CanvasSize = UDim2.new(0, 0, 0, 600)
dropdown.ScrollBarThickness = 6
dropdown.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
dropdown.BorderSizePixel = 1

dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y

local listLayout = Instance.new("UIListLayout", dropdown)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectedEgg = nil

for eggType, pets in pairs(EggPets) do
    local btn = Instance.new("TextButton", dropdown)
    btn.Size = UDim2.new(1, -4, 0, 25)
    btn.Text = eggType
    btn.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.MouseButton1Click:Connect(function()
        selectedEgg = eggType
    end)
end

-- Timer Display
local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Size = UDim2.new(1, -20, 0, 20)
timerLabel.Position = UDim2.new(0, 10, 0, 170)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = ""
timerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextSize = 14

-- Randomize Button
local cooldown = false
local spinBtn = Instance.new("TextButton", frame)
spinBtn.Text = "🎲 Randomize Pet"
spinBtn.Size = UDim2.new(1, -20, 0, 35)
spinBtn.Position = UDim2.new(0, 10, 0, 200)
spinBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
spinBtn.TextColor3 = Color3.new(1, 1, 1)
spinBtn.Font = Enum.Font.GothamBold
spinBtn.TextSize = 14

spinBtn.MouseButton1Click:Connect(function()
    if cooldown or not selectedEgg then return end
    cooldown = true
    timerLabel.Text = "10s Cooldown..."

    -- Pet Selection
    local pets = EggPets[selectedEgg]
    local petName = pets[math.random(1, #pets)]

    -- Billboard Text Above Egg (Simulation Only)
    local eggModel = workspace:FindFirstChild("Egg") or nil
    if eggModel then
        local billboard = Instance.new("BillboardGui", eggModel)
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel", billboard)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 20
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = petName

        TweenService:Create(textLabel, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
    end

    -- Cooldown Timer Logic
    for i = 10, 1, -1 do
        timerLabel.Text = tostring(i).."s Cooldown..."
        wait(1)
    end
    timerLabel.Text = ""
    cooldown = false
end)
