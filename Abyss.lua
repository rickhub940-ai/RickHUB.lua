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




local character = player.Character or player.CharacterAdded:Wait()

local root
local event


local function setupCharacter(char)
    root = char:WaitForChild("HumanoidRootPart")
    local tool = char:WaitForChild("Tool")
    event = tool:WaitForChild("Event")
end

if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)



_G.FarmEnabled = false
_G.PositionMode = false
_G.SelectedFish = "All - ทุกตัว"
_G.SelectedSlot = nil
_G.ShootRange = 40

_G.SavedPositions = _G.SavedPositions or {
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil
}


local Fish_Name_list = { "All - ทุกตัว" }

pcall(function()
    for _, fishModel in pairs(
        ReplicatedStorage:WaitForChild("common")
        :WaitForChild("assets")
        :WaitForChild("fish")
        :GetChildren()
    ) do
        if fishModel:IsA("Model") and fishModel.PrimaryPart then
            table.insert(Fish_Name_list, fishModel.Name)
        end
    end
end)

local fishFolder = workspace:WaitForChild("Game")
    :WaitForChild("Fish")
    :WaitForChild("client")


local function TweenTo(position)
    if not root then return end

    local distance = (root.Position - position).Magnitude
    local speed = 60
    local time = distance / speed

    local tween = TweenService:Create(
        root,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(position)}
    )

    tween:Play()
    tween.Completed:Wait()
end



local function GetClosestFish()
    if not root then return nil end

    local closest = nil
    local dist = math.huge

    for _, fish in pairs(fishFolder:GetChildren()) do
        local torso = fish:FindFirstChild("UpperTorso")
        if torso then
            if _G.SelectedFish == "All - ทุกตัว" or fish.Name == _G.SelectedFish then
                local mag = (root.Position - torso.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = fish
                end
            end
        end
    end

    return closest
end

local function ShootFish(fish)
    if not event then return end

    local torso = fish:FindFirstChild("UpperTorso")
    if torso then
        event:FireServer(
            "use",
            torso.Position,
            torso.CFrame.LookVector
        )
    end
end


task.spawn(function()
    while task.wait(0.1) do

        if not _G.FarmEnabled then continue end
        if not root or not event then continue end

        local target = GetClosestFish()
        if not target then continue end

        local torso = target:FindFirstChild("UpperTorso")
        if not torso then continue end

        local distance = (root.Position - torso.Position).Magnitude

        if _G.PositionMode and _G.SelectedSlot and _G.SavedPositions[_G.SelectedSlot] then

            TweenTo(_G.SavedPositions[_G.SelectedSlot])

            if distance <= _G.ShootRange then
                ShootFish(target)
            end

            else
            if distance > _G.ShootRange then
                TweenTo(torso.Position)
            else
                ShootFish(target)
            end
        end

    end
end)







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


FarmTab:Dropdown({
    Title = "เลือกปลาที่จะฟาม",
    Values = Fish_Name_list,
    Multi = false,
    Callback = function(option)
        _G.SelectedFish = option
    end
})


FarmTab:Toggle({
    Title = "ฟามปลา",
    Default = false,
    Callback = function(state)
        _G.FarmEnabled = state
    end
})


local function UpdateDropdown()
    local values = {}

    for i = 1,5 do
        if _G.SavedPositions[i] then
            local pos = _G.SavedPositions[i]
            table.insert(values, i .. ": " ..
                math.floor(pos.X) .. ", " ..
                math.floor(pos.Y) .. ", " ..
                math.floor(pos.Z))
        else
            table.insert(values, i .. ":")
        end
    end

    PositionDropdown:SetValues(values)
end

PositionDropdown = FarmTab:Dropdown({
    Title = "เลือกสล็อต/ตำแหน่ง",
    Values = {"1:","2:","3:","4:","5:"},
    Multi = false,
    Callback = function(option)
        local number = tonumber(string.match(option, "%d+"))
        _G.SelectedSlot = number
    end
})

FarmTab:Toggle({
    Title = "โหมดฟามตามตำแหน่งที่เซฟ",
    Default = false,
    Callback = function(state)
        _G.PositionMode = state
    end
})




FarmTab:Button({
    Title = "เซฟตำแหน่งฟาม",
    Callback = function()

        if not _G.SelectedSlot then
            WindUI:Notify({
                Title = "Warning",
                Content = "🛸เลือกสล็อตที่จะเซฟก่อน!!!",
                Duration = 3,
            })
            return
        end

        _G.SavedPositions[_G.SelectedSlot] = root.Position
        UpdateDropdown()

        WindUI:Notify({
            Title = "Saved",
            Content = "บันทึกตำแหน่ง ลง Slot " .. _G.SelectedSlot .. " เรียบร้อย",
            Duration = 2,
        })

    end
})



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

