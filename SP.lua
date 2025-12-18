local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- متغيرات الحالة
local selectedLocation = nil -- "Min" أو "Max"
local selectedPlayer = nil
local isOnCooldownLocations = false
local isOnCooldownPlayers = false
local cooldownTime = 9

-- إحداثيات Min
local MinArmoryPos = Vector3.new(196, 23.23, -215)
local MinSecretDropPos = Vector3.new(-6.64, 26.10, -58.50)
local MinCamArmoryPos = Vector3.new(197.10, 24.68, -215.00)
local MinCamDropPos = Vector3.new(-6.10, 24.13, -104.07)

-- إحداثيات Max
local MaxArmoryPos = Vector3.new(196, 23.23, -215)
local MaxSecretDropPos = Vector3.new(58.19, -8.87, -140.50)
local MaxCamArmoryPos = Vector3.new(197.10, 24.68, -215.00)
local MaxCamDropPos = Vector3.new(85.27, -7.25, -140.44)

-- إحداثيات عامة
local FinalFarmPos = Vector3.new(20.06, 11.23, -117.39)

-- دالة تفتيح اللون
local function brightenColor(c)
    return Color3.new(
        math.min(1, c.R * 1.3 + 0.1),
        math.min(1, c.G * 1.3 + 0.1),
        math.min(1, c.B * 1.3 + 0.1)
    )
end

-- ===================================
-- إنشاء الواجهة الرسومية
-- ===================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GunSpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 580)
mainFrame.Position = UDim2.new(0, 20, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 50, 82)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 22, 44)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 19))
})
gradient.Rotation = 0
gradient.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 3
mainStroke.Color = Color3.fromRGB(0, 0, 0)
mainStroke.Parent = mainFrame

-- التبويبات
local tabNames = {"Locations", "Players", "Teleport", "Player"}
local tabButtons = {}
local tabContents = {}

local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0.9, 0, 0, 50)
tabsFrame.Position = UDim2.new(0.05, 0, 0, 20)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = mainFrame

local tabPadding = 5
local totalWidth = 360 * 0.9
local buttonWidth = (totalWidth - (#tabNames - 1) * tabPadding) / #tabNames

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * (buttonWidth + tabPadding), 0, 0)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(62, 39, 78) or Color3.fromRGB(102, 65, 129)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = tabsFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    tabButtons[name] = btn

    local content = Instance.new("Frame")
    content.Size = UDim2.new(0.9, 0, 0, 500)
    content.Position = UDim2.new(0.05, 0, 0, 80)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    tabContents[name] = content
end

-- تبديل التبويبات
for _, name in ipairs(tabNames) do
    tabButtons[name].MouseButton1Click:Connect(function()
        for k, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
            tabContents[k].Visible = false
        end
        tabButtons[name].BackgroundColor3 = Color3.fromRGB(62, 39, 78)
        tabContents[name].Visible = true
    end)
end

-- ==================== Locations Tab ====================
local locContent = tabContents["Locations"]

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.9, 0, 0, 70)
minBtn.Position = UDim2.new(0.05, 0, 0, 20)
minBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
minBtn.Text = "Min Lobby"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 30
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = locContent
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 14)

local maxBtn = Instance.new("TextButton")
maxBtn.Size = UDim2.new(0.9, 0, 0, 70)
maxBtn.Position = UDim2.new(0.05, 0, 0, 110)
maxBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
maxBtn.Text = "Max"
maxBtn.TextColor3 = Color3.new(1,1,1)
maxBtn.TextSize = 30
maxBtn.Font = Enum.Font.GothamBold
maxBtn.Parent = locContent
Instance.new("UICorner", maxBtn).CornerRadius = UDim.new(0, 14)

minBtn.MouseButton1Click:Connect(function()
    minBtn.BackgroundColor3 = Color3.fromRGB(62, 39, 78)
    maxBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
    selectedLocation = "Min"
end)

maxBtn.MouseButton1Click:Connect(function()
    maxBtn.BackgroundColor3 = Color3.fromRGB(62, 39, 78)
    minBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
    selectedLocation = "Max"
end)

