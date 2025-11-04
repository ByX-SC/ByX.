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
        Title = "Valley Prison ByX pc - mob? v2.5.1 NOV 25", 
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
 
-- // قسم القتال (Combat Tab)
local CombatTab = Window:CreateTab("قتال", 4483362458)

-- متغيرات الـ Silent Aim والـ Aimbot
local silentAimEnabled = false
local aimbotEnabled = false
local fovCircleVisible = true  -- للتحكم في ظهور الدائرة
local normalFOV = 100  -- حجم FOV العادي
local minFOV = 50  -- حجم FOV الصغير عند التصويب على العدو
local currentFOV = normalFOV
local dynamicFOVEnabled = false
local dynamicSmoothness = 0.1  -- سلاسة تحول حجم الدائرة (0-1)
local aimbotSmoothness = 0.2  -- سلاسة الـ Aimbot (0-1)
local aimKey = Enum.KeyCode.Q  -- الاختصار الافتراضي للتشغيل/إيقاف

-- إنشاء دائرة FOV التي تتبع الماوس
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 100
fovCircle.Radius = normalFOV
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.ZIndex = 999
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)

-- دالة للحصول على أقرب عدو داخل FOV حول الماوس
local function getClosestEnemy()
    local closest = nil
    local minDist = currentFOV
    local mousePos = Vector2.new(Mouse.X, Mouse.Y + 36)  -- تعديل لـ GUI inset
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- هوك لـ Silent Aim باستخدام metatable لتعديل mouse.Hit
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
    if silentAimEnabled and self == Mouse and key == "Hit" then
        local target = getClosestEnemy()
        if target then
            return target.Character.Head.CFrame  -- يجعل الرصاصات تصيب الرأس دائمًا
        end
    end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

-- تحديث الدائرة والـ Dynamic FOV والـ Aimbot في كل إطار
RunService.RenderStepped:Connect(function()
    if silentAimEnabled then
        -- تحديث موقع الدائرة لتتبع الماوس
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        fovCircle.Visible = fovCircleVisible
        
        -- Dynamic FOV
        if dynamicFOVEnabled then
            local targetRadius = getClosestEnemy() and minFOV or normalFOV
            currentFOV = math.lerp(currentFOV, targetRadius, dynamicSmoothness)
            fovCircle.Radius = currentFOV
        else
            currentFOV = normalFOV
            fovCircle.Radius = currentFOV
        end
        
        -- Aimbot (تحريك الكاميرا بسلاسة)
        if aimbotEnabled then
            local target = getClosestEnemy()
            if target then
                local targetPos = target.Character.Head.Position
                local newCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, aimbotSmoothness)
            end
        end
    else
        fovCircle.Visible = false
    end
end)

-- عناصر الـ UI بالعربي
CombatTab:CreateToggle({
    Name = "تشغيل الصامت ايم",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(Value)
        silentAimEnabled = Value
        if Value then
            Rayfield:Notify({ Title = "تم التشغيل", Content = "الصامت ايم مفعل الآن.", Duration = 3, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "تم الإيقاف", Content = "الصامت ايم معطل الآن.", Duration = 3, Image = 4483362458 })
        end
    end
})

CombatTab:CreateToggle({
    Name = "تشغيل الايم بوت (سلس)",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        aimbotEnabled = Value
        if Value then
            Rayfield:Notify({ Title = "تم التشغيل", Content = "الايم بوت مفعل الآن مع سلاسة.", Duration = 3, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "تم الإيقاف", Content = "الايم بوت معطل الآن.", Duration = 3, Image = 4483362458 })
        end
    end
})

CombatTab:CreateSlider({
    Name = "حجم FOV العادي",
    Range = {0, 500},
    Increment = 1,
    Suffix = "بكسل",
    CurrentValue = 100,
    Flag = "NormalFOV",
    Callback = function(Value)
        normalFOV = Value
        if not dynamicFOVEnabled then
            currentFOV = Value
            fovCircle.Radius = currentFOV
        end
    end
})

CombatTab:CreateToggle({
    Name = "تشغيل ديناميك FOV",
    CurrentValue = false,
    Flag = "DynamicFOV",
    Callback = function(Value)
        dynamicFOVEnabled = Value
    end
})

CombatTab:CreateSlider({
    Name = "حجم FOV الصغير",
    Range = {0, 500},
    Increment = 1,
    Suffix = "بكسل",
    CurrentValue = 50,
    Flag = "MinFOV",
    Callback = function(Value)
        minFOV = Value
    end
})

CombatTab:CreateSlider({
    Name = "سلاسة تحول الدائرة",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.1,
    Flag = "DynamicSmooth",
    Callback = function(Value)
        dynamicSmoothness = Value
    end
})

CombatTab:CreateSlider({
    Name = "سلاسة الايم",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.2,
    Flag = "AimbotSmooth",
    Callback = function(Value)
        aimbotSmoothness = Value
    end
})

CombatTab:CreateKeybind({
    Name = "اختصار تشغيل/إيقاف الصامت ايم",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "AimKey",
    Callback = function(Keybind)
        silentAimEnabled = not silentAimEnabled
        if silentAimEnabled then
            Rayfield:Notify({ Title = "تم التشغيل", Content = "الصامت ايم مفعل عبر الاختصار.", Duration = 3, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "تم الإيقاف", Content = "الصامت ايم معطل عبر الاختصار.", Duration = 3, Image = 4483362458 })
        end
    end
})

CombatTab:CreateToggle({
    Name = "إظهار دائرة FOV",
    CurrentValue = true,
    Flag = "FOVCircleVisible",
    Callback = function(Value)
        fovCircleVisible = Value
    end
})

print("✅ Script loaded successfully!")
