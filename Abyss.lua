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
Window:Tag({
    Title = "v1.0.0",
    Icon = "github",
    Color = Color3.fromHex("#00bfff"), -- ฟ้าสด
    Radius = 0,
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
-- 1. SETUP & REFRESH CHARACTER SYSTEM
-- =========================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- ระบบอัปเดตตัวละครเมื่อเกิดใหม่ (แก้บั๊กตายแล้วหยุดทำงาน)
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    root = newChar:WaitForChild("HumanoidRootPart")
end)

local fileName = "RickhubAbyss_" .. player.Name .. "pos.json"

local function SaveToJSON(pos)
    pcall(function()
        writefile(fileName, HttpService:JSONEncode({x = pos.X, y = pos.Y, z = pos.Z}))
    end)
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
-- 2. GLOBAL SETTINGS & MULTI-SELECT FISH
-- =========================================
_G.FarmEnabled = false
_G.PositionMode = false
_G.SelectedFishes = {} -- เปลี่ยนเป็น Table เพื่อเก็บปลาหลายตัว
_G.SingleSavedPos = LoadFromJSON()
_G.TweenSpeed = 70 
_G.WaitDelay = 2

local Fish_Name_list = {} 
pcall(function()
    local fishAssets = ReplicatedStorage:WaitForChild("common"):WaitForChild("assets"):WaitForChild("fish")
    for _, fishModel in pairs(fishAssets:GetChildren()) do
        if fishModel:IsA("Model") then
            table.insert(Fish_Name_list, fishModel.Name)
        end
    end
end)

-- =========================================
-- 3. CORE FUNCTIONS (FIXED)
-- =========================================

local activeTween = nil
local isProcessing = false 

local function TweenTo(position)
    if not root then return end
    local distance = (root.Position - position).Magnitude
    if distance < 3 then 
        if activeTween then activeTween:Cancel() end
        return true 
    end
    
    local info = TweenInfo.new(distance / _G.TweenSpeed, Enum.EasingStyle.Linear)
    if activeTween then activeTween:Cancel() end
    
    activeTween = TweenService:Create(root, info, {CFrame = CFrame.new(position)})
    activeTween:Play()
    return false 
end

local function GetClosestFish()
    local closest, dist = nil, math.huge
    local success, fishFolder = pcall(function()
        return workspace:WaitForChild("Game"):WaitForChild("Fish"):WaitForChild("client")
    end)
    
    if success and fishFolder then
        for _, fish in pairs(fishFolder:GetChildren()) do
            if fish:IsA("Model") and fish.PrimaryPart then
                local isMatch = false
                
                -- ตรวจสอบว่าชื่อปลาตัวนี้อยู่ในรายการที่เลือกไว้หรือไม่
                if #_G.SelectedFishes == 0 then -- ถ้าไม่เลือกอะไรเลย ให้ถือว่าเอาหมด
                    isMatch = true
                else
                    pcall(function()
                        local actualName = fish.Head.stats.Fish.Text
                        for _, selected in pairs(_G.SelectedFishes) do
                            if string.find(string.lower(actualName), string.lower(selected)) then 
                                isMatch = true 
                                break
                            end
                        end
                    end)
                end
                
                if isMatch then
                    local mag = (root.Position - fish.PrimaryPart.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = fish
                    end
                end
            end
        end
    end
    return closest
end

local function AutoShoot(target)
    if not target or not target.PrimaryPart or not character then return end
    local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
    local event = tool and tool:FindFirstChild("Event")
    if event then
        local targetPos = target.PrimaryPart.Position
        root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
        event:FireServer("use", targetPos, (targetPos - root.Position).Unit)
    end
end





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


FarmTab:Section({ Title = "Auto Farm:)" })




FarmTab:Dropdown({
    Title = "เลือกปลาที่จะฟาม",
    Values = Fish_Name_list,
    Default = {},
    Callback = function(selectedList)
        _G.SelectedFishes = selectedList
    end
})

FarmTab:Toggle({
    Title = "ฟามปลาตามที่เลือก",
    Callback = function(state) _G.FarmEnabled = state end
})

FarmTab:Slider({
    Title = "ปรับความเร็วการเคลื่อนที่",
    Step = 1,
    Value = { Min = 20, Max = 300, Default = 70 },
    Callback = function(v) _G.TweenSpeed = v end
})

FarmTab:Section({ Title = "Permanent Position" })

local PosLabel = FarmTab:Paragraph({ Title = "ยังไม่มีข้อมูลพิกัด", Content = "" })

local function UpdateUI()
    if _G.SingleSavedPos then
        local x, y, z = math.floor(_G.SingleSavedPos.X), math.floor(_G.SingleSavedPos.Y), math.floor(_G.SingleSavedPos.Z)
        pcall(function()
            PosLabel:SetTitle("📍พิกัดที่เซฟ: X:"..x.." Y:"..y.." Z:"..z)
        end)
    end
end
UpdateUI()

FarmTab:Button({
    Title = "เซฟตำแหน่ง",
    Callback = function()
        if root then
            _G.SingleSavedPos = root.Position
            SaveToJSON(_G.SingleSavedPos)
            UpdateUI()
        end
    end
})

FarmTab:Toggle({
    Title = "โหมดฟามตามตำแหน่งที่เซฟ",
    Callback = function(state) _G.PositionMode = state end
})


task.spawn(function()
    while task.wait(0.1) do
        if not _G.FarmEnabled or not root or not root.Parent then continue end
        if isProcessing then continue end

        if _G.PositionMode and _G.SingleSavedPos then
            if (root.Position - _G.SingleSavedPos).Magnitude > 3 then
                if activeTween then activeTween:Cancel() end
                root.CFrame = CFrame.new(_G.SingleSavedPos)
            end
        end

        local target = GetClosestFish()
        if target and target.PrimaryPart then
            local targetPos = target.PrimaryPart.Position
            
            if not _G.PositionMode then
                local stopPos = targetPos + (root.Position - targetPos).Unit * 15
                local dist = (root.Position - stopPos).Magnitude
                
                if dist < 8 then
                    if activeTween then activeTween:Cancel() end
                    root.Velocity = Vector3.zero 
                    isProcessing = true
                    
                    task.wait(_G.WaitDelay) -- รอ 2 วิ
                    
                    if _G.FarmEnabled and target and target.Parent and root then
                        AutoShoot(target)
                        task.wait(_G.WaitDelay) -- รออีก 2 วิ ค่อยขยับ
                    end
                    
                    isProcessing = false
                else
                    TweenTo(stopPos)
                end
            else
                AutoShoot(target)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.FarmEnabled then
        pcall(function()
            local catchBar = player.PlayerGui.Main:FindFirstChild("CatchingBar")
            if catchBar and catchBar.Visible then
                local green = catchBar.Frame.Bar.Catch.Green
                green.Size = UDim2.new(1, 0, 1, 0)
                green.BackgroundTransparency = 1
            end
        end)
    end
end)


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

