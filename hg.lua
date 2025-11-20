-- Load Rayfield UI Library with retry mechanism 
local success, Rayfield 
local maxAttempts, attempt = 3, 1 
while attempt <= maxAttempts and not success do 
    success, Rayfield = pcall(function() return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() end) 
    if not success then 
        warn("Failed to load Rayfield (Attempt " .. attempt .. "): " .. tostring(Rayfield)) 
        task.wait(1) 
        attempt = attempt + 1 
    end 
end 
if not success then 
    warn("Failed to load Rayfield after " .. maxAttempts .. " attempts.") 
    return 
end 
print("Rayfield loaded successfully!") 
 
-- Random theme selection (initial theme) 
local themes = {"Ocean", "Amethyst", "DarkBlue"} 
local randomIndex = math.random(1, #themes) 
local randomTheme = themes[randomIndex] 
 
-- Create the Window with KeySystem disabled for testing 
local Window = Rayfield:CreateWindow({ 
    Name = "Valley Prison ByX", 
    LoadingTitle = ".", 
    LoadingSubtitle = "ByX", 
    ConfigurationSaving = { Enabled = false }, 
    Discord = { Enabled = false }, 
    KeySystem = false, 
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
 
-- Verify Window creation 
if not Window then 
    warn("Failed to create Rayfield window.") 
    return 
else 
    print("Rayfield window created successfully!") 
end 
 
-- Services 
local RunService = game:GetService("RunService") 
local Players = game:GetService("Players") 
local UserInputService = game:GetService("UserInputService") 
local Camera = workspace.CurrentCamera 
local LocalPlayer = Players.LocalPlayer 
local Mouse = LocalPlayer:GetMouse() 
local prisonerTeams = {"Minimum Security", "Medium Security", "Maximum Security"} 
 
-- Variables 
local infiniteStaminaEnabled = false 
local speed = 16 
local infjumpv2 = false 
local antiOCSprayEnabled = false 
local antiOCSprayHumanoidConnection = nil 
local antiOCSprayHumanoidConnection2 = nil 
local antiOCSprayGuiConnection = nil 
local antiOCSprayEffectConnection = nil 
local antiOCSprayToolConnection = nil 
local antiArrestEnabled = false 
local antiTazeEnabled = false 
local antiArrestConnection = nil 
local originalCuffsState = false 
local antiTazeHumanoidConnection = nil 
local antiTazeHumanoidConnection2 = nil 
local antiTazeGuiConnection = nil 
local antiTazeEffectConnection = nil 
local antiTazeToolConnection = nil 
 
-- // INFO TAB 
local InfoTab = Window:CreateTab("Info", 4483362458) 
 
InfoTab:CreateButton({ 
    Name = "Copy YouTube Link", 
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
 
-- // VISUALS SECTION (ESP, Xray, 3D Box, Material ESP)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local ESPEnabled = false
local ShowHealth = false
local ShowInventory = false
local ESPObjects = {}
local xrayEnabled = false  -- Restored Xray
local Box3DEnabled = false
local Box3DObjects = {}
local materialESPEnabled = false
local materialHighlights = {}
local boxEnabled = false
local boxAdornments = {}
local ventsEnabled = false  -- Restored Vents ESP
local ventHighlights = {}
local garbageEnabled = false  -- Restored Garbage ESP
local garbageHighlights = {}
local espSettings = {
    Enabled = false,
    ShowDistance = true,
    MaxDistance = 1000,
    LineColor = Color3.fromRGB(255, 255, 255),
    Thickness = 1,  -- Reduced initial thickness
    Transparency = 0.8
}
local espObjects = {}
local connections = {}
local autoRefreshEnabled = false
local autoRefreshInterval = 10  -- Changed to 10 seconds
local autoRefreshConnection = nil
local lastRefresh = 0  -- Track last refresh time

local drawings = {}
local connection
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- State variables for new ESP features
local enableMainESP = false
local showBox = false
local show3DBox = false
local showHealthNew = false
local showHealthNew2 = false  -- Added Health Bar 2
local showName = false
local showDist = false
local showTool = false

-- Health Bar settings
local healthTransparency = 1 -- Default max transparency (100%)
local healthThickness = 1 -- Default thickness for foreground (bg will be +2)

-- Box Transparency settings
local box2DTransparency = 1
local box3DTransparency = 1

-- Box Thickness settings
local box2DThickness = 1
local box3DThickness = 1

-- Max Distance for New ESP (to reduce lag)
local maxDistance = 1000

-- Auto Clean settings
local autoCleanEnabled = false
local autoCleanConnection = nil
local cleanTimer = 0

-- New: Highlight ESP (restored)
local highlightESPEnabled = false

-- New: Line ESP
local lineESPEnabled = false
local lineStartFrom = "Bottom Screen"  -- Fixed to bottom screen only
local lineColor = Color3.fromRGB(255, 0, 0)
local lineThickness = 1  -- Reduced initial thickness
local lineESPObjects = {}  -- {player = line}

-- New: Custom Color for Selected ESPs
local customColorEnabled = false
local customESPColor = Color3.fromRGB(0, 255, 0)  -- Default green
local selectedESPTypes = {}  -- Table for selected ESP types (multi-select)

-- Global ESP listeners table
local espListeners = {}

-- Function to setup global ESP update listeners (runs once at script start for always-on monitoring)
local function setupGlobalESPListeners()
    if espListeners.playerAdded then return end  -- Prevent duplicate setup

    -- Player Added: Refresh when new player joins
    espListeners.playerAdded = Players.PlayerAdded:Connect(function(player)
        task.wait(1)  -- Small delay for character to load
        RefreshAllESP()
    end)

    -- Player Removing: Clean up for leaving players
    espListeners.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        cleanStuckESPs()
        if espListeners[player] then
            for _, conn in pairs(espListeners[player]) do
                conn:Disconnect()
            end
            espListeners[player] = nil
        end
    end)

    -- For all existing players, add individual listeners
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            espListeners[player] = {}
            -- Team Change: Refresh on team change
            espListeners[player].teamChange = player:GetPropertyChangedSignal("Team"):Connect(function()
                RefreshAllESP()
            end)
            -- Character Added: Refresh on respawn (death/respawn)
            espListeners[player].charAdded = player.CharacterAdded:Connect(function()
                RefreshAllESP()
            end)
            -- Character Removing: Clean on death
            espListeners[player].charRemoving = player.CharacterRemoving:Connect(function()
                cleanStuckESPs()
            end)
        end
    end

    -- Also add PlayerAdded to dynamically add listeners for new players
    espListeners.dynamicPlayerAdded = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            espListeners[player] = {}
            espListeners[player].teamChange = player:GetPropertyChangedSignal("Team"):Connect(function()
                RefreshAllESP()
            end)
            espListeners[player].charAdded = player.CharacterAdded:Connect(function()
                RefreshAllESP()
            end)
            espListeners[player].charRemoving = player.CharacterRemoving:Connect(function()
                cleanStuckESPs()
            end)
        end
    end)
end

-- Call setup at script start (always monitor and refresh on events, regardless of ESP toggle state)
setupGlobalESPListeners()

local function getCharacter(player)
    return player.Character
end

local function createNewESP(player)
    if player == localPlayer then return end  -- Skip self

    -- 2D Box
    local box = Drawing.new("Square")
    box.Thickness = box2DThickness
    box.Filled = false
    box.Color = Color3.new(1, 1, 1)
    box.Visible = false

    -- 3D Box Lines (12 lines for a full box)
    local lines = {}
    for i = 1, 12 do
        local line = Drawing.new("Line")
        line.Thickness = box3DThickness
        line.Color = Color3.new(1, 1, 1)
        line.Visible = false
        lines[i] = line
    end

    -- Health Bar 1
    local healthBg = Drawing.new("Line")
    healthBg.Color = Color3.new(0, 0, 0) -- Black background/border
    healthBg.Visible = false

    local healthFg = Drawing.new("Line")
    healthFg.Color = Color3.new(0, 1, 0)
    healthFg.Visible = false

    -- Health Bar 2 (added, positioned on the right side)
    local healthBg2 = Drawing.new("Line")
    healthBg2.Color = Color3.new(0, 0, 0) -- Black background/border
    healthBg2.Visible = false

    local healthFg2 = Drawing.new("Line")
    healthFg2.Color = Color3.new(0, 1, 0)
    healthFg2.Visible = false

    -- Texts
    local nameText = Drawing.new("Text")
    nameText.Size = 12
    nameText.Center = true
    nameText.Outline = true
    nameText.Color = Color3.new(1, 1, 1)
    nameText.Font = Drawing.Fonts.UI
    nameText.Visible = false

    local distText = Drawing.new("Text")
    distText.Size = 13
    distText.Center = true
    distText.Outline = true
    distText.Color = Color3.new(1, 1, 1)
    distText.Font = Drawing.Fonts.UI
    distText.Visible = false

    local toolText = Drawing.new("Text")
    toolText.Size = 13
    toolText.Center = true
    toolText.Outline = true
    toolText.Color = Color3.new(1, 1, 1)
    toolText.Font = Drawing.Fonts.UI
    toolText.Visible = false

    drawings[player] = {
        box = box,
        lines = lines,
        healthBg = healthBg,
        healthFg = healthFg,
        healthBg2 = healthBg2,
        healthFg2 = healthFg2,
        name = nameText,
        dist = distText,
        tool = toolText
    }
end

local function updateNewESP()
    local myChar = getCharacter(localPlayer)
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = myChar.HumanoidRootPart

    for player, draws in pairs(drawings) do
        local char = getCharacter(player)
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0 then
            local root = char.HumanoidRootPart
            local dist = (myRoot.Position - root.Position).Magnitude
            if dist > maxDistance then
                for _, d in pairs(draws) do 
                    if typeof(d) == "table" then
                        for _, line in ipairs(d) do line.Visible = false end
                    else
                        d.Visible = false 
                    end
                end
                continue
            end

            local humanoid = char.Humanoid
            local head = char:FindFirstChild("Head")
            if head then
                local pos, onScreen = camera:WorldToViewportPoint(root.Position)
                if not onScreen then
                    for _, d in pairs(draws) do 
                        if typeof(d) == "table" then
                            for _, line in ipairs(d) do line.Visible = false end
                        else
                            d.Visible = false 
                        end
                    end
                    continue
                end

                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 4, 0))
                local sizeY = math.abs(headPos.Y - legPos.Y)
                local sizeX = sizeY / 2

                local finalColor = (customColorEnabled and table.find(selectedESPTypes, "All ESP")) and customESPColor or (player.Team and player.Team.TeamColor.Color or Color3.new(1,1,1))

                -- 2D Box (if enabled)
                if showBox then
                    draws.box.Size = Vector2.new(sizeX, sizeY)
                    draws.box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                    draws.box.Color = (customColorEnabled and table.find(selectedESPTypes, "2D Box")) and customESPColor or finalColor
                    draws.box.Transparency = box2DTransparency
                    draws.box.Thickness = box2DThickness
                    draws.box.Visible = true
                else
                    draws.box.Visible = false
                end

                -- 3D Box (if enabled)
                if show3DBox then
                    local halfSize = Vector3.new(2, 5, 1) / 2  -- Approx character size: width 2, height 5, depth 1
                    local corners = {
                        root.CFrame * CFrame.new(-halfSize.X, -halfSize.Y, -halfSize.Z).Position,
                        root.CFrame * CFrame.new(halfSize.X, -halfSize.Y, -halfSize.Z).Position,
                        root.CFrame * CFrame.new(halfSize.X, halfSize.Y, -halfSize.Z).Position,
                        root.CFrame * CFrame.new(-halfSize.X, halfSize.Y, -halfSize.Z).Position,
                        root.CFrame * CFrame.new(-halfSize.X, -halfSize.Y, halfSize.Z).Position,
                        root.CFrame * CFrame.new(halfSize.X, -halfSize.Y, halfSize.Z).Position,
                        root.CFrame * CFrame.new(halfSize.X, halfSize.Y, halfSize.Z).Position,
                        root.CFrame * CFrame.new(-halfSize.X, halfSize.Y, halfSize.Z).Position
                    }

                    local screenCorners = {}
                    local allOnScreen = true
                    for i, corner in ipairs(corners) do
                        local screenPos, visible = camera:WorldToViewportPoint(corner)
                        screenCorners[i] = Vector2.new(screenPos.X, screenPos.Y)
                        if not visible then
                            allOnScreen = false
                            break
                        end
                    end

                    if allOnScreen then
                        local lineConnections = {
                            {1,2}, {2,3}, {3,4}, {4,1},  -- Front face
                            {5,6}, {6,7}, {7,8}, {8,5},  -- Back face
                            {1,5}, {2,6}, {3,7}, {4,8}   -- Connecting lines
                        }

                        for i, conn in ipairs(lineConnections) do
                            draws.lines[i].From = screenCorners[conn[1]]
                            draws.lines[i].To = screenCorners[conn[2]]
                            draws.lines[i].Color = (customColorEnabled and table.find(selectedESPTypes, "3D Box")) and customESPColor or finalColor
                            draws.lines[i].Transparency = box3DTransparency
                            draws.lines[i].Thickness = box3DThickness
                            draws.lines[i].Visible = true
                        end
                    else
                        for _, line in ipairs(draws.lines) do line.Visible = false end
                    end
                else
                    for _, line in ipairs(draws.lines) do line.Visible = false end
                end

                -- Health Bar 1 (if enabled) with black borders
                if showHealthNew then
                    local healthPct = humanoid.Health / humanoid.MaxHealth
                    local barHeight = sizeY
                    local barPosX = (pos.X - sizeX / 2) - 6
                    local barBottomY = pos.Y + sizeY / 2
                    local barTopY = barBottomY - barHeight

                    -- Update thickness dynamically
                    draws.healthBg.Thickness = healthThickness + 2
                    draws.healthFg.Thickness = healthThickness

                    -- Background (thicker black for border effect)
                    draws.healthBg.From = Vector2.new(barPosX, barBottomY)
                    draws.healthBg.To = Vector2.new(barPosX, barTopY)
                    draws.healthBg.Transparency = healthTransparency
                    draws.healthBg.Visible = true

                    -- Foreground (original HSV colors)
                    draws.healthFg.From = Vector2.new(barPosX, barBottomY)
                    draws.healthFg.To = Vector2.new(barPosX, barBottomY - (barHeight * healthPct))
                    draws.healthFg.Color = Color3.fromHSV(healthPct * 0.333, 1, 1) -- Original green to red
                    draws.healthFg.Transparency = healthTransparency
                    draws.healthFg.Visible = true
                else
                    draws.healthBg.Visible = false
                    draws.healthFg.Visible = false
                end

                -- Health Bar 2 (added, positioned on the right side)
                if showHealthNew2 then
                    local healthPct = humanoid.Health / humanoid.MaxHealth
                    local barHeight = sizeY
                    local barPosX = (pos.X + sizeX / 2) + 6  -- Right side
                    local barBottomY = pos.Y + sizeY / 2
                    local barTopY = barBottomY - barHeight

                    -- Update thickness dynamically
                    draws.healthBg2.Thickness = healthThickness + 2
                    draws.healthFg2.Thickness = healthThickness

                    -- Background (thicker black for border effect)
                    draws.healthBg2.From = Vector2.new(barPosX, barBottomY)
                    draws.healthBg2.To = Vector2.new(barPosX, barTopY)
                    draws.healthBg2.Transparency = healthTransparency
                    draws.healthBg2.Visible = true

                    -- Foreground (original HSV colors)
                    draws.healthFg2.From = Vector2.new(barPosX, barBottomY)
                    draws.healthFg2.To = Vector2.new(barPosX, barBottomY - (barHeight * healthPct))
                    draws.healthFg2.Color = Color3.fromHSV(healthPct * 0.333, 1, 1) -- Original green to red
                    draws.healthFg2.Transparency = healthTransparency
                    draws.healthFg2.Visible = true
                else
                    draws.healthBg2.Visible = false
                    draws.healthFg2.Visible = false
                end

                -- Name (if enabled)
                if showName then
                    draws.name.Text = player.DisplayName .. " (" .. player.Name .. ")"
                    draws.name.Position = Vector2.new(pos.X, (pos.Y - sizeY / 2) - 22)
                    draws.name.Color = (customColorEnabled and table.find(selectedESPTypes, "Name")) and customESPColor or finalColor
                    draws.name.Visible = true
                else
                    draws.name.Visible = false
                end

                -- Distance (if enabled)
                if showDist then
                    local distTextStr = math.floor(dist) .. " Studs"
                    draws.dist.Text = distTextStr
                    draws.dist.Position = Vector2.new(pos.X, (pos.Y + sizeY / 2) + 5)
                    draws.dist.Color = (customColorEnabled and table.find(selectedESPTypes, "Distance")) and customESPColor or finalColor
                    draws.dist.Visible = true
                else
                    draws.dist.Visible = false
                end

                -- Tool (if enabled)
                if showTool then
                    local tool = char:FindFirstChildOfClass("Tool")
                    draws.tool.Text = tool and tool.Name or "Equipped Tool Name Here"
                    draws.tool.Position = Vector2.new(pos.X, (pos.Y + sizeY / 2) + 20)
                    draws.tool.Color = (customColorEnabled and table.find(selectedESPTypes, "Tool")) and customESPColor or finalColor
                    draws.tool.Visible = true
                else
                    draws.tool.Visible = false
                end
            end
        else
            for _, d in pairs(draws) do 
                if typeof(d) == "table" then
                    for _, line in ipairs(d) do line.Visible = false end
                else
                    d.Visible = false 
                end
            end
            -- Remove drawings if player no longer exists
            drawings[player] = nil
        end
    end
end

local function enableNewESP()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then  -- Skip self
            createNewESP(player)
        end
    end
    players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then
            createNewESP(player)
        end
    end)
    connection = game:GetService("RunService").Heartbeat:Connect(updateNewESP)  -- Changed to Heartbeat for less lag
