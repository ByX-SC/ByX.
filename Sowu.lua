-- Load Rayfield UI Library
local success, Rayfield = pcall(function() return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() end)
if not success then
    warn("Failed to load Rayfield: " .. tostring(Rayfield))
    return
end
print("Rayfield loaded successfully!")

-- Random theme selection
local themes = {"Ocean", "Amethyst", "DarkBlue"}
local randomIndex = math.random(1, #themes)
local randomTheme = themes[randomIndex]

-- Create the Window with KeySystem enabled
local Window = Rayfield:CreateWindow({
    Name = "Valley Prison ByX",
    LoadingTitle = ".",
    LoadingSubtitle = "ByX",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "Valley Prison ByX",
        Subtitle = "Enter the key to unlock the script",
        Note = ".",
        Key = "BYXVALLYPRISON_BEST2025ioiup_V2",
        SaveKey = false,
        WrongKeyMessage = "Incorrect key! Please try again.",
        CorrectKeyMessage = "Script unlocked successfully!"
    },
    Theme = randomTheme
})

-- Verify KeySystem
if not Window then
    warn("KeySystem failed to initialize. Please enter the key: BYXVALLYPRISON_BEST2025ioiup_V2")
    return
else
    print("KeySystem validated successfully!")
end

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local prisonerTeams = {"Minimum Security", "Medium Security", "Maximum Security"}

-- // INFO TAB
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateButton({
    Name = "Copy yt Link",
    Callback = function()
        local link = "https://www.youtube.com/@6rb-l5r"
        if setclipboard then
            setclipboard(link)
            Rayfield:Notify({ Title = "Link Copied!", Content = "The link has been copied to your clipboard.", Duration = 3, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Your executor does not support clipboard copying. Link: " .. link, Duration = 5, Image = 4483362458 })
        end
    end
})

-- // VISUALS SECTION (ESP, Xray)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local ESPEnabled = false
local ESPType = "Highlight" -- أنواع الـ ESP: "Highlight", "Dot", "Line", "Box"
local ShowHealth = false
local ShowInventory = false
local ESPObjects = {}
local xrayEnabled = false

-- إعدادات الـ ESP الجديدة
local DotSize = 3
local LineThickness = 1
local BoxThickness = 1

-- وظيفة لإنشاء Dot ESP
local function CreateDotESP(player, espHolder)
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    if not espHolder.Dot then
        local dot = Drawing.new("Circle")
        dot.Visible = false
        dot.Color = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        dot.Thickness = 1
        dot.Filled = true
        dot.Transparency = 1
        dot.Radius = DotSize
        espHolder.Dot = dot
    end
    
    return espHolder.Dot
end

-- وظيفة لإنشاء Line ESP
local function CreateLineESP(player, espHolder)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    if not espHolder.Line then
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        line.Thickness = LineThickness
        line.Transparency = 1
        espHolder.Line = line
    end
    
    return espHolder.Line
end

-- وظيفة لإنشاء Box ESP
local function CreateBoxESP(player, espHolder)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    if not espHolder.Box then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        box.Thickness = BoxThickness
        box.Filled = false
        box.Transparency = 1
        espHolder.Box = box
    end
    
    return espHolder.Box
end

local function updateInventory(player, espHolder)
    if not player or not espHolder or not player.Backpack or not player.Character then
        espHolder.InventoryText.Text = "Inventory: N/A"
        return
    end
    local inv = {}
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then table.insert(inv, tool.Name) end
    end
    local equipped = player.Character:FindFirstChildOfClass("Tool")
    if equipped then table.insert(inv, equipped.Name .. " (equipped)") end
    espHolder.InventoryText.Text = #inv == 0 and "Inventory: Empty" or "Inventory: " .. table.concat(inv, ", ")
end

function CreateESP(player)
    if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") then return end
    if not ESPObjects[player] then
        local espHolder = {}
        
        -- إنشاء Highlight (النوع الأساسي)
        local highlight = Instance.new("Highlight", player.Character)
        highlight.Adornee = player.Character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.3
        highlight.FillColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 1
        highlight.Enabled = ESPEnabled and ESPType == "Highlight"
        
        -- إنشاء أنواع الـ ESP الأخرى
        if ESPType == "Dot" then
            CreateDotESP(player, espHolder)
        elseif ESPType == "Line" then
            CreateLineESP(player, espHolder)
        elseif ESPType == "Box" then
            CreateBoxESP(player, espHolder)
        end
        
        local billboard = Instance.new("BillboardGui", player.Character)
        billboard.Name = "ESP_Billboard"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 200, 0, 100)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = ESPEnabled

        local healthFrame = Instance.new("Frame", billboard)
        healthFrame.Name = "HealthBar"
        healthFrame.Size = UDim2.new(1, 0, 0, 8)
        healthFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        healthFrame.BackgroundTransparency = 0.2
        healthFrame.BorderSizePixel = 1
        healthFrame.Visible = ShowHealth and ESPEnabled

        local healthBg = Instance.new("Frame", healthFrame)
        healthBg.Name = "HealthBarBg"
        healthBg.Size = UDim2.new(1, 0, 1, 0)
        healthBg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        healthBg.BackgroundTransparency = 0.7
        healthBg.BorderSizePixel = 0

        local healthText = Instance.new("TextLabel", billboard)
        healthText.Name = "HealthText"
        healthText.Size = UDim2.new(1, 0, 0, 15)
        healthText.Position = UDim2.new(0, 0, 0, 10)
        healthText.BackgroundTransparency = 1
        healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
        healthText.TextSize = 12
        healthText.Font = Enum.Font.SourceSansBold
        healthText.TextStrokeTransparency = 0
        healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        healthText.Text = "HP: N/A"
        healthText.Visible = ShowHealth and ESPEnabled

        local inventoryText = Instance.new("TextLabel", billboard)
        inventoryText.Name = "InventoryText"
        inventoryText.Size = UDim2.new(1, 0, 0, 15)
        inventoryText.Position = UDim2.new(0, 0, 0, 25)
        inventoryText.BackgroundTransparency = 1
        inventoryText.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        inventoryText.TextSize = 12
        inventoryText.Font = Enum.Font.SourceSansBold
        inventoryText.TextStrokeTransparency = 0
        inventoryText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        inventoryText.Text = "Inventory: N/A"
        inventoryText.Visible = ShowInventory and ESPEnabled and player.Team and table.find(prisonerTeams, player.Team.Name)

        local humanoid = player.Character.Humanoid
        if humanoid then
            local function updateHealth()
                if not player.Character or not humanoid or not healthFrame.Visible then
                    healthText.Text = "HP: N/A"
                    healthFrame.Size = UDim2.new(1, 0, 0, 8)
                    return
                end
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                healthFrame.Size = UDim2.new(healthPercent, 0, 0, 8)
                healthFrame.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPercent), 150 * healthPercent, 0)
                healthText.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            end
            updateHealth()
            humanoid:GetPropertyChangedSignal("Health"):Connect(updateHealth)
            humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(updateHealth)
        end

        if player.Team and table.find(prisonerTeams, player.Team.Name) then
            updateInventory(player, { InventoryText = inventoryText })
            player.Backpack.ChildAdded:Connect(function() updateInventory(player, { InventoryText = inventoryText }) end)
            player.Backpack.ChildRemoved:Connect(function() updateInventory(player, { InventoryText = inventoryText }) end)
            player.Character.ChildAdded:Connect(function(child) if child:IsA("Tool") then updateInventory(player, { InventoryText = inventoryText }) end end)
            player.Character.ChildRemoved:Connect(function(child) if child:IsA("Tool") then updateInventory(player, { InventoryText = inventoryText }) end end)
        end

        espHolder.Highlight = highlight
        espHolder.Billboard = billboard
        espHolder.HealthFrame = healthFrame
        espHolder.HealthText = healthText
        espHolder.InventoryText = inventoryText
        ESPObjects[player] = espHolder
    end