local locSpawnBtn = Instance.new("TextButton")
locSpawnBtn.Size = UDim2.new(0.9, 0, 0, 60)
locSpawnBtn.Position = UDim2.new(0.05, 0, 0, 200)
locSpawnBtn.BackgroundColor3 = Color3.fromRGB(52, 50, 82)
locSpawnBtn.Text = "Spawn"
locSpawnBtn.TextColor3 = Color3.new(1,1,1)
locSpawnBtn.TextSize = 30
locSpawnBtn.Font = Enum.Font.GothamBold
locSpawnBtn.Parent = locContent
Instance.new("UICorner", locSpawnBtn).CornerRadius = UDim.new(0, 14)

local locLoadingDot = Instance.new("Frame")
locLoadingDot.Size = UDim2.new(0, 20, 0, 20)
locLoadingDot.Position = UDim2.new(1, -30, 0.5, -10)
locLoadingDot.BackgroundColor3 = Color3.fromHex("#22B365")
locLoadingDot.Visible = false
locLoadingDot.Parent = locSpawnBtn
Instance.new("UICorner", locLoadingDot).CornerRadius = UDim.new(1, 0)

-- ==================== Players Tab ====================
local playersContent = tabContents["Players"]

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,0.65,0)
scroll.Position = UDim2.new(0,0,0,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = playersContent

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,8)
list.Parent = scroll

local viewBtn = Instance.new("TextButton")
viewBtn.Size = UDim2.new(0.9, 0, 0, 55)
viewBtn.Position = UDim2.new(0.05, 0, 0.68, 0)
viewBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
viewBtn.Text = "View Player"
viewBtn.TextColor3 = Color3.new(1,1,1)
viewBtn.TextSize = 26
viewBtn.Font = Enum.Font.GothamBold
viewBtn.Parent = playersContent
Instance.new("UICorner", viewBtn).CornerRadius = UDim.new(0, 14)

local playersSpawnBtn = Instance.new("TextButton")
playersSpawnBtn.Size = UDim2.new(0.9, 0, 0, 60)
playersSpawnBtn.Position = UDim2.new(0.05, 0, 0.80, 0)
playersSpawnBtn.BackgroundColor3 = Color3.fromRGB(52, 50, 82)
playersSpawnBtn.Text = "Spawn"
playersSpawnBtn.TextColor3 = Color3.new(1,1,1)
playersSpawnBtn.TextSize = 30
playersSpawnBtn.Font = Enum.Font.GothamBold
playersSpawnBtn.Parent = playersContent
Instance.new("UICorner", playersSpawnBtn).CornerRadius = UDim.new(0, 14)

local playersLoadingDot = Instance.new("Frame")
playersLoadingDot.Size = UDim2.new(0, 20, 0, 20)
playersLoadingDot.Position = UDim2.new(1, -30, 0.5, -10)
playersLoadingDot.BackgroundColor3 = Color3.fromHex("#22B365")
playersLoadingDot.Visible = false
playersLoadingDot.Parent = playersSpawnBtn
Instance.new("UICorner", playersLoadingDot).CornerRadius = UDim.new(1, 0)

-- View/Spectate Logic
local isViewing = false
local viewConnection
local oldCamType, oldCamSubject
local lastTargetPos = nil

local function toggleView()
    if not selectedPlayer then
        game.StarterGui:SetCore("SendNotification",{Title="خطأ",Text="اختر لاعب أولاً!",Duration=3})
        return
    end
    if isViewing then
        isViewing = false
        viewBtn.Text = "View Player"
        viewBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
        if viewConnection then viewConnection:Disconnect() end
        camera.CameraType = oldCamType
        camera.CameraSubject = oldCamSubject
        lastTargetPos = nil
        game.StarterGui:SetCore("SendNotification",{Title="View",Text="تم إيقاف المشاهدة",Duration=2})
    else
        oldCamType = camera.CameraType
        oldCamSubject = camera.CameraSubject
        isViewing = true
        viewBtn.Text = "Stop View"
        viewBtn.BackgroundColor3 = Color3.fromRGB(62, 39, 78)
        camera.CameraType = Enum.CameraType.Scriptable
        
        local function updateView()
            local targetChar = selectedPlayer.Character
            if targetChar then
                local targetHead = targetChar:FindFirstChild("Head")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                local pos = (targetHead and targetHead.Position) or (targetHRP and targetHRP.Position) or lastTargetPos
                if pos then
                    lastTargetPos = pos
                    camera.CFrame = CFrame.lookAt(pos + Vector3.new(0, 2, 8), pos)
                end
            end
        end
        
        viewConnection = RunService.RenderStepped:Connect(updateView)
        
        selectedPlayer.CharacterAdded:Connect(function()
            if isViewing then
                task.wait(1)
                updateView()
            end
        end)
        
        game.StarterGui:SetCore("SendNotification",{Title="View",Text="تتبع اللاعب: "..selectedPlayer.Name.." (حتى بعد الموت)",Duration=3})
    end
