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
    Title = "RICK HUB [ Build A Boat for Treasure ]",
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




local player = game.Players.LocalPlayer




-- -------------
--  ฟาทตังค์
-- -------------





local AutoFarm = false
local root
local reachedChest = false
local function setupCharacter(character)
    root = character:WaitForChild("HumanoidRootPart")
    if AutoFarm and reachedChest then
        reachedChest = false
    end
end
setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

task.spawn(function()
    local stages = workspace.BoatStages.NormalStages

    while true do
        if AutoFarm and root and not reachedChest then

            for i = 1,50 do
                if not AutoFarm then break end

                local stage = stages:FindFirstChild("CaveStage"..i)
                if stage then
                    local part = stage:FindFirstChild("DarknessPart")
                    if part then

                        local start = tick()
                        while tick() - start < 2 and AutoFarm do
                            root.CFrame = part.CFrame + Vector3.new(0,3,0)
                            task.wait()
                        end

                    end
                else
                    break
                end
                end
            if AutoFarm then
                local chest = stages.TheEnd.GoldenChest.LightPart
                root.CFrame = chest.CFrame + Vector3.new(0,3,0)
                reachedChest = true
            end

        end

        task.wait()
    end
end)



-- -----------
-- จอดำ
---------------

local data = player:WaitForChild("Data")
local gui
local goldText
local blockText

function BlackScreenUI(state)

    if state then
        if gui then return end

        gui = Instance.new("ScreenGui")
        gui.Name = "FarmBlackScreen"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = player.PlayerGui

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1,0,1,0)
        bg.BackgroundColor3 = Color3.new(0,0,0)
        bg.BorderSizePixel = 0
        bg.Parent = gui

        goldText = Instance.new("TextLabel")
        goldText.Size = UDim2.new(1,0,0,30)
        goldText.Position = UDim2.new(0,0,0.45,0)
        goldText.BackgroundTransparency = 1
        goldText.Font = Enum.Font.GothamBold
        goldText.TextSize = 22
        goldText.TextColor3 = Color3.fromRGB(255,221,0)
        goldText.Text = "จำนวนทอง : "..data.Gold.Value
        goldText.Parent = bg

        blockText = Instance.new("TextLabel")
        blockText.Size = UDim2.new(1,0,0,30)
        blockText.Position = UDim2.new(0,0,0.50,0)
        blockText.BackgroundTransparency = 1
        blockText.Font = Enum.Font.GothamBold
        blockText.TextSize = 22
        blockText.TextColor3 = Color3.fromRGB(255,221,0)
        blockText.Text = "จำนวนบล็อกทอง : "..data.GoldBlock.Value
        blockText.Parent = bg

        data.Gold:GetPropertyChangedSignal("Value"):Connect(function()
            if goldText then
                goldText.Text = "จำนวนทอง : "..data.Gold.Value
            end
        end)

        data.GoldBlock:GetPropertyChangedSignal("Value"):Connect(function()
            if blockText then
                blockText.Text = "จำนวนบล็อกทอง : "..data.GoldBlock.Value
            end
        end)

    else
        if gui then
            gui:Destroy()
            gui = nil
        end
    end
end


local FarmTab = Window:Tab({Title = "FARM", Icon = "hand-coins"})


FarmTab:Toggle({
    Title = "ออโต้ฟาม",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        AutoFarm = state
    end
})

FarmTab:Toggle({
    Title = "จอดำ",
    Type = "Checkbox",
    Value = false,

    Callback = function(state)
        BlackScreenUI(state)
    end
})
