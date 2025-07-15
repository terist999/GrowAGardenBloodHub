--[[ 
Egg Randomizer GUI by Blood.lust (@terist999)
Final Version: July 2025
Features:
- Bloody UI with toggle button 🅱️
- Scrollable egg list
- Pet result text displayed above egg
- 10-second cooldown with timer
- Full v1.12.0 Pet Database including Primal pets
- No center-screen pet display bug
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Egg database (including Primal)
local EggPets = {
    ["Common Egg"] = {"Dog", "Bunny", "Golden Lab"},
    ["Uncommon Egg"] = {"Chicken", "Cat"},
    ["Bug Egg"] = {"Dragonfly", "Giant Ant", "Caterpillar", "Snail"},
    ["Bee Egg"] = {"Queen Bee"},
    ["Rare Summer Egg"] = {"Toucan", "Flamingo", "Orangutan", "Sea Turtle"},
    ["Common Summer Egg"] = {"Starfish", "Crab", "Seagull"},
    ["Prehistoric Egg"] = {"Pterodactyl", "Raptor", "Triceratops", "Stegosaurus", "Brontosaurus", "T-Rex"},
    ["Paradise Egg"] = {"Ostrich", "Peacock", "Capybara"},
    ["Oasis Egg"] = {"Meerkat", "Fennec Fox"},
    ["Night Egg"] = {"Night Owl", "Raccoon"},
    ["Primal Egg"] = {
        "Parasaurolophus", "Iguanodon", "Pachycephalosaurus",
        "Dilophosaurus", "Ankylosaurus", "Spinosaurus"
    }
}

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EggRandomizerGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 300)
frame.Position = UDim2.new(0.02, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Egg Randomizer"
title.TextColor3 = Color3.fromRGB(255, 60, 60)
title.Font = Enum.Font.FredokaOne
title.TextSize = 20

-- Toggle Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -35, 0, 0)
toggleBtn.Text = "🅱️"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
toggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Font = Enum.Font.FredokaOne
toggleBtn.TextSize = 18

local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in pairs(frame:GetChildren()) do
        if v ~= toggleBtn and v ~= title then
            v.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 50, 0, 50) or UDim2.new(0, 270, 0, 300)
end)

-- Scrollable Dropdown
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -20, 0, 150)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scrollFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

local selectedEgg = nil

for eggName, _ in pairs(EggPets) do
    local button = Instance.new("TextButton", scrollFrame)
    button.Size = UDim2.new(1, 0, 0, 25)
    button.Text = eggName
    button.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.MouseButton1Click:Connect(function()
        selectedEgg = eggName
    end)
end

-- Randomizer
local cooldown = false
local spinButton = Instance.new("TextButton", frame)
spinButton.Size = UDim2.new(1, -20, 0, 40)
spinButton.Position = UDim2.new(0, 10, 0, 200)
spinButton.Text = "🎲 Randomize Pet"
spinButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spinButton.Font = Enum.Font.FredokaOne
spinButton.TextSize = 16

local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Size = UDim2.new(1, -20, 0, 20)
timerLabel.Position = UDim2.new(0, 10, 0, 250)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextSize = 14
timerLabel.Text = ""

spinButton.MouseButton1Click:Connect(function()
    if cooldown or not selectedEgg then return end
    cooldown = true

    local petList = EggPets[selectedEgg]
    local randomPet = petList[math.random(1, #petList)]

    -- Display BillboardGui above egg (simulate with Workspace for demo)
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Part") and egg.Name:lower():find("egg") then
            local billboard = Instance.new("BillboardGui", egg)
            billboard.Name = "EggPetDisplay"
            billboard.Size = UDim2.new(0, 150, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Adornee = egg
            billboard.AlwaysOnTop = true

            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = randomPet
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.Font = Enum.Font.FredokaOne
            label.TextSize = 18
        end
    end

    -- Timer / Cooldown
    local countdown = 10
    timerLabel.Text = "Cooldown: 10s"
    spawn(function()
        while countdown > 0 do
            wait(1)
            countdown -= 1
            timerLabel.Text = "Cooldown: "..countdown.."s"
        end
        timerLabel.Text = ""
        cooldown = false
    end)
end)
