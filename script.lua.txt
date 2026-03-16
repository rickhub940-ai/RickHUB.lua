local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local DownloadGui = Instance.new("ScreenGui")
DownloadGui.Name = "PigHubLoad"
DownloadGui.Parent = CoreGui
DownloadGui.ResetOnSpawn = false
DownloadGui.IgnoreGuiInset = true
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = DownloadGui
local CharImage = Instance.new("ImageLabel")
CharImage.Size = UDim2.new(0, 300, 0, 300)
CharImage.Position = UDim2.new(0.5, -150, 0.5, -170)
CharImage.BackgroundTransparency = 1
CharImage.Image = "rbxassetid://117924028123190"
CharImage.ImageTransparency = 1
CharImage.Parent = MainFrame
local CampName = Instance.new("TextLabel")
CampName.Size = UDim2.new(1, 0, 0, 70)
CampName.Position = UDim2.new(0, 0, 0.5, 140)
CampName.BackgroundTransparency = 1
CampName.Text = "PIG HUB"
CampName.TextColor3 = Color3.fromRGB(0, 200, 255)
CampName.TextScaled = true
CampName.Font = Enum.Font.GothamBold
CampName.TextTransparency = 1
CampName.Parent = MainFrame
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
})
Gradient.Rotation = 45
Gradient.Parent = CampName
task.spawn(function()
    local fadeInImage = TweenService:Create(CharImage, TweenInfo.new(1.5), {ImageTransparency = 0})
    fadeInImage:Play()
    fadeInImage.Completed:Wait()
    task.wait(0.5)
    
    local fadeInText = TweenService:Create(CampName, TweenInfo.new(2), {TextTransparency = 0})
    fadeInText:Play()
    
    local angle = 45
    while CampName.TextTransparency < 0.1 do
        angle = (angle + 1) % 360
        Gradient.Rotation = angle
        task.wait(0.03)
    end
    fadeInText.Completed:Wait()
    task.wait(2)
    
    local fadeOutImage = TweenService:Create(CharImage, TweenInfo.new(1), {ImageTransparency = 1})
    local fadeOutText = TweenService:Create(CampName, TweenInfo.new(1), {TextTransparency = 1})
    fadeOutImage:Play()
    fadeOutText:Play()
    fadeOutImage.Completed:Wait()
    
    DownloadGui:Destroy()
end)
repeat task.wait() until not CoreGui:FindFirstChild("PigHubLoad")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "PIG HUB",
    Icon = "rbxassetid://120437295686483",
    Author = "PIG TEAM",
    Folder = "PIG HUB",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Name = LocalPlayer.Name,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId
    }
})
Window:EditOpenButton({ Enabled = false })
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "WindUI_Toggle"
ScreenGui.ResetOnSpawn = false
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0,20,0.5,-25)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://120437295686483"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
local function ToggleUI()
    if Window.Toggle then
        Window:Toggle()
    else
        Window.UI.Enabled = not Window.UI.Enabled
    end
end
ToggleBtn.MouseButton1Click:Connect(ToggleUI)
UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.T then
        ToggleUI()
    end
end)
local PlayerTab = Window:Tab({Title="Player",Icon="user"})
local ESPTab = Window:Tab({Title="ESP",Icon="crosshair"})
local PVPTab = Window:Tab({Title="PVP",Icon="target"})
local QuestTab = Window:Tab({Title="Quest",Icon="flag"})
local ServerTab = Window:Tab({Title="Server",Icon="globe"})
local CustomTab = Window:Tab({Title="Custom",Icon="settings"})
PlayerTab:Section({Title="Player Stats"})
local BankBalance = PlayerTab:Button({Title="Bank Balance",Desc="<b><font color='#1E90FF'>$0</font></b>"})
local HandBalance = PlayerTab:Button({Title="Hand Balance",Desc="<b><font color='#00BFFF'>$0</font></b>"})
local function formatMoney(amount)
    amount = tonumber(amount) or 0
    if amount >= 1000000 then return string.format("$%.1fM", amount/1000000)
    elseif amount >= 1000 then return string.format("$%.1fK", amount/1000)
    else return string.format("$%d", amount) end