end

viewBtn.MouseButton1Click:Connect(toggleView)

-- Players List Refresh
local function getPlayerTeamInfo(p)
    if p.Team and p.Team.Name then
        local teamName = p.Team.Name
        if teamName == "Maximum Security" then
            return "Max", brightenColor(p.Team.TeamColor.Color)
        elseif teamName == "Minimum Security" then
            return "Min", brightenColor(p.Team.TeamColor.Color)
        end
    end
    return nil, nil
end

local function refreshPlayers()
    for _,v in scroll:GetChildren() do if v:IsA("TextButton") then v:Destroy() end end
    
    local maxPlayers = {}
    local minPlayers = {}
    
    for _, p in Players:GetPlayers() do
        if p ~= player then
            local teamType, textColor = getPlayerTeamInfo(p)
            if teamType == "Max" then
                table.insert(maxPlayers, {player = p, color = textColor})
            elseif teamType == "Min" then
                table.insert(minPlayers, {player = p, color = textColor})
            end
        end
    end
    
    for _, info in ipairs(maxPlayers) do
        local p = info.player
        local textColor = info.color
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95,0,0,50)
        btn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
        btn.Text = p.Name .. " (Max)"
        btn.TextColor3 = textColor
        btn.TextSize = 24
        btn.Font = Enum.Font.Gotham
        btn.AutoButtonColor = false
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
        
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = p
            for _,b in scroll:GetChildren() do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(62, 39, 78)
            game.StarterGui:SetCore("SendNotification",{Title="Target Selected",Text="Drop at: "..p.Name.." (Max)",Duration=3})
        end)
    end
    
    for _, info in ipairs(minPlayers) do
        local p = info.player
        local textColor = info.color
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95,0,0,50)
        btn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
        btn.Text = p.Name .. " (Min)"
        btn.TextColor3 = textColor
        btn.TextSize = 24
        btn.Font = Enum.Font.Gotham
        btn.AutoButtonColor = false
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
        
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = p
            for _,b in scroll:GetChildren() do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(62, 39, 78)
            game.StarterGui:SetCore("SendNotification",{Title="Target Selected",Text="Drop at: "..p.Name.." (Min)",Duration=3})
        end)
    end
    
    local totalPlayers = #maxPlayers + #minPlayers
    scroll.CanvasSize = UDim2.new(0,0,0,totalPlayers * 58)
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- ==================== Teleport Tab ====================
local tpContent = tabContents["Teleport"]

local teleportButtons = {
    {name = "Gun", action = "gun"},
    {name = "Keycard", action = "keycard"},
    {name = "Maintenance", pos = CFrame.new(172.34, 23.10, -143.87)},
    {name = "Security", pos = CFrame.new(224.47, 23.10, -167.90)},
    {name = "OC Lockers", pos = CFrame.new(137.60, 23.10, -169.93)},
    {name = "RIOT Lockers", pos = CFrame.new(165.63, 23.10, -192.25)},
    {name = "Ventilation", pos = CFrame.new(76.96, -7.02, -19.21)},
    {name = "Maximum", pos = CFrame.new(99.85, -8.87, -156.13)},
    {name = "Generator", pos = CFrame.new(100.95, -8.82, -57.59)},
    {name = "Outside", pos = CFrame.new(350.22, 5.40, -171.09)},
    {name = "Escape Base", pos = CFrame.new(749.02, -0.97, -470.45)},
    {name = "Escape", pos = CFrame.new(307.06, 5.40, -177.88)},
    {name = "Keycard (💳)", pos = CFrame.new(-13.36, 22.13, -27.47)},
    {name = "GAS STATION", pos = CFrame.new(274.30, 6.21, -612.77)},
    {name = "armory", pos = CFrame.new(189.40, 23.10, -214.47)},
    {name = "BARN", pos = CFrame.new(43.68, 10.37, 395.04)},
    {name = "R&D", pos = CFrame.new(-182.35, -85.90, 158.07)}
}

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1,0,1,0)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 6
tpScroll.Parent = tpContent

