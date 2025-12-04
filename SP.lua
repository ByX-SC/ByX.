local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera
-- متغيرات الحالة
local selectedLocation = nil -- خيار واحد فقط في Locations ("Min" أو "Max")
local selectedPlayer = nil -- لاعب واحد فقط في Players
local isOnCooldownLocations = false
local isOnCooldownPlayers = false
local cooldownTime = 9 -- 9 ثواني كول داون
-- إحداثيات Min الجديدة (اللي طلبتها للـ Min)
local MinArmoryPos = Vector3.new(196, 23.23, -215)
local MinSecretDropPos = Vector3.new(-6.64, 26.10, -58.50)
local MinCamArmoryPos = Vector3.new(197.10, 24.68, -215.00)
local MinCamDropPos = Vector3.new(-6.10, 24.13, -104.07)
-- إحداثيات Max الجديدة
local MaxArmoryPos = Vector3.new(196, 23.23, -215)
local MaxSecretDropPos = Vector3.new(58.19, -8.87, -140.50)
local MaxCamArmoryPos = Vector3.new(197.10, 24.68, -215.00)
local MaxCamDropPos = Vector3.new(85.27, -7.25, -140.44)
-- إحداثيات عامة
local ArmoryTeleport = Vector3.new(189.40, 23.10, -214.47) -- زر Armory
local FinalFarmPos = Vector3.new(20.06, 11.23, -117.39) -- النهاية + Teleport to Farm
-- ===================================
-- إنشاء الواجهة الرسومية (الثيم الجديد)
-- ===================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GunSpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 580)
mainFrame.Position = UDim2.new(0, 20, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.new(1, 1, 1) -- ليظهر التدرج
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 50, 82)), -- #343252
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 22, 44)), -- #23162C
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 19)) -- #0C0C13
})
gradient.Rotation = 0 -- تدرج أفقي
gradient.Parent = mainFrame
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 3
mainStroke.Color = Color3.fromRGB(0, 0, 0)
mainStroke.Parent = mainFrame
-- التبويبات
local tabNames = {"Locations", "Players", "Teleport"}
local tabButtons = {}
local tabContents = {}
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0.9, 0, 0, 50)
tabsFrame.Position = UDim2.new(0.05, 0, 0, 20) -- عدلت الموقع بعد شيل العنوان
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = mainFrame
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.333, 0, 0, 0)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(62, 39, 78) or Color3.fromRGB(102, 65, 129) -- نشط #3E274E، غير نشط #664181
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 22
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = tabsFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    tabButtons[name] = btn
    local content = Instance.new("Frame")
    content.Size = UDim2.new(0.9, 0, 0, 500) -- زدت الحجم بعد شيل العنوان
    content.Position = UDim2.new(0.05, 0, 0, 80)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    tabContents[name] = content
end
-- دالة لتعيين الشفافية بشكل فوري
local function setTransparency(frame, trans)
    local function recurse(f)
        if f:IsA("TextLabel") or f:IsA("TextButton") then
            f.TextTransparency = trans
        end
        if f:IsA("ImageLabel") or f:IsA("ImageButton") then
            f.ImageTransparency = trans
        end
        if not f:IsA("ScrollingFrame") then
            f.BackgroundTransparency = trans
        end
        for _, child in ipairs(f:GetChildren()) do
            if child:IsA("GuiObject") then
                recurse(child)
            end
        end
    end
    recurse(frame)
end
-- دالة لتلاشي الإطار
local function fadeFrame(frame, startTrans, endTrans, info)
    local tweens = {}
    local function recurse(f)
        if f:IsA("TextLabel") or f:IsA("TextButton") then
            f.TextTransparency = startTrans
            table.insert(tweens, TweenService:Create(f, info, {TextTransparency = endTrans}))
        end
        if f:IsA("ImageLabel") or f:IsA("ImageButton") then
            f.ImageTransparency = startTrans
            table.insert(tweens, TweenService:Create(f, info, {ImageTransparency = endTrans}))
        end
        if f:IsA("Frame") or f:IsA("ScrollingFrame") or f:IsA("TextButton") or f:IsA("ImageButton") then
            if not f:IsA("ScrollingFrame") then
                f.BackgroundTransparency = startTrans
                table.insert(tweens, TweenService:Create(f, info, {BackgroundTransparency = endTrans}))
            end
        end
        for _, child in ipairs(f:GetChildren()) do
            if child:IsA("GuiObject") then
                recurse(child)
            end
        end
    end
    recurse(frame)
    for _, t in ipairs(tweens) do
        t:Play()
    end