end

local function disableNewESP()
    if connection then connection:Disconnect() end
    for _, draws in pairs(drawings) do
        for k, d in pairs(draws) do
            if k == "lines" then
                for _, line in ipairs(d) do line:Remove() end
            else
                d:Remove()
            end
        end
    end
    drawings = {}
end

local function refreshNewESP()
    disableNewESP()
    if showBox or show3DBox or showHealthNew or showHealthNew2 or showName or showDist or showTool then
        enableNewESP()
    end
end

local function cleanStuckESPs()
    local currentPlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        currentPlayers[player] = true
    end

    -- Clean new ESP drawings
    for player, _ in pairs(drawings) do
        if not currentPlayers[player] then
            local draws = drawings[player]
            for k, d in pairs(draws) do
                if k == "lines" then
                    for _, line in ipairs(d) do line:Remove() end
                else
                    d:Remove()
                end
            end
            drawings[player] = nil
        end
    end

    -- Clean skeleton ESP
    for player, _ in pairs(espObjects) do
        if not currentPlayers[player] then
            local esp = espObjects[player]
            for _, line in pairs(esp.Lines) do
                line:Remove()
            end
            for _, label in pairs(esp.Labels) do
                label:Remove()
            end
            espObjects[player] = nil
        end
    end

    -- Clean 3D Box
    for player, _ in pairs(Box3DObjects) do
        if not currentPlayers[player] then
            Remove3DBox(player)
        end
    end

    -- Clean original ESP
    for player, _ in pairs(ESPObjects) do
        if not currentPlayers[player] then
            RemoveESP(player)
        end
    end

    -- Clean Line ESP
    for player, line in pairs(lineESPObjects) do
        if not currentPlayers[player] then
            line:Remove()
            lineESPObjects[player] = nil
        end
    end
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
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.3
        highlight.FillColor = customColorEnabled and table.find(selectedESPTypes, "Highlight ESP") and customESPColor or (player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255))
        highlight.OutlineTransparency = 1
        highlight.Enabled = ESPEnabled and highlightESPEnabled  -- Controlled by Highlight toggle
        highlight.Parent = player.Character
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 200, 0, 100)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = ESPEnabled or ShowHealth or ShowInventory
        billboard.Parent = player.Character

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
        healthText.Visible = ShowHealth
        healthText.Parent = billboard

        local inventoryText = Instance.new("TextLabel")
        inventoryText.Name = "InventoryText"
        inventoryText.Size = UDim2.new(1, 0, 0, 15)
        inventoryText.Position = UDim2.new(0, 0, 0, 25)
        inventoryText.BackgroundTransparency = 1
        inventoryText.TextColor3 = customColorEnabled and customESPColor or (player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255))
        inventoryText.TextSize = 12
        inventoryText.Font = Enum.Font.SourceSansBold
        inventoryText.TextStrokeTransparency = 0
        inventoryText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        inventoryText.Text = "Inventory: N/A"
        inventoryText.Visible = ShowInventory and player.Team and table.find(prisonerTeams, player.Team.Name)
        inventoryText.Parent = billboard

        local humanoid = player.Character.Humanoid
        if humanoid then
            local function updateHealth()
                if not player.Character or not humanoid or not healthText.Visible then
                    healthText.Text = "HP: N/A"
                    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    return
                end
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local hpValue = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                healthText.Text = "HP: " .. hpValue
                if healthPercent >= 0.7 then
                    healthText.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green
                elseif healthPercent >= 0.3 then
                    healthText.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange
                else
                    healthText.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red
                end
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
    for _, espHolder in pairs(ESPObjects) do
        if espHolder.Highlight then espHolder.Highlight:Destroy() end
        if espHolder.Billboard then espHolder.Billboard:Destroy() end
    end
    ESPObjects = {}
    if not (ESPEnabled or ShowHealth or ShowInventory) then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            CreateESP(player)
        end
    end
