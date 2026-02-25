
--// =========================
--// LOAD WINDUI
--// =========================
local WindUI = loadstring(game:HttpGet(
"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local player = game.Players.LocalPlayer


local BLUE   = Color3.fromHex("#3BA9FF")
local SKY    = Color3.fromHex("#6FD3FF")
local YELLOW = Color3.fromHex("#FFD93B")
local WHITE  = Color3.fromHex("#FFFFFF")

local DARK_BG1 = Color3.fromHex("#0A1628")
local DARK_BG2 = Color3.fromHex("#0F223F")

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
    Title = "RICK HUB [ Prison life ]",
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
    Radius = 5,
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



local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local RS = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")


-- CONFIG

local buffEnabled = false
local ESP_Name = false
local ESP_Health = false
local ESP_Distance = false
local ESP_Highlight = false

local TEXT_SIZE = 12






-- ----
-- ฟังชั่นบัพปืน
-- -------

local function BuffGun(tool)
    if not buffEnabled then return end
    if tool:IsA("Tool") then
        task.wait(0.1)
        tool:SetAttribute("AutoFire", true)
        tool:SetAttribute("FireRate", 0.001)
        tool:SetAttribute("Damage", 999)
        tool:SetAttribute("IsReloading", false)
    end
end

local function ClearBuff(tool)
    if tool:IsA("Tool") then
        task.wait(0.1)
        tool:SetAttribute("AutoFire", false)
        tool:SetAttribute("FireRate", nil)
        tool:SetAttribute("Damage", nil)
        tool:SetAttribute("IsReloading", nil)
    end
end

local function HandleBuffOnTool(tool)
    if buffEnabled then
        BuffGun(tool)
    else
        ClearBuff(tool)
    end
end

local function ConnectCharacter(char)
    char.ChildAdded:Connect(HandleBuffOnTool)
end

local Players = game:GetService("Players")
local plr = Players.LocalPlayer

plr.CharacterAdded:Connect(function(char)
    ConnectCharacter(char)
end)

if plr.Character then
    ConnectCharacter(plr.Character)
end

for _, tool in pairs(plr.Backpack:GetChildren()) do
    HandleBuffOnTool(tool)
end

plr.Backpack.ChildAdded:Connect(HandleBuffOnTool)


-- ====
-- esp
-- ===



local ESP_FOLDER = Instance.new("Folder")
ESP_FOLDER.Name = "ESP_FOLDER"
ESP_FOLDER.Parent = CoreGui

--// สีทีม
local function getTeamColor(player)
    if player.Team and player.TeamColor then
        return player.TeamColor.Color
    end
    return Color3.fromRGB(255,255,255)
end

--// สีเลือด
local function getHealthColor(hp, maxHp)
    local percent = hp / maxHp
    if percent > 0.6 then
        return Color3.fromRGB(0,255,0)
    elseif percent > 0.3 then
        return Color3.fromRGB(255,255,0)
    else
        return Color3.fromRGB(255,0,0)
    end
end

--// Create ESP
local function createESP(player)
    if player == LocalPlayer then return end

    local function onCharacter(char)
        local hum = char:WaitForChild("Humanoid",5)
        local root = char:WaitForChild("HumanoidRootPart",5)
        local head = char:WaitForChild("Head",5)
        if not hum or not root or not head then return end

        -- Highlight
        local hl = Instance.new("Highlight")
        hl.Adornee = char
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.Enabled = false
        hl.Parent = ESP_FOLDER

        -- Name + HP
        local nameGui = Instance.new("BillboardGui")
        nameGui.Adornee = head
        nameGui.Size = UDim2.new(0,200,0,45)
        nameGui.StudsOffset = Vector3.new(0,2.5,0)
        nameGui.AlwaysOnTop = true
        nameGui.Parent = ESP_FOLDER

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1,0,0,20)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextSize = TEXT_SIZE
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Parent = nameGui

        local hpLabel = Instance.new("TextLabel")
        hpLabel.Position = UDim2.new(0,0,0,20)
        hpLabel.Size = UDim2.new(1,0,0,20)
        hpLabel.BackgroundTransparency = 1
        hpLabel.TextSize = TEXT_SIZE
        hpLabel.Font = Enum.Font.SourceSans
        hpLabel.TextStrokeTransparency = 0
        hpLabel.Parent = nameGui

        -- Distance
        local distGui = Instance.new("BillboardGui")
        distGui.Adornee = root
        distGui.Size = UDim2.new(0,200,0,20)
        distGui.StudsOffset = Vector3.new(0,-3,0)
        distGui.AlwaysOnTop = true
        distGui.Parent = ESP_FOLDER

        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1,0,1,0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextSize = TEXT_SIZE
        distLabel.Font = Enum.Font.SourceSans
        distLabel.TextStrokeTransparency = 0
        distLabel.TextColor3 = Color3.new(1,1,1)
        distLabel.Parent = distGui

        -- Update
        RunService.RenderStepped:Connect(function()
            if not char.Parent or hum.Health <= 0 then
                nameGui:Destroy()
                distGui:Destroy()
                hl:Destroy()
                return
            end

            local teamColor = getTeamColor(player)
            local hp = math.floor(hum.Health)

            -- Name (สีทีม)
            nameLabel.Visible = ESP_Name
            nameLabel.TextColor3 = teamColor

            -- HP (สีตามเลือด)
            hpLabel.Visible = ESP_Health
            hpLabel.Text = "HP: "..hp
            hpLabel.TextColor3 = getHealthColor(hp, hum.MaxHealth)

            -- Distance
            distGui.Enabled = ESP_Distance
            if ESP_Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                distLabel.Text = math.floor(dist).." m"
            end

            -- Highlight (สีทีม)
            hl.Enabled = ESP_Highlight
            hl.FillColor = teamColor
            hl.OutlineColor = teamColor
        end)
    end

    if player.Character then
        onCharacter(player.Character)
    end
    player.CharacterAdded:Connect(onCharacter)
end

--// Init
for _,plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end
Players.PlayerAdded:Connect(createESP)



-- -----------
-- ESPGUN
-- -----------

local WEAPONS = {
    ["M9"] = "rbxassetid://121771988549115",
    ["Remington 870"] = "rbxassetid://80406360248544",
    ["MP5"] = "rbxassetid://95606011187656",
}

local ESPGUNEnabled = false
local BillboardCache = {}

local function clearESPGUN(player)
    if BillboardCache[player] then
         BillboardCache[player]:Destroy()
         BillboardCache[player] = nil
    end
end

local function clearAllESPGUN()
    for _, p in ipairs(Players:GetPlayers()) do
        clearESPGUN(p)
    end
end

local function updateESPGUN(player)
    -- ถ้าปิดอยู่ให้ลบทิ้งทันที
    if not ESPGUNEnabled then
        clearESPGUN(player)
        return
    end
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    clearESPGUN(player)

    local tools = {}
    if player:FindFirstChild("Backpack") then
        for _, t in ipairs(player.Backpack:GetChildren()) do
            if t:IsA("Tool") and WEAPONS[t.Name] then table.insert(tools, t) end
        end
    end
    for _, t in ipairs(player.Character:GetChildren()) do
        if t:IsA("Tool") and WEAPONS[t.Name] then table.insert(tools, t) end
    end

    if #tools == 0 then return end
    local gui = Instance.new("BillboardGui")
    gui.Name = "ESPGUN"
    gui.Adornee = hrp
    gui.Size = UDim2.new(0, 120, 0, 28)
    gui.StudsOffset = Vector3.new(0, -5, 0)
    gui.AlwaysOnTop = true
    gui.Parent = player.Character

    local layout = Instance.new("UIListLayout", gui)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    for _, tool in ipairs(tools) do
        local img = Instance.new("ImageLabel", gui)
        img.Size = UDim2.new(0, 22, 0, 22)
        img.BackgroundColor3 = Color3.fromRGB(35,35,35)
        img.BackgroundTransparency = 0.1
        img.Image = WEAPONS[tool.Name]

        Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke", img)
        if tool.Parent == player.Character then
            stroke.Color = Color3.fromRGB(0,170,255)
            stroke.Thickness = 2
        else
            stroke.Transparency = 1
        end
    end

    BillboardCache[player] = gui
end

-- LOOP
RunService.Heartbeat:Connect(function()
    if not ESPGUNEnabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            updateESPGUN(p)
        end
    end
end)

Players.PlayerRemoving:Connect(clearESPGUN)





-- ----------
-- walkspeed
-- ----------


-- Settings
local Body = {
    WalkSpeed = {
        Enabled = false,
        Value = 16,
        Default = 16
    }
}

local function UpdateBody()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.WalkSpeed = Body.WalkSpeed.Enabled
        and Body.WalkSpeed.Value
        or Body.WalkSpeed.Default
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    UpdateBody()
end)

