--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 320)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

--// Rounded corners for main frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

--// Header Text
local sectionLabel = Instance.new("TextLabel")
sectionLabel.Size = UDim2.new(0.6, 0, 0, 40)
sectionLabel.Position = UDim2.new(0.2, 0, 0, 10)
sectionLabel.Text = "Home"
sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sectionLabel.Font = Enum.Font.GothamBold
sectionLabel.TextSize = 24
sectionLabel.BackgroundTransparency = 1
sectionLabel.Parent = mainFrame

--// Arrows
local leftArrow = Instance.new("TextButton")
leftArrow.Size = UDim2.new(0, 30, 0, 30)
leftArrow.Position = UDim2.new(0, 10, 0, 10)
leftArrow.Text = "<"
leftArrow.Font = Enum.Font.GothamBold
leftArrow.TextSize = 24
leftArrow.BackgroundTransparency = 1
leftArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
leftArrow.Parent = mainFrame

local rightArrow = Instance.new("TextButton")
rightArrow.Size = UDim2.new(0, 30, 0, 30)
rightArrow.Position = UDim2.new(1, -40, 0, 10)
rightArrow.Text = ">"
rightArrow.Font = Enum.Font.GothamBold
rightArrow.TextSize = 24
rightArrow.BackgroundTransparency = 1
rightArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
rightArrow.Parent = mainFrame

--// Particle System for background animation
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = mainFrame

local particles = {}
local particleCount = 15 -- أقل عدد من الجسيمات

for i = 1, particleCount do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 3), 0, math.random(2, 3)) -- أصغر حجم
    
    -- تحويل الجسيمات إلى دوائر
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0) -- دائرة كاملة
    particleCorner.Parent = particle
    
    particle.Position = UDim2.new(0, math.random(0, 390), 0, math.random(0, 310))
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = 0.8 -- أكثر شفافية
    particle.ZIndex = 0 -- خلف النص
    particle.Parent = particleContainer
    
    -- تخزين بيانات الجسيم
    particles[i] = {
        object = particle,
        speedX = (math.random(-20, 20) / 100), -- أبطأ حركة
        speedY = (math.random(-20, 20) / 100),
        transparency = 0.8,
        transparencyDir = math.random() > 0.5 and 1 or -1,
        size = math.random(2, 3)
    }
end

--// Particle animation function
local function updateParticles(deltaTime)
    for _, particleData in ipairs(particles) do
        local particle = particleData.object
        local currentPos = particle.Position
        
        -- تحديث الموضع بسرعة أبطأ
        local newX = currentPos.X.Offset + (particleData.speedX * 30 * deltaTime)
        local newY = currentPos.Y.Offset + (particleData.speedY * 30 * deltaTime)
        
        -- الارتداد من الحواف
        if newX < 0 then
            newX = 0
            particleData.speedX = math.abs(particleData.speedX)
        elseif newX > 390 then
            newX = 390
            particleData.speedX = -math.abs(particleData.speedX)
        end
        
        if newY < 0 then
            newY = 0
            particleData.speedY = math.abs(particleData.speedY)
        elseif newY > 310 then
            newY = 310
            particleData.speedY = -math.abs(particleData.speedY)
        end
        
        particle.Position = UDim2.new(0, newX, 0, newY)
        
        -- تحديث الشفافية (تأثير التلاشي البطيء)
        particleData.transparency = particleData.transparency + (particleData.transparencyDir * deltaTime * 0.3) -- أبطأ
        
        if particleData.transparency > 0.9 then
            particleData.transparency = 0.9
            particleData.transparencyDir = -1
        elseif particleData.transparency < 0.5 then
            particleData.transparency = 0.5
            particleData.transparencyDir = 1
        end
        
        particle.BackgroundTransparency = particleData.transparency
    end
end

--// ربط حركة الجسيمات بـ RenderStepped
RunService.RenderStepped:Connect(updateParticles)

--// Sections
local sections = {"Home", "Locations", "Players", "Teleport", "Player"}
local currentIndex = 1
local sectionFrames = {}

--// الحصول على اسم الماب (اللعبة)
local gameName = "Unknown Game"
local success, result = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

if success then
    gameName = result
end

