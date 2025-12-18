--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- أسود
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

--// Add white border for contrast
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(255, 255, 255)
border.Thickness = 2
border.Parent = mainFrame

--// Header Text
local sectionLabel = Instance.new("TextLabel")
sectionLabel.Size = UDim2.new(0.6,0,0,40)
sectionLabel.Position = UDim2.new(0.2,0,0,10)
sectionLabel.Text = "Home"
sectionLabel.TextColor3 = Color3.fromRGB(255,255,255)
sectionLabel.Font = Enum.Font.GothamBold
sectionLabel.TextSize = 24
sectionLabel.BackgroundTransparency = 1
sectionLabel.Parent = mainFrame

--// Separator Line under header
local separatorLine = Instance.new("Frame")
separatorLine.Size = UDim2.new(0.9, 0, 0, 2)
separatorLine.Position = UDim2.new(0.05, 0, 0, 50)
separatorLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
separatorLine.BorderSizePixel = 0
separatorLine.Parent = mainFrame

--// Arrows (white)
local leftArrow = Instance.new("TextButton")
leftArrow.Size = UDim2.new(0,30,0,30)
leftArrow.Position = UDim2.new(0,10,0,10)
leftArrow.Text = "<"
leftArrow.Font = Enum.Font.GothamBold
leftArrow.TextSize = 24
leftArrow.BackgroundTransparency = 1
leftArrow.TextColor3 = Color3.fromRGB(255,255,255) -- أبيض
leftArrow.Parent = mainFrame

local rightArrow = Instance.new("TextButton")
rightArrow.Size = UDim2.new(0,30,0,30)
rightArrow.Position = UDim2.new(1,-40,0,10)
rightArrow.Text = ">"
rightArrow.Font = Enum.Font.GothamBold
rightArrow.TextSize = 24
rightArrow.BackgroundTransparency = 1
rightArrow.TextColor3 = Color3.fromRGB(255,255,255) -- أبيض
rightArrow.Parent = mainFrame

--// Particle System for background animation
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = mainFrame

local particles = {}
local particleCount = 20

for i = 1, particleCount do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
    particle.Position = UDim2.new(0, math.random(0, 380), 0, math.random(0, 280))
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = 0.7
    particle.Parent = particleContainer
    
    -- Store particle data
    particles[i] = {
        object = particle,
        speedX = math.random(-50, 50) / 100,
        speedY = math.random(-50, 50) / 100,
        transparency = 0.7,
        transparencyDir = math.random() > 0.5 and 1 or -1
    }
end

--// Particle animation function
local function updateParticles(deltaTime)
    for _, particleData in ipairs(particles) do
        local particle = particleData.object
        local currentPos = particle.Position
        
        -- Update position
        local newX = currentPos.X.Offset + (particleData.speedX * 60 * deltaTime)
        local newY = currentPos.Y.Offset + (particleData.speedY * 60 * deltaTime)
        
        -- Bounce off edges
        if newX < 0 then
            newX = 0
            particleData.speedX = math.abs(particleData.speedX)
        elseif newX > 380 then
            newX = 380
            particleData.speedX = -math.abs(particleData.speedX)
        end
        
        if newY < 0 then
            newY = 0
            particleData.speedY = math.abs(particleData.speedY)
        elseif newY > 280 then
            newY = 280
            particleData.speedY = -math.abs(particleData.speedY)
        end
        
        particle.Position = UDim2.new(0, newX, 0, newY)
        
        -- Update transparency (fading effect)
        particleData.transparency = particleData.transparency + (particleData.transparencyDir * deltaTime * 0.5)
        
        if particleData.transparency > 0.8 then
            particleData.transparency = 0.8
            particleData.transparencyDir = -1
        elseif particleData.transparency < 0.3 then
            particleData.transparency = 0.3
            particleData.transparencyDir = 1
        end
        
        particle.BackgroundTransparency = particleData.transparency
    end
end

--// Connect particle animation to RenderStepped
RunService.RenderStepped:Connect(updateParticles)

--// Sections
local sections = {"Home", "Locations", "Players", "Teleport", "Player"}
local currentIndex = 1
local sectionFrames = {}

for i, name in ipairs(sections) do
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9,0,0.7,0)
    frame.Position = UDim2.new(0.05,0,0,80)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- خلفية سوداء للقطاعات
    frame.BackgroundTransparency = 0.8 -- شفافية لجعل الجسيمات مرئية
    frame.BorderSizePixel = 0
    frame.Visible = (i == currentIndex)
    frame.Name = name
    frame.Parent = mainFrame
    
    -- Add section separator line
    local sectionSeparator = Instance.new("Frame")
    sectionSeparator.Size = UDim2.new(1, 0, 0, 1)
    sectionSeparator.Position = UDim2.new(0, 0, 0, 35)
    sectionSeparator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sectionSeparator.BorderSizePixel = 0
    sectionSeparator.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,35)
    label.Position = UDim2.new(0,0,0,0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1,0,1,-35)
    contentLabel.Position = UDim2.new(0,0,0,35)
    contentLabel.Text = name.." Content"
    contentLabel.TextColor3 = Color3.fromRGB(200,200,255)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextSize = 16
    contentLabel.BackgroundTransparency = 1
    contentLabel.Parent = frame

    sectionFrames[i] = frame
end

--// Function to change section with animation
local function changeSection(newIndex, direction)
    if newIndex < 1 then newIndex = #sections end
    if newIndex > #sections then newIndex = 1 end
    
    local oldFrame = sectionFrames[currentIndex]
    local newFrame = sectionFrames[newIndex]
    
    local offset = (direction == "right") and 400 or -400
    
    local tweenOut = TweenService:Create(oldFrame, TweenInfo.new(0.3), {Position = oldFrame.Position + UDim2.new(0, -offset,0,0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        oldFrame.Visible = false
        oldFrame.Position = UDim2.new(0.05,0,0,80)
    end)
    
    newFrame.Position = UDim2.new(0.05, offset,0,80)
    newFrame.Visible = true
    local tweenIn = TweenService:Create(newFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.05,0,0,80)})
    tweenIn:Play()
    
    sectionLabel.Text = sections[newIndex]
    currentIndex = newIndex
end

--// Arrow Buttons
leftArrow.MouseButton1Click:Connect(function()
    changeSection(currentIndex-1,"left")
end)
rightArrow.MouseButton1Click:Connect(function()
    changeSection(currentIndex+1,"right")
end)
