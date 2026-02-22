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
    Title = "RICK HUB [ Abyss Beta ]",
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


-- ---------
--   เซอร์วิส
-- ----------

local client = workspace.Game.Fish.client
local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")




-- ---------
-- AutoFarm
-- ---------

-- =========================================
-- SERVICES
-- =========================================


-- =========================================
-- SERVICES
-- =========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- =========================================
-- FILE SYSTEM (RickhubAbyss_ชื่อผู้เล่นpos.json)
-- =========================================
local fileName = "RickhubAbyss_" .. player.Name .. "pos.json"

local function SaveToJSON(pos)
    local data = { x = pos.X, y = pos.Y, z = pos.Z }
    local success, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if success then
        writefile(fileName, encoded)
    end
end

local function LoadFromJSON()
    if isfile(fileName) then
        local success, content = pcall(function() return readfile(fileName) end)
        if success then
            local data = HttpService:JSONDecode(content)
            return Vector3.new(data.x, data.y, data.z)
        end
    end
    return nil
end

-- =========================================
-- GLOBAL SETTINGS
-- =========================================
_G.FarmEnabled = false
_G.PositionMode = false
_G.SelectedFish = "All - ทุกตัว"
_G.ShootRange = 40
_G.TweenSpeed = 50 
_G.SingleSavedPos = LoadFromJSON()
_G.FollowDelay = 0.8 

local fishFolder = workspace:WaitForChild("Game"):WaitForChild("Fish"):WaitForChild("client")

-- =========================================
-- FUNCTIONS: MOVEMENT & TARGETING
-- =========================================
local function TweenTo(position)
    if not root then return end
    local distance = (root.Position - position).Magnitude
    if distance < 5 then return end 

    local duration = distance / _G.TweenSpeed
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)})
    tween:Play()
    return tween
end

local function GetClosestFish()
    local closest, dist = nil, math.huge
    for _, fish in pairs(fishFolder:GetChildren()) do
        if fish:IsA("Model") and fish.PrimaryPart then
            local canTarget = false
            if _G.SelectedFish == "All - ทุกตัว" then
                canTarget = true
            else
                pcall(function()
                    local actualName = fish.Head.stats.Fish.Text
                    if actualName and string.find(string.lower(tostring(actualName)), string.lower(tostring(_G.SelectedFish))) then 
                        canTarget = true 
                    end
                end)
            end
            if canTarget then
                local mag = (root.Position - fish.PrimaryPart.Position).Magnitude
                if mag < dist then dist = mag; closest = fish end
            end
        end
    end
    return closest
end

local function ShootAt(fish)
    local tool = player.Character:FindFirstChildOfClass("Tool")
    local event = tool and tool:FindFirstChild("Event")
    if event and fish.PrimaryPart then
        local targetPos = fish.PrimaryPart.Position
        root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
        local direction = (targetPos - root.Position).Unit
        event:FireServer("use", targetPos, direction)
    end
end

-- =========================================
-- MAIN LOOP
-- =========================================
task.spawn(function()
    local lastFollowTime = 0
    while task.wait(0.1) do
        if not _G.FarmEnabled or not root then continue end

        if _G.PositionMode and _G.SingleSavedPos then
            if (root.Position - _G.SingleSavedPos).Magnitude > 3 then
                local t = TweenTo(_G.SingleSavedPos)
                if t then t.Completed:Wait() end
            end
        end

        local target = GetClosestFish()
        if not target or not target.PrimaryPart then continue end

        while _G.FarmEnabled and target and target.Parent and target.PrimaryPart do
            local targetPos = target.PrimaryPart.Position
            local distance = (root.Position - targetPos).Magnitude

            if _G.PositionMode and _G.SingleSavedPos then
                if (root.Position - _G.SingleSavedPos).Magnitude > 5 then
                    root.CFrame = CFrame.new(_G.SingleSavedPos)
                end
            else
                if distance > _G.ShootRange then
                    local stopPos = targetPos + (root.Position - targetPos).Unit * 20
                    TweenTo(stopPos)
                elseif distance > 15 then
                    if tick() - lastFollowTime >= _G.FollowDelay then
                        local followPos = targetPos + (root.Position - targetPos).Unit * 18
                        root.CFrame = root.CFrame:Lerp(CFrame.new(followPos), 0.1)
                        lastFollowTime = tick()
                    end
                end
                if distance < 10 then
                    root.CFrame = root.CFrame * CFrame.new(0, 0, 5)
                end
            end

            ShootAt(target)
            task.wait(0.05) 
            if _G.PositionMode then break end 
        end
    end
end)

