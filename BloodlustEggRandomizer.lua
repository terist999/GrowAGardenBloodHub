--[[
    Bloodlust Egg Randomizer GUI
    Created by Bloodlust92
    Bloody Red Themed Visual Pet Hatch Simulator
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Your existing petTable and all script code here...

-- Replace GUI Theme Colors
frame.BackgroundColor3 = Color3.fromRGB(120, 0, 0) -- Dark Bloody Red
frame.BackgroundTransparency = 0.05

randomizeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 20, 20)
autoBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
loadAgeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
mutationBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)

-- Change main title
title.Text = "🩸 Bloodlust Egg Randomizer 🩸"
title.TextColor3 = Color3.fromRGB(255, 200, 200)

-- Credit updated
credit.Text = "Created by Bloodlust92"
credit.TextColor3 = Color3.fromRGB(255, 0, 0)

-- Optional animated blood effect
local function bloodPulse()
    while true do
        frame.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        wait(0.5)
        frame.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        wait(0.5)
    end
end
coroutine.wrap(bloodPulse)()

-- Continue rest of script normally...