end

function RemoveESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
        if ESPObjects[player].Billboard then ESPObjects[player].Billboard:Destroy() end
        if ESPObjects[player].Dot then ESPObjects[player].Dot:Remove() end
        if ESPObjects[player].Line then ESPObjects[player].Line:Remove() end
        if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
        ESPObjects[player] = nil
    end
end

local function RefreshESP()
    if not ESPEnabled then
        Rayfield:Notify({ Title = "Info", Content = "ESP must be enabled to refresh!", Duration = 3, Image = 4483362458 })
        return
    end
    for _, espHolder in pairs(ESPObjects) do
        if espHolder.Highlight then espHolder.Highlight:Destroy() end
        if espHolder.Billboard then espHolder.Billboard:Destroy() end
        if espHolder.Dot then espHolder.Dot:Remove() end
        if espHolder.Line then espHolder.Line:Remove() end
        if espHolder.Box then espHolder.Box:Remove() end
    end
    ESPObjects = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            task.spawn(function() CreateESP(player) end)
        end
    end
    Rayfield:Notify({ Title = "Success", Content = "ESP refreshed for all players!", Duration = 3, Image = 4483362458 })
end

-- تحديث أنواع الـ ESP
local function UpdateESPType()
    for player, espHolder in pairs(ESPObjects) do
        if espHolder.Highlight then
            espHolder.Highlight.Enabled = ESPEnabled and ESPType == "Highlight"
        end
        
        if espHolder.Dot then
            espHolder.Dot.Visible = ESPEnabled and ESPType == "Dot"
        end
        
        if espHolder.Line then
            espHolder.Line.Visible = ESPEnabled and ESPType == "Line"
        end
        
        if espHolder.Box then
            espHolder.Box.Visible = ESPEnabled and ESPType == "Box"
        end
    end
end

