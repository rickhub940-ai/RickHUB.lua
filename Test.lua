local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- UI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RickHubUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- เฟรมหลัก (ลากได้)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,260,0,140)
mainFrame.Position = UDim2.new(0.5,-130,0.5,-70) -- กลางจอ
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- มุมโค้ง
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- แถบบน (ใช้ลาก)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,35)
topBar.BackgroundColor3 = Color3.fromRGB(0,170,255)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,12)

-- ชื่อ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "RICK HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = topBar

-- ปุ่มสลับ
local switchButton = Instance.new("TextButton")
switchButton.Size = UDim2.new(0.8,0,0,45)
switchButton.Position = UDim2.new(0.1,0,0.55,0)
switchButton.BackgroundColor3 = Color3.fromRGB(50,150,255)
switchButton.TextColor3 = Color3.fromRGB(255,255,255)
switchButton.TextSize = 18
switchButton.Font = Enum.Font.GothamBold
switchButton.Text = "Godmode"
switchButton.Parent = mainFrame
Instance.new("UICorner", switchButton).CornerRadius = UDim.new(0,10)

-- ระบบลาก UI
local dragging=false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging=true
		dragStart=input.Position
		startPos=mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				dragging=false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement 
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput=input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input==dragInput and dragging then
		update(input)
	end
end)

-- ==============================
-- ระบบสลับตัวละครเดิม
-- ==============================

local currentCharacter = player.Character or player.CharacterAdded:Wait()
local altCharacter = nil
local followLoop = nil
local frozen = false

-- highlight
local realHighlight = Instance.new("Highlight")
realHighlight.FillColor = Color3.fromRGB(0,170,255)
realHighlight.OutlineColor = Color3.fromRGB(255,255,255)
realHighlight.FillTransparency = 0.4
realHighlight.Enabled = false
realHighlight.Parent = workspace

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
	player.Character=char
	workspace.CurrentCamera.CameraSubject=char:WaitForChild("Humanoid")
end

local function setCollision(model,val)
	for _,p in pairs(model:GetDescendants()) do
		if p:IsA("BasePart") then
			p.CanCollide=val
		end
	end
end

local function anchorModel(model,val)
	for _,p in pairs(model:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Anchored=val
		end
	end
end

switchButton.MouseButton1Click:Connect(function()

	if player.Character==currentCharacter then
		if altCharacter then altCharacter:Destroy() end

		altCharacter=cloneCharacter(currentCharacter)
		altCharacter.Parent=workspace
		altCharacter:SetPrimaryPartCFrame(currentCharacter.PrimaryPart.CFrame)

		setCollision(currentCharacter,false)
		setCollision(altCharacter,true)
		setCharacter(altCharacter)

		anchorModel(currentCharacter,true)
		frozen=true

		realHighlight.Adornee=currentCharacter
		realHighlight.Enabled=true

		local angle=math.rad(90)

		followLoop=RunService.RenderStepped:Connect(function()
			if altCharacter and currentCharacter then
				local cf=altCharacter.PrimaryPart.CFrame
					* CFrame.new(0,-7,0)
					* CFrame.Angles(angle,0,0)

				currentCharacter:PivotTo(cf)
			end
		end)

	else
		if not altCharacter then return end

		currentCharacter:PivotTo(altCharacter.PrimaryPart.CFrame)
		setCharacter(currentCharacter)
		setCollision(currentCharacter,true)

		if frozen then
			anchorModel(currentCharacter,false)
			frozen=false
		end

		if followLoop then
			followLoop:Disconnect()
			followLoop=nil
		end

		altCharacter:Destroy()
		altCharacter=nil

		realHighlight.Enabled=false
		realHighlight.Adornee=nil
	end
end)