RunService.Heartbeat:Connect(function()
    if Body.WalkSpeed.Enabled then
        UpdateBody()
    end
end)


-- ------------
--  Jump power
-- ------------


local jumpEnabled = false
local jumpPowerValue = 50
local jumpLoop = nil


local function toggleHighJump(on)
    jumpEnabled = on
    if jumpLoop then
        jumpLoop:Disconnect()
        jumpLoop = nil
    end
    if on then
        jumpLoop = RunService.Heartbeat:Connect(function()
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true  -- เปิดใช้ Jump Power
                hum.JumpPower = jumpPowerValue  -- ตั้งค่าแรงกระโดด
            end
        end)
    end
end


-- -----------
--  Noclip 
-- -----------

local frontNoclip = false
local radius = 6
local trackedParts = {}

local function applyNoclip()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- ค้นหาส่วนต่างๆ ในรัศมีที่กำหนด
    local parts = workspace:GetPartBoundsInRadius(root.Position, radius)
    local currentParts = {}

    for _, part in pairs(parts) do
        if part:IsA("BasePart") and part ~= root then
            -- ตรวจสอบว่าส่วนนั้นอยู่ใต้เท้าหรือไม่
            local underFoot = part.Position.Y + part.Size.Y/2 < root.Position.Y
            if not underFoot then
                -- ปิดการชน
                part.CanCollide = false
                trackedParts[part] = true
                currentParts[part] = true
            end
        end
    end
    for part,_ in pairs(trackedParts) do
        if not currentParts[part] then
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
            trackedParts[part] = nil
        end
    end