end

local function UpdateESPVisibilities()
    for player, espHolder in pairs(ESPObjects) do
        if espHolder.Highlight then 
            espHolder.Highlight.Enabled = ESPEnabled and highlightESPEnabled
            espHolder.Highlight.FillColor = customColorEnabled and table.find(selectedESPTypes, "Highlight ESP") and customESPColor or (player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255))
        end
        if espHolder.Billboard then espHolder.Billboard.Enabled = ESPEnabled or ShowHealth or ShowInventory end
        if espHolder.HealthText then espHolder.HealthText.Visible = ShowHealth end
        if espHolder.InventoryText then 
            espHolder.InventoryText.Visible = ShowInventory and player.Team and table.find(prisonerTeams, player.Team.Name) or false 
            espHolder.InventoryText.TextColor3 = customColorEnabled and customESPColor or (player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255))
        end
    end
end

local function CleanupUnusedESP()
    if ESPEnabled or ShowHealth or ShowInventory then return end
    for player in pairs(ESPObjects) do
        RemoveESP(player)
    end
    ESPObjects = {}
end

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
    local allOnScreen = true
    for i, corner in pairs(corners) do
        local screenPos, onScreen = camera:WorldToViewportPoint(corner)
        screenCorners[i] = {Pos = Vector2.new(screenPos.X, screenPos.Y), OnScreen = onScreen}
        allOnScreen = allOnScreen and onScreen
    end
    local lineConnections = {
        {1,2}, {2,3}, {3,4}, {4,1},
        {5,6}, {6,7}, {7,8}, {8,5},
        {1,5}, {2,6}, {3,7}, {4,8}
    }
    if not allOnScreen then
        for _, line in pairs(Box3DObjects[player].Lines) do line.Visible = false end
        return
    end
    local finalColor = customColorEnabled and customESPColor or Box3DObjects[player].Color
    for i, conn in pairs(lineConnections) do
        local line = Box3DObjects[player].Lines[i]
        line.From = screenCorners[conn[1]].Pos
        line.To = screenCorners[conn[2]].Pos
        line.Color = finalColor
        line.Visible = true
    end
end

local function Refresh3DBox()
    if not Box3DEnabled then
        return
    end
    for player in pairs(Box3DObjects) do
        Remove3DBox(player)
    end
    Box3DObjects = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            Create3DBox(player)
            Update3DBox(player)
        end
    end
end

local function createMaterialESP(material)
    if not materialESPEnabled or not material:IsA("BasePart") or not (material.Material == Enum.Material.Plastic or material.Material == Enum.Material.Metal) then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = material
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.FillColor = material.Color
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
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
            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        else
            highlight:Destroy()
        end
    end
    materialHighlights = {}
    for _, material in pairs(workspace:GetDescendants()) do
        if material:IsA("BasePart") and (material.Material == Enum.Material.Plastic or material.Material == Enum.Material.Metal) then
            createMaterialESP(material)
        end
    end
end

local function createBoxESP(obj)
    if boxAdornments[obj] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = obj
    box.Size = obj.Size + Vector3.new(0.2, 0.2, 0.2)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 255, 0)
    box.AlwaysOnTop = true
    box.ZIndex = 1
    box.Parent = obj
    local legLine1 = Instance.new("LineHandleAdornment")
    legLine1.Adornee = obj
    legLine1.Length = obj.Size.Y / 2
    legLine1.Thickness = 0.1
    legLine1.Color3 = Color3.fromRGB(255, 255, 255)
    legLine1.CFrame = obj.CFrame * CFrame.new(0, -obj.Size.Y / 4, 0)
    legLine1.AlwaysOnTop = true
    legLine1.Parent = obj
    local legLine2 = legLine1:Clone()
    legLine2.CFrame = obj.CFrame * CFrame.new(0, -obj.Size.Y / 4, 0.5)
    legLine2.Parent = obj
    local bodyLine = Instance.new("LineHandleAdornment")
    bodyLine.Adornee = obj
    bodyLine.Length = obj.Size.X + 0.2
    bodyLine.Thickness = 0.1
    bodyLine.Color3 = Color3.fromRGB(255, 255, 255)
    bodyLine.CFrame = obj.CFrame * CFrame.new(0, 0, 0)
    bodyLine.AlwaysOnTop = true
    bodyLine.Parent = obj
    local armLine1 = Instance.new("LineHandleAdornment")
    armLine1.Adornee = obj
    armLine1.Length = obj.Size.X / 2
    armLine1.Thickness = 0.1
    armLine1.Color3 = Color3.fromRGB(255, 255, 255)
    armLine1.CFrame = obj.CFrame * CFrame.new(-obj.Size.X / 4, 0, 0)
    armLine1.AlwaysOnTop = true
    armLine1.Parent = obj
    local armLine2 = armLine1:Clone()
    armLine2.CFrame = obj.CFrame * CFrame.new(obj.Size.X / 4, 0, 0)
    armLine2.Parent = obj
    local headCircle = Instance.new("CylinderHandleAdornment")
    headCircle.Adornee = obj
    headCircle.Height = 0.1
    headCircle.Radius = obj.Size.X / 4
    headCircle.Transparency = 0.5
    headCircle.Color3 = Color3.fromRGB(255, 255, 255)
    headCircle.CFrame = obj.CFrame * CFrame.new(0, obj.Size.Y / 2, 0)
    headCircle.AlwaysOnTop = true
    headCircle.Parent = obj
    boxAdornments[obj] = {box, legLine1, legLine2, bodyLine, armLine1, armLine2, headCircle}
end

local function updateBoxESP(obj)
    if not boxAdornments[obj] then return end
    local adornments = boxAdornments[obj]
    adornments[1].Color3 = Color3.fromRGB(255, 255, 0)
    adornments[2].CFrame = obj.CFrame * CFrame.new(0, -obj.Size.Y / 4, 0)
    adornments[3].CFrame = obj.CFrame * CFrame.new(0, -obj.Size.Y / 4, 0.5)
    adornments[4].CFrame = obj.CFrame * CFrame.new(0, 0, 0)
    adornments[5].CFrame = obj.CFrame * CFrame.new(-obj.Size.X / 4, 0, 0)
    adornments[6].CFrame = obj.CFrame * CFrame.new(obj.Size.X / 4, 0, 0)
    adornments[7].CFrame = obj.CFrame * CFrame.new(0, obj.Size.Y / 2, 0)
    print("Updating " .. obj.Name .. " Box ESP")
end

local function refreshBoxESP()
    if not boxEnabled then
        for obj, adornments in pairs(boxAdornments) do
            for _, adornment in pairs(adornments) do
                adornment:Destroy()
            end
        end
        boxAdornments = {}
        return
    end
    for obj, adornments in pairs(boxAdornments) do
        for _, adornment in pairs(adornments) do
            adornment:Destroy()
        end
    end
    boxAdornments = {}
    local crafting = workspace.Map:FindFirstChild("Functional") and workspace.Map.Functional:FindFirstChild("Crafting")
    if crafting then
        for _, obj in pairs(crafting:GetDescendants()) do
            if (obj:IsA("Part") or obj:IsA("BasePart")) and (obj.Name:lower():find("metal") or obj.Name:lower():find("plastic")) then
                createBoxESP(obj)
                updateBoxESP(obj)
            end
        end
    else
        print("Crafting path not found, searching all workspace...")
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("Part") or obj:IsA("BasePart")) and (obj.Name:lower():find("metal") or obj.Name:lower():find("plastic")) then
                createBoxESP(obj)
                updateBoxESP(obj)
            end
        end
    end
end

local function createVentHighlight(vent)
    if ventHighlights[vent] then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = vent
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 1
    highlight.FillColor = Color3.fromRGB(0, 255, 255)
    highlight.Parent = vent
    ventHighlights[vent] = highlight