end
local function HandMoney()
    local success, value = pcall(function()
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not PlayerGui then return 0 end
        local topRight = PlayerGui:FindFirstChild("TopRightHud")
        if topRight then
            local holder = topRight:FindFirstChild("Holder")
            if holder and holder:FindFirstChild("Frame") and holder.Frame:FindFirstChild("MoneyTextLabel") then
                return tonumber(holder.Frame.MoneyTextLabel.Text:gsub("[$,]", "")) or 0
            end
        end
        return 0
    end)
    return success and value or 0
end
local function ATMMoney()
    local success, value = pcall(function()
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") and (v.Text:find("Bank") or v.Text:find("Balance")) then
                return tonumber(v.Text:gsub("[$,]", ""):gsub("Bank", ""):gsub("Balance", ""):gsub(":", ""):match("%d+")) or 0
            end
        end
        return 0
    end)
    return success and value or 0
end
task.spawn(function()
    while task.wait(0.5) do
        BankBalance:SetDesc('<b><font color="#1E90FF">' .. formatMoney(ATMMoney()) .. "</font></b>")
        HandBalance:SetDesc('<b><font color="#00BFFF">' .. formatMoney(HandMoney()) .. "</font></b>")
    end
end)
PlayerTab:Section({Title="ซ่อนชื่อและเลเวล"})
PlayerTab:Button({Title="เปิดใช้ระบบ", Desc="คลิกเพื่อเปิดระบบซ่อนชื่อและเลเวล", Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/3BxE2aGP/raw",true))()
end})
PlayerTab:Section({Title="ANTI-LOOK SYSTEM"})
local AntiLookEnabled = false
local AntiLookHeight = 1500
local AntiLookConnection = nil
local function ToggleAntiLook(state)
    AntiLookEnabled = state
    
    if state then
        if AntiLookConnection then
            AntiLookConnection:Disconnect()
        end
        
        AntiLookConnection = RunService.Heartbeat:Connect(function()
            if AntiLookEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local currentVelocity = hrp.Velocity
                local angle = math.rad(tick() * 1500 % 360)
                
                local xVelocity = math.cos(angle) * AntiLookHeight
                local zVelocity = math.sin(angle) * AntiLookHeight
                local yVelocity = math.random(280, 480)
                
                hrp.Velocity = Vector3.new(xVelocity, yVelocity, zVelocity)
                
                task.wait()
                
                if hrp and hrp.Parent then
                    hrp.Velocity = currentVelocity
                end
            end
        end)
    else
        if AntiLookConnection then
            AntiLookConnection:Disconnect()
            AntiLookConnection = nil
        end
    end
