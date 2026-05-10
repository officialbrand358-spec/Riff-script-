-- =============================================
-- VIOLENCE DISTRICT ESP + FULLBRIGHT
-- OPTIMIZED MOBILE VERSION
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
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0, 15, 0.5, -25)
Icon.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Icon.Text = "⚡"
Icon.TextColor3 = Color3.new(1,1,1)
Icon.TextScaled = true
Icon.Font = Enum.Font.GothamBold
Icon.Active = true
Icon.Draggable = true
Icon.Parent = ScreenGui

Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)

-- MAIN MENU
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 360)
Main.Position = UDim2.new(0.5, -140, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,45)
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

-- ================= TOGGLE SYSTEM =================
local toggles = {
	["ESP Killer"] = true,
	["ESP Survivor"] = true,
	["ESP Generator"] = true,
	["Generator Progress"] = true,
	["Fullbright"] = false
}

local function CreateToggle(name, posY)

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1,-20,0,40)
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
	Button.Size = UDim2.new(0,65,0,28)
	Button.Position = UDim2.new(1,-75,0.5,-14)
	Button.Text = toggles[name] and "ON" or "OFF"
	Button.TextColor3 = Color3.new(1,1,1)
	Button.Font = Enum.Font.GothamBold
	Button.BackgroundColor3 = toggles[name]
		and Color3.fromRGB(0,170,0)
		or Color3.fromRGB(170,0,0)
	Button.Parent = Frame

	Instance.new("UICorner", Button).CornerRadius = UDim.new(1,0)

	Button.MouseButton1Click:Connect(function()

		toggles[name] = not toggles[name]

		if toggles[name] then
			Button.Text = "ON"
			Button.BackgroundColor3 = Color3.fromRGB(0,170,0)
		else
			Button.Text = "OFF"
			Button.BackgroundColor3 = Color3.fromRGB(170,0,0)
		end
	end)
end

CreateToggle("ESP Killer", 60)
CreateToggle("ESP Survivor", 110)
CreateToggle("ESP Generator", 160)
CreateToggle("Generator Progress", 210)
CreateToggle("Fullbright", 260)

-- ================= ESP =================
local ESP_CACHE = {}
local GENERATORS = {}

local function RemoveESP(obj)

	if ESP_CACHE[obj] then
		ESP_CACHE[obj]:Destroy()
		ESP_CACHE[obj] = nil
	end
end

local function CreateESP(part, text, color)

	if not part then return end

	if ESP_CACHE[part] then
		local label = ESP_CACHE[part]:FindFirstChildOfClass("TextLabel")

		if label then
			label.Text = text
			label.TextColor3 = color
		end

		return
	end

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "VD_ESP"
	Billboard.Adornee = part
	Billboard.Size = UDim2.new(0,200,0,50)
	Billboard.StudsOffset = Vector3.new(0,3,0)
	Billboard.AlwaysOnTop = true
	Billboard.Parent = part

	local Text = Instance.new("TextLabel")
	Text.Size = UDim2.new(1,0,1,0)
	Text.BackgroundTransparency = 1
	Text.TextScaled = true
	Text.Font = Enum.Font.GothamBold
	Text.TextStrokeTransparency = 0.5
	Text.Text = text
	Text.TextColor3 = color
	Text.Parent = Billboard

	ESP_CACHE[part] = Billboard
end

-- ================= FIND GENERATORS =================
local function ScanGenerators()

	table.clear(GENERATORS)

	for _, v in ipairs(Workspace:GetDescendants()) do

		if v.Name:lower():find("generator")
			or v:FindFirstChild("RepairPart") then

			table.insert(GENERATORS, v)
		end
	end
end

ScanGenerators()

task.spawn(function()

	while true do
		task.wait(15)
		ScanGenerators()
	end
end)

-- ================= SAVE ORIGINAL LIGHTING =================
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogEnd = Lighting.FogEnd
local oldAmbient = Lighting.Ambient

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()

	-- FULLBRIGHT
	if toggles["Fullbright"] then

		Lighting.Brightness = 5
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.Ambient = Color3.fromRGB(255,255,255)

	else

		Lighting.Brightness = oldBrightness
		Lighting.ClockTime = oldClockTime
		Lighting.FogEnd = oldFogEnd
		Lighting.Ambient = oldAmbient
	end

	-- PLAYER ESP
	for _, plr in ipairs(Players:GetPlayers()) do

		if plr ~= LocalPlayer and plr.Character then

			local root = plr.Character:FindFirstChild("HumanoidRootPart")

			if root then

				local isKiller =
					plr.Character:FindFirstChild("KillerTool")
					or plr.Backpack:FindFirstChild("KillerTool")

				if isKiller and toggles["ESP Killer"] then

					CreateESP(
						root,
						plr.Name .. "\n[KILLER]",
						Color3.fromRGB(255,0,0)
					)

				elseif (not isKiller) and toggles["ESP Survivor"] then

					CreateESP(
						root,
						plr.Name .. "\n[SURVIVOR]",
						Color3.fromRGB(0,170,255)
					)

				else
					RemoveESP(root)
				end
			end
		end
	end

	-- GENERATOR ESP
	if toggles["ESP Generator"] then

		for _, gen in ipairs(GENERATORS) do

			local root =
				gen.PrimaryPart
				or gen:FindFirstChildWhichIsA("BasePart")

			if root then

				local progress = 0

				local prog =
					gen:FindFirstChild("Progress")
					or gen:FindFirstChild("RepairProgress")
					or gen:FindFirstChildWhichIsA("NumberValue")

				if prog then
					progress = math.floor(prog.Value)
				end

				local status = progress .. "%"
				local color = Color3.fromRGB(255,220,0)

				if progress >= 100 then
					status = "DONE"
					color = Color3.fromRGB(0,255,0)
				end

				local text = "Generator"

				if toggles["Generator Progress"] then
					text = text .. "\n" .. status
				end

				CreateESP(root, text, color)
			end
		end
	end
end)

print("✅ Violence District ESP + Fullbright Loaded")