end

local function updateVentHighlight(vent)
    if not ventHighlights[vent] then return end
    local highlight = ventHighlights[vent]
    local isOpen = not vent:FindFirstChild("Cover") and not vent:FindFirstChild("Locked")
    highlight.FillColor = isOpen and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 105, 180)
end

local function refreshVents()
    if not ventsEnabled then
        for vent, highlight in pairs(ventHighlights) do
            highlight:Destroy()
        end
        ventHighlights = {}
        return
    end
    for vent, highlight in pairs(ventHighlights) do
        highlight:Destroy()
    end
    ventHighlights = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("vent") then
            createVentHighlight(obj)
            updateVentHighlight(obj)
        end
    end
end

local function createGarbageHighlight(garbage)
    if garbageHighlights[garbage] then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = garbage
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 1
    highlight.FillColor = Color3.fromRGB(255, 105, 180)
    highlight.Parent = garbage
    garbageHighlights[garbage] = highlight
end

local function updateGarbageHighlight(garbage)
    if not garbageHighlights[garbage] then return end
    local highlight = garbageHighlights[garbage]
    local isEmpty = false
    if garbage.Name:lower():find("empty") or garbage.Name:lower():find("searched") then
        isEmpty = true
    else
        for _, child in pairs(garbage:GetChildren()) do
            if child.Name:lower():find("empty") or child.Name:lower():find("searched") or 
               (child:IsA("BoolValue") and child.Name:lower() == "searched" and child.Value) then
                isEmpty = true
                break
            end
        end
    end
    highlight.FillColor = isEmpty and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 105, 180)
    print("Updating " .. garbage.Name .. ": IsEmpty = " .. tostring(isEmpty))
end

local function refreshGarbage()
    if not garbageEnabled then
        for garbage, highlight in pairs(garbageHighlights) do
            highlight:Destroy()
        end
        garbageHighlights = {}
        return
    end
    for garbage, highlight in pairs(garbageHighlights) do
        highlight:Destroy()
    end
    garbageHighlights = {}
    local searchable = workspace.Map:FindFirstChild("Functional") and workspace.Map.Functional:FindFirstChild("Storages") and workspace.Map.Functional.Storages:FindFirstChild("Searchable")
    if searchable then
        for _, obj in pairs(searchable:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("Part") or obj:IsA("BasePart")) and obj.Name:lower():find("bin") then
                createGarbageHighlight(obj)
                updateGarbageHighlight(obj)
            end
        end
    else
        print("Searchable path not found, searching all workspace...")
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("Part") or obj:IsA("BasePart")) and obj.Name:lower():find("bin") then
                createGarbageHighlight(obj)
                updateGarbageHighlight(obj)
            end
        end
    end
end

local function RefreshAllESP()
    RefreshESP()
    Refresh3DBox()
    refreshMaterialESP()
    refreshVents()
    refreshGarbage()
    refreshNewESP()
    refreshStickmanESP()  -- Added to include Skeleton ESP 1 in auto refresh
    refreshLineESP()
end

function createStickmanESP(player)
    if player == localPlayer then return end  -- Skip self
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local parts = {}
    local function getPart(name)
        local part = character:FindFirstChild(name)
        if part then return part end
        local r6Map = {
            ["Head"] = "Head",
            ["Torso"] = "Torso",
            ["Left Arm"] = "LeftUpperArm",
            ["Right Arm"] = "RightUpperArm",
            ["Left Leg"] = "LeftUpperLeg",
            ["Right Leg"] = "RightUpperLeg"
        }
        local r15Map = {
            ["Head"] = "Head",
            ["UpperTorso"] = "UpperTorso",
            ["LowerTorso"] = "LowerTorso",
            ["LeftUpperArm"] = "LeftUpperArm",
            ["LeftLowerArm"] = "LeftLowerArm",
            ["LeftHand"] = "LeftHand",
            ["RightUpperArm"] = "RightUpperArm",
            ["RightLowerArm"] = "RightLowerArm",
            ["RightHand"] = "RightHand",
            ["LeftUpperLeg"] = "LeftUpperLeg",
            ["LeftLowerLeg"] = "LeftLowerLeg",
            ["LeftFoot"] = "LeftFoot",
            ["RightUpperLeg"] = "RightUpperLeg",
            ["RightLowerLeg"] = "RightLowerLeg",
            ["RightFoot"] = "RightFoot"
        }
        for r6Name, r15Name in pairs(r6Map) do
            if name == r15Name then
                local r6Part = character:FindFirstChild(r6Name)
                if r6Part then return r6Part end
            end
        end
        for r15Name, _ in pairs(r15Map) do
            if name == r15Name then
                local r15Part = character:FindFirstChild(r15Name)
                if r15Part then return r15Part end
            end
        end
        return nil
    end
    parts.Head = getPart("Head")
    parts.UpperTorso = getPart("UpperTorso") or getPart("Torso")
    parts.LowerTorso = getPart("LowerTorso")
    parts.LeftUpperArm = getPart("LeftUpperArm") or getPart("Left Arm")
    parts.LeftLowerArm = getPart("LeftLowerArm")
    parts.LeftHand = getPart("LeftHand")
    parts.RightUpperArm = getPart("RightUpperArm") or getPart("Right Arm")
    parts.RightLowerArm = getPart("RightLowerArm")
    parts.RightHand = getPart("RightHand")
    parts.LeftUpperLeg = getPart("LeftUpperLeg") or getPart("Left Leg")
    parts.LeftLowerLeg = getPart("LeftLowerLeg")
    parts.LeftFoot = getPart("LeftFoot")
    parts.RightUpperLeg = getPart("RightUpperLeg") or getPart("Right Leg")
    parts.RightLowerLeg = getPart("RightLowerLeg")
    parts.RightFoot = getPart("RightFoot")
    parts.HumanoidRootPart = getPart("HumanoidRootPart")
    if not parts.Head or not parts.UpperTorso or not parts.HumanoidRootPart then return end
    local esp = {
        Player = player,
        Lines = {},
        Labels = {}
    }
    local connections = {
        {From = parts.Head, To = parts.UpperTorso},
        {From = parts.UpperTorso, To = parts.LowerTorso or parts.UpperTorso},
        {From = parts.UpperTorso, To = parts.LeftUpperArm},
        {From = parts.LeftUpperArm, To = parts.LeftLowerArm or parts.LeftUpperArm},
        {From = parts.LeftLowerArm or parts.LeftUpperArm, To = parts.LeftHand or parts.LeftUpperArm},
        {From = parts.UpperTorso, To = parts.RightUpperArm},
        {From = parts.RightUpperArm, To = parts.RightLowerArm or parts.RightUpperArm},
        {From = parts.RightLowerArm or parts.RightUpperArm, To = parts.RightHand or parts.RightUpperArm},
        {From = parts.LowerTorso or parts.UpperTorso, To = parts.LeftUpperLeg},
        {From = parts.LeftUpperLeg, To = parts.LeftLowerLeg or parts.LeftUpperLeg},
        {From = parts.LeftLowerLeg or parts.LeftUpperLeg, To = parts.LeftFoot or parts.LeftUpperLeg},
        {From = parts.LowerTorso or parts.UpperTorso, To = parts.RightUpperLeg},
        {From = parts.RightUpperLeg, To = parts.RightLowerLeg or parts.RightUpperLeg},
        {From = parts.RightLowerLeg or parts.RightUpperLeg, To = parts.RightFoot or parts.RightUpperLeg}
    }
    for _, connection in pairs(connections) do
        local fromPart, toPart = connection.From, connection.To
        if fromPart and toPart then
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = customColorEnabled and customESPColor or (player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255))
            line.Thickness = espSettings.Thickness
            line.Transparency = espSettings.Transparency
            table.insert(esp.Lines, line)
        end
    end
    local distanceLabel = Drawing.new("Text")
    distanceLabel.Visible = false
    distanceLabel.Color = customColorEnabled and customESPColor or (player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255))
    distanceLabel.Size = 11
    distanceLabel.Center = true
    distanceLabel.Outline = true
    distanceLabel.Font = 2
    esp.Labels.Distance = distanceLabel
    espObjects[player] = esp
end