end
PlayerTab:Toggle({
    Title = "Anti-Look",
    Desc = "ป้องกันการล็อคเป้า",
    Default = false,
    Callback = function(v)
        ToggleAntiLook(v)
    end
})
PlayerTab:Slider({
    Title = "Anti-Look Height",
    Desc = "ปรับความสูง 500-3000",
    Step = 10,
    Value = {Min = 500, Max = 3000, Default = 1500},
    Callback = function(v)
        AntiLookHeight = v
    end
})
PlayerTab:Section({Title="Sit System"})
local sit=false
local sitHeight=0
local sitConn
PlayerTab:Toggle({
    Title="เก็บของใต้ดิน",
    Callback=function(v)
        sit=v
        if sitConn then sitConn:Disconnect() end
        local c=LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.Sit=v
            if v then
                sitConn=RunService.Heartbeat:Connect(function()
                    if c:FindFirstChild("HumanoidRootPart") then
                        c.HumanoidRootPart.CFrame=c.HumanoidRootPart.CFrame+Vector3.new(0,sitHeight,0)
                    end
                end)
            end
        end
    end
})
PlayerTab:Slider({
    Title="ปรับ Height",
    Step=0.1,
    Value={Min=-5,Max=4,Default=0},
    Callback=function(v) sitHeight=v end
})
PlayerTab:Section({Title="Jump power"})
local infJump=false
local jumpPower=70
local jumpConn
PlayerTab:Toggle({
    Title="Jump power",
    Callback=function(v)
        infJump=v
        if jumpConn then jumpConn:Disconnect() end
        if v then
            jumpConn=UserInputService.JumpRequest:Connect(function()
                local c=LocalPlayer.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    c.HumanoidRootPart.Velocity=Vector3.new(
                        c.HumanoidRootPart.Velocity.X,
                        jumpPower,
                        c.HumanoidRootPart.Velocity.Z
                    )
                end
            end)
        end
    end
})
PlayerTab:Slider({
    Title="Jump Power",
    Step=5,
    Value={Min=20,Max=100,Default=70},
    Callback=function(v) jumpPower=v end
})
PlayerTab:Section({Title="Warp Walk"})
local warpEnabled, warpDistance, warpSpeed, lastWarp, warpConnection = false, 0.5, 0.1, 0
PlayerTab:Toggle({
    Title="Enable Warp",
    Callback=function(v)
        warpEnabled = v
        if warpConnection then warpConnection:Disconnect() warpConnection = nil end
        if v then
            warpConnection = RunService.Heartbeat:Connect(function()
                if warpEnabled and tick() - lastWarp >= warpSpeed then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                        local moveDir = char.Humanoid.MoveDirection
                        if moveDir.Magnitude > 0 then
                            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (moveDir * warpDistance)
                            lastWarp = tick()
                        end
                    end
                end
            end)
        end
    end
})
PlayerTab:Slider({
    Title="Warp Distance",
    Step=0.1,
    Value={Min=0.1,Max=0.9,Default=0.9},
    Callback=function(v) warpDistance = tonumber(v) or 0.5 end
})
PlayerTab:Slider({
    Title="Warp Speed",
    Step=0.01,
    Value={Min=0.01,Max=0.09,Default=0.09},
    Callback=function(v) warpSpeed = tonumber(v) or 0.1 end
})
PlayerTab:Section({Title="Infinite Stamina"})
local Net = require(ReplicatedStorage.Modules.Core.Net)
local SprintModule = require(ReplicatedStorage.Modules.Game.Sprint)
PlayerTab:Toggle({
    Title = "Infinite Stamina",
    Default = false,
    Callback = function(v)
        if v then
            if not getgenv().Bypassed then
                local func = debug.getupvalue(Net.get,2)
                debug.setconstant(func,3,'__Bypass')
                debug.setconstant(func,4,'__Bypass')
                getgenv().Bypassed = true
            end
            
            repeat task.wait() until getgenv().Bypassed
            RunService.Heartbeat:Connect(function()
                Net.send("set_sprinting_1",true)
            end)
            local consume_stamina = SprintModule.consume_stamina
            local SprintBar = debug.getupvalue(consume_stamina, 2).sprint_bar
            local __InfiniteStamina = SprintBar.update
            SprintBar.update = function(...)
                if getgenv().InfiniteStamina then
                    return __InfiniteStamina(function()
                        return 0.5
                    end)
                end
                return __InfiniteStamina(...)
            end
            
            getgenv().InfiniteStamina = true
        else
            getgenv().InfiniteStamina = false
        end
    end
})
PlayerTab:Section({Title="ดูเของ"})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CLIENT_ZONE_SIZE = Vector3.new(120, 14, 120)
local SERVER_FAKE_RADIUS = 2000
local MAGNET_SPEED = 0.8
local remoteGet = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")
local function resizeZones()
    for _, item in pairs(workspace.DroppedItems:GetChildren()) do
        local zone = item:FindFirstChild("PickUpZone")
        if zone and zone:IsA("BasePart") then
            zone.Size = CLIENT_ZONE_SIZE
            zone.Transparency = 1
            zone.CanCollide = false
            zone.Anchored = true
        end
    end
end
resizeZones()
workspace.DroppedItems.ChildAdded:Connect(resizeZones)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, item in pairs(workspace.DroppedItems:GetChildren()) do
        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
        if not prompt then continue end
        local dist = (hrp.Position - item.Position).Magnitude
        if dist <= SERVER_FAKE_RADIUS then
            remoteGet:InvokeServer("pickup_dropped_item", item)
            if item:IsA("BasePart") then
                item.CFrame = item.CFrame:Lerp(CFrame.new(hrp.Position), MAGNET_SPEED)
            else
                local part = item:FindFirstChildWhichIsA("BasePart")
                if part then
                    part.CFrame = part.CFrame:Lerp(CFrame.new(hrp.Position), MAGNET_SPEED)
                end
            end
        end
    end