-- تحديث الرسومات كل إطار
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    
    for player, espHolder in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            
            if ESPType == "Dot" and head and espHolder.Dot then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    espHolder.Dot.Position = Vector2.new(screenPos.X, screenPos.Y)
                    espHolder.Dot.Visible = true
                else
                    espHolder.Dot.Visible = false
                end
            end
            
            if ESPType == "Line" and rootPart and espHolder.Line then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    espHolder.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    espHolder.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                    espHolder.Line.Visible = true
                else
                    espHolder.Line.Visible = false
                end
            end
            
            if ESPType == "Box" and rootPart and head and espHolder.Box then
                local rootScreenPos, rootOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
                local headScreenPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                
                if rootOnScreen and headOnScreen then
                    local height = math.abs(headScreenPos.Y - rootScreenPos.Y) * 2
                    local width = height / 2
                    
                    espHolder.Box.Size = Vector2.new(width, height)
                    espHolder.Box.Position = Vector2.new(rootScreenPos.X - width / 2, rootScreenPos.Y - height / 2)
                    espHolder.Box.Visible = true
                else
                    espHolder.Box.Visible = false
                end
            end
        end
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            if ESPEnabled then task.wait(0.5) CreateESP(player) end
        end)
        if player.Character and ESPEnabled then task.spawn(function() task.wait(0.5) CreateESP(player) end) end
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            if ESPEnabled then task.wait(0.5) CreateESP(player) end
        end)
    end
end)

Players.PlayerRemoving:Connect(RemoveESP)

RunService.Heartbeat:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                task.spawn(function() CreateESP(player) end)
            end
        end
    end
end)

VisualsTab:CreateToggle({
    Name = "Enable ESP", CurrentValue = false, Flag = "ESP_TOGGLE",
    Callback = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    task.spawn(function() CreateESP(player) end)
                end
            end
        else
            for _, espHolder in pairs(ESPObjects) do
                if espHolder.Highlight then espHolder.Highlight:Destroy() end
                if espHolder.Billboard then espHolder.Billboard:Destroy() end
                if espHolder.Dot then espHolder.Dot:Remove() end
                if espHolder.Line then espHolder.Line:Remove() end
                if espHolder.Box then espHolder.Box:Remove() end
            end
            ESPObjects = {}
        end
    end
})

VisualsTab:CreateDropdown({
    Name = "ESP Type",
    Options = {"Highlight", "Dot", "Line", "Box"},
    CurrentOption = "Highlight",
    MultipleOptions = false,
    Flag = "ESP_TYPE",
    Callback = function(Option)
        ESPType = Option[1]
        UpdateESPType()
    end
})

VisualsTab:CreateSlider({
    Name = "Dot Size",
    Range = {1, 10},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 3,
    Flag = "DOT_SIZE",
    Callback = function(Value)
        DotSize = Value
        for _, espHolder in pairs(ESPObjects) do
            if espHolder.Dot then
                espHolder.Dot.Radius = DotSize
            end
        end
    end
})

VisualsTab:CreateSlider({
    Name = "Line Thickness",
    Range = {1, 5},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 1,
    Flag = "LINE_THICKNESS",
    Callback = function(Value)
        LineThickness = Value
        for _, espHolder in pairs(ESPObjects) do
            if espHolder.Line then
                espHolder.Line.Thickness = LineThickness
            end
        end
    end
})

VisualsTab:CreateSlider({
    Name = "Box Thickness",
    Range = {1, 5},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 1,
    Flag = "BOX_THICKNESS",
    Callback = function(Value)
        BoxThickness = Value
        for _, espHolder in pairs(ESPObjects) do
            if espHolder.Box then
                espHolder.Box.Thickness = BoxThickness
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Show Health Bar", CurrentValue = false, Flag = "SHOW_HEALTH",
    Callback = function(Value)
        ShowHealth = Value
        for _, player in pairs(Players:GetPlayers()) do
            if ESPObjects[player] and ESPObjects[player].Billboard then
                ESPObjects[player].Billboard.HealthBar.Visible = ShowHealth and ESPEnabled
                ESPObjects[player].Billboard.HealthText.Visible = ShowHealth and ESPEnabled
                if ESPObjects[player].Billboard.HealthText.Visible then
                    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                    ESPObjects[player].Billboard.HealthText.Text = humanoid and "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) or "HP: N/A"
                end
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Show Inventory", CurrentValue = false, Flag = "SHOW_INVENTORY",
    Callback = function(Value)
        ShowInventory = Value
        for _, player in pairs(Players:GetPlayers()) do
            if ESPObjects[player] and ESPObjects[player].Billboard then
                ESPObjects[player].Billboard.InventoryText.Visible = ShowInventory and ESPEnabled and player.Team and table.find(prisonerTeams, player.Team.Name)
                if ESPObjects[player].Billboard.InventoryText.Visible then updateInventory(player, ESPObjects[player]) end
            end
        end
    end
})

VisualsTab:CreateButton({
    Name = "Refresh ESP",
    Callback = RefreshESP
})

VisualsTab:CreateToggle({
    Name = "Xray", CurrentValue = false, Flag = "Xray",
    Callback = function(Value)
        xrayEnabled = Value
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.LocalTransparencyModifier = Value and 0.5 or 0 end
        end
    end
})

-- // COMBAT SECTION (Aimbot, FOV, Desync, Silent Aim, Kill All Showcase)
local CombatTab = Window:CreateTab("Combat", 4483362458)