end

local accumulator = 0
RunService.RenderStepped:Connect(function(dt)
    if not frontNoclip then return end
    accumulator = accumulator + dt
    if accumulator >= 0.12 then
        applyNoclip()
        accumulator = 0
    end
end)


-- -------------------------
-- flybypss by DayToDay 2044
-- -------------------------

local API_Bypass = getgenv()
API_Bypass["_CR.DayToDay2044_Fly"] = API_Bypass["_CR.DayToDay2044_Fly"] or false
API_Bypass["_CR.DayToDay2044_Speed"] = API_Bypass["_CR.DayToDay2044_Speed"] or 100

loadstring(game:HttpGet("https://raw.githubusercontent.com/SUNRTX22/What_happen_dafak/refs/heads/main/Fly_API"))()





local Tab = Window:Tab({Title = "MAIN", Icon = "list"})



Tab:Toggle({
    Title = "Buff ปืน",
    Desc = "ทำให้ปืนยิงรัว",
    Value = false,
    Callback = function(v)
        buffEnabled = v
        
        for _, tool in pairs(plr.Backpack:GetChildren()) do
            HandleBuffOnTool(tool)
        end
        
        if plr.Character then
            for _, tool in pairs(plr.Character:GetChildren()) do
                HandleBuffOnTool(tool)
            end
        end
    end
})



local hitboxEnabled = false
local sizeMultiplier = 2 
local boxTransparency = 0.7