end)
getgenv().SilentAimEnabled = false
getgenv().FOV_Radius = 200
getgenv().AimPart = "Head"
getgenv().Prediction = 0.165
getgenv().RGB_Speed = 1
local i = ReplicatedStorage:WaitForChild("Remotes")
local send = i:WaitForChild("Send")
local Lines = {}
for i = 1, 8 do
    Lines[i] = Drawing.new("Line")
    Lines[i].Visible = true
    Lines[i].Thickness = 2
end
local ScreenTracer = Drawing.new("Line")
ScreenTracer.Thickness = 1.5
ScreenTracer.Transparency = 0.8
ScreenTracer.Visible = false
local isFiring = false
local lastBeamTime = 0
local beamCooldown = 0.15
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.UserInputType == Enum.UserInputType.MouseButton1 then
        isFiring = true
        task.spawn(function()
            task.wait(0.1)
            isFiring = false
        end)
    end
end)
UserInputService.TouchStarted:Connect(function(input, gp)
    if not gp then
        isFiring = true
        task.spawn(function()
            task.wait(0.1)
            isFiring = false
        end)
    end
end)
local function CreateBulletBeam(startPos, endPos)
    if not isFiring then return end
    if tick() - lastBeamTime < beamCooldown then
        return
    end
    lastBeamTime = tick()
    
    local p = Instance.new("Part")
    p.Name = "PIG_Beam"
    p.Parent = workspace
    p.Anchored = true
    p.CanCollide = false
    p.Material = Enum.Material.Neon
    p.Size = Vector3.new(0.1, 0.1, (startPos - endPos).Magnitude)
    p.CFrame = CFrame.new(startPos:Lerp(endPos, 0.5), endPos)
    
    local hue = (tick() * 2) % 1
    p.Color = Color3.fromHSV(hue, 1, 1)
    
    local t = TweenService:Create(p, TweenInfo.new(0.5), {
        Transparency = 1,
        Size = Vector3.new(0, 0, p.Size.Z)
    })
    t:Play()
    game:GetService("Debris"):AddItem(p, 0.5)
end
local function GetClosestTarget()
    local target = nil
    local shortestDist = getgenv().FOV_Radius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
            if v.Character.Humanoid.Health > 0 then
                local part = v.Character:FindFirstChild(getgenv().AimPart)
                if part then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist <= getgenv().FOV_Radius and dist < shortestDist then
                            shortestDist = dist
                            target = v
                        end
                    end
                end
            end
        end
    end
    return target
end
RunService.RenderStepped:Connect(function()
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local Time = tick() * getgenv().RGB_Speed
    
    for i = 1, 8 do
        local angle = math.rad((i - 1) * 45)
        local nextAngle = math.rad(i * 45)
        Lines[i].From = Center + Vector2.new(math.cos(angle) * getgenv().FOV_Radius, math.sin(angle) * getgenv().FOV_Radius)
        Lines[i].To = Center + Vector2.new(math.cos(nextAngle) * getgenv().FOV_Radius, math.sin(nextAngle) * getgenv().FOV_Radius)
        Lines[i].Color = Color3.fromHSV((Time + (i / 8)) % 1, 1, 1)
        Lines[i].Visible = getgenv().SilentAimEnabled
    end
    if getgenv().SilentAimEnabled then
        local targetPlayer = GetClosestTarget()
        if targetPlayer then
            local headPart = targetPlayer.Character:FindFirstChild(getgenv().AimPart)
            if headPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPart.Position)
                if onScreen then
                    ScreenTracer.From = Center
                    ScreenTracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    ScreenTracer.Color = Color3.fromHSV(Time % 1, 1, 1)
                    ScreenTracer.Visible = true
                    
                    getgenv().CurrentTargetHead = headPart
                    getgenv().FinalAimPos = headPart.Position + (headPart.Velocity * getgenv().Prediction)
                end
            end
        else
            ScreenTracer.Visible = false
            getgenv().CurrentTargetHead = nil
            getgenv().FinalAimPos = nil
        end
    else
        ScreenTracer.Visible = false
        getgenv().CurrentTargetHead = nil
        getgenv().FinalAimPos = nil
    end