function updateStickmanESP()
    for player, esp in pairs(espObjects) do
        if not player or not player.Character or not espSettings.Enabled then
            for _, line in pairs(esp.Lines) do
                line.Visible = false
            end
            for _, label in pairs(esp.Labels) do
                label.Visible = false
            end
            continue
        end
        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            for _, line in pairs(esp.Lines) do
                line.Visible = false
            end
            for _, label in pairs(esp.Labels) do
                label.Visible = false
            end
            continue
        end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            for _, line in pairs(esp.Lines) do
                line.Visible = false
            end
            for _, label in pairs(esp.Labels) do
                label.Visible = false
            end
            continue
        end
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
            or 0
        if distance > espSettings.MaxDistance then
            for _, line in pairs(esp.Lines) do
                line.Visible = false
            end
            for _, label in pairs(esp.Labels) do
                label.Visible = false
            end
            continue
        end
        local parts = {}
        local function getPart(name)
            local part = character:FindFirstChild(name)
            if part then return part end
            local r6Map = {["Head"] = "Head", ["Torso"] = "Torso", ["Left Arm"] = "LeftUpperArm", ["Right Arm"] = "RightUpperArm", ["Left Leg"] = "LeftUpperLeg", ["Right Leg"] = "RightUpperLeg"}
            local r15Map = {["Head"] = "Head", ["UpperTorso"] = "UpperTorso", ["LowerTorso"] = "LowerTorso", ["LeftUpperArm"] = "LeftUpperArm", ["LeftLowerArm"] = "LeftLowerArm", ["LeftHand"] = "LeftHand", ["RightUpperArm"] = "RightUpperArm", ["RightLowerArm"] = "RightLowerArm", ["RightHand"] = "RightHand", ["LeftUpperLeg"] = "LeftUpperLeg", ["LeftLowerLeg"] = "LeftLowerLeg", ["LeftFoot"] = "LeftFoot", ["RightUpperLeg"] = "RightUpperLeg", ["RightLowerLeg"] = "RightLowerLeg", ["RightFoot"] = "RightFoot"}
            for r6Name, r15Name in pairs(r6Map) do
                if name == r15Name then
                    local r6Part = character:FindFirstChild(r6Name)
                    if r6Part then return r6Part end
                end
            end
            for r15Name, _ in pairs(r15Map) do
                if name == r15Name then
                    local r15Part = character:FindFirstChild(r15Name)
                    if r15Part then return r15Part end
                end
            end
            return nil
        end
        parts.Head = getPart("Head")
        parts.UpperTorso = getPart("UpperTorso") or getPart("Torso")
        parts.LowerTorso = getPart("LowerTorso")
        parts.LeftUpperArm = getPart("LeftUpperArm") or getPart("Left Arm")
        parts.LeftLowerArm = getPart("LeftLowerArm")
        parts.LeftHand = getPart("LeftHand")
        parts.RightUpperArm = getPart("RightUpperArm") or getPart("Right Arm")
        parts.RightLowerArm = getPart("RightLowerArm")
        parts.RightHand = getPart("RightHand")
        parts.LeftUpperLeg = getPart("LeftUpperLeg") or getPart("Left Leg")
        parts.LeftLowerLeg = getPart("LeftLowerLeg")
        parts.LeftFoot = getPart("LeftFoot")
        parts.RightUpperLeg = getPart("RightUpperLeg") or getPart("Right Leg")
        parts.RightLowerLeg = getPart("RightLowerLeg")
        parts.RightFoot = getPart("RightFoot")
        local connections = {
            {From = parts.Head, To = parts.UpperTorso},
            {From = parts.UpperTorso, To = parts.LowerTorso or parts.UpperTorso},
            {From = parts.UpperTorso, To = parts.LeftUpperArm},
            {From = parts.LeftUpperArm, To = parts.LeftLowerArm or parts.LeftUpperArm},
            {From = parts.LeftLowerArm or parts.LeftUpperArm, To = parts.LeftHand or parts.LeftUpperArm},
            {From = parts.UpperTorso, To = parts.RightUpperArm},
            {From = parts.RightUpperArm, To = parts.RightLowerArm or parts.RightUpperArm},
            {From = parts.RightLowerArm or parts.RightUpperArm, To = parts.RightHand or parts.RightUpperArm},
            {From = parts.LowerTorso or parts.UpperTorso, To = parts.LeftUpperLeg},
            {From = parts.LeftUpperLeg, To = parts.LeftLowerLeg or parts.LeftUpperLeg},
            {From = parts.LeftLowerLeg or parts.LeftUpperLeg, To = parts.LeftFoot or parts.LeftUpperLeg},
            {From = parts.LowerTorso or parts.UpperTorso, To = parts.RightUpperLeg},
            {From = parts.RightUpperLeg, To = parts.RightLowerLeg or parts.RightUpperLeg},
            {From = parts.RightLowerLeg or parts.RightUpperLeg, To = parts.RightFoot or parts.RightUpperLeg}
        }
        local lineIndex = 1
        for _, connection in pairs(connections) do
            local fromPart, toPart = connection.From, connection.To
            if fromPart and toPart then
                local fromScreen, fromVisible = camera:WorldToViewportPoint(fromPart.Position)
                local toScreen, toVisible = camera:WorldToViewportPoint(toPart.Position)
                if fromVisible and toVisible then
                    local line = esp.Lines[lineIndex]
                    line.From = Vector2.new(fromScreen.X, fromScreen.Y)
                    line.To = Vector2.new(toScreen.X, toScreen.Y)
                    line.Visible = true
                    lineIndex = lineIndex + 1
                end
            end
        end
        for i = lineIndex, #esp.Lines do
            esp.Lines[i].Visible = false
        end
        if espSettings.ShowDistance then
            local rootScreen, rootVisible = camera:WorldToViewportPoint(rootPart.Position)
            if rootVisible then
                esp.Labels.Distance.Text = tostring(math.floor(distance)) .. " studs"
                esp.Labels.Distance.Position = Vector2.new(rootScreen.X, rootScreen.Y + 20)
                esp.Labels.Distance.Visible = true
            else
                esp.Labels.Distance.Visible = false
            end
        else
            esp.Labels.Distance.Visible = false
        end
    end
end

local function refreshStickmanESP()
    for player in pairs(espObjects) do
        local esp = espObjects[player]
        for _, line in pairs(esp.Lines) do
            line:Remove()
        end
        for _, label in pairs(esp.Labels) do
            label:Remove()
        end
        espObjects[player] = nil
    end
    if not espSettings.Enabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createStickmanESP(player)
        end
    end
end

local function refreshLineESP()
    for player, line in pairs(lineESPObjects) do
        line:Remove()
        lineESPObjects[player] = nil
    end
    if not lineESPEnabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = lineColor
            line.Thickness = lineThickness
            line.Transparency = 1
            lineESPObjects[player] = line
        end
    end
end

local function updateLineESP()
    local screenHeight = camera.ViewportSize.Y
    for player, line in pairs(lineESPObjects) do
        local char = getCharacter(player)
        if char and char:FindFirstChild("HumanoidRootPart") then
            local rootPos, onScreen = camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
            if onScreen then
                line.From = Vector2.new(rootPos.X, screenHeight)
                line.To = Vector2.new(rootPos.X, rootPos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESP_TOGGLE",
    Callback = function(Value)
        ESPEnabled = Value
        RefreshESP()
        UpdateESPVisibilities()
        CleanupUnusedESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = false,
    Flag = "SHOW_HEALTH",
    Callback = function(Value)
        ShowHealth = Value
        RefreshESP()
        UpdateESPVisibilities()
        CleanupUnusedESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show Inventory",
    CurrentValue = false,
    Flag = "SHOW_INVENTORY",
    Callback = function(Value)
        ShowInventory = Value
        RefreshESP()
        UpdateESPVisibilities()
        CleanupUnusedESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Highlight ESP",
    CurrentValue = false,
    Flag = "HIGHLIGHT_ESP",
    Callback = function(Value)
        highlightESPEnabled = Value
        UpdateESPVisibilities()
    end
})

VisualsTab:CreateToggle({
    Name = "Enable Xray",
    CurrentValue = false,
    Flag = "XRAY_TOGGLE",
    Callback = function(Value)
        xrayEnabled = Value
        -- Implement Xray logic here if needed
    end
})

VisualsTab:CreateToggle({
    Name = "3D Box ESP",
    CurrentValue = false,
    Flag = "3D_BOX_ESP",
    Callback = function(Value)
        Box3DEnabled = Value
        Refresh3DBox()
    end
})

VisualsTab:CreateToggle({
    Name = "Material ESP",
    CurrentValue = false,
    Flag = "MATERIAL_ESP",
    Callback = function(Value)
        materialESPEnabled = Value
        refreshMaterialESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BOX_ESP",
    Callback = function(Value)
        boxEnabled = Value
        refreshBoxESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Vents ESP",
    CurrentValue = false,
    Flag = "VENTS_ESP",
    Callback = function(Value)
        ventsEnabled = Value
        refreshVents()
    end
})

VisualsTab:CreateToggle({
    Name = "Garbage ESP",
    CurrentValue = false,
    Flag = "GARBAGE_ESP",
    Callback = function(Value)
        garbageEnabled = Value
        refreshGarbage()
    end
})

VisualsTab:CreateToggle({
    Name = "Skeleton ESP",
    CurrentValue = false,
    Flag = "SKELETON_ESP",
    Callback = function(Value)
        espSettings.Enabled = Value
        refreshStickmanESP()
        if Value then
            connections.stickman = RunService.Heartbeat:Connect(updateStickmanESP)
        else
            if connections.stickman then connections.stickman:Disconnect() end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Line ESP",
    CurrentValue = false,
    Flag = "LINE_ESP",
    Callback = function(Value)
        lineESPEnabled = Value
        refreshLineESP()
        if Value then
            connections.lineESP = RunService.Heartbeat:Connect(updateLineESP)
        else
            if connections.lineESP then connections.lineESP:Disconnect() end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Auto Refresh ESP",
    CurrentValue = false,
    Flag = "AUTO_REFRESH_ESP",
    Callback = function(Value)
        autoRefreshEnabled = Value
        if Value then
            autoRefreshConnection = RunService.Heartbeat:Connect(function()
                if tick() - lastRefresh >= autoRefreshInterval then
                    RefreshAllESP()
                    lastRefresh = tick()
                end
            end)
        else
            if autoRefreshConnection then autoRefreshConnection:Disconnect() end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Auto Clean Stuck ESPs",
    CurrentValue = false,
    Flag = "AUTO_CLEAN_ESP",
    Callback = function(Value)
        autoCleanEnabled = Value
        if Value then
            autoCleanConnection = RunService.Heartbeat:Connect(function(dt)
                cleanTimer = cleanTimer + dt
                if cleanTimer >= 5 then  -- Clean every 5 seconds
                    cleanStuckESPs()
                    cleanTimer = 0
                end
            end)
        else
            if autoCleanConnection then autoCleanConnection:Disconnect() end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Custom ESP Color",
    CurrentValue = false,
    Flag = "CUSTOM_ESP_COLOR",
    Callback = function(Value)
        customColorEnabled = Value
        RefreshAllESP()
    end
})

VisualsTab:CreateColorPicker({
    Name = "Custom Color",
    Color = Color3.fromRGB(0, 255, 0),
    Callback = function(Value)
        customESPColor = Value
        RefreshAllESP()
    end
})