game:GetService('RunService').RenderStepped:Connect(function()
    if not hitboxEnabled then return end

    local localPlayer = game:GetService('Players').LocalPlayer
    for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Team ~= localPlayer.Team then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                rootPart.Size = Vector3.new(sizeMultiplier, sizeMultiplier, sizeMultiplier)
                rootPart.Transparency = boxTransparency
                rootPart.BrickColor = player.TeamColor
                rootPart.Material = Enum.Material.Neon
                rootPart.CanCollide = false
            end
        end
    end
end)

Tab:Toggle({
    Title = "ขยายฮิตบล็อก",
    Value = false,
    Callback = function(state) 
        hitboxEnabled = state
        if not state then
            for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rp = player.Character.HumanoidRootPart
                    rp.Size = Vector3.new(2, 2, 1)
                    rp.Transparency = 1 
                    rp.Material = Enum.Material.Plastic
                    rp.CanCollide = true
                end
            end
        end
    end
})

Tab:Slider({
    Title = "ปรับขนาดฮิตบล็อก",
    Step = 1,
    Value = {
        Min = 2,
        Max = 15,
        Default = 2,
    },
    Callback = function(value)
        sizeMultiplier = value
    end
})



local EspTab = Window:Tab({Title = "ESP", Icon = "eye"})

EspTab:Toggle({
    Title = "ESP Name",
    Value = false,
    Callback = function(v)
        ESP_Name = v
    end
})

EspTab:Toggle({
    Title = "ESP Health",
    Value = false,
    Callback = function(v)
        ESP_Health = v
    end
})

EspTab:Toggle({
    Title = "ESP Distance",
    Value = false,
    Callback = function(v)
        ESP_Distance = v
    end
})

EspTab:Toggle({
    Title = "ESP Highlight",
    Value = false,
    Callback = function(v)
        ESP_Highlight = v
    end
})


EspTab:Toggle({
    Title = "ESP Gun player",
    Desc = "มองปืนในตัวอะ",
    Default = false,
    Callback = function(state)
        ESPGUNEnabled = state
        if not state then
            -- สั่งล้างทุกอย่างทิ้งทันทีเมื่อกดปิด
            clearAllESPGUN()
        end
    end
})



local bodyTab = Window:Tab({Title = "Body", Icon = "dna"})

bodyTab:Toggle({
    Title = "วิ่งเร็ว",
    Default = false,
    Callback = function(state)
        Body.WalkSpeed.Enabled = state
        UpdateBody()
    end
})


bodyTab:Slider({
    Title = "Speed Value",
    Desc = "ปรับความเร็วเดิน",
    Step = 1,
    Value = {
        Min = 16,
        Max = 120,
        Default = 16
    },
    Callback = function(value)
        Body.WalkSpeed.Value = value
        UpdateBody()
    end
})


bodyTab:Toggle({
    Title = "กระโดดสูง",
    Default = false,
    Callback = function(v)
        toggleHighJump(v)
    end
})


bodyTab:Slider({
    Title = "ปรับความสูงในการกระโดด",
    Step = 5,
    Value = {
        Min = 50,
        Max = 500,
        Default = 50
    },
    Callback = function(v)
        jumpPowerValue = tonumber(v) or 50
    end
})


bodyTab:Toggle({
    Title = "ทะลุกำแพง",
    Callback = function(state)
        frontNoclip = state
        if not frontNoclip then
            for part,_ in pairs(trackedParts) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            trackedParts = {}
        end
    end
})



bodyTab:Toggle({
    Title = "บินบายพาส",
    Default = API_Bypass["_CR.DayToDay2044_Fly"],
    Callback = function(v)
        API_Bypass["_CR.DayToDay2044_Fly"] = v
    end
})

bodyTab:Slider({
    Title = "ปรับความเร็วในการบิน",
    Step = 1,
    Value = {
        Min = 1,
        Max = 500,
        Default = API_Bypass["_CR.DayToDay2044_Speed"]
    },
    Callback = function(v)
        API_Bypass["_CR.DayToDay2044_Speed"] = tonumber(v) or 100
    end
})
