-- TEST SCRIPT - Cek Apakah UI Muncul

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ICON
local Icon = Instance.new("TextButton")
Icon.Size = UDim2.new(0, 70, 0, 70)
Icon.Position = UDim2.new(0, 30, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Icon.Text = "⚡"
Icon.TextColor3 = Color3.new(1,1,1)
Icon.TextScaled = true
Icon.Font = Enum.Font.GothamBold
Icon.Draggable = true
Icon.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1,0)
Corner.Parent = Icon

-- UI
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 200)
Frame.Position = UDim2.new(0.5, -140, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Visible = false
Frame.Draggable = true
Frame.Parent = ScreenGui

local UIC = Instance.new("UICorner")
UIC.CornerRadius = UDim.new(0,12)
UIC.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(200,0,0)
Title.Text = "TEST SCRIPT"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

Icon.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

print("✅ TEST SCRIPT LOADED - Klik icon merah ⚡")