local AimbotEnabled = false
local SilentAim = false
local DesyncEnabled = false
local killAllEnabled = false
local FOVRadius = 150
local Smoothness = 0.15
local StickToTarget = false
local IgnoreWalls = false
local TeamCheck = false
local FriendsCheck = false
local ForcefieldCheck = false
local VelocityCheck = false
local HealthCheck = false
local FirstPersonCheck = false
local WallCheck = true
local VisibilityCheck = true
local ShowFOVCircle = true
local PredictionEnabled = false
local BulletSpeed = 1000
local ShakeEnabled = false
local ShakeIntensity = 5
local CurrentTarget = nil
local TargetPart = "Head"
local FOVCircle = nil
local FOVEnabled = false
local DefaultFOV = 70
local CustomFOV = 90
local killAllConnection = nil
local desyncConnection = nil
local silentAimConnection = nil
local originalPosition = nil
local originalFOV = nil
local killAllAimbotEnabled = false
local killAllCameraConnection = nil
local playerAddedConnection = nil

local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOVRadius
    FOVCircle.Color = Color3.fromRGB(255, 0, 0)
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    FOVCircle.Visible = (AimbotEnabled or killAllAimbotEnabled) and ShowFOVCircle
end

local function UpdateFOVCircle()
    if FOVCircle then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = FOVRadius
        FOVCircle.Visible = (AimbotEnabled or killAllAimbotEnabled) and ShowFOVCircle
    end
end

local function IsVisible(target)
    if IgnoreWalls or not target or not target.Character or not target.Character:FindFirstChild(TargetPart) then return IgnoreWalls end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local ray = workspace:Raycast(Camera.CFrame.Position, (target.Character[TargetPart].Position - Camera.CFrame.Position).Unit * 1000, params)
    return ray and ray.Instance and ray.Instance:IsDescendantOf(target.Character)
end

local function IsValidTarget(player)
    if player == LocalPlayer then return false end
    
    -- Team Check
    if TeamCheck and LocalPlayer.Team and player.Team then
        local localIsPrisoner = table.find(prisonerTeams, LocalPlayer.Team.Name)
        local targetIsPrisoner = table.find(prisonerTeams, player.Team.Name)
        if localIsPrisoner and targetIsPrisoner or LocalPlayer.Team == player.Team then return false end
    end
    
    -- Friends Check
    if FriendsCheck and player:IsFriendsWith(LocalPlayer.UserId) then return false end
    
    -- Forcefield Check
    if ForcefieldCheck and player.Character and player.Character:FindFirstChildOfClass("ForceField") then return false end
    
    -- Velocity Check
    if VelocityCheck and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local velocity = player.Character.HumanoidRootPart.Velocity.Magnitude
        if velocity > 100 then return false end -- سرعة غير طبيعية
    end
    
    -- Health Check
    if HealthCheck and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.Health <= 0 then return false end
    end
    
    -- First Person Check
    if FirstPersonCheck then
        local cameraSubject = Camera.CameraSubject
        if cameraSubject and cameraSubject:IsA("Humanoid") and cameraSubject.Parent == LocalPlayer.Character then
            return false -- اللاعب في وضع الأول شخص
        end
    end
    
    -- Wall Check
    if WallCheck and not IsVisible(player) then return false end
    
    -- Visibility Check
    if VisibilityCheck and player.Character and player.Character:FindFirstChild(TargetPart) then
        local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[TargetPart].Position)
        if not onScreen then return false end
    end
    
    return player.Character and player.Character:FindFirstChild(TargetPart) and player.Character:FindFirstChild("Humanoid")
end

local function GetClosestPlayerInFOV()
    local closestPlayer, shortestDistance = nil, FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidTarget(player) then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[TargetPart].Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

local function GetPredictedPosition(targetPart)
    return PredictionEnabled and targetPart.Position + (targetPart.Velocity * ((Camera.CFrame.Position - targetPart.Position).Magnitude / BulletSpeed)) or targetPart.Position
end

local function ApplyShake(position)
    if not ShakeEnabled then return position end
    local shakeX = math.random(-ShakeIntensity, ShakeIntensity) / 100
    local shakeY = math.random(-ShakeIntensity, ShakeIntensity) / 100
    local shakeZ = math.random(-ShakeIntensity, ShakeIntensity) / 100
    return position + Vector3.new(shakeX, shakeY, shakeZ)
end

local function UpdateFOV()
    Camera.FieldOfView = FOVEnabled and CustomFOV or DefaultFOV
end

local oldIndex = nil
local function EnableSilentAim()
    if silentAimConnection then return end
    oldIndex = getmetatable(game).__index
    getmetatable(game).__index = function(self, index)
        if (AimbotEnabled or killAllAimbotEnabled) and SilentAim and CurrentTarget and self == Mouse and (index == "Hit" or index == "Target") then
            local predictedPos = GetPredictedPosition(CurrentTarget.Character[TargetPart])
            local shakenPos = ApplyShake(predictedPos)
            return CFrame.new(shakenPos)
        end
        return oldIndex(self, index)
    end
    silentAimConnection = true
end

local function DisableSilentAim()
    if oldIndex then getmetatable(game).__index = oldIndex end
    silentAimConnection = nil