for i, name in ipairs(sections) do
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0.75, 0)
    frame.Position = UDim2.new(0.05, 0, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- رمادي غامق بدلاً من الأسود
    frame.BackgroundTransparency = 0.3 -- شفافية أقل
    frame.BorderSizePixel = 0
    frame.Visible = (i == currentIndex)
    frame.Name = name
    
    -- إضافة حواف مستديرة للإطار
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    frame.Parent = mainFrame
    
    -- إنشاء محتوى مختلف لكل قسم
    if name == "Player" then
        -- قسم خاص للاعب مع صورة البروفايل
        local playerInfoContainer = Instance.new("Frame")
        playerInfoContainer.Size = UDim2.new(1, 0, 0, 100)
        playerInfoContainer.Position = UDim2.new(0, 0, 0, 10)
        playerInfoContainer.BackgroundTransparency = 1
        playerInfoContainer.Parent = frame
        
        -- صورة البروفايل
        local avatarFrame = Instance.new("Frame")
        avatarFrame.Size = UDim2.new(0, 80, 0, 80)
        avatarFrame.Position = UDim2.new(0, 20, 0, 0)
        avatarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        avatarFrame.BorderSizePixel = 0
        
        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(0, 12)
        avatarCorner.Parent = avatarFrame
        
        -- إضافة صورة البروفايل
        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Size = UDim2.new(1, 0, 1, 0)
        avatarImage.Position = UDim2.new(0, 0, 0, 0)
        avatarImage.BackgroundTransparency = 1
        
        -- الحصول على صورة البروفايل
        local userId = player.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        
        pcall(function()
            local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
            if content then
                avatarImage.Image = content
            else
                avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            end
        end)
        
        avatarImage.Parent = avatarFrame
        avatarFrame.Parent = playerInfoContainer
        
        -- معلومات اللاعب على يمين الصورة
        local infoFrame = Instance.new("Frame")
        infoFrame.Size = UDim2.new(0, 240, 0, 80)
        infoFrame.Position = UDim2.new(0, 110, 0, 0)
        infoFrame.BackgroundTransparency = 1
        infoFrame.Parent = playerInfoContainer
        
        -- اسم اللاعب
        local playerNameLabel = Instance.new("TextLabel")
        playerNameLabel.Size = UDim2.new(1, 0, 0, 30)
        playerNameLabel.Position = UDim2.new(0, 0, 0, 0)
        playerNameLabel.Text = player.Name
        playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerNameLabel.Font = Enum.Font.GothamBold
        playerNameLabel.TextSize = 18
        playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        playerNameLabel.BackgroundTransparency = 1
        playerNameLabel.Parent = infoFrame
        
        -- فاصل |
        local separator = Instance.new("TextLabel")
        separator.Size = UDim2.new(1, 0, 0, 20)
        separator.Position = UDim2.new(0, 0, 0, 30)
        separator.Text = "|"
        separator.TextColor3 = Color3.fromRGB(150, 150, 150)
        separator.Font = Enum.Font.Gotham
        separator.TextSize = 14
        separator.TextXAlignment = Enum.TextXAlignment.Left
        separator.BackgroundTransparency = 1
        separator.Parent = infoFrame
        
        -- اسم الماب
        local gameNameLabel = Instance.new("TextLabel")
        gameNameLabel.Size = UDim2.new(1, 0, 0, 30)
        gameNameLabel.Position = UDim2.new(0, 0, 0, 50)
        gameNameLabel.Text = "In: " .. gameName
        gameNameLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        gameNameLabel.Font = Enum.Font.Gotham
        gameNameLabel.TextSize = 14
        gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        gameNameLabel.BackgroundTransparency = 1
        gameNameLabel.Parent = infoFrame
        
        -- معلومات إضافية
        local statsFrame = Instance.new("Frame")
        statsFrame.Size = UDim2.new(1, -40, 0, 100)
        statsFrame.Position = UDim2.new(0, 20, 0, 110)
        statsFrame.BackgroundTransparency = 1
        statsFrame.Parent = frame
        
        local statsLabel = Instance.new("TextLabel")
        statsLabel.Size = UDim2.new(1, 0, 1, 0)
        statsLabel.Text = "Player Stats:\nLevel: 1\nExperience: 0/100\nCoins: 0"
        statsLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        statsLabel.Font = Enum.Font.Gotham
        statsLabel.TextSize = 14
        statsLabel.TextXAlignment = Enum.TextXAlignment.Left
        statsLabel.TextYAlignment = Enum.TextYAlignment.Top
        statsLabel.BackgroundTransparency = 1
        statsLabel.Parent = statsFrame
    else
        -- المحتوى العادي للأقسام الأخرى
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 40)
        label.Position = UDim2.new(0, 0, 0, 10)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        -- خط فاصل تحت العنوان
        local titleSeparator = Instance.new("Frame")
        titleSeparator.Size = UDim2.new(0.8, 0, 0, 1)
        titleSeparator.Position = UDim2.new(0.1, 0, 0, 50)
        titleSeparator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        titleSeparator.BorderSizePixel = 0
        titleSeparator.Parent = frame
        
        -- محتوى القسم
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -40, 1, -80)
        contentLabel.Position = UDim2.new(0, 20, 0, 70)
        contentLabel.Text = name .. " Content Area\n\nThis section contains\n" .. name .. " related features."
        contentLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.TextSize = 16
        contentLabel.TextXAlignment = Enum.TextXAlignment.Center
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
        contentLabel.BackgroundTransparency = 1
        contentLabel.Parent = frame
    end
    
    sectionFrames[i] = frame
end

--// Function to change section with animation
local function changeSection(newIndex, direction)
    if newIndex < 1 then
        newIndex = #sections
    end
    if newIndex > #sections then
        newIndex = 1
    end
    
    local oldFrame = sectionFrames[currentIndex]
    local newFrame = sectionFrames[newIndex]
    
    local offset = (direction == "right") and 400 or -400
    
    local tweenOut = TweenService:Create(oldFrame, TweenInfo.new(0.3), {
        Position = oldFrame.Position + UDim2.new(0, -offset, 0, 0)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        oldFrame.Visible = false
        oldFrame.Position = UDim2.new(0.05, 0, 0, 80)
    end)
    
    newFrame.Position = UDim2.new(0.05, offset, 0, 80)
    newFrame.Visible = true
    local tweenIn = TweenService:Create(newFrame, TweenInfo.new(0.3), {
        Position = UDim2.new(0.05, 0, 0, 80)
    })
    tweenIn:Play()
    
    sectionLabel.Text = sections[newIndex]
    currentIndex = newIndex
end

--// Arrow Buttons
leftArrow.MouseButton1Click:Connect(function()
    changeSection(currentIndex - 1, "left")
end)

rightArrow.MouseButton1Click:Connect(function()
    changeSection(currentIndex + 1, "right")
end)
