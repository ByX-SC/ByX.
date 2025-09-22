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

-- // VISUALS SECTION (ESP, Xray, 3D Box)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local ESPEnabled = false
local ShowHealth = false
local ShowInventory = false
local ESPObjects = {}
local xrayEnabled = false
local Box3DEnabled = false
local Box3DObjects = {}
local autoRefreshConnection = nil

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
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.3
        highlight.FillColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 1  -- Remove white outline
        highlight.Parent = player.Character
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 200, 0, 100)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = ESPEnabled
        billboard.Parent = player.Character

        local healthFrame = Instance.new("Frame")
        healthFrame.Name = "HealthBar"
        healthFrame.Size = UDim2.new(1, 0, 0, 8)
        healthFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        healthFrame.BackgroundTransparency = 0.2
        healthFrame.BorderSizePixel = 1
        healthFrame.Visible = ShowHealth and ESPEnabled
        healthFrame.Parent = billboard

        local healthBg = Instance.new("Frame")
        healthBg.Name = "HealthBarBg"
        healthBg.Size = UDim2.new(1, 0, 1, 0)
        healthBg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        healthBg.BackgroundTransparency = 0.7
        healthBg.BorderSizePixel = 0
        healthBg.Parent = healthFrame

        local healthText = Instance.new("TextLabel")
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
        healthText.Parent = billboard

        local inventoryText = Instance.new("TextLabel")
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
        inventoryText.Parent = billboard

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
    end
    ESPObjects = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            CreateESP(player)
        end
    end
    Rayfield:Notify({ Title = "Success", Content = "ESP refreshed for all players!", Duration = 3, Image = 4483362458 })
end

-- Add 3D Box ESP
local function Create3DBox(player)
    if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if not Box3DObjects[player] then
        local boxLines = {}
        for i = 1, 12 do
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            line.Thickness = 1
            line.Transparency = 1
            table.insert(boxLines, line)
        end
        Box3DObjects[player] = {Lines = boxLines, Color = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)}
    end
end

local function Remove3DBox(player)
    if Box3DObjects[player] then
        for _, line in pairs(Box3DObjects[player].Lines) do
            line:Remove()
        end
        Box3DObjects[player] = nil
    end
end

local function Update3DBox(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    local parts = player.Character:GetChildren()
    local min, max = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
    for _, part in pairs(parts) do
        if part:IsA("BasePart") then
            min = Vector3.new(math.min(min.X, part.Position.X - part.Size.X/2), math.min(min.Y, part.Position.Y - part.Size.Y/2), math.min(min.Z, part.Position.Z - part.Size.Z/2))
            max = Vector3.new(math.max(max.X, part.Position.X + part.Size.X/2), math.max(max.Y, part.Position.Y + part.Size.Y/2), math.max(max.Z, part.Position.Z + part.Size.Z/2))
        end
    end
    local corners = {
        Vector3.new(min.X, min.Y, min.Z),
        Vector3.new(max.X, min.Y, min.Z),
        Vector3.new(max.X, max.Y, min.Z),
        Vector3.new(min.X, max.Y, min.Z),
        Vector3.new(min.X, min.Y, max.Z),
        Vector3.new(max.X, min.Y, max.Z),
        Vector3.new(max.X, max.Y, max.Z),
        Vector3.new(min.X, max.Y, max.Z)
    }
    local screenCorners = {}
    for i, corner in pairs(corners) do
        local screenPos, onScreen = Camera:WorldToViewportPoint(corner)
        screenCorners[i] = {Pos = Vector2.new(screenPos.X, screenPos.Y), OnScreen = onScreen}
    end
    local connections = {
        {1,2}, {2,3}, {3,4}, {4,1},
        {5,6}, {6,7}, {7,8}, {8,5},
        {1,5}, {2,6}, {3,7}, {4,8}
    }
    local allOnScreen = true
    for _, conn in pairs(connections) do
        allOnScreen = allOnScreen and screenCorners[conn[1]].OnScreen and screenCorners[conn[2]].OnScreen
    end
    if not allOnScreen then
        for _, line in pairs(Box3DObjects[player].Lines) do line.Visible = false end
        return
    end
    for i, conn in pairs(connections) do
        local line = Box3DObjects[player].Lines[i]
        line.From = screenCorners[conn[1]].Pos
        line.To = screenCorners[conn[2]].Pos
        line.Visible = true
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            if ESPEnabled then task.wait(0.5) CreateESP(player) end
            if Box3DEnabled then task.wait(0.5) Create3DBox(player) end
        end)
        if player.Character and ESPEnabled then task.spawn(function() task.wait(0.5) CreateESP(player) end) end
        if player.Character and Box3DEnabled then task.spawn(function() task.wait(0.5) Create3DBox(player) end) end
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            if ESPEnabled then task.wait(0.5) CreateESP(player) end
            if Box3DEnabled then task.wait(0.5) Create3DBox(player) end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    Remove3DBox(player)
