-- =============================================
-- VIOLENCE DISTRICT ESP + FULLBRIGHT - FIXED
-- =============================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VD_ESP_MOBILE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ICON
local Icon = Instance.new("TextButton")
Icon.Size = UDim2.new(0,55,0,55)
Icon.Position = UDim2.new(0,15,0.5,-30)
Icon.BackgroundColor3 = Color3.fromRGB(200,0,0)
Icon.Text = "⚡"
Icon.TextColor3 = Color3.new(1,1,1)
Icon.TextScaled = true
Icon.Font = Enum.Font.GothamBold
Icon.Active = true
Icon.Draggable = true
Icon.Parent = ScreenGui

Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)

-- MAIN UI
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,280,0,380)
Main.Position = UDim2.new(0.5,-140,0.5,-190)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(180,0,0)
Title.Text = "VIOLENCE DISTRICT ESP"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

Instance.new("UICorner", Title).CornerRadius = UDim.new(0,12)

Icon.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- ================= TOGGLES =================
local toggles = {
	["ESP Killer"] = true,
	["ESP Survivor"] = true,
	["ESP Generator"] = true,
	["Generator Progress"] = true,
	["Fullbright"] = true
}

local function CreateToggle(name, posY)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1,-20,0,45)
	Frame.Position = UDim2.new(0,10,0,posY)
	Frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Frame.Parent = Main
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.65,0,1,0)
	Label.BackgroundTransparency = 1
	Label.Text = name
	Label.TextColor3 = Color3.new(1,1,1)
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0,65,0,30)
	Button.Position = UDim2.new(1,-80,0.5,-15)
	Button.Text = toggles[name] and "ON" or "OFF"
	Button.TextColor3 = Color3.new(1,1,1)
	Button.Font = Enum.Font.GothamBold
	Button.BackgroundColor3 = toggles[name] and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
	Button.Parent = Frame
	Instance.new("UICorner", Button).CornerRadius = UDim.new(1,0)

	Button.MouseButton1Click:Connect(function()
		toggles[name] = not toggles[name]
		Button.Text = toggles[name] and "ON" or "OFF"
		Button.BackgroundColor3 = toggles[name] and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
	end)
end

CreateToggle("ESP Killer", 65)
CreateToggle("ESP Survivor", 120)
CreateToggle("ESP Generator", 175)
CreateToggle("Generator Progress", 230)
CreateToggle("Fullbright", 285)

-- ================= ESP CACHE =================
local ESP_CACHE = {}
local HIGHLIGHT_CACHE = {}

local function CreateESP(part, text, color)
	if not part then return end
	if ESP_CACHE[part] then
		ESP_CACHE[part]:FindFirstChildOfClass("TextLabel").Text = text
		ESP_CACHE[part]:FindFirstChildOfClass("TextLabel").TextColor3 = color
		return
	end

	local bb = Instance.new("BillboardGui")
	bb.Adornee = part
	bb.AlwaysOnTop = true
	bb.Size = UDim2.new(0, 200, 0, 60)
	bb.StudsOffset = Vector3.new(0, 3.5, 0)
	bb.Parent = part

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = text
	txt.TextColor3 = color
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBold
	txt.TextStrokeTransparency = 0.6
	txt.Parent = bb

	ESP_CACHE[part] = bb
end

local function CreateHighlight(obj, color)
	if HIGHLIGHT_CACHE[obj] then
		HIGHLIGHT_CACHE[obj].FillColor = color
		HIGHLIGHT_CACHE[obj].OutlineColor = color
		return
	end

	local hl = Instance.new("Highlight")
	hl.FillColor = color
	hl.OutlineColor = color
	hl.FillTransparency = 0.4
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = obj
	HIGHLIGHT_CACHE[obj] = hl
end

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()

	-- Fullbright
	if toggles["Fullbright"] then
		Lighting.Brightness = 3
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.Ambient = Color3.fromRGB(200,200,200)
	else
		Lighting.Brightness = 1
		Lighting.ClockTime = 12
		Lighting.FogEnd = 1000
		Lighting.Ambient = Color3.fromRGB(100,100,100)
	end

	-- PLAYER ESP
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local root = plr.Character.HumanoidRootPart
			local isKiller = false

			-- Deteksi Killer lebih akurat
			if plr.Character:FindFirstChildWhichIsA("Tool") then
				local toolName = plr.Character:FindFirstChildWhichIsA("Tool").Name:lower()
				if toolName:find("knife") or toolName:find("bat") or toolName:find("sword") or toolName:find("machete") or toolName:find("axe") then
					isKiller = true
				end
			end

			if isKiller and toggles["ESP Killer"] then
				CreateESP(root, plr.Name .. "\n[KILLER]", Color3.fromRGB(255, 0, 0))
				CreateHighlight(plr.Character, Color3.fromRGB(255, 0, 0))
			elseif not isKiller and toggles["ESP Survivor"] then
				CreateESP(root, plr.Name .. "\n[SURVIVOR]", Color3.fromRGB(0, 170, 255))
				CreateHighlight(plr.Character, Color3.fromRGB(0, 170, 255))
			end
		end
	end

	-- GENERATOR ESP
	if toggles["ESP Generator"] then
		for _, gen in ipairs(Workspace:GetDescendants()) do
			if gen.Name:lower():find("generator") or gen:FindFirstChild("RepairPart") then
				local root = gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")
				if root then
					local progress = 0
					local progVal = gen:FindFirstChild("Progress") or gen:FindFirstChild("RepairProgress") or gen:FindFirstChildWhichIsA("NumberValue")

					if progVal then
						progress = math.floor(progVal.Value)
					end

					local color = (progress >= 100) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 220, 0)
					local status = (progress >= 100) and "DONE" or progress .. "%"

					local text = "Generator"
					if toggles["Generator Progress"] then
						text = text .. "\n" .. status
					end

					CreateESP(root, text, color)
					CreateHighlight(gen, color)
				end
			end
		end
	end
end)

print("✅ FIXED SCRIPT LOADED - Killer Red + Generator Green")