end
-- تبديل التبويبات مع تلاشي سلس
local currentTab = "Locations"
for _, name in ipairs(tabNames) do
    tabButtons[name].MouseButton1Click:Connect(function()
        for k, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(102, 65, 129) -- غير نشط #664181
            tabContents[k].Visible = false
        end
        tabButtons[name].BackgroundColor3 = Color3.fromRGB(62, 39, 78) -- نشط #3E274E
        local newContent = tabContents[name]
        setTransparency(newContent, 1)
        newContent.Visible = true
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        fadeFrame(newContent, 1, 0, tweenInfo)
    end)
end
-- ==================== Locations Tab (Min & Max) ====================
local locContent = tabContents["Locations"]
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.9, 0, 0, 70)
minBtn.Position = UDim2.new(0.05, 0, 0, 20)
minBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129) -- #664181
minBtn.Text = "Min Lobby"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 30
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = locContent
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 14)
local maxBtn = Instance.new("TextButton")
maxBtn.Size = UDim2.new(0.9, 0, 0, 70)
maxBtn.Position = UDim2.new(0.05, 0, 0, 110)
maxBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129) -- #664181
maxBtn.Text = "Max"
maxBtn.TextColor3 = Color3.new(1,1,1)
maxBtn.TextSize = 30
maxBtn.Font = Enum.Font.GothamBold
maxBtn.Parent = locContent
Instance.new("UICorner", maxBtn).CornerRadius = UDim.new(0, 14)
-- عند الضغط على Min يتحول لونه
minBtn.MouseButton1Click:Connect(function()
    minBtn.BackgroundColor3 = Color3.fromRGB(62, 39, 78) -- نشط #3E274E
    maxBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129) -- #664181
    selectedLocation = "Min"
