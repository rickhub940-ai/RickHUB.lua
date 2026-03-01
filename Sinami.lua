--// =========================
--// LOAD WINDUI
--// =========================
local WindUI = loadstring(game:HttpGet(
"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local player = game.Players.LocalPlayer

--// =========================
--// COLORS (ฟ้าเหลือง)
--// =========================
local BLUE   = Color3.fromHex("#3BA9FF")
local SKY    = Color3.fromHex("#6FD3FF")
local YELLOW = Color3.fromHex("#FFD93B")
local WHITE  = Color3.fromHex("#FFFFFF")

local DARK_BG1 = Color3.fromHex("#0A1628")
local DARK_BG2 = Color3.fromHex("#0F223F")

--// =========================
--// GRADIENT
--// =========================
local MAIN_GRADIENT = WindUI:Gradient({
    ["0"]   = {Color = BLUE, Transparency = 0},
    ["50"]  = {Color = SKY, Transparency = 0},
    ["100"] = {Color = YELLOW, Transparency = 0},
},{Rotation = 45})

local BACKGROUND_GRADIENT = WindUI:Gradient({
    ["0"]   = {Color = BLUE, Transparency = 0.35},
    ["50"]  = {Color = SKY, Transparency = 0.35},
    ["100"] = {Color = YELLOW, Transparency = 0.35},
},{Rotation = 45})

local DARK_TAB_GRADIENT = WindUI:Gradient({
    ["0"]   = {Color = DARK_BG1, Transparency = 0},
    ["100"] = {Color = DARK_BG2, Transparency = 0},
},{Rotation = 90})

--// =========================
--// THEME
--// =========================
WindUI:AddTheme({
    Name = "RickHUBTheme",

    Accent = MAIN_GRADIENT,
    Hover  = MAIN_GRADIENT,

    Background = BACKGROUND_GRADIENT,
    BackgroundTransparency = 0.35,

    Outline = YELLOW,
    Text = WHITE,
    Icon = WHITE,

    WindowBackground = BACKGROUND_GRADIENT,
    WindowShadow = Color3.fromRGB(0,0,0),

    TabBackground = DARK_TAB_GRADIENT,
    TabTitle = WHITE,
    TabIcon = WHITE,

    ElementBackground = DARK_TAB_GRADIENT,
    ElementTitle = WHITE,

    Button = MAIN_GRADIENT,
    Toggle = MAIN_GRADIENT,
    Slider = MAIN_GRADIENT,
})

WindUI:SetTheme("RickHUBTheme")


local avatar = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
..player.UserId.."&size=420x420&format=Png"

local Window = WindUI:CreateWindow({
    Title = "RICK HUB ",
    Icon = "rbxassetid://108958018844079",
    Author = "Author[ 009.exe ]",
    Folder = "RICK HUB",
    Size = UDim2.fromOffset(730, 410),
    Theme = "RickHUBTheme",
    Transparent = true,
    Resizable = true,

    User = {
        Enabled = true,
        Custom = {
            Name = player.Name,
            Bio = "RickHUB USER",
            Image = avatar
        }
    }
})

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")




Window:EditOpenButton({ Enabled = false })

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("ImageButton")

ScreenGui.Name = "WindUI_Toggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://108958018844079"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local opened = true

local function toggle()
    opened = not opened
    if Window.UI then
        Window.UI.Enabled = opened
    else
        Window:Toggle()
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    ToggleBtn:TweenSize(
        UDim2.new(0, 56, 0, 56),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.12,
        true,
        function()
            ToggleBtn:TweenSize(
                UDim2.new(0, 50, 0, 50),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.12,
                true
            )
        end
    )
    toggle()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        toggle()
    end
end)





local Enabled = false
local tweening = false
local arrived = false
local currentGapPart
local AutoCollectEnabled = false


-- ====== STATECombat ======
local HitLongEnabled = false
local ShowRangeEnabled = false
local HitRangeValue = 50
local ORIGINAL_SIZES = {}
local Connections = {}
local char, hrp





-- ===============================

-- Auto pickup 

-- ------------------------------

local AutoPromptEnabled = false
local lastFire = {}

for _, v in ipairs(workspace:GetDescendants()) do
	if v:IsA("ProximityPrompt") then
		v.HoldDuration = 0
		v.RequiresLineOfSight = false
	end
end

ProximityPromptService.PromptShown:Connect(function(prompt)
	if not AutoPromptEnabled then return end

	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local part = prompt.Parent
	if not part or not part:IsA("BasePart") then return end

	if lastFire[prompt] and tick() - lastFire[prompt] < 0.05 then
		return
	end

	local dist = (part.Position - hrp.Position).Magnitude
	if dist <= prompt.MaxActivationDistance then
		lastFire[prompt] = tick()
		pcall(function()
			fireproximityprompt(prompt)
		end)
	end
end)





-- ======
-- Godmode
-- =====
-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local FAKE_HP = 100000

-- ================= STATE =================
local AntiWaveEnabled = false
local Connections = {}

local function ClearConnections()
    for _, c in ipairs(Connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    table.clear(Connections)
end

-- ================= MAIN =================
local function AntiWaveInfinite(char)
    local hum = char:WaitForChild("Humanoid")

    hum.BreakJointsOnDeath = false
    hum.MaxHealth = math.huge
    hum.Health = FAKE_HP

    hum.WalkSpeed = 16
    hum.JumpPower = 50
    hum.UseJumpPower = true

    -- กันตายจากเวฟ
    table.insert(Connections,
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not AntiWaveEnabled then return end
            if hum.Health <= 0 then
                hum.Health = FAKE_HP
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    )

    table.insert(Connections,
        hum.StateChanged:Connect(function(_, new)
            if not AntiWaveEnabled then return end
            if new == Enum.HumanoidStateType.Dead then
                hum.Health = FAKE_HP
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    )

    table.insert(Connections,
        RunService.Heartbeat:Connect(function()
            if not AntiWaveEnabled then return end
            if hum.Health <= 0 then
                hum.Health = FAKE_HP
            end
        end)
    )
end


-----------------
-- ร่างปลอม ------
-----------------


-- --------
-- CombatTab
-- ----------

local lp = Players.LocalPlayer
local bp = lp:WaitForChild("Backpack")

-- ====== VISUAL ======
local function createBoxVisual(parent, size)
    local box = Instance.new("Part")
    box.Name = "BoxVisual"
    box.Size = size
    box.Transparency = 0.8
    box.Color = Color3.fromRGB(255, 100, 100)
    box.Material = Enum.Material.Neon
    box.CanCollide = false
    box.Anchored = false
    box.CastShadow = false

    local wireframe = Instance.new("SelectionBox")
    wireframe.Adornee = box
    wireframe.Color3 = Color3.fromRGB(255, 50, 50)
    wireframe.LineThickness = 0.05
    wireframe.Parent = box

    box.Parent = parent
    return box
end

-- ====== APPLY HITBOX ======
local function applyHitbox(tool)
    local hitbox = tool:FindFirstChild("Hitbox")
    if not hitbox then return end

    if not ORIGINAL_SIZES[hitbox] then
        ORIGINAL_SIZES[hitbox] = hitbox.Size
    end

    if HitLongEnabled then
        hitbox.Size = Vector3.new(HitRangeValue, HitRangeValue, HitRangeValue)
        tool.ToolTip = ("📦 Hit Range\nSize: %d×%d×%d")
            :format(HitRangeValue, HitRangeValue, HitRangeValue)
    else
        hitbox.Size = ORIGINAL_SIZES[hitbox]
    end
end

-- ====== APPLY VISUAL ======
local function applyVisual(tool)
    local hitbox = tool:FindFirstChild("Hitbox")
    if not hitbox then return end

    if Connections[tool] then
        Connections[tool]:Disconnect()
        Connections[tool] = nil
    end

    local old = tool:FindFirstChild("BoxVisual")
    if old then old:Destroy() end

    if not ShowRangeEnabled then return end

    local box = createBoxVisual(
        tool,
        Vector3.new(HitRangeValue, HitRangeValue, HitRangeValue)
    )

    Connections[tool] = RunService.Heartbeat:Connect(function()
        if box.Parent and hitbox.Parent then
            box.CFrame = hitbox.CFrame
        end
    end)
end

-- ====== TOOL SETUP ======
local function setupTool(tool)
    if not tool:IsA("Tool") then return end
    if not tool:FindFirstChild("Hitbox") then return end

    tool.Equipped:Connect(function()
        applyHitbox(tool)
        applyVisual(tool)
    end)

    tool.Unequipped:Connect(function()
        local box = tool:FindFirstChild("BoxVisual")
        if box then box:Destroy() end

        if Connections[tool] then
            Connections[tool]:Disconnect()
            Connections[tool] = nil
        end
    end)
end

-- ====== INIT ======
for _, tool in ipairs(bp:GetChildren()) do
    setupTool(tool)
end
bp.ChildAdded:Connect(setupTool)



local MainTab = Window:Tab({Title = "Main", Icon = "user"})




MainTab:Toggle({
    Title = "walk Speed",
    Desc = "วิ่งเร็ว",
    Default = false,
    Callback = function(state)
        getgenv().SPEED_ON = state
        if state then
            localPlayer:SetAttribute("CurrentSpeed", getgenv().SPEED_VALUE)
        end
    end
})


MainTab:Slider({
    Title = "Speed Value",
    Desc = "ปรับสปีด",
    Step = 1,
    Value = {
        Min = 0,
        Max = 3000,
        Default = 500,
    },
    Callback = function(value)
        getgenv().SPEED_VALUE = value
        if getgenv().SPEED_ON then
            localPlayer:SetAttribute("CurrentSpeed", value)
        end
    end
})


local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local zoomConnection

MainTab:Button({
    Title = "Unlock Camera Zoom",
    Desc = "ทำให้ซูมไกล",
    Callback = function()
        if zoomConnection then
            zoomConnection:Disconnect()
            zoomConnection = nil
        end

        zoomConnection = RunService.RenderStepped:Connect(function()
            player.CameraMode = Enum.CameraMode.Classic
            camera.CameraType = Enum.CameraType.Custom
            player.CameraMinZoomDistance = 0.5
            player.CameraMaxZoomDistance = 1000
        end)

        WindUi:Notify({
            Title = "unlockCamera Zoom✅",
            Content = "ปลดล็อกซูม✅",
            Duration = 3
        })
    end
})

local lp = Players.LocalPlayer




MainTab:Toggle({
    Title = "Auto pick Brainrots",
    Desc = "หยิบเบรอสอัตโนมัติ",
    Default = false,
    Callback = function(state)
        AutoPromptEnabled = state
    end
})



local Net = require(ReplicatedStorage.Packages.Net)
local ClientGlobals = require(ReplicatedStorage.Client.Modules.ClientGlobals)
local PlotAction = Net:RemoteFunction("Plot.PlotAction")
task.spawn(function()
	while true do
		if AutoCollectEnabled then
			for _, plot in ipairs(CollectionService:GetTagged("Plot")) do
				local uuid = plot.Name

				-- เช็คว่า Plot เป็นของเรา
				if ClientGlobals.Plots:TryIndex({ uuid, "player" }) == Players.LocalPlayer then
					local maxSlots = ClientGlobals.Plots:TryIndex({ uuid, "data", "MaxSlots" }) or 10

					for slot = 1, maxSlots do
						if not AutoCollectEnabled then break end

						local args = {
							"Collect Money",
							uuid,
							tostring(slot)
						}

						pcall(function()
							PlotAction:InvokeServer(unpack(args))
						end)

						task.wait(0.05)
					end
				end
			end
		end
		task.wait(0.5)
	end
end)



MainTab:Toggle({
    Title = "Auto Collect Money",
    Desc = "เก็บเงินที่ฐานอัตโนมัติ",
    Default = false,
    Callback = function(state)
        AutoCollectEnabled = state
    end
})



local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")


local ClientGlobals = require(ReplicatedStorage.Client.Modules.ClientGlobals)
local Net = require(ReplicatedStorage.Packages.Net)
local PlotAction = Net:RemoteFunction("Plot.PlotAction")

local lp = Players.LocalPlayer

-- ===== STATE =====
local AutoUpgrade = false
local SelectedBrainrot = nil

-- ===== FIND OUR BASE + UUID =====
local function getMyBaseAndUUID()
	for _, plot in ipairs(CollectionService:GetTagged("Plot")) do
		local uuid = plot.Name
		if ClientGlobals.Plots:TryIndex({ uuid, "player" }) == lp then
			return uuid, Workspace.Bases:FindFirstChild(uuid)
		end
	end
end

-- ===== GET BRAINROT VALUES
local function getBrainrotValues()
	local _, base = getMyBaseAndUUID()
	if not base then return { "No Base" } end

	local values = {}

	for slot = 1, 30 do
		local slotFolder = base:FindFirstChild("slot "..slot.." brainrot")
		if slotFolder then
			for _, obj in ipairs(slotFolder:GetChildren()) do
				if obj.Name ~= "Root" then
					table.insert(values, "Slot "..slot.." : "..obj.Name)
				end
			end
		end
	end

	return (#values > 0) and values or { "No Brainrot" }
end

local BrainrotDropdown = MainTab:Dropdown({
	Title = "Select Brainrot",
	Values = getBrainrotValues(),
	Callback = function(selected)
		SelectedBrainrot = selected
		print("Selected:", selected)
	end
})

-- ===== TOGGLE AUTO UPGRADE =====
MainTab:Toggle({
	Title = "Auto Upgrade",
	Callback = function(state)
		AutoUpgrade = state
		print("Auto Upgrade:", state)
	end
})

-- ===== REAL-TIME DROPDOWN UPDATE =====
local lastHash = ""

RunService.Heartbeat:Connect(function()
	local values = getBrainrotValues()
	local hash = table.concat(values, "|")

	if hash ~= lastHash then
		lastHash = hash
		BrainrotDropdown:Refresh(values)
	end
end)

-- ===== AUTO UPGRADE LOOP =====
task.spawn(function()
	while task.wait(2) do
		if not AutoUpgrade then continue end
		if not SelectedBrainrot then continue end

		-- แยก slot จากข้อความ Dropdown
		local slot = SelectedBrainrot:match("Slot%s+(%d+)")
		if not slot then continue end

		local uuid = getMyBaseAndUUID()
		if not uuid then continue end

		pcall(function()
			PlotAction:InvokeServer(
				"Upgrade Brainrot",
				uuid,
				tostring(slot)
			)
		end)
	end
end)



local localPlayer = Players.LocalPlayer
getgenv().SPEED_VALUE = 500
getgenv().SPEED_ON = false

task.spawn(function()
    while true do
        if getgenv().SPEED_ON then
            localPlayer:SetAttribute("CurrentSpeed", getgenv().SPEED_VALUE)
        end
        task.wait(0.1)
    end
end)





local FarmTab = Window:Tab({Title = "FARM", Icon = "botid"})


FarmTab:Dropdown({
	Title = "Select Zone Farm",
	Desc = "เลือกโซนที่จะฟาม",
	Values = BrainrotValues,
	Multi = true,
	AllowNone = true,
	Callback = function(selected)
		for k in pairs(SelectedFolders) do
			SelectedFolders[k] = false
		end
		for _, name in ipairs(selected) do
			SelectedFolders[name] = true
		end
	end
})

FarmTab:Toggle({
	Title = "AutoFarm",
	Value = false,
	Callback = function(state)
		AutoFarmEnabled = state
	end
})

RunService.Heartbeat:Connect(function()
	if not hrp or not hrp.Parent then return end
	if not AutoFarmEnabled then
		return
	end
	local evading = checkHazard()
	autoFirePrompts()

	if evading then return end
	local maxCarry = getMaxCarry()
	if maxCarry > 0 and countRendered() >= maxCarry then
		tweenTo(FINAL_CFRAME)
		return
	end

	local target, dist = getNearestRendered()
	if target and not busyEvade then
		tweenTo(target.CFrame, dist)
	end
end)





local WaveTab = Window:Tab({Title = "Wave", Icon = "user"})


local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Variables
local currentCharacter = nil
local altCharacter = nil
local followLoop = nil
local frozen = false

-- 🔵 Blue Highlight
local realHighlight = Instance.new("Highlight")
realHighlight.FillColor = Color3.fromRGB(0,170,255)
realHighlight.OutlineColor = Color3.fromRGB(255,255,255)
realHighlight.FillTransparency = 0.4
realHighlight.Enabled = false
realHighlight.Parent = workspace

-- Clone character
local function cloneCharacter(original)
	local NewHead=nil
	local fake=Instance.new("Model")
	fake.Name="AltCharacter"

	for _,child in ipairs(original:GetChildren()) do
		pcall(function()
			local c=child:Clone()
			if not NewHead and c.Name=="Head" then
				NewHead=c
			end
			c.Parent=fake
		end)
	end

	for _,child in ipairs(fake:GetChildren()) do
		pcall(function()
			if child:IsA("Accessory") and child:FindFirstChild("Handle") and NewHead then
				for _,w in ipairs(child.Handle:GetChildren()) do
					if w:IsA("Weld") then
						w.Part1=NewHead
					end
				end
			end
		end)
	end

	fake.PrimaryPart=fake:WaitForChild("HumanoidRootPart")
	return fake
end

local function setCharacter(char)
	player.Character = char
	workspace.CurrentCamera.CameraSubject = char:WaitForChild("Humanoid")
end

local function setCollision(model,val)
	for _,p in pairs(model:GetDescendants()) do
		if p:IsA("BasePart") then
			p.CanCollide = val
		end
	end
end

local function anchorModel(model,val)
	for _,p in pairs(model:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Anchored = val
		end
	end
end

-- 🔥 Reset system (when dying)
local function resetFake()
	if followLoop then
		followLoop:Disconnect()
		followLoop = nil
	end

	if altCharacter then
		altCharacter:Destroy()
		altCharacter = nil
	end

	realHighlight.Enabled = false
	realHighlight.Adornee = nil
	frozen = false
end

-- When player respawns
player.CharacterAdded:Connect(function(newChar)
	currentCharacter = newChar
	resetFake()
end)

---------------------------------------------------
-- 🔥 WaveTab Toggle (bottom of script)
---------------------------------------------------

WaveTab:Toggle({
	Title = "Fake Character",
	Desc = "Switch between real and fake character",
	Default = false,
	Callback = function(state)

		if state then
			-- Always get latest character
			currentCharacter = player.Character or player.CharacterAdded:Wait()

			if altCharacter then
				altCharacter:Destroy()
				altCharacter = nil
			end

			-- Create new fake
			altCharacter = cloneCharacter(currentCharacter)
			altCharacter.Parent = workspace
			altCharacter:PivotTo(currentCharacter.PrimaryPart.CFrame)

			setCollision(currentCharacter,false)
			setCollision(altCharacter,true)
			setCharacter(altCharacter)

			anchorModel(currentCharacter,true)
			frozen = true

			realHighlight.Adornee = currentCharacter
			realHighlight.Enabled = true

			local angle = math.rad(90)

			followLoop = RunService.RenderStepped:Connect(function()
				if altCharacter and currentCharacter then
					local cf = altCharacter.PrimaryPart.CFrame
						* CFrame.new(0,-10,0)
						* CFrame.Angles(angle,0,0)

					currentCharacter:PivotTo(cf)
				end
			end)

		else
			if not altCharacter then return end

			currentCharacter:PivotTo(altCharacter.PrimaryPart.CFrame)
			setCharacter(currentCharacter)
			setCollision(currentCharacter,true)

			anchorModel(currentCharacter,false)
			frozen = false

			if followLoop then
				followLoop:Disconnect()
				followLoop = nil
			end

			altCharacter:Destroy()
			altCharacter = nil

			realHighlight.Enabled = false
			realHighlight.Adornee = nil
		end
	end
})





WaveTab:Button({
    Title = "Tween Gap UI",
    Desc = "กดแล้วจะมีหน้าต่างสคริปเสริมขึ้นมา",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/reothebest13-art/ERROR-HUB/refs/heads/main/Gaptween"))()
    end
})

WaveTab:Toggle({
    Title = "There are 2-3 lives",
    Desc = "มี2-3ชีวิต",
    Default = false,
    Callback = function(state)
        AntiWaveEnabled = state
        ClearConnections()

        if state then
            if lp.Character then
                AntiWaveInfinite(lp.Character)
            end

            table.insert(Connections,
                lp.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if AntiWaveEnabled then
                        AntiWaveInfinite(char)
                    end
                end)
            )
        end
    end
})


local ESPTab = Window:Tab({Title = "ESP", Icon = "eye"})


ESPTab:Section({
    Title = "มันบัคอยู่เดะเพิ่มให้ทีหลัง"
})



local CombatTab = Window:Tab({Title = "Combat", Icon = "swords"})


CombatTab:Toggle({
    Title = "Hit Long",
    Desc = "ตีไกล",
    Value = false,
    Callback = function(state)
        HitLongEnabled = state
        for _, tool in ipairs(bp:GetChildren()) do
            applyHitbox(tool)
        end
    end
})

CombatTab:Toggle({
    Title = "Show hit range",
    Desc = "โชว์ระยะการตี",
    Value = false,
    Callback = function(state)
        ShowRangeEnabled = state
        for _, tool in ipairs(bp:GetChildren()) do
            applyVisual(tool)
        end
    end
})

CombatTab:Slider({
    Title = "hit range Value",
    Desc = "ปรับระยะการตี",
    Value = { Min = 10, Max = 200, Default = 50 },
    Step = 1,
    Callback = function(value)
        HitRangeValue = value

        for _, tool in ipairs(bp:GetChildren()) do
            if HitLongEnabled then
                applyHitbox(tool)
            end

            if ShowRangeEnabled then
                local box = tool:FindFirstChild("BoxVisual")
                if box then
                    box.Size = Vector3.new(value, value, value)
                end
            end
        end
    end
})



local AutoClickConnection = nil

CombatTab:Toggle({
    Title = "Auto Hit (Click screen)",
    Desc = "ออโต้ตี (แบบคลิกหน้าจอ)",
    Default = false,
    Callback = function(state)
        if state then
            AutoClickConnection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                    VirtualUser:Button1Up(Vector2.new(1280, 672))
                end)
            end)
        else
            if AutoClickConnection then
                AutoClickConnection:Disconnect()
                AutoClickConnection = nil
            end
        end
    end
})