-- =========================================
-- UI SECTION (WindUI)
-- =========================================







-- -------
-- esp
-- -------


local ESP_ENABLED = false
local SelectedFish = {}
local ShowInfo = {
    Name = true,
    Distance = true,
    Mutation = true
}

local ESP_LIST = {}

-- ดึงรายชื่อปลา
local function getAllFishNames()
    local list = {"All"}
    local added = {}

    for _,fish in pairs(client:GetChildren()) do
        local head = fish:FindFirstChild("Head")
        if head and head:FindFirstChild("stats") and head.stats:FindFirstChild("Fish") then
            local name = head.stats.Fish.Text
            if not added[name] then
                added[name] = true
                table.insert(list,name)
            end
        end
    end

    table.sort(list,function(a,b)
        if a=="All" then return true end
        if b=="All" then return false end
        return a<b
    end)

    return list
end

local function createESP(fish)
    if not ESP_ENABLED then return end
    if ESP_LIST[fish] then return end

    local head = fish:FindFirstChild("Head")
    local torso = fish:FindFirstChild("UpperTorso")
    if not head or not torso then return end

    local fishName = "???"
    if head:FindFirstChild("stats") and head.stats:FindFirstChild("Fish") then
        fishName = head.stats.Fish.Text
    end

    -- ยังไม่เลือกปลา = ไม่แสดง
    if not next(SelectedFish) then return end

    -- ถ้าไม่ได้เลือก All
    if not SelectedFish["ALL"] then
        if not SelectedFish[fishName] then
            return
        end
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FishESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,115,0,34)
    billboard.StudsOffset = Vector3.new(0,1.9,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fish

    local y = 0

    -- ชื่อปลา
    if ShowInfo.Name then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1,0,0.5,0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = fishName
        nameLabel.TextColor3 = torso.Color
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = billboard
        y = 0.5
    end

    -- mutation
    local mutationText = ""
    local mutationColor = Color3.new(1,1,1)
    local hasMutation = false

    if head:FindFirstChild("stats") and head.stats:FindFirstChild("Mutation") then
        local m = head.stats.Mutation:FindFirstChild("Label")
        if m and m.Text ~= "" then
            mutationText = m.Text
            mutationColor = m.TextColor3
            hasMutation = true
        end
    end

    if hasMutation and ShowInfo.Mutation then
        local mut = Instance.new("TextLabel")
        mut.Size = UDim2.new(1,0,0.3,0)
        mut.Position = UDim2.new(0,0,y,0)
        mut.BackgroundTransparency = 1
        mut.Text = "🧬"..mutationText
        mut.TextColor3 = mutationColor
        mut.TextStrokeTransparency = 0.2
        mut.TextScaled = true
        mut.Font = Enum.Font.SourceSansBold
        mut.Parent = billboard
        y = y + 0.3
    end

    if ShowInfo.Distance then
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1,0,0.3,0)
        distLabel.Position = UDim2.new(0,0,y,0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.new(1,1,1)
        distLabel.TextScaled = true
        distLabel.Font = Enum.Font.SourceSans
        distLabel.Parent = billboard

        task.spawn(function()
            while billboard.Parent do
                task.wait(0.2)
                pcall(function()
                    if Player.Character and Player.Character:FindFirstChild("Head") then
                        local dist = math.floor((Player.Character.Head.Position - head.Position).Magnitude)
                        distLabel.Text = dist.."m"
                    end
                end)
            end
        end)
    end

    ESP_LIST[fish] = {billboard = billboard}
end

local function removeESP(fish)
    if ESP_LIST[fish] then
        ESP_LIST[fish].billboard:Destroy()
        ESP_LIST[fish] = nil
    end
end
local function refreshESP()
    for fish,data in pairs(ESP_LIST) do
        if data.billboard then
            data.billboard:Destroy()
        end
    end
    ESP_LIST = {}

    for _,fish in pairs(client:GetChildren()) do
        createESP(fish)
    end
end



local FarmTab   = Window:Tab({Title="FARM",   Icon="hand-coins"})

FarmTab:Section({ Title = "Auto Farm Settings" })

FarmTab:Toggle({
    Title = "Enable Auto Farm",
    Callback = function(state) _G.FarmEnabled = state end
})

FarmTab:Dropdown({
    Title = "Select Fish",
    Values = Fish_Name_list,
    Callback = function(option) _G.SelectedFish = option end
})

FarmTab:Section({ Title = "Permanent Saved Position" })

-- สร้าง Paragraph
local PosLabel = FarmTab:Paragraph({
    Title = "ข้อมูลตำแหน่ง",
    Content = "ยังไม่มีข้อมูลที่เซฟไว้"
})

-- ฟังก์ชันอัปเดตข้อความ Paragraph (แก้ไขตามเอกสาร WindUI Docs)
local function UpdatePosUI(title, content)
    pcall(function()
        -- WindUI ใช้ SetTitle และ SetContent ในการอัปเดต Paragraph
        if PosLabel.SetTitle then PosLabel:SetTitle(title) end
        if PosLabel.SetContent then PosLabel:SetContent(content) end
    end)
end

-- โหลดข้อมูลครั้งแรกทันทีที่รันสคริปต์
if _G.SingleSavedPos then
    local x, y, z = math.floor(_G.SingleSavedPos.X), math.floor(_G.SingleSavedPos.Y), math.floor(_G.SingleSavedPos.Z)
    UpdatePosUI("โหลดพิกัดสำเร็จ ✅", "📍 ตำแหน่งที่เซฟ : X: "..x.." | Y: "..y.." | Z: "..z)
end

FarmTab:Button({
    Title = "Save Current Position (JSON)",
    Callback = function()
        if root then
            _G.SingleSavedPos = root.Position
            SaveToJSON(_G.SingleSavedPos) 
            
            local x, y, z = math.floor(_G.SingleSavedPos.X), math.floor(_G.SingleSavedPos.Y), math.floor(_G.SingleSavedPos.Z)
            UpdatePosUI("บันทึกสำเร็จ ✅", "📍 ตำแหน่งที่เซฟ : X: " .. x .. " | Y: " .. y .. " | Z: " .. z)
            
            WindUI:Notify({Title = "Success", Content = "บันทึกลงไฟล์เรียบร้อย", Duration = 2})
        end
    end
})

FarmTab:Toggle({
    Title = "Use Saved Position",
    Callback = function(state) _G.PositionMode = state end
})

-- Auto Perfect Catch
pcall(function()
    RunService.Heartbeat:Connect(function()
        local catchBar = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("CatchingBar")
        if catchBar then
            local green = catchBar.Frame.Bar.Catch:FindFirstChild("Green")
            if green and green.Visible then
                green.Size = UDim2.new(1, 0, 1, 0)
                green.Position = UDim2.new(0.5, 0, 0.5, 0)
                green.AnchorPoint = Vector2.new(0.5, 0.5)
                green.BackgroundTransparency = 1
            end
        end
    end)
end)

print("🔥 RickhubAbyss - FIXED ACCURACY & UI")



local ESPTab   = Window:Tab({Title="ESP",   Icon="eye"})

ESPTab:Dropdown({
    Title = "เลือกปลาที่จะมอง",
    Values = getAllFishNames(),
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        SelectedFish = {}

        if table.find(option,"All") then
            SelectedFish["ALL"] = true
        else
            for _,v in pairs(option) do
                SelectedFish[v] = true
            end
        end

        refreshESP()
    end
})


ESPTab:Dropdown({
    Title = "ข้อมูลที่จะแสดง",
    Values = {"ชื่อปลา","ระยะ","การกลายพันธุ์"},
    Multi = true,
    AllowNone = true,
    Callback = function(option)

        ShowInfo.Name = table.find(option,"ชื่อปลา") ~= nil
        ShowInfo.Distance = table.find(option,"ระยะ") ~= nil
        ShowInfo.Mutation = table.find(option,"การกลายพันธุ์") ~= nil

        refreshESP()
    end
})


ESPTab:Toggle({
    Title = "มองปลา",
    Value = false,
    Callback = function(state)
        ESP_ENABLED = state
        refreshESP()
    end
})
client.ChildAdded:Connect(function(fish)
    task.wait(0.3)
    createESP(fish)
end)
client.ChildRemoved:Connect(function(fish)
    removeESP(fish)
end)

