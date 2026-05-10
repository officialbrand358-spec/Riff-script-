--// =========================================
--// VIOLENCE DISTRICT V1
--// Mobile UI + ESP + Fullbright + FPS Boost
--// =========================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--=========================================
-- FLAGS
--=========================================

local Flags = {
	KillerESP = true,
	SurvivorESP = true,
	GeneratorESP = true,
	ExitGateESP = true,
	SkeletonESP = false,
	KillerWarn = true,
	Fullbright = false,
	FPSBoost = false
}

--=========================================
-- GUI
--=========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDT_V1"
ScreenGui.ResetOnSpawn = false

pcall(function()
	ScreenGui.Parent = gethui()
end)

if not ScreenGui.Parent then
	ScreenGui.Parent = LocalPlayer.PlayerGui
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 650, 0, 380)
Main.Position = UDim2.new(0.5,-325,0.5,-190)
Main.BackgroundColor3 = Color3.fromRGB(10,10,10)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,14)
MainCorner.Parent = Main

-- TOP

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,55)
Top.BackgroundColor3 = Color3.fromRGB(15,15,15)
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0,14)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0,200,1,0)
Title.BackgroundTransparency = 1
Title.Text = "VD T"
Title.Font = Enum.Font.Code
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 32
Title.Parent = Top

-- CONTENT

local Holder = Instance.new("Frame")
Holder.Size = UDim2.new(1,-20,1,-75)
Holder.Position = UDim2.new(0,10,0,65)
Holder.BackgroundTransparency = 1
Holder.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Holder

--=========================================
-- TOGGLE FUNCTION
--=========================================

local function Notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "VDT",
			Text = text,
			Duration = 3
		})
	end)
end

local function CreateToggle(name, default)

	Flags[name] = default

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1,0,0,45)
	Frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
	Frame.Parent = Holder

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,10)
	Corner.Parent = Frame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7,0,1,0)
	Label.BackgroundTransparency = 1
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.Font = Enum.Font.Code
	Label.TextSize = 24
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local Toggle = Instance.new("Frame")
	Toggle.Size = UDim2.new(0,55,0,28)
	Toggle.Position = UDim2.new(1,-70,0.5,-14)
	Toggle.BackgroundColor3 = default and Color3.fromRGB(120,70,255) or Color3.fromRGB(30,30,30)
	Toggle.Parent = Frame

	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(1,0)
	ToggleCorner.Parent = Toggle

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0,24,0,24)
	Circle.Position = default and UDim2.new(1,-26,0.5,-12) or UDim2.new(0,2,0.5,-12)
	Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Circle.Parent = Toggle

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1,0)
	CircleCorner.Parent = Circle

	Toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then

			Flags[name] = not Flags[name]

			if Flags[name] then

				TweenService:Create(Circle,TweenInfo.new(0.2),{
					Position = UDim2.new(1,-26,0.5,-12)
				}):Play()

				TweenService:Create(Toggle,TweenInfo.new(0.2),{
					BackgroundColor3 = Color3.fromRGB(120,70,255)
				}):Play()

				Notify(name.." Enabled")

			else

				TweenService:Create(Circle,TweenInfo.new(0.2),{
					Position = UDim2.new(0,2,0.5,-12)
				}):Play()

				TweenService:Create(Toggle,TweenInfo.new(0.2),{
					BackgroundColor3 = Color3.fromRGB(30,30,30)
				}):Play()

				Notify(name.." Disabled")
			end
		end
	end)
end

CreateToggle("KillerESP", true)
CreateToggle("SurvivorESP", true)
CreateToggle("GeneratorESP", true)
CreateToggle("ExitGateESP", true)
CreateToggle("SkeletonESP", false)
CreateToggle("KillerWarn", true)
CreateToggle("Fullbright", false)
CreateToggle("FPSBoost", false)

--=========================================
-- ESP SYSTEM
--=========================================

local ESP_CACHE = {}

local function RemoveESP(obj)
	if ESP_CACHE[obj] then
		ESP_CACHE[obj]:Destroy()
		ESP_CACHE[obj] = nil
	end
end

local function CreateESP(part, text, color)

	if not part then return end

	if ESP_CACHE[part] then

		local txt = ESP_CACHE[part]:FindFirstChild("TXT")

		if txt then
			txt.Text = text
			txt.TextColor3 = color
		end

		return
	end

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "VDT_ESP"
	Billboard.Size = UDim2.new(0,200,0,50)
	Billboard.StudsOffset = Vector3.new(0,3,0)
	Billboard.AlwaysOnTop = true
	Billboard.Adornee = part
	Billboard.Parent = part

	local Text = Instance.new("TextLabel")
	Text.Name = "TXT"
	Text.Size = UDim2.new(1,0,1,0)
	Text.BackgroundTransparency = 1
	Text.TextScaled = true
	Text.Font = Enum.Font.Code
	Text.TextStrokeTransparency = 0
	Text.TextColor3 = color
	Text.Text = text
	Text.Parent = Billboard

	ESP_CACHE[part] = Billboard
