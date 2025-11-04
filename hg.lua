-- Roblox LocalScript
-- ضع هذا السكربت داخل StarterPlayer > StarterPlayerScripts (LocalScript)
-- وظيفة: دائرة متحركة مع الماوس + خيار تفعيل 'aim' داخل الدائرة

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- إعدادات قابلة للتعديل
local CIRCLE_RADIUS = 80 -- نصف القطر بالبكسل
local SMOOTHNESS = 0.25 -- 0 = لحظي ، 1 = بطيء جداً
local AIM_KEY = Enum.KeyCode.RightShift -- مفتاح تفعيل/ايقاف الaim
local ENABLE_TEAM_CHECK = true -- تعطيل/تفعيل فحص الفريق

-- Helper: معرفة أقرب هدف صالح
local function isValidTarget(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not root then return false end
    return true
end

local function getPlayersCharacters()
    local out = {}
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local char = pl.Character
            if char and isValidTarget(char) then
                table.insert(out, {player = pl, char = char})
            end
        end
    end
    return out
end

-- بناء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimCircleUI"
screenGui.ResetOnSpawn = true
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local circle = Instance.new("Frame")
circle.Name = "AimCircle"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Size = UDim2.new(0, CIRCLE_RADIUS * 2, 0, CIRCLE_RADIUS * 2)
circle.Position = UDim2.new(0, 100, 0, 100)
circle.BackgroundTransparency = 1
circle.Parent = screenGui

local outer = Instance.new("ImageLabel")
outer.Name = "Outer"
outer.Size = UDim2.new(1, 0, 1, 0)
outer.Position = UDim2.new(0, 0, 0, 0)
outer.BackgroundTransparency = 1
outer.Image = "rbxassetid://2032997629" -- دائرة جاهزة (يمكن تغييره)
outer.ScaleType = Enum.ScaleType.Slice
outer.SliceCenter = Rect.new(10, 10, 118, 118)
outer.Parent = circle
outer.ImageTransparency = 0.2

local fill = Instance.new("Frame")
fill.Name = "Fill"
fill.AnchorPoint = Vector2.new(0.5, 0.5)
fill.Size = UDim2.new(0, 6, 0, 6)
fill.Position = UDim2.new(0.5, 0.5, 0.5, 0)
fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fill.BackgroundTransparency = 0.2
fill.BorderSizePixel = 0
fill.Parent = circle

-- زر تشغيل / ايقاف بسيط
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(0, 120, 0, 34)
toggleBtn.Position = UDim2.new(0, 16, 0, 16)
toggleBtn.AnchorPoint = Vector2.new(0, 0)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Text = "Aim: OFF"
toggleBtn.Parent = screenGui

-- حالة التشغيل
local aimEnabled = false

local function toggleAim()
    aimEnabled = not aimEnabled
    toggleBtn.Text = aimEnabled and "Aim: ON" or "Aim: OFF"
end

toggleBtn.MouseButton1Click:Connect(toggleAim)

-- مفتاح سريع
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == AIM_KEY then
        toggleAim()
    end
end)

-- حركة الدائرة مع الماوس
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation() -- يعطي بكسلات الشاشة (x,y)
    -- تصحيح لوضع شريط القوائم أعلاه على بعض الشاشات
    local viewportOffsetY = 36 -- تقديري (يمكن تغييره لو احتجت)
    circle.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y - viewportOffsetY)
end)

-- دالة إيجاد أقرب لاعب داخل الدائرة (بناءً على المسافة على الشاشة)
local function findClosestTarget()
    local mousePos = UserInputService:GetMouseLocation()
    local best = nil
    local bestDist = math.huge
    for _, entry in ipairs(getPlayersCharacters()) do
        local char = entry.char
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if root then
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local dx = screenPos.X - mousePos.X
                local dy = screenPos.Y - (mousePos.Y - 36) -- نفس تصحيح الـY أعلاه
                local dist = math.sqrt(dx*dx + dy*dy)
                if dist <= CIRCLE_RADIUS then
                    if ENABLE_TEAM_CHECK then
                        local ok = true
                        pcall(function()
                            local pl = Players:GetPlayerFromCharacter(char)
                            if pl and pl.Team and LocalPlayer.Team and pl.Team == LocalPlayer.Team then
                                ok = false
                            end
                        end)
                        if not ok then continue end
                    end
                    if dist < bestDist then
                        bestDist = dist
                        best = entry
                    end
                end
            end
        end
    end
    return best
end

-- الدالة الأساسية للتوجيه (تعمل على كل فريم عند التفعيل)
RunService.RenderStepped:Connect(function(dt)
    if not aimEnabled then return end
    local targetEntry = findClosestTarget()
    if targetEntry then
        local targetRoot = targetEntry.char:FindFirstChild("HumanoidRootPart") or targetEntry.char:FindFirstChild("Torso") or targetEntry.char:FindFirstChild("UpperTorso")
        if targetRoot then
            local camPos = Camera.CFrame.Position
            local targetPos = targetRoot.Position
            local lookAt = CFrame.new(camPos, targetPos)
            -- مزج سلس بين الوضع الحالي والمطلوب
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, math.clamp(1 - math.exp(-SMOOTHNESS * 60 * dt), 0, 1))
        end
    end
end)

-- نصائح:
-- 1) هذا سكربت تعليمي بسيط؛ قد يحتاج تعديلات ليتناسب مع كل لعبة (أسماء الـParts، فرق التعامل، أو إزالة تأثر الكاميرا المسموح به).
-- 2) تعديل CIRCLE_RADIUS وSMOOTHNESS يعطيك سلوك مختلف (دقيق/حاد أو بطيء/نعم).
-- 3) تغيير "outer.Image" أو إزالة الصورة واستبدالها برسم UI آخر للحصول على شكل دائري مخصص.
-- 4) تجنب استخدامه في سيرفرات عامة أو ضد قوانين اللعبة.

print("AimCircleUI loaded")