VisualsTab:CreateDropdown({
    Name = "Select ESP Types for Custom Color",
    Options = {"All ESP", "2D Box", "3D Box", "Name", "Distance", "Tool", "Highlight ESP"},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SELECTED_ESP_TYPES",
    Callback = function(Options)
        selectedESPTypes = Options
        RefreshAllESP()
    end
})

VisualsTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 5000},
    Increment = 100,
    CurrentValue = 1000,
    Flag = "MAX_DISTANCE",
    Callback = function(Value)
        maxDistance = Value
    end
})

VisualsTab:CreateSlider({
    Name = "Health Bar Transparency",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "HEALTH_TRANSPARENCY",
    Callback = function(Value)
        healthTransparency = Value
    end
})

VisualsTab:CreateSlider({
    Name = "Health Bar Thickness",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 1,
    Flag = "HEALTH_THICKNESS",
    Callback = function(Value)
        healthThickness = Value
    end
})

VisualsTab:CreateSlider({
    Name = "2D Box Transparency",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "BOX2D_TRANSPARENCY",
    Callback = function(Value)
        box2DTransparency = Value
    end
})

VisualsTab:CreateSlider({
    Name = "2D Box Thickness",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 1,
    Flag = "BOX2D_THICKNESS",
    Callback = function(Value)
        box2DThickness = Value
    end
})

VisualsTab:CreateSlider({
    Name = "3D Box Transparency",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "BOX3D_TRANSPARENCY",
    Callback = function(Value)
        box3DTransparency = Value
    end
})

VisualsTab:CreateSlider({
    Name = "3D Box Thickness",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 1,
    Flag = "BOX3D_THICKNESS",
    Callback = function(Value)
        box3DThickness = Value
    end
})

VisualsTab:CreateSlider({
    Name = "Line ESP Thickness",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 1,
    Flag = "LINE_THICKNESS",
    Callback = function(Value)
        lineThickness = Value
        refreshLineESP()
    end
})

VisualsTab:CreateColorPicker({
    Name = "Line ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        lineColor = Value
        refreshLineESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Enable New ESP",
    CurrentValue = false,
    Flag = "NEW_ESP_TOGGLE",
    Callback = function(Value)
        enableMainESP = Value
        if Value then
            enableNewESP()
        else
            disableNewESP()
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Show 2D Box",
    CurrentValue = false,
    Flag = "SHOW_2D_BOX",
    Callback = function(Value)
        showBox = Value
        refreshNewESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show 3D Box",
    CurrentValue = false,
    Flag = "SHOW_3D_BOX_NEW",
    Callback = function(Value)
        show3DBox = Value
        refreshNewESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show Health Bar 1",
    CurrentValue = false,
    Flag = "SHOW_HEALTH_NEW",
    Callback = function(Value)
        showHealthNew = Value
        refreshNewESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show Health Bar 2",
    CurrentValue = false,
    Flag = "SHOW_HEALTH_NEW2",
    Callback = function(Value)
        showHealthNew2 = Value
        refreshNewESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = false,
    Flag = "SHOW_NAME",
    Callback = function(Value)
        showName = Value
        refreshNewESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Flag = "SHOW_DIST_NEW",
    Callback = function(Value)
        showDist = Value
        refreshNewESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Show Tool",
    CurrentValue = false,
    Flag = "SHOW_TOOL",
    Callback = function(Value)
        showTool = Value
        refreshNewESP()
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
local ShowFOVCircle = true 
local PredictionEnabled = false 
local BulletSpeed = 1000 
local HumanizationFactor = 0.2 -- متغير جديد للـ Humanization Factor
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
local SelectedTeams = { 
    ["Minimum Security"] = false, 
    ["VCSO-SWAT"] = false,
    ["Medium Security"] = false,
    ["Maximum Security"] = false, 
    ["Department of Corrections"] = false, 
    ["State Police"] = false, 
    ["Escapee"] = false, 
    ["Civilian"] = false, 
    ["Dead Body"] = false 
} 
local AimAccuracy = 100  -- متغير موجود للـ Aim Stability/Accuracy (0-100, 100 = perfect hit, lower = more spread) 
local aimbotConnection = nil 
local outConnection = nil 

-- دالة Humanization Factor لإضافة عشوائية للتصويب
local function ApplyHumanization(position)
    local randomOffset = Vector3.new(
        math.random(-HumanizationFactor, HumanizationFactor),
        math.random(-HumanizationFactor, HumanizationFactor),
        math.random(-HumanizationFactor, HumanizationFactor)
    )
    return position + randomOffset
end

-- دالة Prediction مُحدثة مع Ping وGravity
local function GetPredictedPosition(targetPart)
    if not targetPart then return Vector3.zero end 
    local basePos = targetPart.Position
    if PredictionEnabled then
        local velocity = targetPart.AssemblyLinearVelocity
        local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
        local timeToHit = distance / BulletSpeed
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        timeToHit = timeToHit + ping
        local gravity = Vector3.new(0, workspace.Gravity * timeToHit^2 / 2, 0)
        basePos = targetPart.Position + (velocity * timeToHit) + gravity
    end
    local spread = (100 - AimAccuracy) / 100 * 1  -- Max spread of 1 stud when accuracy=0, 0 when accuracy=100 
    local offset = Vector3.new(
        math.random(-spread, spread),
        math.random(-spread, spread),
        math.random(-spread, spread)
    )
    local predictedPos = basePos + offset
    return ApplyHumanization(predictedPos) -- إضافة Humanization
end 

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
    local playerTeam = player.Team and player.Team.Name or nil 
    local anyTeamSelected = false 
    for _, enabled in pairs(SelectedTeams) do 
        if enabled then 
            anyTeamSelected = true 
            break 
        end 
    end 
    if anyTeamSelected and playerTeam then 
        local isTargetable = false 
        for team, enabled in pairs(SelectedTeams) do 
            if enabled and playerTeam == team then 
                isTargetable = true 
                break 
            end 
        end 
        if not isTargetable then return false end 
    end 
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid") 
    if SelectedTeams["Dead Body"] == false and humanoid and humanoid.Health <= 0 then return false end 
    return player.Character and player.Character:FindFirstChild(TargetPart) and humanoid and IsVisible(player) 
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

local function UpdateFOV() 
    if FOVEnabled then 
        Camera.FieldOfView = CustomFOV 
    else 
        Camera.FieldOfView = DefaultFOV 
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
end 

local function DisableSilentAim() 
    if oldIndex then 
        getmetatable(game).__index = oldIndex 
        oldIndex = nil 
    end 
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
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, GetPredictedPosition(CurrentTarget.Character[TargetPart])) 
        end 
    end) 
end 

local function DisableKillAllAimbot() 
    if killAllCameraConnection then killAllCameraConnection:Disconnect(); killAllCameraConnection = nil end 
end 

local function EnableKillAll() 
    if killAllConnection then return end 
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
    UpdateFOV() 
end) 

CombatTab:CreateToggle({ 
    Name = "Enable Aimbot", 
    CurrentValue = false, 
    Flag = "AIMBOT_TOGGLE", 
    Callback = function(Value) 
        AimbotEnabled = Value 
        CurrentTarget = nil 
        hasNotifiedNoTarget = false 
        if AimbotEnabled then 
            CreateFOVCircle() 
            aimbotConnection = RunService.RenderStepped:Connect(function() 
                UpdateFOVCircle() 
                if AimbotEnabled then 
                    CurrentTarget = StickToTarget and CurrentTarget and IsValidTarget(CurrentTarget) and CurrentTarget or GetClosestPlayerInFOV() 
                    if not SilentAim and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(TargetPart) then 
                        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, GetPredictedPosition(CurrentTarget.Character[TargetPart])), Smoothness) 
                    end 
                end 
            end) 
        else 
            if aimbotConnection then 
                aimbotConnection:Disconnect() 
                aimbotConnection = nil 
            end 
            local currentSmooth = Smoothness 
            outConnection = RunService.RenderStepped:Connect(function() 
                local targetCFrame = CFrame.new(Camera.CFrame.Position, Mouse.Hit.Position) 
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, currentSmooth) 
                currentSmooth = math.min(1, currentSmooth + Smoothness) 
                if currentSmooth >= 1 then 
                    outConnection:Disconnect() 
                    outConnection = nil 
                end 
            end) 
            if FOVCircle then FOVCircle:Remove() FOVCircle = nil end 
            DisableSilentAim() 
        end 
    end 
}) 

CombatTab:CreateToggle({ 
    Name = "Silent Aim", 
    CurrentValue = false, 
    Flag = "SILENT_AIM", 
    Callback = function(Value) 
        SilentAim = Value 
        if SilentAim then 
            EnableSilentAim() 
        else 
            DisableSilentAim() 
        end 
    end 
})

CombatTab:CreateToggle({ 
    Name = "Desync", 
    CurrentValue = false, 
    Flag = "DESYNC", 
    Callback = function(Value) 
        DesyncEnabled = Value 
        if DesyncEnabled then EnableDesync() else DisableDesync() end 
    end 
}) 

CombatTab:CreateToggle({ 
    Name = "Prediction", 
    CurrentValue = false, 
    Flag = "PREDICTION", 
    Callback = function(Value) PredictionEnabled = Value end 
}) 

CombatTab:CreateSlider({ 
    Name = "Bullet Speed", 
    Range = {500, 5000}, 
    Increment = 100, 
    CurrentValue = 1000, 
    Flag = "BULLET_SPEED", 
    Callback = function(Value) BulletSpeed = Value end 
}) 

CombatTab:CreateSlider({ 
    Name = "Humanization Factor", 
    Range = {0, 1}, 
    Increment = 0.1, 
    CurrentValue = 0.2, 
    Flag = "HUMANIZATION", 
    Callback = function(Value) 
        HumanizationFactor = Value 
        Rayfield:Notify({ Title = "Humanization", Content = "تم تغيير عامل العشوائية إلى " .. Value, Duration = 3 }) 
    end 
})