end)
maxBtn.MouseButton1Click:Connect(function()
    maxBtn.BackgroundColor3 = Color3.fromRGB(62, 39, 78) -- نشط #3E274E
    minBtn.BackgroundColor3 = Color3.fromRGB(102, 65, 129) -- #664181
    selectedLocation = "Max"
end)
-- زر Spawn لـ Locations
local locSpawnBtn = Instance.new("TextButton")
locSpawnBtn.Size = UDim2.new(0.9, 0, 0, 60)
locSpawnBtn.Position = UDim2.new(0.05, 0, 0, 200)
locSpawnBtn.BackgroundColor3 = Color3.fromRGB(52, 50, 82) -- #343252
locSpawnBtn.Text = "Spawn"
locSpawnBtn.TextColor3 = Color3.new(1,1,1)
locSpawnBtn.TextSize = 30
locSpawnBtn.Font = Enum.Font.GothamBold
locSpawnBtn.Parent = locContent
Instance.new("UICorner", locSpawnBtn).CornerRadius = UDim.new(0, 14)
-- إنشاء النقطة للتحميل داخل الزر
local locLoadingDot = Instance.new("Frame")
locLoadingDot.Size = UDim2.new(0, 20, 0, 20)
locLoadingDot.Position = UDim2.new(1, -30, 0.5, -10)
locLoadingDot.BackgroundColor3 = Color3.fromHex("#22B365")
locLoadingDot.Visible = false
locLoadingDot.Parent = locSpawnBtn
Instance.new("UICorner", locLoadingDot).CornerRadius = UDim.new(1, 0) -- دائرة
-- ==================== Players Tab ====================
local playersContent = tabContents["Players"]
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,0.8,0)
scroll.Position = UDim2.new(0,0,0,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = playersContent
local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,8)
list.Parent = scroll
local function refreshPlayers()
    for _,v in scroll:GetChildren() do if v:IsA("TextButton") then v:Destroy() end end
    for _,p in Players:GetPlayers() do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.95,0,0,50)
            btn.BackgroundColor3 = Color3.fromRGB(102, 65, 129) -- #664181
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextSize = 24
            btn.Font = Enum.Font.Gotham
            btn.AutoButtonColor = false
            btn.Parent = scroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                for _,b in scroll:GetChildren() do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(102, 65, 129) end end
                btn.BackgroundColor3 = Color3.fromRGB(62, 39, 78) -- نشط #3E274E
                game.StarterGui:SetCore("SendNotification",{Title="Target Selected",Text="Drop at: "..p.Name,Duration=3})
            end)
        end
    end
    scroll.CanvasSize = UDim2.new(0,0,0,(#Players:GetPlayers()-1)*58)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()
-- زر Spawn لـ Players (تحت الـ ScrollingFrame تمامًا)
local playersSpawnBtn = Instance.new("TextButton")
playersSpawnBtn.Size = UDim2.new(0.9, 0, 0, 60)
playersSpawnBtn.Position = UDim2.new(0.05, 0, 0.82, 0) -- تحت الـ scroll
playersSpawnBtn.BackgroundColor3 = Color3.fromRGB(52, 50, 82) -- #343252
playersSpawnBtn.Text = "Spawn"
playersSpawnBtn.TextColor3 = Color3.new(1,1,1)
playersSpawnBtn.TextSize = 30
playersSpawnBtn.Font = Enum.Font.GothamBold
playersSpawnBtn.Parent = playersContent
Instance.new("UICorner", playersSpawnBtn).CornerRadius = UDim.new(0, 14)
-- إنشاء النقطة للتحميل داخل الزر
local playersLoadingDot = Instance.new("Frame")
playersLoadingDot.Size = UDim2.new(0, 20, 0, 20)
playersLoadingDot.Position = UDim2.new(1, -30, 0.5, -10)
playersLoadingDot.BackgroundColor3 = Color3.fromHex("#22B365")
playersLoadingDot.Visible = false
playersLoadingDot.Parent = playersSpawnBtn
Instance.new("UICorner", playersLoadingDot).CornerRadius = UDim.new(1, 0) -- دائرة
-- ==================== Teleport Tab ====================
local tpContent = tabContents["Teleport"]
-- أزرار التليبورت الجديدة (بدون وظائف بعد)
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
-- إنشاء ScrollingFrame لكل الأزرار
local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1,0,1,0)
tpScroll.Position = UDim2.new(0,0,0,0)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 6
tpScroll.Parent = tpContent
local tpList = Instance.new("UIListLayout")
tpList.Padding = UDim.new(0,8)
tpList.Parent = tpScroll
for i, tp in ipairs(teleportButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95,0,0,50)
    btn.BackgroundColor3 = Color3.fromRGB(102, 65, 129) -- #664181
    btn.Text = tp.name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 24
    btn.Font = Enum.Font.Gotham
    btn.AutoButtonColor = false
    btn.Parent = tpScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    if tp.action == "gun" then
        btn.MouseButton1Click:Connect(function()
            -- أضف وظيفة الـ Gun هنا
            game.StarterGui:SetCore("SendNotification",{Title="Gun Activated",Text="WIP",Duration=3})
        end)
    elseif tp.action == "keycard" then
        btn.MouseButton1Click:Connect(function()
            -- أضف وظيفة الـ Keycard هنا
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
-- ===================================
-- دالة Min (الجديدة تماماً زي اللي بعثتها)
-- ===================================
local function RunMin(dropPos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local oldCamType = camera.CameraType
    local oldCamSubject = camera.CameraSubject
    local camConnection
    local secretDropPos = dropPos or MinSecretDropPos -- استخدم dropPos إذا موجود، وإلا الافتراضي
    local camDropPos = dropPos and (dropPos + Vector3.new(0, 5, -10)) or MinCamDropPos -- تعديل كاميرا إذا dropPos
    local function FixCamera(pos, target)
        if camConnection then camConnection:Disconnect() end
        camera.CameraType = Enum.CameraType.Scriptable
        camConnection = RunService.RenderStepped:Connect(function()
            camera.CFrame = CFrame.lookAt(pos, target or secretDropPos)
        end)
    end
    local function RestoreCamera()
        task.wait(3)
        if camConnection then
            camConnection:Disconnect()
            camConnection = nil
        end
        camera.CameraType = oldCamType
        camera.CameraSubject = oldCamSubject
    end
    local function MakeInvisible()
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
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
    local function MakeVisible()
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
                part.CanCollide = true
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
    MakeInvisible()
    FixCamera(MinCamArmoryPos, MinArmoryPos)
    hrp.CFrame = CFrame.new(MinArmoryPos)
    task.wait(0.4)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            task.spawn(function()
                fireproximityprompt(v)
            end)
        end
    end
    task.wait(1.1)
    hrp.CFrame = CFrame.new(secretDropPos)
    FixCamera(camDropPos, secretDropPos)
    local posFix = RunService.Heartbeat:Connect(function()
        hrp.CFrame = CFrame.new(secretDropPos)
    end)
    task.wait(0.4)
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
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
    if posFix then posFix:Disconnect() end
    MakeVisible()
    hrp.CFrame = CFrame.new(FinalFarmPos)
    task.wait(0.5)
    hum:ChangeState(Enum.HumanoidStateType.Dead)
    task.spawn(RestoreCamera)
    game.StarterGui:SetCore("SendNotification", {
        Title = "سرقة + نقل جديد + ريسبون ✅";
        Text = "الأسلحة دروب وانتقلت لـ X:20.06 Y:11.23 Z:-117.39 قبل الريسبون 🔥";
        Duration = 8;
    })
end
-- ===================================
-- دالة Max (تبقى كما هي، مع تعديل مشابه)
-- ===================================
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
        if camConnection then
            camConnection:Disconnect()
            camConnection = nil
        end
        camera.CameraType = oldCamType
        camera.CameraSubject = oldCamSubject
    end
    local function MakeInvisible()
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
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
    local function MakeVisible()
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
                part.CanCollide = true
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
    MakeInvisible()
    FixCamera(MaxCamArmoryPos, MaxArmoryPos)
    hrp.CFrame = CFrame.new(MaxArmoryPos)
    task.wait(0.4)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            task.spawn(function()
                fireproximityprompt(v)
            end)
        end
    end
    task.wait(1.1)
    hrp.CFrame = CFrame.new(secretDropPos)
    FixCamera(camDropPos, secretDropPos)
    local posFix = RunService.Heartbeat:Connect(function()
        hrp.CFrame = CFrame.new(secretDropPos)
    end)
    task.wait(0.4)
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
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
    if posFix then posFix:Disconnect() end
    MakeVisible()
    hrp.CFrame = CFrame.new(FinalFarmPos)
    task.wait(0.5)
    hum:ChangeState(Enum.HumanoidStateType.Dead)
    task.spawn(RestoreCamera)
    game.StarterGui:SetCore("SendNotification", {
        Title = "سرقة + نقل جديد + ريسبون ✅";
        Text = "الأسلحة دروب وانتقلت لـ X:20.06 Y:11.23 Z:-117.39 قبل الريسبون 🔥";
        Duration = 8;
    })
end
-- دالة تنفيذ عامة للـ Locations أو Players (واحد تلو الآخر)
local function executeSelected(tabType)
    stopSignal = false
    if tabType == "Locations" then
        if selectedLocation == "Min" then
            RunMin()
        elseif selectedLocation == "Max" then
            RunMax()
        end
    elseif tabType == "Players" then
        if selectedPlayer then
            local targetPos = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") and selectedPlayer.Character.HumanoidRootPart.Position or FinalFarmPos
            RunMin(targetPos) -- استخدم RunMin مع موقع اللاعب (أو غيّر لـ RunMax إذا لزم)
        end
    end
end
-- دالة لتشغيل أنيميشن التلاشي للنقطة
local function startLoadingAnimation(dot)
    dot.Visible = true
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(dot, tweenInfo, {Transparency = 1})
    tween:Play()
    return tween
end
-- دالة الكول داون مع النقطة بدلاً من الرمادي
local function startCooldown(tabType)
    local dot, btn
    if tabType == "Locations" then
        isOnCooldownLocations = true
        dot = locLoadingDot
        btn = locSpawnBtn
    elseif tabType == "Players" then
        isOnCooldownPlayers = true
        dot = playersLoadingDot
        btn = playersSpawnBtn
    end
    local tween = startLoadingAnimation(dot)
    task.wait(cooldownTime)
    tween:Cancel()
    dot.Transparency = 0
    dot.Visible = false
    if tabType == "Locations" then
        isOnCooldownLocations = false
    elseif tabType == "Players" then
        isOnCooldownPlayers = false
    end
end
-- ربط زر Spawn لـ Locations
locSpawnBtn.MouseButton1Click:Connect(function()
    if not isOnCooldownLocations then
        if selectedLocation then
            task.spawn(executeSelected, "Locations")
            task.spawn(startCooldown, "Locations")
        end
    end
end)
-- ربط زر Spawn لـ Players
playersSpawnBtn.MouseButton1Click:Connect(function()
    if not isOnCooldownPlayers then
        if selectedPlayer then
            task.spawn(executeSelected, "Players")
            task.spawn(startCooldown, "Players")
        end
    end
end)