end

local function EnableDesync()
    if desyncConnection then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    desyncConnection = RunService.RenderStepped:Connect(function()
        if DesyncEnabled and root then
            root.CFrame = root.CFrame * CFrame.new(0, math.random(-0.2, 0.2), 0)
        end
    end)
end

local function DisableDesync()
    if desyncConnection then desyncConnection:Disconnect(); desyncConnection = nil end
end

local function EnableKillAllAimbot()
    if killAllCameraConnection then return end
    killAllCameraConnection = RunService.RenderStepped:Connect(function()
        if killAllAimbotEnabled and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(TargetPart) then
            local predictedPos = GetPredictedPosition(CurrentTarget.Character[TargetPart])
            local shakenPos = ApplyShake(predictedPos)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, shakenPos)
        end
    end)
end

local function DisableKillAllAimbot()
    if killAllCameraConnection then killAllCameraConnection:Disconnect(); killAllCameraConnection = nil end
end

local function EnableKillAll()
    if killAllConnection then 
        Rayfield:Notify({ Title = "Info", Content = "Kill All is already running!", Duration = 3, Image = 4483362458 })
        return 
    end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        Rayfield:Notify({ Title = "Error", Content = "Character not found!", Duration = 3, Image = 4483362458 })
        return 
    end
    originalPosition = root.CFrame
    originalFOV = Camera.FieldOfView
    local targetPlayers = {}
    local function addPlayer(player)
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") 
           and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            table.insert(targetPlayers, player)
        end
    end
    for _, player in pairs(Players:GetPlayers()) do
        addPlayer(player)
    end
    playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        if killAllEnabled then
            player.CharacterAdded:Wait()
            addPlayer(player)
        end
    end)
    if #targetPlayers == 0 then
        Rayfield:Notify({ 
            Title = "Info", 
            Content = "No valid targets found!", 
            Duration = 3, 
            Image = 4483362458 
        })
        return
    end
    local currentIndex = 1
    local rotationAngle = 0
    killAllAimbotEnabled = true
    EnableKillAllAimbot()
    killAllConnection = RunService.Heartbeat:Connect(function()
        if not killAllEnabled or not root then
            DisableKillAll()
            return
        end
        if #targetPlayers == 0 then
            for _, player in pairs(Players:GetPlayers()) do
                addPlayer(player)
            end
            if #targetPlayers == 0 then return end
        end
        local target = targetPlayers[currentIndex]
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") 
           or target.Character.Humanoid.Health <= 0 then
            table.remove(targetPlayers, currentIndex)
            if currentIndex > #targetPlayers then
                currentIndex = 1
            end
            return
        end
        CurrentTarget = target
        rotationAngle = (rotationAngle + 0.25) % (2 * math.pi)
        local offset = Vector3.new(math.cos(rotationAngle) * 5, 0, math.sin(rotationAngle) * 5)
        root.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position + offset, target.Character.HumanoidRootPart.Position)
        local lookAt = (target.Character.HumanoidRootPart.Position - root.Position).Unit
        root.CFrame = CFrame.new(root.Position, root.Position + lookAt)
    end)
end

local function DisableKillAll()
    if killAllConnection then
        killAllConnection:Disconnect()
        killAllConnection = nil
    end
    if playerAddedConnection then
        playerAddedConnection:Disconnect()
        playerAddedConnection = nil
    end
    killAllAimbotEnabled = false
    DisableKillAllAimbot()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and originalPosition then
        root.CFrame = originalPosition
    end
    if originalFOV then
        Camera.FieldOfView = originalFOV
    end
    Rayfield:Notify({ 
        Title = "Kill All Deactivated", 
        Content = "Returned to original position.", 
        Duration = 3, 
        Image = 4483362458 
    })
end

CombatTab:CreateToggle({
    Name = "Enable Aimbot", CurrentValue = false, Flag = "AIMBOT_TOGGLE",
    Callback = function(Value)
        AimbotEnabled = Value
        CurrentTarget = nil
        if AimbotEnabled then CreateFOVCircle() end
        local conn = AimbotEnabled and RunService.RenderStepped:Connect(function()
            UpdateFOVCircle()
            if AimbotEnabled then
                CurrentTarget = StickToTarget and CurrentTarget and IsValidTarget(CurrentTarget) and CurrentTarget or GetClosestPlayerInFOV()
                if not SilentAim and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(TargetPart) then
                    local predictedPos = GetPredictedPosition(CurrentTarget.Character[TargetPart])
                    local shakenPos = ApplyShake(predictedPos)
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, shakenPos), Smoothness)
                end
            else conn:Disconnect() end
        end) or nil
        if not AimbotEnabled then
            if FOVCircle then FOVCircle:Remove() FOVCircle = nil end
            DisableSilentAim()
        end
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim", CurrentValue = false, Flag = "SILENT_AIM",
    Callback = function(Value)
        SilentAim = Value
        if SilentAim and (AimbotEnabled or killAllAimbotEnabled) then EnableSilentAim() else DisableSilentAim() end
    end
})