CombatTab:CreateDropdown({ 
    Name = "Target Part", 
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, 
    CurrentOption = {"Head"}, 
    MultipleOptions = false, 
    Flag = "TARGET_PART", 
    Callback = function(Option) TargetPart = Option[1] end 
}) 

CombatTab:CreateDropdown({ 
    Name = "Check", 
    Options = {"Minimum Security", "Medium Security", "Maximum Security", "Department of Corrections", "State Police", "Escapee", "Civilian", "VCSO-SWAT"}, 
    CurrentOption = {}, 
    MultipleOptions = true, 
    Flag = "CHECK_TEAMS", 
    Callback = function(Options) 
        for team in pairs(SelectedTeams) do 
            SelectedTeams[team] = false 
        end 
        for _, team in pairs(Options) do 
            SelectedTeams[team] = true 
        end 
        CurrentTarget = nil 
    end 
}) 

CombatTab:CreateSlider({ 
    Name = "FOV Radius", 
    Range = {50, 500}, 
    Increment = 10, 
    CurrentValue = 150, 
    Flag = "FOV_RADIUS", 
    Callback = function(Value) FOVRadius = Value; UpdateFOVCircle() end 
}) 

CombatTab:CreateSlider({ 
    Name = "Smoothness (Visible Aim)", 
    Range = {0.05, 0.5}, 
    Increment = 0.01, 
    CurrentValue = 0.15, 
    Flag = "AIMBOT_SMOOTHNESS", 
    Callback = function(Value) Smoothness = Value end 
}) 

CombatTab:CreateToggle({ 
    Name = "Stick to Target", 
    CurrentValue = false, 
    Flag = "STICK_TARGET", 
    Callback = function(Value) StickToTarget = Value; if not StickToTarget then CurrentTarget = nil end end 
}) 

CombatTab:CreateToggle({ 
    Name = "Ignore Walls", 
    CurrentValue = false, 
    Flag = "IGNORE_WALLS", 
    Callback = function(Value) IgnoreWalls = Value end 
}) 

CombatTab:CreateToggle({ 
    Name = "Show FOV Circle", 
    CurrentValue = true, 
    Flag = "SHOW_FOV_CIRCLE", 
    Callback = function(Value) ShowFOVCircle = Value; UpdateFOVCircle() end 
}) 

CombatTab:CreateToggle({ 
    Name = "Enable Custom FOV", 
    CurrentValue = false, 
    Flag = "FOV_TOGGLE", 
    Callback = function(Value) FOVEnabled = Value; UpdateFOV() end 
}) 

CombatTab:CreateSlider({ 
    Name = "FOV Value", 
    Range = {30, 200}, 
    Increment = 1, 
    CurrentValue = 90, 
    Flag = "FOV_SLIDER", 
    Callback = function(Value) CustomFOV = Value; if FOVEnabled then Camera.FieldOfView = CustomFOV end end 
}) 

CombatTab:CreateColorPicker({ 
    Name = "FOV Circle Color", 
    Color = Color3.fromRGB(255, 0, 0), 
    Callback = function(Value) 
        FOVColor = Value 
        UpdateFOVCircle() 
    end 
}) 

CombatTab:CreateSlider({ 
    Name = "Aim Accuracy", 
    Range = {0, 100}, 
    Increment = 1, 
    Suffix = "%", 
    CurrentValue = 100, 
    Flag = "AIM_ACCURACY", 
    Callback = function(Value) AimAccuracy = Value end =
}) 
 
-- // TELEPORT SECTION 
local TeleportTab = Window:CreateTab("Teleports", 4483362458) 
local locations = { 
    ["Maintenance"] = CFrame.new(172.34, 23.10, -143.87), 
    ["Security"] = CFrame.new(224.47, 23.10, -167.90), 
    ["OC Lockers"] = CFrame.new(137.60, 23.10, -169.93), 
    ["RIOT Lockers"] = CFrame.new(165.63, 23.10, -192.25), 
    ["Ventilation"] = CFrame.new(76.96, -7.02, -19.21), 
    ["Maximum"] = CFrame.new(101.84, -8.82, -141.41), 
    ["Generator"] = CFrame.new(100.95, -8.82, -57.59), 
    ["Outside"] = CFrame.new(350.22, 5.40, -171.09), 
    ["Escape Base"] = CFrame.new(749.02, -0.97, -470.45) 
} 
for name, cf in pairs(locations) do 
    TeleportTab:CreateButton({ Name = name, Callback = function() LocalPlayer.Character:PivotTo(cf) end }) 
end 
TeleportTab:CreateButton({ Name = "Escape", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(307.06, 5.40, -177.88)) end }) 
TeleportTab:CreateButton({ Name = "Keycard (💳)", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(-13.36, 22.13, -27.47)) end }) 
TeleportTab:CreateButton({ Name = "GAS STATION", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(274.30, 6.21, -612.77)) end }) 
TeleportTab:CreateButton({ Name = "armory", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(189.40, 23.10, -214.47)) end }) 
TeleportTab:CreateButton({ Name = "BARN", Callback = function() LocalPlayer.Character:PivotTo(CFrame.new(43.68, 10.37, 395.04)) end }) 
 
-- // ITEMS SECTION 
local ItemsTab = Window:CreateTab("Items", 4483362458) 
ItemsTab:CreateButton({ 
    Name = "Get Fake Keycard (Visible to Players)", 
    Callback = function() 
        local player = LocalPlayer 
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
            Rayfield:Notify({ Title = "Error", Content = "Character not found!", Duration = 3, Image = 4483362458 }) 
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
                Rayfield:Notify({ Title = "Success", Content = "Keycard added to inventory!", Duration = 3, Image = 4483362458 }) 
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
                    Rayfield:Notify({ Title = "Success", Content = "Infinite stamina enabled!", Duration = 5, Image = 4483362458 }) 
                else 
                    Rayfield:Notify({ Title = "Info", Content = "Infinite stamina disabled!", Duration = 5, Image = 4483362458 }) 
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
    Name = "Speed", 
    Range = {1, 100}, 
    Increment = 1, 
    Suffix = "USpeed", 
    CurrentValue = 16, 
    Flag = "UserSpeed", 
    Callback = function(Value) 
        speed = Value 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
            LocalPlayer.Character.Humanoid.WalkSpeed = Value 
        end 
    end 
}) 
 
PlayerTab:CreateToggle({ 
    Name = "Infinite Jump (Stable)", 
    CurrentValue = false, 
    Flag = "IJ", 
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
                antiOCSprayHumanoidConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() 
                    if antiOCSprayEnabled and humanoid.WalkSpeed < defaultWalkSpeed then 
                        humanoid.WalkSpeed = defaultWalkSpeed 
                    end 
                end) 
                antiOCSprayHumanoidConnection2 = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function() 
                    if antiOCSprayEnabled and humanoid.JumpPower < defaultJumpPower then 
                        humanoid.JumpPower = defaultJumpPower 
                    end 
                end) 
            end 
            antiOCSprayGuiConnection = LocalPlayer.PlayerGui.ChildAdded:Connect(function(gui) 
                if antiOCSprayEnabled and gui:IsA("ScreenGui") and (gui.Name:lower():find("pepper") or gui.Name:lower():find("spray") or gui.Name:lower():find("ocspray")) then 
                    gui.Enabled = false 
                end 
            end) 
            antiOCSprayEffectConnection = game:GetService("Lighting").ChildAdded:Connect(function(effect) 
                if antiOCSprayEnabled and (effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect")) then 
                    effect.Enabled = false 
                end 
            end) 
            antiOCSprayToolConnection = LocalPlayer.Backpack.ChildAdded:Connect(function(child) 
                if antiOCSprayEnabled and child.Name == "OC Spray" then 
                    local localScript = child:FindFirstChild("LocalScript") 
                    if localScript then localScript.Disabled = true end 
                end 
            end) 
            Rayfield:Notify({ Title = "Enabled", Content = "Anti OC Spray enabled.", Duration = 5, Image = 4483362458 }) 
        else 
            if antiOCSprayHumanoidConnection then antiOCSprayHumanoidConnection:Disconnect() end 
            if antiOCSprayHumanoidConnection2 then antiOCSprayHumanoidConnection2:Disconnect() end 
            if antiOCSprayGuiConnection then antiOCSprayGuiConnection:Disconnect() end 
            if antiOCSprayEffectConnection then antiOCSprayEffectConnection:Disconnect() end 
            if antiOCSprayToolConnection then antiOCSprayToolConnection:Disconnect() end 
            Rayfield:Notify({ Title = "Disabled", Content = "Anti OC Spray disabled.", Duration = 5, Image = 4483362458 }) 
        end 
    end 
}) 
 
