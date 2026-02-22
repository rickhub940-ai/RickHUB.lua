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
-- 1. SETUP & SERVICES
-- =========================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- ระบบไฟล์พิกัด
local fileName = "RickhubAbyss_" .. player.Name .. "pos.json"

local function SaveToJSON(pos)
    pcall(function()
        writefile(fileName, HttpService:JSONEncode({x = pos.X, y = pos.Y, z = pos.Z}))
    end)
end

local function LoadFromJSON()
    local success, result = pcall(function()
        if isfile(fileName) then
            local data = HttpService:JSONDecode(readfile(fileName))
            return Vector3.new(data.x, data.y, data.z)
        end
    end)
    return success and result or nil
end

-- =========================================
-- 2. GLOBAL SETTINGS
-- =========================================
_G.FarmEnabled = false
_G.PositionMode = false
_G.SelectedFish = "All - ทุกตัว"
_G.SingleSavedPos = LoadFromJSON()
_G.ShootRange = 100 -- ระยะการยิง

local Fish_Name_list = {"All - ทุกตัว"}

-- สแกนรายชื่อปลาจาก Models ในเกม
task.spawn(function()
    pcall(function()
        local fishModels = ReplicatedStorage:WaitForChild("Models", 5):WaitForChild("Fish", 5)
        if fishModels then
            for _, v in pairs(fishModels:GetChildren()) do
                if not table.find(Fish_Name_list, v.Name) then
                    table.insert(Fish_Name_list, v.Name)
                end
            end
        end
    end)
end)

-- =========================================
-- 3. CORE FUNCTIONS (ระบบยิง & ระบบฟาร์ม)
-- =========================================

-- ฟังก์ชันหาปลาที่ใกล้ที่สุด
local function GetClosestFish()
    local closest, dist = nil, _G.ShootRange
    local fishFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Fish") and workspace.Game.Fish:FindFirstChild("client")
    
    if fishFolder then
        for _, fish in pairs(fishFolder:GetChildren()) do
            if fish:IsA("Model") and fish.PrimaryPart then
                local isMatch = false
                if _G.SelectedFish == "All - ทุกตัว" then
                    isMatch = true
                else
                    pcall(function()
                        -- ตรวจสอบชื่อปลาจาก UI ใน Head ของปลา
                        local fishNameUI = fish:FindFirstChild("Head") and fish.Head:FindFirstChild("stats") and fish.Head.stats:FindFirstChild("Fish")
                        if fishNameUI and string.find(fishNameUI.Text, _G.SelectedFish) then
                            isMatch = true
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

-- ฟังก์ชันสั่งยิงเบ็ด
local function AutoShoot(target)
    if not target or not target.PrimaryPart then return end
    
    local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
    local event = tool and tool:FindFirstChild("Event")
    
    if event then
        local targetPos = target.PrimaryPart.Position
        -- หันตัวไปหาปลา
        root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
        -- ส่งสัญญาณยิง
        event:FireServer("use", targetPos, (targetPos - root.Position).Unit)
    end
end

-- =========================================
-- 4. UI COMPONENTS (เชื่อมกับ FarmTab เดิม)
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

FarmTab:Section({ Title = "Saved Position Info" })

local PosLabel = FarmTab:Paragraph({
    Title = "ข้อมูลตำแหน่ง",
    Content = "ยังไม่มีข้อมูล"
})

local function UpdateUIInfo()
    if _G.SingleSavedPos then
        local x, y = math.floor(_G.SingleSavedPos.X), math.floor(_G.SingleSavedPos.Y)
        pcall(function()
            if PosLabel.SetTitle then
                PosLabel:SetTitle("โหลดพิกัดสำเร็จ ✅")
                PosLabel:SetContent("📍 ตำแหน่งที่เซฟ : X: "..x.." | Y: "..y)
            else
                PosLabel.Title = "โหลดพิกัดสำเร็จ ✅"
                PosLabel.Content = "📍 ตำแหน่งที่เซฟ : X: "..x.." | Y: "..y
            end
        end)
    end
end
UpdateUIInfo()

FarmTab:Button({
    Title = "Save Current Position (JSON)",
    Callback = function()
        if root then
            _G.SingleSavedPos = root.Position
            SaveToJSON(_G.SingleSavedPos)
            UpdateUIInfo()
            if WindUI and WindUI.Notify then
                WindUI:Notify({Title = "Success", Content = "Saved Position!", Duration = 2})
            end
        end
    end
})

FarmTab:Toggle({
    Title = "Use Saved Position",
    Callback = function(state) _G.PositionMode = state end
})

-- =========================================
-- 5. MAIN LOOPS (ตัวรันระบบ)
-- =========================================

-- ลูปการฟาร์มและการยิง
task.spawn(function()
    while task.wait(0.1) do
        if not _G.FarmEnabled or not root then continue end

        -- ระบบล็อกตำแหน่ง
        if _G.PositionMode and _G.SingleSavedPos then
            if (root.Position - _G.SingleSavedPos).Magnitude > 3 then
                root.CFrame = CFrame.new(_G.SingleSavedPos)
            end
        end

        -- ระบบค้นหาและยิง
        local target = GetClosestFish()
        if target then
            AutoShoot(target)
            task.wait(0.1) -- หน่วงเวลาเล็กน้อยกันกระตุก
        end
    end
end)

-- ระบบ Perfect Catch (ทำงานตลอดถ้า FarmEnabled)
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

print("✅ [FULL SYSTEM] RICKHUB ABYSS LOADED")


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