end

--=========================================
-- HIGHLIGHT
--=========================================

local HighlightCache = {}

local function CreateHighlight(obj, color)

	if HighlightCache[obj] then
		HighlightCache[obj].FillColor = color
		HighlightCache[obj].OutlineColor = color
		return
	end

	local hl = Instance.new("Highlight")
	hl.FillColor = color
	hl.OutlineColor = color
	hl.FillTransparency = 0.5
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = obj

	HighlightCache[obj] = hl
end

--=========================================
-- FULLBRIGHT
--=========================================

local Old = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	Ambient = Lighting.Ambient
}

task.spawn(function()
	while task.wait(1) do

		if Flags.Fullbright then
			Lighting.Brightness = 4
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.Ambient = Color3.fromRGB(255,255,255)
		else
			Lighting.Brightness = Old.Brightness
			Lighting.ClockTime = Old.ClockTime
			Lighting.FogEnd = Old.FogEnd
			Lighting.Ambient = Old.Ambient
		end
	end
end)

--=========================================
-- FPS BOOST
--=========================================

local Boosted = false

local function FPSBoost()

	if Boosted then return end

	Boosted = true

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end

		if v:IsA("Trail") then
			v.Enabled = false
		end

		if v:IsA("Explosion") then
			v.BlastPressure = 0
		end
	end

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

	Notify("FPS BOOST ENABLED")
end

--=========================================
-- PLAYER ESP LOOP
--=========================================

local WarnCooldown = false

local function IsKiller(plr)

	for _,tool in pairs(plr.Character:GetChildren()) do

		if tool:IsA("Tool") then

			local n = tool.Name:lower()

			if n:find("knife")
			or n:find("bat")
			or n:find("sword")
			or n:find("machete") then
				return true
			end
		end
	end

	return false
end

--=========================================
-- MAIN LOOP
--=========================================

task.spawn(function()

	while task.wait(0.2) do

		if Flags.FPSBoost then
			FPSBoost()
		end

		for _,plr in pairs(Players:GetPlayers()) do

			if plr ~= LocalPlayer and plr.Character then

				local root = plr.Character:FindFirstChild("HumanoidRootPart")

				if root then

					local killer = IsKiller(plr)

					if killer and Flags.KillerESP then

						CreateESP(root,plr.Name.."\n[KILLER]",Color3.fromRGB(255,0,0))
						CreateHighlight(plr.Character,Color3.fromRGB(255,0,0))

						local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)

						if Flags.KillerWarn and dist <= 30 and not WarnCooldown then

							WarnCooldown = true
							Notify("⚠ Killer Nearby ["..dist.."m]")

							task.delay(5,function()
								WarnCooldown = false
							end)
						end

					elseif (not killer) and Flags.SurvivorESP then

						CreateESP(root,plr.Name.."\n[SURVIVOR]",Color3.fromRGB(0,170,255))
						CreateHighlight(plr.Character,Color3.fromRGB(0,170,255))

					else
						RemoveESP(root)
					end
				end
			end
		end
	end
end)

--=========================================
-- GENERATOR + EXIT GATE ESP
--=========================================

local function ScanMap()

	for _,v in pairs(workspace:GetDescendants()) do

		if Flags.GeneratorESP then

			if v.Name:lower():find("generator") then

				local p = v:FindFirstChildWhichIsA("BasePart")

				if p then
					CreateESP(p,"Generator",Color3.fromRGB(255,255,0))
				end
			end
		end

		if Flags.ExitGateESP then

			if v.Name:lower():find("gate") then

				local p = v:FindFirstChildWhichIsA("BasePart")

				if p then
					CreateESP(p,"Exit Gate",Color3.fromRGB(0,255,0))
				end
			end
		end
	end
end

--=========================================
-- SKELETON ESP
--=========================================

local function SkeletonESP(char)

	if not Flags.SkeletonESP then return end

	for _,v in pairs(char:GetDescendants()) do

		if v:IsA("BasePart") then
			v.Material = Enum.Material.ForceField
		end
	end
end

task.spawn(function()
	while task.wait(1) do
		ScanMap()

		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character then
				SkeletonESP(plr.Character)
			end
		end
	end
end)

Notify("VDT V1 Loaded")
print("VDT V1 LOADED")