local tpList = Instance.new("UIListLayout")
tpList.Padding = UDim.new(0,8)
tpList.Parent = tpScroll

for i, tp in ipairs(teleportButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95,0,0,50)
    btn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
    btn.Text = tp.name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 24
    btn.Font = Enum.Font.Gotham
    btn.AutoButtonColor = false
    btn.Parent = tpScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    
    if tp.action == "gun" then
        btn.MouseButton1Click:Connect(function()
            game.StarterGui:SetCore("SendNotification",{Title="Gun Activated",Text="WIP",Duration=3})
        end)
    elseif tp.action == "keycard" then
        btn.MouseButton1Click:Connect(function()
            game.StarterGui:SetCore("SendNotification",{Title="Keycard Activated",Text="WIP",Duration=3})
        end)
    elseif tp.pos then
        btn.MouseButton1Click:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = tp.pos
                game.StarterGui:SetCore("SendNotification",{Title="Teleported",Text="To " .. tp.name,Duration=3})
            end
        end)
    end
end

tpScroll.CanvasSize = UDim2.new(0,0,0,#teleportButtons*58)

-- ==================== Player Tab (Speed, Invisible, Fly) ====================
local playerContent = tabContents["Player"]

getgenv().Psalms = getgenv().Psalms or {
    Tech = {
        speedvalue = 3,
        cframespeedtoggle = false
    }
}

local function UpdateSpeedValue(newValue)
    local numValue = tonumber(newValue)
    if numValue and numValue >= 0 and numValue <= 10 then
        getgenv().Psalms.Tech.speedvalue = numValue
        if getgenv().flyEnabled then
            EnableFly(false)
            EnableFly(true)
        end
        if getgenv().Psalms.Tech.cframespeedtoggle then
            EnableCFrameSpeed(false)
            EnableCFrameSpeed(true)
        end
    end
end

local function EnableCFrameSpeed(state)
    getgenv().Psalms.Tech.cframespeedtoggle = state
    local speeds = getgenv().Psalms.Tech.speedvalue
    local tpwalking = false
    local speaker = player
    if state then
        tpwalking = true
        for i = 1, speeds do
            spawn(function()
                local hb = RunService.Heartbeat
                local chr = speaker.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
    else
        tpwalking = false
    end
end

local HideEnabled, LastCFrame
local function EnableInvisible(state)
    HideEnabled = state
    if not state then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = LastCFrame
        end
        LastCFrame = nil
        return
    end
    local heartbeatConn
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not HideEnabled then heartbeatConn:Disconnect() return end
        if player.Character then
            local HumanoidRootPart = player.Character.HumanoidRootPart
            if HumanoidRootPart then
                local Offset = HumanoidRootPart.CFrame * CFrame.new(9e9, 0, 9e9)
                LastCFrame = HumanoidRootPart.CFrame
                HumanoidRootPart.CFrame = Offset
                RunService.RenderStepped:Wait()
                HumanoidRootPart.CFrame = LastCFrame
            end
        end
    end)
end

local function EnableFly(state)
    getgenv().flyEnabled = state
    local speeds = getgenv().Psalms.Tech.speedvalue
    local speaker = player
    local chr = speaker.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    local nowe = false
    local tpwalking = false
    local rsConn = nil
    local flyLoopConn = nil
    if state then
        nowe = true
        for i = 1, speeds do
            spawn(function()
                local hb = RunService.Heartbeat
                local chr = speaker.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                tpwalking = true
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
        speaker.Character.Animate.Disabled = true
        local humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end
        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
            local torso = speaker.Character.Torso
            local ctrl, lastctrl = {f = 0, b = 0, l = 0, r = 0}, {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0
            local bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame
            local bv = Instance.new("BodyVelocity", torso)
            bv.velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            speaker.Character.Humanoid.PlatformStand = true
            rsConn = RunService.RenderStepped:Connect(function()
                if not nowe then rsConn:Disconnect() return end
                if speaker.Character.Humanoid.Health == 0 then return end
                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed + 0.5 + (speed / maxspeed)
                    if speed > maxspeed then speed = maxspeed end
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                    speed = speed - 1
                    if speed < 0 then speed = 0 end
                end
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((camera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((camera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - camera.CoordinateFrame.p)) * speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                    bv.velocity = ((camera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((camera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - camera.CoordinateFrame.p)) * speed
                else
                    bv.velocity = Vector3.new(0, 0, 0)
                end
                bg.cframe = camera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
            end)
        else
            local UpperTorso = speaker.Character.UpperTorso
            local ctrl, lastctrl = {f = 0, b = 0, l = 0, r = 0}, {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0
            local bg = Instance.new("BodyGyro", UpperTorso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = UpperTorso.CFrame
            local bv = Instance.new("BodyVelocity", UpperTorso)
            bv.velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            speaker.Character.Humanoid.PlatformStand = true
            flyLoopConn = spawn(function()
                while nowe or player.Character.Humanoid.Health == 0 do
                    wait()
                    if not nowe then break end
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed + 0.5 + (speed / maxspeed)
                        if speed > maxspeed then speed = maxspeed end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed - 1
                        if speed < 0 then speed = 0 end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((camera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((camera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - camera.CoordinateFrame.p)) * speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((camera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((camera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - camera.CoordinateFrame.p)) * speed
                    else
                        bv.velocity = Vector3.new(0, 0, 0)
                    end
                    bg.cframe = camera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
                end
                ctrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.PlatformStand = false
                end
                player.Character.Animate.Disabled = false
                tpwalking = false
            end)
        end
    else
        nowe = false
        tpwalking = false
        if rsConn then rsConn:Disconnect() rsConn = nil end
        if flyLoopConn then coroutine.close(flyLoopConn) flyLoopConn = nil end
        local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            humanoid.PlatformStand = false
        end
        local bodies = speaker.Character:FindFirstChild("UpperTorso") or speaker.Character:FindFirstChild("Torso")
        if bodies then
            local bg = bodies:FindFirstChild("BodyGyro")
            local bv = bodies:FindFirstChild("BodyVelocity")
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
        speaker.Character.Animate.Disabled = false
    end
end

-- أزرار Player Tab
local speedEnabled, invisibleEnabled, flyEnabled = false, false, false
getgenv().flyEnabled = false

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.8, 0, 0, 60)
speedBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
speedBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
speedBtn.Text = "Speed: OFF"
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.TextSize = 30
speedBtn.Font = Enum.Font.GothamBold
speedBtn.Parent = playerContent
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 14)
speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    EnableCFrameSpeed(speedEnabled)
    speedBtn.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(62, 39, 78) or Color3.fromRGB(102, 65, 129)
end)

local invisibleBtn = Instance.new("TextButton")
invisibleBtn.Size = UDim2.new(0.8, 0, 0, 60)
invisibleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
invisibleBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
invisibleBtn.Text = "Invisible: OFF"
invisibleBtn.TextColor3 = Color3.new(1,1,1)
invisibleBtn.TextSize = 30
invisibleBtn.Font = Enum.Font.GothamBold
invisibleBtn.Parent = playerContent
Instance.new("UICorner", invisibleBtn).CornerRadius = UDim.new(0, 14)
invisibleBtn.MouseButton1Click:Connect(function()
    invisibleEnabled = not invisibleEnabled
    EnableInvisible(invisibleEnabled)
    invisibleBtn.Text = "Invisible: " .. (invisibleEnabled and "ON" or "OFF")
    invisibleBtn.BackgroundColor3 = invisibleEnabled and Color3.fromRGB(62, 39, 78) or Color3.fromRGB(102, 65, 129)
end)

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.8, 0, 0, 60)
flyBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.TextSize = 30
flyBtn.Font = Enum.Font.GothamBold
flyBtn.Parent = playerContent
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 14)
flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    EnableFly(flyEnabled)
    flyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(62, 39, 78) or Color3.fromRGB(102, 65, 129)
end)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.8, 0, 0, 50)
speedInput.Position = UDim2.new(0.1, 0, 0.7, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(52, 50, 82)
speedInput.Text = tostring(getgenv().Psalms.Tech.speedvalue)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.TextSize = 28
speedInput.Font = Enum.Font.GothamBold
speedInput.PlaceholderText = "Speed (0-10)"
speedInput.Parent = playerContent
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 14)

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        UpdateSpeedValue(speedInput.Text)
        speedInput.Text = tostring(getgenv().Psalms.Tech.speedvalue)
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
        char.Animate.Disabled = false
    end
end)

-- ==================== دوال الـ Spawn المحسّنة ====================

-- محاكاة ضغط E كاملة
local function triggerPrompt(prompt)
    if not prompt or not prompt.Enabled or not prompt.Parent then return end
    prompt:InputHoldBegin()
    task.wait(prompt.HoldDuration + 0.2)
    prompt:InputHoldEnd()
end

-- MakeInvisible / MakeVisible
local function MakeInvisible(char)
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            if part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 1
                handle.CanCollide = false
            end
        end
    end
    if char:FindFirstChild("Head") then
        for _, v in ipairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
    end
end

local function MakeVisible(char)
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            if part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 0
                handle.CanCollide = true
            end
        end
    end
    if char:FindFirstChild("Head") then
        for _, v in ipairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = true
            end
        end
    end
end

-- RunMin
local function RunMin(dropPos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local oldCamType = camera.CameraType
    local oldCamSubject = camera.CameraSubject
    local camConnection

    local secretDropPos = dropPos or MinSecretDropPos
    local camDropPos = dropPos and (dropPos + Vector3.new(0, 5, -10)) or MinCamDropPos

    local function FixCamera(pos, target)
        if camConnection then camConnection:Disconnect() end
        camera.CameraType = Enum.CameraType.Scriptable
        camConnection = RunService.RenderStepped:Connect(function()
            camera.CFrame = CFrame.lookAt(pos, target or secretDropPos)
        end)
    end

    local function RestoreCamera()
        task.wait(3)
        if camConnection then camConnection:Disconnect() end
        camera.CameraType = oldCamType
        camera.CameraSubject = oldCamSubject
    end

    FixCamera(MinCamArmoryPos, MinArmoryPos)
    hrp.CFrame = CFrame.new(MinArmoryPos)
    task.wait(0.7)

    for i = 1, 6 do
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                task.spawn(triggerPrompt, v)
            end
        end
        hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-1.5, 1.5), 0, math.random(-1.5, 1.5))
        task.wait(0.8)
    end

    task.wait(5)

    MakeInvisible(char)

    hrp.CFrame = CFrame.new(secretDropPos)
    FixCamera(camDropPos, secretDropPos)

    local posFix = RunService.Heartbeat:Connect(function()
        hrp.CFrame = CFrame.new(secretDropPos)
    end)

    task.wait(0.5)

    repeat
        local droppedAny = false
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                droppedAny = true
                tool.Parent = char
                task.wait(0.25)
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (string.find(string.lower(obj.Name), "drop") or string.find(string.lower(obj.Name), "send") or string.find(string.lower(obj.Name), "key")) then
                        obj:FireServer()
                        break
                    end
                end
                task.wait(0.35)
            end
        end
        task.wait(0.5)
    until not droppedAny

    if posFix then posFix:Disconnect() end

    MakeVisible(char)
    hrp.CFrame = CFrame.new(FinalFarmPos)
    task.wait(0.5)
    hum:ChangeState(Enum.HumanoidStateType.Dead)
    task.spawn(RestoreCamera)

    game.StarterGui:SetCore("SendNotification", {
        Title = "سرقة + نقل + ريسبون ✅";
        Text = "الأسلحة دروبت وانتقلت للفارم قبل الريسبون 🔥";
        Duration = 8;
    })
end

-- RunMax
local function RunMax(dropPos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local oldCamType = camera.CameraType
    local oldCamSubject = camera.CameraSubject
    local camConnection

    local secretDropPos = dropPos or MaxSecretDropPos
    local camDropPos = dropPos and (dropPos + Vector3.new(0, 5, -10)) or MaxCamDropPos

    local function FixCamera(pos, target)
        if camConnection then camConnection:Disconnect() end
        camera.CameraType = Enum.CameraType.Scriptable
        camConnection = RunService.RenderStepped:Connect(function()
            camera.CFrame = CFrame.lookAt(pos, target or secretDropPos)
        end)
    end

    local function RestoreCamera()
        task.wait(3)
        if camConnection then camConnection:Disconnect() end
        camera.CameraType = oldCamType
        camera.CameraSubject = oldCamSubject
    end

    FixCamera(MaxCamArmoryPos, MaxArmoryPos)
    hrp.CFrame = CFrame.new(MaxArmoryPos)
    task.wait(0.7)

    for i = 1, 6 do
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                task.spawn(triggerPrompt, v)
            end
        end
        hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-1.5, 1.5), 0, math.random(-1.5, 1.5))
        task.wait(0.8)
    end

    task.wait(5)

    MakeInvisible(char)

    hrp.CFrame = CFrame.new(secretDropPos)
    FixCamera(camDropPos, secretDropPos)

    local posFix = RunService.Heartbeat:Connect(function()
        hrp.CFrame = CFrame.new(secretDropPos)
    end)

    task.wait(0.5)

    repeat
        local droppedAny = false
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                droppedAny = true
                tool.Parent = char
                task.wait(0.25)
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (string.find(string.lower(obj.Name), "drop") or string.find(string.lower(obj.Name), "send") or string.find(string.lower(obj.Name), "key")) then
                        obj:FireServer()
                        break
                    end
                end
                task.wait(0.35)
            end
        end
        task.wait(0.5)
    until not droppedAny

    if posFix then posFix:Disconnect() end

    MakeVisible(char)
    hrp.CFrame = CFrame.new(FinalFarmPos)
    task.wait(0.5)
    hum:ChangeState(Enum.HumanoidStateType.Dead)
    task.spawn(RestoreCamera)

    game.StarterGui:SetCore("SendNotification", {
        Title = "سرقة + نقل + ريسبون ✅";
        Text = "الأسلحة دروبت وانتقلت للفارم قبل الريسبون 🔥";
        Duration = 8;
    })
end

-- تنفيذ Spawn
local function executeSelected(tabType)
    if tabType == "Locations" then
        if selectedLocation == "Min" then
            RunMin()
        elseif selectedLocation == "Max" then
            RunMax()
        end
    elseif tabType == "Players" then
        if selectedPlayer then
            local targetPos = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") and selectedPlayer.Character.HumanoidRootPart.Position or FinalFarmPos
            if selectedLocation == "Min" then
                RunMin(targetPos)
            elseif selectedLocation == "Max" then
                RunMax(targetPos)
            end
        end
    end
end

local function startLoadingAnimation(dot)
    dot.Visible = true
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(dot, tweenInfo, {Transparency = 1})
    tween:Play()
    return tween
end

local function startCooldown(tabType)
    local dot
    if tabType == "Locations" then
        isOnCooldownLocations = true
        dot = locLoadingDot
    elseif tabType == "Players" then
        isOnCooldownPlayers = true
        dot = playersLoadingDot
    end
    local tween = startLoadingAnimation(dot)
    task.wait(cooldownTime)
    tween:Cancel()
    dot.Transparency = 0
    dot.Visible = false
    if tabType == "Locations" then isOnCooldownLocations = false
    elseif tabType == "Players" then isOnCooldownPlayers = false end
end

locSpawnBtn.MouseButton1Click:Connect(function()
    if not isOnCooldownLocations and selectedLocation then
        task.spawn(executeSelected, "Locations")
        task.spawn(startCooldown, "Locations")
    end
end)

playersSpawnBtn.MouseButton1Click:Connect(function()
    if not isOnCooldownPlayers and selectedPlayer then
        task.spawn(executeSelected, "Players")
        task.spawn(startCooldown, "Players")
    end
end)