end)

local function StartAutoRefresh()
    if autoRefreshConnection then autoRefreshConnection:Disconnect() end
    autoRefreshConnection = RunService.Heartbeat:Connect(function()
        if ESPEnabled or materialESPEnabled then
            task.wait(60) -- Refresh every 60 seconds (1 minute)
            RefreshESP()
            refreshMaterialESP()
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                task.spawn(function() CreateESP(player) end)
            end
        end
    end
    if Box3DEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                task.spawn(function() Create3DBox(player) Update3DBox(player) end)
            end
        end
    end
end)

VisualsTab:CreateToggle({
    Name = "Enable ESP", CurrentValue = false, Flag = "ESP_TOGGLE",
    Callback = function(Value)
        ESPEnabled = Value
        for _, player in pairs(Players:GetPlayers()) do
            if ESPObjects[player] then
                ESPObjects[player].Billboard.Enabled = ESPEnabled
                ESPObjects[player].Highlight.Enabled = ESPEnabled
                ESPObjects[player].HealthFrame.Visible = ShowHealth and ESPEnabled
                ESPObjects[player].HealthText.Visible = ShowHealth and ESPEnabled
                ESPObjects[player].InventoryText.Visible = ShowInventory and ESPEnabled and player.Team and table.find(prisonerTeams, player.Team.Name)
            end
        end
        if not ESPEnabled then
            for _, espHolder in pairs(ESPObjects) do
                if espHolder.Highlight then espHolder.Highlight:Destroy() end
                if espHolder.Billboard then espHolder.Billboard:Destroy() end
            end
            ESPObjects = {}
            if autoRefreshConnection then autoRefreshConnection:Disconnect() end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    task.spawn(function() CreateESP(player) end)
                end
            end
            StartAutoRefresh()
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

VisualsTab:CreateToggle({
    Name = "Enable 3D Box ESP", CurrentValue = false, Flag = "BOX3D_TOGGLE",
    Callback = function(Value)
        Box3DEnabled = Value
        if not Box3DEnabled then
            for player in pairs(Box3DObjects) do
                Remove3DBox(player)
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    task.spawn(function() Create3DBox(player) Update3DBox(player) end)
                end
            end
        end
    end
})

-- // Material ESP for Plastic and Metal with Optimized Check
local materialESPEnabled = false
local materialHighlights = {}

local function isMaterialAvailable(materialName)
    local found = false
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower():find(materialName:lower()) then
            found = true
            break
        end
    end
    return found
end

local function createMaterialESP(material)
    if not materialESPEnabled or not material:IsA("BasePart") or not (material.Name:lower():find("plastic") or material.Name:lower():find("metal")) then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = material
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.FillColor = material.Color
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = isMaterialAvailable(material.Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    highlight.Parent = material
    table.insert(materialHighlights, highlight)
end

local function refreshMaterialESP()
    if not materialESPEnabled then
        for _, highlight in pairs(materialHighlights) do
            highlight:Destroy()
        end
        materialHighlights = {}
        return
    end
    for _, highlight in pairs(materialHighlights) do
        if highlight and highlight.Adornee and highlight.Adornee.Parent then
            highlight.OutlineColor = isMaterialAvailable(highlight.Adornee.Name) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        else
            highlight:Destroy()
        end
    end
    for _, material in pairs(workspace:GetDescendants()) do
        if material:IsA("BasePart") and (material.Name:lower():find("plastic") or material.Name:lower():find("metal")) then
            local hasHighlight = false
            for _, h in pairs(materialHighlights) do
                if h.Adornee == material then
                    hasHighlight = true
                    break
                end
            end
            if not hasHighlight then
                createMaterialESP(material)
            end
        end
    end
    Rayfield:Notify({ Title = "Success", Content = "Material ESP refreshed!", Duration = 3, Image = 4483362458 })
end

VisualsTab:CreateToggle({
    Name = "Enable Material ESP",
    CurrentValue = false,
    Flag = "MATERIAL_ESP",
    Callback = function(Value)
        materialESPEnabled = Value
        refreshMaterialESP()
        if materialESPEnabled and not autoRefreshConnection then
            StartAutoRefresh()
        elseif not materialESPEnabled and autoRefreshConnection then
            if not ESPEnabled then autoRefreshConnection:Disconnect() end
        end
    end
})

VisualsTab:CreateLabel("Adds highlights to Plastic and Metal (Green = Available, Red = Taken).")

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
local ShowFOVCircle = true
local PredictionEnabled = false
local BulletSpeed = 1000
local CurrentTarget = nil
local TargetPart = "Head"
local FOVCircle = nil
local FOVEnabled = false
local DefaultFOV = Camera.FieldOfView
local CustomFOV = 90
local killAllConnection = nil
local desyncConnection = nil
local silentAimConnection = nil
local originalPosition = nil
local originalFOV = nil
local killAllAimbotEnabled = false
local killAllCameraConnection = nil
local playerAddedConnection = nil
local FOVColor = Color3.fromRGB(255, 0, 0)
local hasNotifiedNoTarget = false

local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOVRadius
    FOVCircle.Color = FOVColor
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    FOVCircle.Visible = (AimbotEnabled or killAllAimbotEnabled) and ShowFOVCircle
end

local function UpdateFOVCircle()
    if FOVCircle then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = FOVRadius
        FOVCircle.Color = FOVColor
        FOVCircle.Visible = (AimbotEnabled or killAllAimbotEnabled) and ShowFOVCircle
    end
end

local function IsVisible(target)
    if not target or not target.Character or not target.Character:FindFirstChild(TargetPart) then return false end
    if IgnoreWalls then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local ray = workspace:Raycast(Camera.CFrame.Position, (target.Character[TargetPart].Position - Camera.CFrame.Position).Unit * 1000, params)
    return ray and ray.Instance and ray.Instance:IsDescendantOf(target.Character)
end

local function IsValidTarget(player)
    if player == LocalPlayer then return false end
    if TeamCheck and LocalPlayer.Team and player.Team then
        local localIsPrisoner = table.find(prisonerTeams, LocalPlayer.Team.Name)
        local targetIsPrisoner = table.find(prisonerTeams, player.Team.Name)
        if localIsPrisoner and targetIsPrisoner or LocalPlayer.Team == player.Team then return false end
    end
    return player.Character and player.Character:FindFirstChild(TargetPart) and player.Character:FindFirstChild("Humanoid") and IsVisible(player)
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
    if not targetPart then return Vector3.zero end
    return PredictionEnabled and targetPart.Position + (targetPart.Velocity * ((Camera.CFrame.Position - targetPart.Position).Magnitude / BulletSpeed)) or targetPart.Position
end

local function UpdateFOV()
    if FOVEnabled then
        Camera.FieldOfView = CustomFOV -- Fixed FOV when enabled
    end
end

local oldIndex = nil
local function EnableSilentAim()
    if silentAimConnection then return end
    oldIndex = getmetatable(game).__index
    getmetatable(game).__index = function(self, index)
        if SilentAim and (AimbotEnabled or killAllAimbotEnabled) and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(TargetPart) and self == Mouse then
            local predictedPos = GetPredictedPosition(CurrentTarget.Character[TargetPart])
            if index == "Hit" then
                return CFrame.new(predictedPos)
            elseif index == "Target" then
                return CurrentTarget.Character[TargetPart]
            end
        end
        return oldIndex(self, index)
    end
    silentAimConnection = true
    Rayfield:Notify({ Title = "Silent Aim", Content = "Silent Aim enabled successfully!", Duration = 3, Image = 4483362458 })
end

local function DisableSilentAim()
    if oldIndex then
        getmetatable(game).__index = oldIndex
        oldIndex = nil
    end
    silentAimConnection = nil
    Rayfield:Notify({ Title = "Silent Aim", Content = "Silent Aim disabled.", Duration = 3, Image = 4483362458 })
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
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, GetPredictedPosition(CurrentTarget.Character[TargetPart]))
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

RunService.RenderStepped:Connect(function()
    if AimbotEnabled or SilentAim then
        CurrentTarget = StickToTarget and CurrentTarget and IsValidTarget(CurrentTarget) and CurrentTarget or GetClosestPlayerInFOV()
        if SilentAim and not CurrentTarget and not hasNotifiedNoTarget then
            Rayfield:Notify({ Title = "Silent Aim", Content = "No valid target found in FOV!", Duration = 2, Image = 4483362458 })
            hasNotifiedNoTarget = true
        elseif CurrentTarget then
            hasNotifiedNoTarget = false
        end
    end
    UpdateFOV() -- Ensure FOV stays fixed
end)

CombatTab:CreateToggle({
    Name = "Enable Aimbot", CurrentValue = false, Flag = "AIMBOT_TOGGLE",
    Callback = function(Value)
        AimbotEnabled = Value
        CurrentTarget = nil
        hasNotifiedNoTarget = false
        if AimbotEnabled then
            CreateFOVCircle()
            local conn = RunService.RenderStepped:Connect(function()
                UpdateFOVCircle()
                if AimbotEnabled then
                    CurrentTarget = StickToTarget and CurrentTarget and IsValidTarget(CurrentTarget) and CurrentTarget or GetClosestPlayerInFOV()
                    if not SilentAim and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(TargetPart) then
                        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, GetPredictedPosition(CurrentTarget.Character[TargetPart])), Smoothness)
                    end
                else
                    conn:Disconnect()
                    if FOVCircle then FOVCircle:Remove() FOVCircle = nil end
                    DisableSilentAim()
                end
            end)
        else
            if FOVCircle then FOVCircle:Remove() FOVCircle = nil end
            DisableSilentAim()
        end
    end
})