end)
local oldFire
oldFire = hookfunction(send.FireServer, function(self, ...)
    local args = {...}
    
    if getgenv().SilentAimEnabled and getgenv().CurrentTargetHead and getgenv().FinalAimPos then
        local origin = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")) and LocalPlayer.Character.Head.Position or Vector3.new(0,0,0)
        
        CreateBulletBeam(origin, getgenv().FinalAimPos)
        args[4] = CFrame.new(1/0, 1/0, 1/0, 0/0, 0/0, 0/0, 0/0, 0/0, 0/0, 0/0, 0/0, 0/0)
        args[5] = {
            [1] = {
                [1] = {
                    ["Instance"] = getgenv().CurrentTargetHead,
                    ["Position"] = getgenv().FinalAimPos
                }
            }
        }
    end
    
    return oldFire(self, unpack(args))
end)
PVPTab:Toggle({
    Title = "Silent Aim",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimEnabled = v
        if not v then
            getgenv().CurrentTargetHead = nil
            getgenv().FinalAimPos = nil
            ScreenTracer.Visible = false
        end
    end
})
PVPTab:Slider({
    Title = "FOV Radius",
    Desc = "ปรับขนาดวงเล็ง",
    Step = 10,
    Value = {Min = 50, Max = 500, Default = 200},
    Callback = function(v)
        getgenv().FOV_Radius = v
    end
})
PVPTab:Dropdown({
    Title = "Aim Part",
    Desc = "เลือกส่วนที่ต้องการเล็ง",
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    Default = 1,
    Callback = function(v)
        getgenv().AimPart = v
    end
})
PVPTab:Slider({
    Title = "Prediction",
    Desc = "ความแม่นยำ 0.1-0.2",
    Step = 0.005,
    Value = {Min = 0.1, Max = 0.2, Default = 0.165},
    Callback = function(v)
        getgenv().Prediction = v
    end
})
PVPTab:Slider({
    Title = "Beam Cooldown",
    Desc = "ระยะห่างลำแสง (ms)",
    Step = 10,
    Value = {Min = 50, Max = 300, Default = 150},
    Callback = function(v)
        beamCooldown = v / 1000
    end
})
local function findCounterTable()
    if not getgc then return nil end
    
    for _, obj in ipairs(getgc(true)) do
        if typeof(obj) == "table" then
            if rawget(obj, "event") and rawget(obj, "func") then
                return obj
            end
        end
    end
    return nil
end
local function createNetwork()
    local CounterTable = findCounterTable()
    if not CounterTable then return nil end
    
    local Net = {}
    
    function Net.get(...)
        CounterTable.func = (CounterTable.func or 0) + 1
        local GetRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")
        return GetRemote:InvokeServer(CounterTable.func, ...)
    end
    
    function Net.send(action)
        CounterTable.event = (CounterTable.event or 0) + 1
        local SendRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Send")
        SendRemote:FireServer(CounterTable.event, action)
    end
    
    return Net