CombatTab:CreateToggle({
    Name = "Desync", CurrentValue = false, Flag = "DESYNC",
    Callback = function(Value)
        DesyncEnabled = Value
        if DesyncEnabled then EnableDesync() else DisableDesync() end
    end
})

CombatTab:CreateToggle({
    Name = "Kill All Showcase", CurrentValue = false, Flag = "KILL_ALL_SHOWCASE",
    Callback = function(Value)
        killAllEnabled = Value
        if killAllEnabled then
            EnableKillAll()
            Rayfield:Notify({
                Title = "Kill All Activated",
                Content = "Rotating around target with locked camera!",
                Duration = 5,
                Image = 4483362458
            })
        else
            DisableKillAll()
        end
    end
})

CombatTab:CreateToggle({
    Name = "Prediction", CurrentValue = false, Flag = "PREDICTION",
    Callback = function(Value) PredictionEnabled = Value end
})

CombatTab:CreateToggle({
    Name = "Shake Enabled", CurrentValue = false, Flag = "SHAKE_ENABLED",
    Callback = function(Value) ShakeEnabled = Value end
})

CombatTab:CreateSlider({
    Name = "Shake Intensity", Range = {1, 20}, Increment = 1, CurrentValue = 5, Flag = "SHAKE_INTENSITY",
    Callback = function(Value) ShakeIntensity = Value end
})

CombatTab:CreateSlider({
    Name = "Bullet Speed", Range = {500, 5000}, Increment = 100, CurrentValue = 1000, Flag = "BULLET_SPEED",
    Callback = function(Value) BulletSpeed = Value end
})

CombatTab:CreateDropdown({
    Name = "Target Part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, CurrentOption = {"Head"}, MultipleOptions = false, Flag = "TARGET_PART",
    Callback = function(Option) TargetPart = Option[1] end
})

CombatTab:CreateSlider({
    Name = "FOV Radius", Range = {50, 500}, Increment = 10, CurrentValue = 150, Flag = "FOV_RADIUS",
    Callback = function(Value) FOVRadius = Value; UpdateFOVCircle() end
})

CombatTab:CreateSlider({
    Name = "Smoothness (Visible Aim)", Range = {0.05, 0.5}, Increment = 0.01, CurrentValue = 0.15, Flag = "AIMBOT_SMOOTHNESS",
    Callback = function(Value) Smoothness = Value end
})

CombatTab:CreateToggle({
    Name = "Stick to Target", CurrentValue = false, Flag = "STICK_TARGET",
    Callback = function(Value) StickToTarget = Value; if not StickToTarget then CurrentTarget = nil end end
})

CombatTab:CreateToggle({
    Name = "Ignore Walls", CurrentValue = false, Flag = "IGNORE_WALLS",
    Callback = function(Value) IgnoreWalls = Value end
})

CombatTab:CreateToggle({
    Name = "Team Check", CurrentValue = false, Flag = "TEAM_CHECK",
    Callback = function(Value) TeamCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "Friends Check", CurrentValue = false, Flag = "FRIENDS_CHECK",
    Callback = function(Value) FriendsCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "Forcefield Check", CurrentValue = false, Flag = "FORCEFIELD_CHECK",
    Callback = function(Value) ForcefieldCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "Velocity Check", CurrentValue = false, Flag = "VELOCITY_CHECK",
    Callback = function(Value) VelocityCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "Health Check", CurrentValue = false, Flag = "HEALTH_CHECK",
    Callback = function(Value) HealthCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "First Person Check", CurrentValue = false, Flag = "FIRST_PERSON_CHECK",
    Callback = function(Value) FirstPersonCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "Wall Check", CurrentValue = true, Flag = "WALL_CHECK",
    Callback = function(Value) WallCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "Visibility Check", CurrentValue = true, Flag = "VISIBILITY_CHECK",
    Callback = function(Value) VisibilityCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateToggle({
    Name = "Show FOV Circle", CurrentValue = true, Flag = "SHOW_FOV_CIRCLE",
    Callback = function(Value) ShowFOVCircle = Value; UpdateFOVCircle() end
})

CombatTab:CreateToggle({
    Name = "Enable Custom FOV", CurrentValue = false, Flag = "FOV_TOGGLE",
    Callback = function(Value) FOVEnabled = Value; UpdateFOV() end
})

CombatTab:CreateSlider({
    Name = "FOV Value", Range = {30, 200}, Increment = 1, CurrentValue = 90, Flag = "FOV_SLIDER",
    Callback = function(Value) CustomFOV = Value; if FOVEnabled then Camera.FieldOfView = CustomFOV end end
})

-- // TELEPORT SECTION
local TeleportTab = Window:CreateTab("Teleports", 4483362458)

local locations = {
    ["MAINTENANCE"] = CFrame.new(172.34, 23.10, -143.87),
    ["SECURITY"] = CFrame.new(224.47, 23.10, -167.90),
    ["OC LOCKERS"] = CFrame.new(137.60, 23.10, -169.93),
    ["RIOT LOCKERS"] = CFrame.new(165.63, 23.10, -192.25),
    ["VENT"] = CFrame.new(76.96, -7.02, -19.21),
    ["Maximum"] = CFrame.new(101.84, -8.82, -141.41),
    ["Generator"] = CFrame.new(100.95, -8.82, -57.59),
    ["OUTSIDE"] = CFrame.new(350.22, 5.40, -171.09),
    ["Escapee Base"] = CFrame.new(749.02, -0.97, -470.45)
}

for name, cf in pairs(locations) do
    TeleportTab:CreateButton({ Name = name, Callback = function() LocalPlayer.Character:PivotTo(cf) end })
end

TeleportTab:CreateButton({ Name = "Escapee", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(307.06, 5.40, -177.88)) end })
TeleportTab:CreateButton({ Name = "Keycard (💳)", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(-13.36, 22.13, -27.47)) end })