CombatTab:CreateLabel("Locks the camera onto the closest player within the FOV circle.")

CombatTab:CreateToggle({
    Name = "Silent Aim", CurrentValue = false, Flag = "SILENT_AIM",
    Callback = function(Value)
        SilentAim = Value
        hasNotifiedNoTarget = false
        if SilentAim and (AimbotEnabled or killAllAimbotEnabled) then
            EnableSilentAim()
        else
            DisableSilentAim()
        end
    end
})

CombatTab:CreateLabel("Makes your shots hit the target without moving the camera visibly.")

CombatTab:CreateToggle({
    Name = "Desync", CurrentValue = false, Flag = "DESYNC",
    Callback = function(Value)
        DesyncEnabled = Value
        if DesyncEnabled then EnableDesync() else DisableDesync() end
    end
})

CombatTab:CreateLabel("Slightly offsets your character's position to make it harder for others to hit you.")

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

CombatTab:CreateLabel("Automatically rotates around and kills all valid players in a showcase style.")

CombatTab:CreateToggle({
    Name = "Prediction", CurrentValue = false, Flag = "PREDICTION",
    Callback = function(Value) PredictionEnabled = Value end
})

CombatTab:CreateLabel("Predicts the target's movement based on velocity for more accurate aiming.")

CombatTab:CreateSlider({
    Name = "Bullet Speed", Range = {500, 5000}, Increment = 100, CurrentValue = 1000, Flag = "BULLET_SPEED",
    Callback = function(Value) BulletSpeed = Value end
})