end
QuestTab:Button({
    Title = "Clear All Quests",
    Desc = "เคลียร์เควสทั้งหมด",
    Callback = function()
        task.spawn(function()
            local player = Players.LocalPlayer
            
            local Net = createNetwork()
            if not Net then
                return false
            end
            
            local success, questUI = pcall(function()
                return player:WaitForChild("PlayerGui"):WaitForChild("Quests"):WaitForChild("QuestsHolder"):WaitForChild("QuestsScrollingFrame")
            end)
            
            if not success or not questUI then
                return false
            end
            
            local cleared = 0
            local total = 0
            
            for _, child in pairs(questUI:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") then
                    total = total + 1
                    
                    local success, result = pcall(function()
                        return Net.get("claim_quest", child.Name)
                    end)
                    
                    if success then
                        cleared = cleared + 1
                    end
                    
                    task.wait(0.15)
                end
            end
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Quest Clear",
                Text = "Cleared " .. cleared .. "/" .. total .. " quests",
                Duration = 5
            })
        end)
    end
})
ESPTab:Toggle({Title="ESP Box",Callback=function(v) if v then loadstring(game:HttpGet("https://pastefy.app/IAJ3EjEo/raw"))() end end})
ESPTab:Toggle({Title="ESP Name",Callback=function(v) if v then loadstring(game:HttpGet("https://pastefy.app/uEpm8OT7/raw"))() end end})
ESPTab:Toggle({Title="ESP Item",Callback=function(v) if v then loadstring(game:HttpGet("https://pastefy.app/uAhJQuzj/raw"))() end end})
ServerTab:Button({
    Title="Server Hop",
    Callback=function()
        local servers=HttpService:JSONDecode(game:HttpGet(
            ("https://games.roblox.com/v1/games/%s/servers/Public?limit=100"):format(game.PlaceId)
        )).data
        for _,s in ipairs(servers) do
            if s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
})
ServerTab:Button({
    Title="Rejoin",
    Callback=function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
})
CustomTab:Section({Title="Custom FOV"})
getgenv().CustomFOVCode = ""
CustomTab:Input({
    Title = "ใส่โค้ด FOV",
    Desc = "วางสคริปหน้าตา FOV แล้วกดยืนยัน",
    Placeholder = "วางโค้ด FOV ที่นี่...",
    Callback = function(v)
        getgenv().CustomFOVCode = v
    end
})
CustomTab:Button({
    Title = "ยืนยัน Custom FOV",
    Desc = "กดเพื่อใช้โค้ด FOV ที่ใส่ไว้",
    Callback = function()
        local code = getgenv().CustomFOVCode or ""
        if code == "" then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Custom FOV",
                Text = "กรุณาใส่โค้ด FOV ก่อน / Please enter FOV code first",
                Duration = 3
            })
            return
        end
        local isFOVCode = code:find("FOV_Radius") or code:find("FOVRadius") or code:find("Drawing") or code:find("Circle") or code:find("Radius") or code:find("Lines")
        if not isFOVCode then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Custom FOV",
                Text = "นี่ไม่ใช่โค้ด FOV / This is not a FOV code",
                Duration = 4
            })
            return
        end
        local ok, err = pcall(function()
            for i = 1, 8 do
                if Lines[i] then Lines[i]:Remove() end
            end
            Lines = {}
            loadstring(code)()
        end)
        if ok then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Custom FOV",
                Text = "เปลี่ยนหน้าตา FOV สำเร็จ! / FOV changed successfully!",
                Duration = 3
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Custom FOV",
                Text = "โค้ดผิดพลาด / Code error: " .. tostring(err):sub(1,50),
                Duration = 5
            })
        end
    end
})
CustomTab:Section({Title="Custom Silent Aim"})
getgenv().BulletForce = 1.0
getgenv().StraightBullet = false
CustomTab:Toggle({
    Title = "Straight Bullet (กระสุนตรง)",
    Desc = "บังคับให้กระสุนยิงตรงไปยังเป้าหมายเสมอ",
    Default = false,
    Callback = function(v)
        getgenv().StraightBullet = v
        if v then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Straight Bullet",
                Text = "✅ เปิดระบบกระสุนตรงแล้ว",
                Duration = 2
            })
        end
    end
})
CustomTab:Slider({
    Title = "Custom Prediction (ความแม่นยำ)",
    Desc = "ปรับความแม่นยำ Silent Aim (0.05 = แม่น / 0.3 = กว้าง)",
    Step = 0.005,
    Value = {Min = 0.05, Max = 0.3, Default = 0.165},
    Callback = function(v)
        getgenv().Prediction = v
    end
})
CustomTab:Slider({
    Title = "Bullet Force (แรงดีดกระสุน)",
    Desc = "ปรับแรง offset กระสุน (1.0 = ปกติ, สูง = ดีดแรง)",
    Step = 0.05,
    Value = {Min = 0.5, Max = 3.0, Default = 1.0},
    Callback = function(v)
        getgenv().BulletForce = v
    end
})