-- // ITEMS SECTION
local ItemsTab = Window:CreateTab("Items", 4483362458)

ItemsTab:CreateButton({
    Name = "Get FAKE Keycard (Players can see it",
    Callback = function()
        local player = LocalPlayer
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({ Title = "Error", Content = "Cannot find your character!", Duration = 3, Image = 4483362458 })
            return
        end
        local isPrisoner = player.Team and table.find(prisonerTeams, player.Team.Name)
        if not isPrisoner then
            Rayfield:Notify({ Title = "Access Denied", Content = "Only prisoners can take this item!", Duration = 3, Image = 4483362458 })
            return
        end
        local maxAttempts, attempt = 3, 1
        local function tryGetKeycard()
            local foundItem = nil
            for _, container in pairs({workspace, game:GetService("ReplicatedStorage"), game:GetService("ServerStorage")}) do
                for _, obj in pairs(container:GetDescendants()) do
                    if obj:IsA("Tool") and obj.Name:lower():find("keycard") then foundItem = obj; break end
                end
                if foundItem then break end
            end
            if foundItem and foundItem:FindFirstChild("Handle") then
                local clonedTool = foundItem:Clone()
                clonedTool.Parent = player.Backpack
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then humanoid:EquipTool(clonedTool) end
                Rayfield:Notify({ Title = "Success", Content = "Keycard added to Backpack!", Duration = 3, Image = 4483362458 })
            elseif attempt < maxAttempts then
                attempt = attempt + 1
                task.wait(0.5)
                tryGetKeycard()
            else
                Rayfield:Notify({ Title = "Error", Content = "Keycard not found. Try again.", Duration = 5, Image = 4483362458 })
            end
        end
        tryGetKeycard()
    end
})

-- // PLAYER SECTION
local PlayerTab = Window:CreateTab("Player", 4483362458)

local infiniteStaminaEnabled = false
local speed = 16
local infjumpv2 = false
local antiOCSprayEnabled = false
local connection = nil
local antiArrestEnabled = false
local antiTazeEnabled = false