CombatTab:CreateLabel("Adjusts the assumed bullet speed for prediction calculations.")

CombatTab:CreateDropdown({
    Name = "Target Part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, CurrentOption = {"Head"}, MultipleOptions = false, Flag = "TARGET_PART",
    Callback = function(Option) TargetPart = Option[1] end
})

CombatTab:CreateLabel("Selects which body part the aimbot will target.")

CombatTab:CreateSlider({
    Name = "FOV Radius", Range = {50, 500}, Increment = 10, CurrentValue = 150, Flag = "FOV_RADIUS",
    Callback = function(Value) FOVRadius = Value; UpdateFOVCircle() end
})

CombatTab:CreateLabel("Sets the radius of the field of view circle for targeting.")

CombatTab:CreateSlider({
    Name = "Smoothness (Visible Aim)", Range = {0.05, 0.5}, Increment = 0.01, CurrentValue = 0.15, Flag = "AIMBOT_SMOOTHNESS",
    Callback = function(Value) Smoothness = Value end
})

CombatTab:CreateLabel("Controls how smoothly the camera lerps to the target.")

CombatTab:CreateToggle({
    Name = "Stick to Target", CurrentValue = false, Flag = "STICK_TARGET",
    Callback = function(Value) StickToTarget = Value; if not StickToTarget then CurrentTarget = nil end end
})