RunService.Heartbeat:Connect(function()
    if getgenv().StraightBullet and getgenv().SilentAimEnabled and getgenv().CurrentTargetHead then
        local head = getgenv().CurrentTargetHead
        if head and head.Parent then
            getgenv().FinalAimPos = head.Position + (head.Velocity * (getgenv().Prediction * getgenv().BulletForce))
        end
    end
end)
ESPTab:Section({Title="ดูของที่ตกอยู่ที่พื้น"})
getgenv().ItemESPEnabled = false
getgenv().ItemESPMaxDist = 500
local ItemESPDrawings = {}
local RarityColors = {
    Common    = Color3.fromRGB(255, 255, 255),
    Uncommon  = Color3.fromRGB(100, 255, 100),
    Rare      = Color3.fromRGB(0, 150, 255),
    Epic      = Color3.fromRGB(180, 50, 255),
    Legendary = Color3.fromRGB(255, 150, 0),
    Omega     = Color3.fromRGB(255, 0, 50)
}
local function UpdateItemESP()
    if not getgenv().ItemESPEnabled then
        for _, draw in pairs(ItemESPDrawings) do
            if draw.Dot then draw.Dot.Visible = false end
            if draw.Label then draw.Label.Visible = false end
        end
        return
    end
    local dropped = workspace:FindFirstChild("DroppedItems")
    if not dropped then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local fovCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, item in ipairs(dropped:GetChildren()) do
        if item:IsA("Model") and item:FindFirstChild("PickUpZone") then
            local pz = item.PickUpZone
            local pos, onScreen = Camera:WorldToViewportPoint(pz.Position)
            local dist = (myRoot.Position - pz.Position).Magnitude
            if not ItemESPDrawings[item] then
                ItemESPDrawings[item] = {
                    Dot   = Drawing.new("Circle"),
                    Label = Drawing.new("Text")
                }
            end
            local draw = ItemESPDrawings[item]
            local screenPos = Vector2.new(pos.X, pos.Y)
            local inFOV = (screenPos - fovCenter).Magnitude <= getgenv().FOV_Radius
            if onScreen and dist < getgenv().ItemESPMaxDist then
                local color = Color3.new(1,1,1)
                local ok, template = pcall(function()
                    return ReplicatedStorage.Items:FindFirstChild(item.Name, true)
                end)
                if ok and template then
                    color = RarityColors[template:GetAttribute("RarityName")] or color
                end
                draw.Dot.Visible = true
                draw.Dot.Position = screenPos
                draw.Dot.Radius = inFOV and 6 or 3
                draw.Dot.Color = color
                draw.Dot.Filled = true
                draw.Dot.Transparency = inFOV and 1 or 0.5
                draw.Label.Visible = true
                draw.Label.Position = Vector2.new(pos.X, pos.Y - 18)
                draw.Label.Text = string.format("%s [%dm]", item.Name, math.floor(dist))
                draw.Label.Color = color
                draw.Label.Size = inFOV and 16 or 13
                draw.Label.Center = true
                draw.Label.Outline = true
            else
                draw.Dot.Visible = false
                draw.Label.Visible = false
            end
        end
    end
end
RunService.RenderStepped:Connect(UpdateItemESP)
task.spawn(function()
    while task.wait(1) do
        for item, draw in pairs(ItemESPDrawings) do
            if not item or not item.Parent or not item:FindFirstChild("PickUpZone") then
                if draw.Dot then draw.Dot:Remove() end
                if draw.Label then draw.Label:Remove() end
                ItemESPDrawings[item] = nil
            end
        end
    end
end)
ESPTab:Toggle({
    Title = "Item ESP (ดูของบนพื้น)",
    Desc = "แสดงชื่อและระยะของไอเท็มที่ตกอยู่บนพื้น (สว่างกว่าถ้าอยู่ใน FOV)",
    Default = false,
    Callback = function(v)
        getgenv().ItemESPEnabled = v
    end
})
ESPTab:Slider({
    Title = "Item ESP Distance",
    Desc = "ระยะที่จะแสดง Item ESP (เมตร)",
    Step = 25,
    Value = {Min = 50, Max = 1000, Default = 500},
    Callback = function(v)
        getgenv().ItemESPMaxDist = v
    end
})