PlayerTab:CreateButton({
    Name = "Infinite Stamina",
    Callback = function()
        infiniteStaminaEnabled = not infiniteStaminaEnabled
        local player = LocalPlayer
        local serverVariables = player:FindFirstChild("ServerVariables")
        if serverVariables and serverVariables:FindFirstChild("Sprint") then
            local sprint = serverVariables.Sprint
            local stamina = sprint:FindFirstChild("Stamina")
            local maxStamina = sprint:FindFirstChild("MaxStamina")
            if stamina and maxStamina then
                if infiniteStaminaEnabled then
                    local staminaConnection = RunService.RenderStepped:Connect(function()
                        if infiniteStaminaEnabled then
                            stamina.Value = maxStamina.Value
                        else
                            staminaConnection:Disconnect()
                        end
                    end)
                    Rayfield:Notify({ Title = "Success", Content = "Infinite Stamina enabled!", Duration = 5, Image = 4483362458 })
                else
                    Rayfield:Notify({ Title = "Info", Content = "Infinite Stamina disabled!", Duration = 5, Image = 4483362458 })
                end
            else
                Rayfield:Notify({ Title = "Error", Content = "Stamina not found.", Duration = 5, Image = 4483362458 })
                infiniteStaminaEnabled = false
            end
        else
            Rayfield:Notify({ Title = "Error", Content = "Try again.", Duration = 5, Image = 4483362458 })
            infiniteStaminaEnabled = false
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Speed", Range = {1, 100}, Increment = 1, Suffix = "USpeed", CurrentValue = 16, Flag = "UserSpeed",
    Callback = function(Value) 
        speed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:CreateToggle({
    Name = "(Stable) Inf Jump", CurrentValue = false, Flag = "IJ",
    Callback = function(Value) infjumpv2 = Value end
})

PlayerTab:CreateToggle({
    Name = "Anti OC Spray",
    CurrentValue = false,
    Flag = "ANTI_OC_SPRAY",
    Callback = function(Value)
        antiOCSprayEnabled = Value
        if antiOCSprayEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                local defaultWalkSpeed = humanoid.WalkSpeed
                local defaultJumpPower = humanoid.JumpPower or 25
            end
            connection = RunService.Heartbeat:Connect(function()
                if antiOCSprayEnabled then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        local hum = char.Humanoid
                        hum.WalkSpeed = defaultWalkSpeed
                        hum.JumpPower = defaultJumpPower
                    end
                    local playerGui = LocalPlayer.PlayerGui
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and gui.Enabled and (gui.Name:lower():find("pepper") or gui.Name:lower():find("spray") or gui.Name:lower():find("ocspray")) then
                            gui.Enabled = false
                        end
                    end
                    for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
                        if (effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect")) and effect.Enabled then
                            effect.Enabled = false
                        end
                    end
                end
            end)
            LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if antiOCSprayEnabled and child.Name == "OC Spray" then
                    local localScript = child:FindFirstChild("LocalScript")
                    if localScript then localScript.Disabled = true end
                end
            end)
            Rayfield:Notify({ Title = "Activated", Content = "Anti OC Spray enabled.", Duration = 5, Image = 4483362458 })
        else
            if connection then connection:Disconnect() end
            Rayfield:Notify({ Title = "Deactivated", Content = "Anti OC Spray disabled.", Duration = 5, Image = 4483362458 })
        end
    end
})

local antiArrestConnection
local originalCuffsState = false
PlayerTab:CreateToggle({
    Name = "Anti Taze/Stun",
    CurrentValue = false,
    Flag = "ANTI_ARREST",
    Callback = function(Value)
        antiArrestEnabled = Value
        local cuffsScript = LocalPlayer.PlayerScripts:FindFirstChild("CuffsLocal")
        if antiArrestEnabled and cuffsScript then
            originalCuffsState = cuffsScript.Disabled
            cuffsScript.Disabled = true
            antiArrestConnection = cuffsScript.AncestryChanged:Connect(function()
                if antiArrestEnabled and cuffsScript.Parent then
                    cuffsScript.Disabled = true
                end
            end)
            Rayfield:Notify({ Title = "Activated", Content = "Anti Taze/Stun enabled (CuffsLocal disabled).", Duration = 5, Image = 4483362458 })
        elseif not antiArrestEnabled and cuffsScript then
            if antiArrestConnection then antiArrestConnection:Disconnect(); antiArrestConnection = nil end
            cuffsScript.Disabled = originalCuffsState
            Rayfield:Notify({ Title = "Deactivated", Content = "Anti Taze/Stun disabled.", Duration = 5, Image = 4483362458 })
        elseif not cuffsScript then
            Rayfield:Notify({ Title = "Warning", Content = "CuffsLocal script not found.", Duration = 5, Image = 4483362458 })
        end
    end
})

local antiTazeConnection
local antiTazeHumanoidConnection
local antiTazeGuiConnection
local antiTazeEffectConnection
local antiTazeToolConnection
PlayerTab:CreateToggle({
    Name = "Anti Arrest/Handcuffs",
    CurrentValue = false,
    Flag = "ANTI_TAZE",
    Callback = function(Value)
        antiTazeEnabled = Value
        if antiTazeEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                local defaultWalkSpeed = humanoid.WalkSpeed
                local defaultJumpPower = humanoid.JumpPower or 25
                antiTazeHumanoidConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                    if antiTazeEnabled and humanoid.WalkSpeed < defaultWalkSpeed then
                        humanoid.WalkSpeed = defaultWalkSpeed
                    end
                end)
                antiTazeHumanoidConnection2 = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                    if antiTazeEnabled and humanoid.JumpPower < defaultJumpPower then
                        humanoid.JumpPower = defaultJumpPower
                    end
                end
            end
            antiTazeGuiConnection = LocalPlayer.PlayerGui.ChildAdded:Connect(function(gui)
                if antiTazeEnabled and gui:IsA("ScreenGui") and (gui.Name:lower():find("taze") or gui.Name:lower():find("stun")) then
                    gui.Enabled = false
                end
            end)
            antiTazeEffectConnection = game:GetService("Lighting").ChildAdded:Connect(function(effect)
                if antiTazeEnabled and (effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect")) then
                    effect.Enabled = false
                end
            end)
            LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if antiTazeEnabled and child.Name:lower():find("tazer") then
                    child:Destroy()
                end
            end)
            LocalPlayer.Character.ChildAdded:Connect(function(child)
                if antiTazeEnabled and child.Name:lower():find("tazer") then
                    child:Destroy()
                end
            end)
            Rayfield:Notify({ Title = "Activated", Content = "Anti Arrest/Handcuffs enabled.", Duration = 5, Image = 4483362458 })
        else
            if antiTazeHumanoidConnection then antiTazeHumanoidConnection:Disconnect() end
            if antiTazeHumanoidConnection2 then antiTazeHumanoidConnection2:Disconnect() end
            if antiTazeGuiConnection then antiTazeGuiConnection:Disconnect() end
            if antiTazeEffectConnection then antiTazeEffectConnection:Disconnect() end
            if antiTazeToolConnection then antiTazeToolConnection:Disconnect() end
            Rayfield:Notify({ Title = "Deactivated", Content = "Anti Arrest/Handcuffs disabled.", Duration = 5, Image = 4483362458 })
        end
    end
})

-- RenderStepped connections
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end)

UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    if char and infjumpv2 then
        char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("✅ Script loaded successfully!")