CombatTab:CreateLabel("Locks onto the current target even if a closer one appears.")

CombatTab:CreateToggle({
    Name = "Ignore Walls", CurrentValue = false, Flag = "IGNORE_WALLS",
    Callback = function(Value) IgnoreWalls = Value end
})

CombatTab:CreateLabel("Allows aiming through walls if enabled.")

CombatTab:CreateToggle({
    Name = "Team Check", CurrentValue = false, Flag = "TEAM_CHECK",
    Callback = function(Value) TeamCheck = Value; CurrentTarget = nil end
})

CombatTab:CreateLabel("Prevents targeting players on the same team or same prisoner group.")

CombatTab:CreateToggle({
    Name = "Show FOV Circle", CurrentValue = true, Flag = "SHOW_FOV_CIRCLE",
    Callback = function(Value) ShowFOVCircle = Value; UpdateFOVCircle() end
})

CombatTab:CreateLabel("Toggles visibility of the FOV circle on screen.")

CombatTab:CreateToggle({
    Name = "Enable Custom FOV", CurrentValue = false, Flag = "FOV_TOGGLE",
    Callback = function(Value) FOVEnabled = Value; UpdateFOV() end
})

CombatTab:CreateLabel("Enables a custom field of view for the camera.")

CombatTab:CreateSlider({
    Name = "FOV Value", Range = {30, 200}, Increment = 1, CurrentValue = 90, Flag = "FOV_SLIDER",
    Callback = function(Value) CustomFOV = Value; if FOVEnabled then Camera.FieldOfView = CustomFOV end end
})

CombatTab:CreateLabel("Sets the custom field of view value when enabled.")

CombatTab:CreateColorPicker({
    Name = "FOV Circle Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        FOVColor = Value
        UpdateFOVCircle()
    end
})

CombatTab:CreateLabel("Customizes the color of the FOV circle.")

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
    Name = "Get FAKE Keycard (Players can see it)",
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
local antiTazeHumanoidConnection2
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
                end)
            end
            antiTazeGuiConnection = LocalPlayer.PlayerGui.ChildAdded:Connect(function(gui)
                if antiTazeEnabled and gui:IsA("ScreenGui") and (gui.Name:lower():find("taze") or gui:Name:lower():find("stun")) then
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

-- // MISC SECTION (Empty)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- // RenderStepped connections
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
