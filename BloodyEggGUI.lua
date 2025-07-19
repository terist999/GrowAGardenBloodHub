-- BloodyEggGUI with Loader
-- Created by Blood.luat92

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create Loading Screen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloodLoadingScreen"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 80)
frame.Position = UDim2.new(0.5, -200, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = frame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.FredokaOne
loadingText.TextColor3 = Color3.fromRGB(255, 0, 0)
loadingText.TextScaled = true
loadingText.Text = "Loading... 0%"
loadingText.Parent = frame

-- Animate Loading Bar
local percent = 0
spawn(function()
    while percent < 100 do
        percent = percent + math.random(1, 4)
        if percent > 100 then percent = 100 end
        loadingText.Text = "Loading... " .. percent .. "%"
        wait(0.1)
    end
    loadingText.Text = "Loaded. Welcome Blood.luat92"
    wait(1)
    screenGui:Destroy()

    -- Main BloodyEggGUI Logic Starts
    local petTable = {
        ["Common Egg"] = { "Dog", "Bunny", "Golden Lab" },
        ["Uncommon Egg"] = { "Chicken", "Black Bunny", "Cat", "Deer" },
        ["Rare Egg"] = { "Pig", "Monkey", "Rooster", "Orange Tabby", "Spotted Deer" },
        ["Legendary Egg"] = { "Cow", "Polar Bear", "Sea Otter", "Turtle", "Silver Monkey" },
        ["Mythical Egg"] = { "Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant" },
        ["Bug Egg"] = { "Snail", "Caterpillar", "Giant Ant", "Praying Mantis" },
        ["Night Egg"] = { "Frog", "Hedgehog", "Mole", "Echo Frog", "Night Owl" },
        ["Bee Egg"] = { "Bee", "Honey Bee", "Bear Bee", "Petal Bee" },
        ["Anti Bee Egg"] = { "Wasp", "Moth", "Tarantula Hawk" },
        ["Oasis Egg"] = { "Meerkat", "Sand Snake", "Axolotl" },
        ["Paradise Egg"] = { "Ostrich", "Peacock", "Capybara" },
        ["Dinosaur Egg"] = { "Raptor", "Triceratops", "Stegosaurus" },
        ["Primal Egg"] = { "Parasaurolophus", "Iguanodon", "Pachycephalosaurus" },
    }

    local espEnabled = true
    local truePetMap = {}

    local function glitchLabelEffect(label)
        coroutine.wrap(function()
            local original = label.TextColor3
            for i = 1, 2 do
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                wait(0.07)
                label.TextColor3 = original
                wait(0.07)
            end
        end)()
    end

    local function applyEggESP(eggModel, petName)
        local existingLabel = eggModel:FindFirstChild("PetBillboard", true)
        if existingLabel then existingLabel:Destroy() end

        local existingHighlight = eggModel:FindFirstChild("ESPHighlight")
        if existingHighlight then existingHighlight:Destroy() end

        if not espEnabled then return end

        local basePart = eggModel:FindFirstChildWhichIsA("BasePart")
        if not basePart then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PetBillboard"
        billboard.Size = UDim2.new(0, 270, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 4.5, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 500
        billboard.Parent = basePart

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = eggModel.Name .. " | " .. petName
        label.TextColor3 = Color3.fromRGB(200, 30, 30)
        label.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
        label.TextStrokeTransparency = 0.5
        label.TextScaled = true
        label.Font = Enum.Font.FredokaOne
        label.Parent = billboard

        glitchLabelEffect(label)

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(180, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = eggModel
        highlight.Parent = eggModel
    end

    local function removeEggESP(eggModel)
        local label = eggModel:FindFirstChild("PetBillboard", true)
        if label then label:Destroy() end

        local highlight = eggModel:FindFirstChild("ESPHighlight")
        if highlight then highlight:Destroy() end
    end

    local function getPlayerGardenEggs(radius)
        local eggs = {}
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return eggs end

        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and petTable[obj.Name] then
                local dist = (obj:GetModelCFrame().Position - root.Position).Magnitude
                if dist <= (radius or 60) then
                    if not truePetMap[obj] then
                        local pets = petTable[obj.Name]
                        local chosen = pets[math.random(1, #pets)]
                        truePetMap[obj] = chosen
                    end
                    table.insert(eggs, obj)
                end
            end
        end
        return eggs
    end

    local function randomizeNearbyEggs()
        local eggs = getPlayerGardenEggs(60)
        for _, egg in ipairs(eggs) do
            local petName = truePetMap[egg] or "???"
            applyEggESP(egg, petName)
        end
    end

    RunService.RenderStepped:Connect(function()
        if espEnabled then
            randomizeNearbyEggs()
        end
    end)

    print("BloodyEggGUI Loaded Successfully by Blood.luat92")
end)