PlayerTab:CreateToggle({ 
    Name = "Lock Jump Button", 
    CurrentValue = true, 
    Flag = "Lock_Jump_Button", 
    Callback = function(Value) 
        antiOCSprayEnabled = Value 
        if antiOCSprayEnabled then 
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") 
            if humanoid then 
                local defaultWalkSpeed = humanoid.WalkSpeed 
                local defaultJumpPower = humanoid.JumpPower or 25 
                antiOCSprayHumanoidConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() 
                    if antiOCSprayEnabled and humanoid.WalkSpeed < defaultWalkSpeed then 
                        humanoid.WalkSpeed = defaultWalkSpeed 
                    end 
                end) 
                antiOCSprayHumanoidConnection2 = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function() 
                    if antiOCSprayEnabled and humanoid.JumpPower < defaultJumpPower then 
                        humanoid.JumpPower = defaultJumpPower 
                    end 
                end) 
            end 
            antiOCSprayGuiConnection = LocalPlayer.PlayerGui.ChildAdded:Connect(function(gui) 
                if antiOCSprayEnabled and gui:IsA("ScreenGui") and (gui.Name:lower():find("pepper") or gui.Name:lower():find("spray") or gui.Name:lower():find("ocspray")) then 
                    gui.Enabled = false 
                end 
            end) 
            antiOCSprayEffectConnection = game:GetService("Lighting").ChildAdded:Connect(function(effect) 
                if antiOCSprayEnabled and (effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect")) then 
                    effect.Enabled = false 
                end 
            end) 
            antiOCSprayToolConnection = LocalPlayer.Backpack.ChildAdded:Connect(function(child) 
                if antiOCSprayEnabled and child.Name == "OC Spray" then 
                    local localScript = child:FindFirstChild("LocalScript") 
                    if localScript then localScript.Disabled = true end 
                end 
            end) 
            Rayfield:Notify({ Title = "Enabled", Content = "Anti OC Spray enabled.", Duration = 5, Image = 4483362458 }) 
        else 
            if antiOCSprayHumanoidConnection then antiOCSprayHumanoidConnection:Disconnect() end 
            if antiOCSprayHumanoidConnection2 then antiOCSprayHumanoidConnection2:Disconnect() end 
            if antiOCSprayGuiConnection then antiOCSprayGuiConnection:Disconnect() end 
            if antiOCSprayEffectConnection then antiOCSprayEffectConnection:Disconnect() end 
            if antiOCSprayToolConnection then antiOCSprayToolConnection:Disconnect() end 
            Rayfield:Notify({ Title = "Disabled", Content = "Anti OC Spray disabled.", Duration = 5, Image = 4483362458 }) 
        end 
    end 
}) 
 
PlayerTab:CreateToggle({ 
    Name = "Anti Taze/Stun", 
    CurrentValue = false, 
    Flag = "ANTI_ARREST", 
    Callback = function(Value) 
        antiArrestEnabled = Value 
        local cuffsScript = LocalPlayer.PlayerScripts:FindFirstChild("CuffsLocal") 
        if not cuffsScript then 
            Rayfield:Notify({ Title = "Warning", Content = "CuffsLocal script not found. Game structure may have changed.", Duration = 5, Image = 4483362458 }) 
            return 
        end 
        if antiArrestEnabled and cuffsScript then 
            originalCuffsState = cuffsScript.Disabled 
            cuffsScript.Disabled = true 
            antiArrestConnection = cuffsScript.AncestryChanged:Connect(function() 
                if antiArrestEnabled and cuffsScript.Parent then 
                    cuffsScript.Disabled = true 
                end 
            end) 
            Rayfield:Notify({ Title = "Enabled", Content = "Anti Taze/Stun enabled (CuffsLocal disabled).", Duration = 5, Image = 4483362458 }) 
        elseif not antiArrestEnabled and cuffsScript then 
            if antiArrestConnection then antiArrestConnection:Disconnect(); antiArrestConnection = nil end 
            cuffsScript.Disabled = originalCuffsState 
            Rayfield:Notify({ Title = "Disabled", Content = "Anti Taze/Stun disabled.", Duration = 5, Image = 4483362458 }) 
        end 
    end 
}) 
 
PlayerTab:CreateToggle({ 
    Name = "Anti Arrest/Cuffs", 
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
            Rayfield:Notify({ Title = "Enabled", Content = "Anti Arrest/Cuffs enabled.", Duration = 5, Image = 4483362458 }) 
        else 
            if antiTazeHumanoidConnection then antiTazeHumanoidConnection:Disconnect() end 
            if antiTazeHumanoidConnection2 then antiTazeHumanoidConnection2:Disconnect() end 
            if antiTazeGuiConnection then antiTazeGuiConnection:Disconnect() end 
            if antiTazeEffectConnection then antiTazeEffectConnection:Disconnect() end 
            if antiTazeToolConnection then antiTazeToolConnection:Disconnect() end 
            Rayfield:Notify({ Title = "Disabled", Content = "Anti Arrest/Cuffs disabled.", Duration = 5, Image = 4483362458 }) 
        end 
    end 
}) 
 
-- Fake Run Variable (Auto Anti-Cuff Freeze)
local fakerun = false
local isCuffed = false
local cuffDebounceTime = 0
local DEBOUNCE_TIME = 3  -- ثواني بدون محاولات كلبشة عشان يتقفل تلقائي

-- إنشاء الـ Toggle و حفظ الـ reference عشان التحكم التلقائي
local antiCuffToggle = PlayerTab:CreateToggle({
    Name = "Anti-Cuff Freeze",
    CurrentValue = false,
    Flag = "AntiCuffFreeze",
    Callback = function(Value)
        fakerun = Value  -- يدعم التحكم اليدوي كمان
    end
})

-- دالة تحديث حالة الكلبشة والـ toggle
local function updateCuffState(cuffed)
    isCuffed = cuffed
    fakerun = cuffed
    antiCuffToggle:Set(cuffed)  -- يحدث الزر في الـ UI ويفعل الـ callback
end

-- مراقبة إضافة الكفوف على الأطراف
local function monitorLimbs(character)
    local limbs = {"Left Arm", "Right Arm"}
    for _, limbName in ipairs(limbs) do
        local limb = character:FindFirstChild(limbName)
        if limb then
            limb.ChildAdded:Connect(function(child)
                if child.Name:lower():match("cuff") or child.Name:lower():match("handcuff") then
                    print("🛑 كلبشني! (Guard handcuffed me)")
                    cuffDebounceTime = tick() + DEBOUNCE_TIME
                    updateCuffState(true)
                end
            end)
        end
    end
end

-- لوب لفحص انتهاء الـ debounce (فك تلقائي)
spawn(function()
    while true do
        wait(0.5)
        if tick() > cuffDebounceTime and isCuffed then
            print("✅ فك الكلبشة! (Handcuffs released / Guard left)")
            updateCuffState(false)
        end
    end
end)

-- تطبيق على الشخصية الحالية
local LocalPlayer = game:GetService("Players").LocalPlayer
if LocalPlayer.Character then
    monitorLimbs(LocalPlayer.Character)
end

-- عند الـ respawn
LocalPlayer.CharacterAdded:Connect(monitorLimbs)

-- Anti-Cuff Freeze Function (كما هو)
local RunService = game:GetService("RunService")
local function RunRenderFakeRun()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if fakerun then
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.Anchored = true
    else
        root.Anchored = false
    end
end
RunService.RenderStepped:Connect(RunRenderFakeRun)

-- Unlock First Person or Third Person Toggle
PlayerTab:CreateButton({
    Name = "Unlock First Person or Third Person",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local isUnlocked = false

        if not isUnlocked then
            player.CameraMaxZoomDistance = 99999
            player.CameraMode = Enum.CameraMode.Classic
            isUnlocked = true
            Rayfield:Notify({ Title = "Activated", Content = "Camera unlocked for First/Third Person!", Duration = 3, Image = 4483362458 })
        else
            player.CameraMaxZoomDistance = 400 -- Default max zoom distance
            player.CameraMode = Enum.CameraMode.LockFirstPerson -- Reset to default or game-specific mode
            isUnlocked = false
            Rayfield:Notify({ Title = "Deactivated", Content = "Camera reverted to default!", Duration = 3, Image = 4483362458 })
        end
    end
})
 
-- Server Lag Variables
local serverLagEnabled = false
local serverLagConnection = nil
local lagIntensity = 500  -- Default intensity, controlled by slider

-- // MISC SECTION  
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateToggle({  
    Name = "Server Lag (Toggle Off to Stop)",  
    CurrentValue = false,  
    Flag = "SERVER_LAG",  
    Callback = function(Value)  
        serverLagEnabled = Value  
        if serverLagEnabled then  
            serverLagConnection = game:GetService("RunService").RenderStepped:Connect(function()  -- RenderStepped for max speed (~60+ FPS)  
                for i = 1, lagIntensity do  
                    -- High-load Part spam  
                    local part = Instance.new("Part")  
                    part.Name = "LagPart" .. i  
                    part.Parent = workspace  
                    part.Anchored = true  
                    part.CanCollide = false  
                    part.Size = Vector3.new(0.05, 0.05, 0.05)  
                    part.Transparency = 1  
                    part.Material = Enum.Material.ForceField  
                    part.CFrame = CFrame.new(  
                        math.random(-2000, 2000),  
                        math.random(0, 2000),  
                        math.random(-2000, 2000)  
                    )  
                    
                    -- Extra load: Explosion spam (physics simulation, affects all players server-side)  
                    local exp = Instance.new("Explosion")  
                    exp.Position = part.Position  
                    exp.BlastRadius = 0  -- No damage  
                    exp.BlastPressure = 0  
                    exp.Parent = workspace  
                    
                    -- Quick cleanup to prevent total crash but keep spam pressure  
                    game:GetService("Debris"):AddItem(part, 0.05)  
                    game:GetService("Debris"):AddItem(exp, 0.05)  
                end  
            end)  
            Rayfield:Notify({  
                Title = "Enabled",  
                Content = "Server Lag Started! Affects ALL players. Adjust Intensity & Toggle OFF to stop.",  
                Duration = 5,  
                Image = 4483362458  
            })  
        else  
            if serverLagConnection then  
                serverLagConnection:Disconnect()  
                serverLagConnection = nil  
            end  
            Rayfield:Notify({  
                Title = "Disabled",  
                Content = "Server Lag Stopped Safely.",  
                Duration = 3,  
                Image = 4483362458  
            })  
        end  
    end  
})

MiscTab:CreateSlider({  
    Name = "Lag Intensity",  
    Range = {100, 5000},  -- High range for max power  
    Increment = 100,  
    Suffix = "/frame",  
    CurrentValue = 500,  
    Flag = "LAG_INTENSITY",  
    Callback = function(Value)  
        lagIntensity = Value  
        Rayfield:Notify({  
            Title = "Intensity Updated",  
            Content = "Lag power set to " .. Value .. "/frame (Higher = Stronger Lag for ALL players)",  
            Duration = 3,  
            Image = 4483362458  
        })  
    end  
})  
  
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
