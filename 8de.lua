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
  
local VisualsTab = Window:CreateTab("Visuals", 4483362458) -- You can change the image ID if needed

-- ESP Section (Global)
local ESPSection = VisualsTab:CreateSection("Global ESP")

ESPSection:CreateToggle({
   Name = "Use Bounding Box",
   CurrentValue = getgenv().esp.UseBoundingBox,
   Callback = function(Value)
      getgenv().esp.UseBoundingBox = Value
   end
})

ESPSection:CreateToggle({
   Name = "Box Enabled",
   CurrentValue = getgenv().esp.BoxEnabled,
   Callback = function(Value)
      getgenv().esp.BoxEnabled = Value
   end
})

ESPSection:CreateColorPicker({
   Name = "Box Color",
   Color = getgenv().esp.BoxColor,
   Callback = function(Color)
      getgenv().esp.BoxColor = Color
   end
})

ESPSection:CreateToggle({
   Name = "Box Corners",
   CurrentValue = getgenv().esp.BoxCorners,
   Callback = function(Value)
      getgenv().esp.BoxCorners = Value
   end
})

ESPSection:CreateToggle({
   Name = "Box Dynamic",
   CurrentValue = getgenv().esp.BoxDynamic,
   Callback = function(Value)
      getgenv().esp.BoxDynamic = Value
   end
})

ESPSection:CreateSlider({
   Name = "Box Width",
   Range = {0.1, 3},
   Increment = 0.01,
   Suffix = "X",
   CurrentValue = getgenv().esp.BoxStaticXFactor,
   Callback = function(Value)
      getgenv().esp.BoxStaticXFactor = Value
   end
})

ESPSection:CreateSlider({
   Name = "Box Height",
   Range = {0.1, 3},
   Increment = 0.01,
   Suffix = "Y",
   CurrentValue = getgenv().esp.BoxStaticYFactor,
   Callback = function(Value)
      getgenv().esp.BoxStaticYFactor = Value
   end
})

ESPSection:CreateToggle({
   Name = "Skeleton Enabled",
   CurrentValue = getgenv().esp.SkeletonEnabled,
   Callback = function(Value)
      getgenv().esp.SkeletonEnabled = Value
   end
})

ESPSection:CreateColorPicker({
   Name = "Skeleton Color",
   Color = getgenv().esp.SkeletonColor,
   Callback = function(Color)
      getgenv().esp.SkeletonColor = Color
   end
})

ESPSection:CreateSlider({
   Name = "Skeleton Max Distance",
   Range = {100, 1000},
   Increment = 1,
   Suffix = "m",
   CurrentValue = getgenv().esp.SkeletonMaxDistance,
   Callback = function(Value)
      getgenv().esp.SkeletonMaxDistance = Value
   end
})

ESPSection:CreateToggle({
   Name = "Chams Enabled",
   CurrentValue = getgenv().esp.ChamsEnabled,
   Callback = function(Value)
      getgenv().esp.ChamsEnabled = Value
   end
})

ESPSection:CreateColorPicker({
   Name = "Chams Inner Color",
   Color = getgenv().esp.ChamsInnerColor,
   Callback = function(Color)
      getgenv().esp.ChamsInnerColor = Color
   end
})

ESPSection:CreateColorPicker({
   Name = "Chams Outer Color",
   Color = getgenv().esp.ChamsOuterColor,
   Callback = function(Color)
      getgenv().esp.ChamsOuterColor = Color
   end
})

ESPSection:CreateSlider({
   Name = "Chams Inner Transparency",
   Range = {0, 1},
   Increment = 0.01,
   CurrentValue = getgenv().esp.ChamsInnerTransparency,
   Callback = function(Value)
      getgenv().esp.ChamsInnerTransparency = Value
   end
})

ESPSection:CreateSlider({
   Name = "Chams Outer Transparency",
   Range = {0, 1},
   Increment = 0.01,
   CurrentValue = getgenv().esp.ChamsOuterTransparency,
   Callback = function(Value)
      getgenv().esp.ChamsOuterTransparency = Value
   end
})

ESPSection:CreateToggle({
   Name = "Text Enabled",
   CurrentValue = getgenv().esp.TextEnabled,
   Callback = function(Value)
      getgenv().esp.TextEnabled = Value
   end
})

ESPSection:CreateColorPicker({
   Name = "Text Color",
   Color = getgenv().esp.TextColor,
   Callback = function(Color)
      getgenv().esp.TextColor = Color
   end
})

ESPSection:CreateToggle({
   Name = "Health Bar Enabled",
   CurrentValue = getgenv().esp.BarLayout['health'].enabled,
   Callback = function(Value)
      getgenv().esp.BarLayout['health'].enabled = Value
   end
})

ESPSection:CreateToggle({
   Name = "Target Only Mode",
   CurrentValue = getgenv().esp.TargetOnly,
   Callback = function(Value)
      getgenv().esp.TargetOnly = Value
   end
})

-- Bullet Trails Section
local BulletSection = VisualsTab:CreateSection("Bullets")

BulletSection:CreateToggle({
   Name = "Enable",
   CurrentValue = Configurations.Visuals.Bullet_Trails.Enabled,
   Callback = function(Value)
      Configurations.Visuals.Bullet_Trails.Enabled = Value
   end
})

BulletSection:CreateColorPicker({
   Name = "Color",
   Color = Configurations.Visuals.Bullet_Trails.Color,
   Callback = function(Color)
      Configurations.Visuals.Bullet_Trails.Color = Color
   end
})

BulletSection:CreateToggle({
   Name = "Fade",
   CurrentValue = Configurations.Visuals.Bullet_Trails.Fade,
   Callback = function(Value)
      Configurations.Visuals.Bullet_Trails.Fade = Value
   end
})

BulletSection:CreateSlider({
   Name = "Size",
   Range = {0.01, 5},
   Increment = 0.01,
   Suffix = "%",
   CurrentValue = Configurations.Visuals.Bullet_Trails.Width,
   Callback = function(Value)
      Configurations.Visuals.Bullet_Trails.Width = Value
   end
})

BulletSection:CreateSlider({
   Name = "Duration",
   Range = {0.01, 10},
   Increment = 0.01,
   Suffix = "%",
   CurrentValue = Configurations.Visuals.Bullet_Trails.Duration,
   Callback = function(Value)
      Configurations.Visuals.Bullet_Trails.Duration = Value
   end
})

BulletSection:CreateDropdown({
   Name = "Texture",
   Options = {"Cool", "Cum", "Electro", "None"},
   CurrentOption = "Cool",
   Callback = function(Option)
      Configurations.Visuals.Bullet_Trails.Texture = Option
   end
})

-- Crosshair Section
local CrosshairSection = VisualsTab:CreateSection("Crosshair")

CrosshairSection:CreateToggle({
   Name = "Enable",
   CurrentValue = getgenv().crosshair.enabled,
   Callback = function(Value)
      getgenv().crosshair.enabled = Value
   end
})

CrosshairSection:CreateColorPicker({
   Name = "Color",
   Color = getgenv().crosshair.color,
   Callback = function(Color)
      getgenv().crosshair.color = Color
   end
})

CrosshairSection:CreateToggle({
   Name = "Spin",
   CurrentValue = getgenv().crosshair.spin,
   Callback = function(Value)
      getgenv().crosshair.spin = Value
   end
})

CrosshairSection:CreateToggle({
   Name = "Resize",
   CurrentValue = getgenv().crosshair.resize,
   Callback = function(Value)
      getgenv().crosshair.resize = Value
   end
})

CrosshairSection:CreateToggle({
   Name = "Stick To Target",
   CurrentValue = getgenv().crosshair.sticky,
   Callback = function(Value)
      getgenv().crosshair.sticky = Value
   end
})

CrosshairSection:CreateDropdown({
   Name = "Position",
   Options = {"Middle", "Mouse"},
   CurrentOption = "Middle",
   Callback = function(Option)
      crosshair_position = Option
   end
})

-- Local Player Section (Sig2)
local LocalPlayerSection = VisualsTab:CreateSection("Local Player")

getgenv().TrailColor = Color3.fromRGB(255, 255, 255)

LocalPlayerSection:CreateToggle({
   Name = "Trail",
   CurrentValue = false,
   Callback = function(Value)
      utility = utility or {}

      local Settings = {
         Visuals = {
            SelfESP = {
               Trail = {
                  InsideColor = getgenv().TrailColor,
                  OutsideColor = getgenv().TrailColor,
                  LifeTime = 5,
                  Width = 0.08
               }
            }
         }
      }

      utility.trail_character = function(Bool)
         local player = game.Players.LocalPlayer

         -- Clean up existing trail first
         if trailObjects.trailPart then
            trailObjects.trailPart:Destroy()
            trailObjects.trailPart = nil
         end
         if trailObjects.renderConnection then
            trailObjects.renderConnection:Disconnect()
            trailObjects.renderConnection = nil
         end
         if trailObjects.characterConnection then
            trailObjects.characterConnection:Disconnect()
            trailObjects.characterConnection = nil
         end

         if Bool then
            local function createTrail(character)
               if trailObjects.trailPart then
                  trailObjects.trailPart:Destroy()
                  trailObjects.trailPart = nil
               end
               if trailObjects.renderConnection then
                  trailObjects.renderConnection:Disconnect()
                  trailObjects.renderConnection = nil
               end

               local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

               trailObjects.trailPart = Instance.new("Part")
               trailObjects.trailPart.Name = "TrailPart"
               trailObjects.trailPart.Size = Vector3.new(0.1, 0.1, 0.1)
               trailObjects.trailPart.Transparency = 1
               trailObjects.trailPart.Anchored = true
               trailObjects.trailPart.CanCollide = false
               trailObjects.trailPart.CFrame = humanoidRootPart.CFrame
               trailObjects.trailPart.Parent = workspace

               local trail = Instance.new("Trail", trailObjects.trailPart)
               trail.Name = "BlaBla"

               local attachment0 = Instance.new("Attachment", trailObjects.trailPart)
               attachment0.Position = Vector3.new(0, 1, 0)
               local attachment1 = Instance.new("Attachment", trailObjects.trailPart)
               attachment1.Position = Vector3.new(0, -1, 0)

               trail.Attachment0 = attachment0
               trail.Attachment1 = attachment1

               trail.Lifetime = Settings.Visuals.SelfESP.Trail.LifeTime
               trail.Transparency = NumberSequence.new(0, 0)
               trail.LightEmission = 150
               trail.Brightness = 1500
               trail.LightInfluence = 1
               trail.WidthScale = NumberSequence.new(Settings.Visuals.SelfESP.Trail.Width)

               trailObjects.renderConnection = game:GetService("RunService").RenderStepped:Connect(function()
                  trail.Color = ColorSequence.new({
                     ColorSequenceKeypoint.new(0, getgenv().TrailColor),
                     ColorSequenceKeypoint.new(1, getgenv().TrailColor)
                  })

                  if humanoidRootPart and humanoidRootPart.Parent then
                     trailObjects.trailPart.CFrame = humanoidRootPart.CFrame
                  else
                     if trailObjects.renderConnection then
                        trailObjects.renderConnection:Disconnect()
                        trailObjects.renderConnection = nil
                     end
                  end
               end)
            end

            local character = player.Character or player.CharacterAdded:Wait()
            createTrail(character)

            trailObjects.characterConnection = player.CharacterAdded:Connect(function(newCharacter)
               if Bool then
                  createTrail(newCharacter)
               end
            end)
         end
      end

      utility.trail_character(Value)
   end
})

LocalPlayerSection:CreateColorPicker({
   Name = "Color",
   Color = getgenv().TrailColor,
   Callback = function(Color)
      getgenv().TrailColor = Color
   end
})

-- Forcefield Setup (Local Player Chams, Gun Chams, etc.)
local localPlayerEsp = {
   ForcefieldBody = {
      Enabled = false,
      Color = Rayfield.Accent,
   },
   ForcefieldTools = {
      Enabled = false,
      Color = Rayfield.Accent,
   },
   ForcefieldHats = {
      Enabled = false,
      Color = Rayfield.Accent,
   }
}

function applyForcefieldToParts(parts, isEnabled, color)
   for _, part in pairs(parts) do
      if part:IsA("BasePart") then
         if isEnabled then
            part.Material = Enum.Material.ForceField
            part.Color = color
         else
            part.Material = Enum.Material.Plastic
         end
      end
   end
end

function applyForcefieldToBody()
   local character = game.Players.LocalPlayer.Character
   if character then
      applyForcefieldToParts(character:GetChildren(), localPlayerEsp.ForcefieldBody.Enabled, localPlayerEsp.ForcefieldBody.Color)
   end
end

function applyForcefieldToTools()
   local backpack = game.Players.LocalPlayer.Backpack
   for _, tool in pairs(backpack:GetChildren()) do
      if tool:IsA("Tool") then
         applyForcefieldToParts(tool:GetChildren(), localPlayerEsp.ForcefieldTools.Enabled, localPlayerEsp.ForcefieldTools.Color)
      end
   end
end

function applyForcefieldToHats()
   local character = game.Players.LocalPlayer.Character
   if character then
      for _, accessory in pairs(character:GetChildren()) do
         if accessory:IsA("Accessory") then
            applyForcefieldToParts(accessory:GetChildren(), localPlayerEsp.ForcefieldHats.Enabled, localPlayerEsp.ForcefieldHats.Color)
         end
      end
   end
end

function onCharacterAdded(character)
   character:WaitForChild("HumanoidRootPart")
   applyForcefieldToBody()
   applyForcefieldToTools()
   applyForcefieldToHats()
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
   onCharacterAdded(game.Players.LocalPlayer.Character)
end

LocalPlayerSection:CreateToggle({
   Name = "Self Cham",
   CurrentValue = localPlayerEsp.ForcefieldBody.Enabled,
   Callback = function(Value)
      localPlayerEsp.ForcefieldBody.Enabled = Value
      applyForcefieldToBody()
   end
})

LocalPlayerSection:CreateColorPicker({
   Name = "Color",
   Color = localPlayerEsp.ForcefieldBody.Color,
   Callback = function(Color)
      localPlayerEsp.ForcefieldBody.Color = Color
      applyForcefieldToBody()
   end
})

LocalPlayerSection:CreateToggle({
   Name = "Gun Chams",
   CurrentValue = localPlayerEsp.ForcefieldTools.Enabled,
   Callback = function(Value)
      localPlayerEsp.ForcefieldTools.Enabled = Value
      applyForcefieldToTools()
   end
})

LocalPlayerSection:CreateColorPicker({
   Name = "Color gun",
   Color = localPlayerEsp.ForcefieldTools.Color,
   Callback = function(Color)
      localPlayerEsp.ForcefieldTools.Color = Color
      applyForcefieldToTools()
   end
})

LocalPlayerSection:CreateToggle({
   Name = "Accessories Chams",
   CurrentValue = localPlayerEsp.ForcefieldHats.Enabled,
   Callback = function(Value)
      localPlayerEsp.ForcefieldHats.Enabled = Value
      applyForcefieldToHats()
   end
})

LocalPlayerSection:CreateColorPicker({
   Name = "Color1",
   Color = localPlayerEsp.ForcefieldHats.Color,
   Callback = function(Color)
      localPlayerEsp.ForcefieldHats.Color = Color
      applyForcefieldToHats()
   end
})

-- Target Visual Section
local TargetVisualSection = VisualsTab:CreateSection("Target")

TargetVisualSection:CreateToggle({
   Name = "Highlight",
   CurrentValue = Highlight,
   Callback = function(Value)
      Highlight = Value
   end
})

TargetVisualSection:CreateToggle({
   Name = "Animate Highlight",
   CurrentValue = AChams,
   Callback = function(Value)
      AChams = Value
   end
})

TargetVisualSection:CreateColorPicker({
   Name = "Color",
   Color = TargetAimbot.HighlightColor1,
   Callback = function(Color)
      TargetAimbot.HighlightColor1 = Color
   end
})

TargetVisualSection:CreateColorPicker({
   Name = "Color2",
   Color = TargetAimbot.HighlightColor2,
   Callback = function(Color)
      TargetAimbot.HighlightColor2 = Color
   end
})

-- Environment Section (Sig3)
local EnvironmentTab = Window:CreateTab("Environment", 4483362458)

local EnvironmentSection = EnvironmentTab:CreateSection("Environment")

EnvironmentSection:CreateToggle({
   Name = "Enable",
   CurrentValue = Environment.Settings.Enabled,
   Callback = function(Value)
      Environment.Settings.Enabled = Value
      UpdateWorld()
   end
})

EnvironmentSection:CreateToggle({
   Name = "Global Shadow",
   CurrentValue = Environment.Settings.GlobalShadows,
   Callback = function(Value)
      Environment.Settings.GlobalShadows = Value
      UpdateWorld()
   end
})

EnvironmentSection:CreateInput({
   Name = "Exposure",
   PlaceholderText = Environment.Settings.Exposure,
   Callback = function(Input)
      Environment.Settings.Exposure = tonumber(Input)
      UpdateWorld()
   end
})

EnvironmentSection:CreateColorPicker({
   Name = "Color Shift",
   Color = Environment.Settings.ColorShift_Bottom,
   Callback = function(Color)
      Environment.Settings.ColorShift_Bottom = Color
      UpdateWorld()
   end
})

EnvironmentSection:CreateColorPicker({
   Name = "Top",
   Color = Environment.Settings.ColorShift_Top,
   Callback = function(Color)
      Environment.Settings.ColorShift_Top = Color
      UpdateWorld()
   end
})

EnvironmentSection:CreateInput({
   Name = "Clock Time",
   PlaceholderText = Environment.Settings.ClockTime,
   Callback = function(Input)
      Environment.Settings.ClockTime = tonumber(Input)
      UpdateWorld()
   end
})

EnvironmentSection:CreateColorPicker({
   Name = "Ambient Color",
   Color = Environment.Settings.Ambient,
   Callback = function(Color)
      Environment.Settings.Ambient = Color
      UpdateWorld()
   end
})

EnvironmentSection:CreateColorPicker({
   Name = "OutdoorAmbient Color",
   Color = Environment.Settings.OutdoorAmbient,
   Callback = function(Color)
      Environment.Settings.OutdoorAmbient = Color
      UpdateWorld()
   end
})

EnvironmentSection:CreateInput({
   Name = "Brightness",
   PlaceholderText = Environment.Settings.Brightness,
   Callback = function(Input)
      Environment.Settings.Brightness = tonumber(Input)
      UpdateWorld()
   end
})

-- Skybox Section
local SkyboxSection = EnvironmentTab:CreateSection("SkyBox")

SkyboxSection:CreateToggle({
   Name = "Skybox Enabled",
   CurrentValue = skyboxEnabled,
   Callback = function(Value)
      skyboxEnabled = Value
      changeSkybox()
   end
})

SkyboxSection:CreateDropdown({
   Name = "Skybox Type",
   Options = {"1", "2", "3", "4", "5", "6", "7"},
   CurrentOption = "1",
   Callback = function(Option)
      skyboxType = tonumber(Option)
      changeSkybox()
   end
})

SkyboxSection:CreateButton({
   Name = "Change",
   Callback = function()
      changeSkybox()
   end
})

-- Fog Section
local FogSection = EnvironmentTab:CreateSection("Fog")

FogSection:CreateToggle({
   Name = "Fog Enabled",
   CurrentValue = Environment.Settings.FogEnabled,
   Callback = function(Value)
      Environment.Settings.FogEnabled = Value
      fogmaker()
   end
})

FogSection:CreateColorPicker({
   Name = "Fog Color",
   Color = Environment.Settings.FogColor,
   Callback = function(Color)
      Environment.Settings.FogColor = Color
      fogmaker()
   end
})

FogSection:CreateInput({
   Name = "Fog Start",
   PlaceholderText = Environment.Settings.FogStart,
   Callback = function(Input)
      Environment.Settings.FogStart = tonumber(Input)
      fogmaker()
   end
})

FogSection:CreateInput({
   Name = "Fog End",
   PlaceholderText = Environment.Settings.FogEnd,
   Callback = function(Input)
      Environment.Settings.FogEnd = tonumber(Input)
      fogmaker()
   end
})
  
-- // COMBAT SECTION  
local CombatTab = Window:CreateTab("Combat", 4483362458)  
  
local AimbotEnabled = false  
local SilentAim = false  
local DesyncEnabled = false  
local PredictionEnabled = false  
local BulletSpeed = 1000  
local FOVEnabled = false  
local DefaultFOV = Camera.FieldOfView  
local CustomFOV = 90  
local FOVCircle = nil  
local FOVRadius = 150  
local Smoothness = 0.15  
local HumanizationFactor = 0.2  
local ShowFOVCircle = true  
local StickToTarget = false  
local IgnoreWalls = false  
local CurrentTarget = nil  
local TargetPart = "Head"  
local killAllEnabled = false  
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

-- إضافات جديدة للتخصيص الأكثر دقة
local OffsetSpread = 1.0  -- Slider لـ Offset Spread (0-5 studs)
local PredictionMultiplier = 1.0  -- Slider لـ Prediction Multiplier (0.5-2)
local AimMovingTargetsOnly = false  -- Toggle لـ Aim at Moving Targets Only
local VelocityThreshold = 5  -- Slider لـ Velocity Threshold (للـ moving targets)
local AutoSwitchOnKill = false  -- Toggle لـ Auto-Switch Target on Kill
local TargetPriority = "Closest"  -- Dropdown لـ Target Priority ("Closest", "Lowest Health", "Highest Threat")
local TriggerbotEnabled = false  -- Toggle لـ Triggerbot
local TriggerDelay = 100  -- Slider لـ Trigger Delay (0-500 ms)
local AntiRecoilEnabled = false  -- Toggle لـ Anti-Recoil
local RecoilFactor = 0.5  -- Slider لـ Recoil Factor (0-1)
local ScanMode = "Fixed"  -- Dropdown لـ Scan Mode ("Fixed", "Dynamic")
local DynamicFOV = false  -- Toggle لـ Dynamic FOV
local MinFOVRadius = 50  -- Slider لـ Min FOV Radius
local MaxFOVRadius = 300  -- Slider لـ Max FOV Radius
local DynamicFOVMultiplier = 0.1  -- Slider لـ Dynamic FOV Multiplier (بناءً على distance)
local EnableStats = false  -- Toggle لـ Enable Stats
local Stats = { Kills = 0, Misses = 0 }  -- Table لتخزين الـ stats
local NoMissBullets = false  -- ميزة جديدة: No Miss Bullets (تضمن إصابة كل الرصاص)
local BulletMagnetStrength = 0.5  -- Slider لـ Bullet Magnet Strength (0-1, قوة جذب الرصاص نحو الهدف)

-- New: Moving FOV circle
local movingFOVCircleEnabled = false

-- New: Weapon Check for Aim Bot
local weaponCheckEnabled = false

-- New: Smart Aim Bot
local smartAimBotEnabled = false

-- New: Closest Aim
local closestAimEnabled = false

-- New: Aim on Sight / Approach / Face to Face
local AimOnSight = false  -- Aim if in line of sight
local AimOnApproach = false  -- Aim if approaching
local AimFaceToFace = false  -- Aim if face to face

-- New: Advanced Accuracy Controls
local HitChanceVariance = 0  -- Slider for hit chance variance (0-50%)
local AimPrecision = 100  -- Slider for aim precision (0-100%)
local TargetLockStrength = 0.5  -- Slider for target lock strength (0-1)

-- دالة Humanization Factor لإضافة عشوائية للتصويب
local function ApplyHumanization(position)
    local randomOffset = Vector3.new(
        math.random(-HumanizationFactor, HumanizationFactor),
        math.random(-HumanizationFactor, HumanizationFactor),
        math.random(-HumanizationFactor, HumanizationFactor)
    )
    return position + randomOffset
end

-- دالة Prediction مُحدثة مع Ping وGravity وMultiplier
local function GetPredictedPosition(targetPart)
    if not targetPart then return Vector3.zero end 
    local basePos = targetPart.Position
    if PredictionEnabled then
        local velocity = targetPart.AssemblyLinearVelocity
        local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
        local timeToHit = (distance / BulletSpeed) * PredictionMultiplier
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        timeToHit = timeToHit + ping
        local gravity = Vector3.new(0, workspace.Gravity * timeToHit^2 / 2, 0)
        basePos = targetPart.Position + (velocity * timeToHit) + gravity
    end
    local spread = (100 - AimAccuracy) / 100 * OffsetSpread  -- استخدام OffsetSpread الجديد
    local offset = Vector3.new(
        math.random(-spread, spread),
        math.random(-spread, spread),
        math.random(-spread, spread)
    )
    local predictedPos = basePos + offset
    if NoMissBullets then
        -- ميزة No Miss Bullets: جذب الرصاص نحو الهدف لتقليل الـ misses
        local diff = (targetPart.Position - predictedPos)
        if diff.Magnitude > 0 then
            local magnetOffset = diff.Unit * BulletMagnetStrength
            predictedPos = predictedPos + magnetOffset
        end
    end
    return ApplyHumanization(predictedPos) -- إضافة Humanization
end 

-- دالة جديدة لـ GetBestVisiblePart (للـ Dynamic Scan)
local function GetBestVisiblePart(player)
    local parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
    for _, partName in ipairs(parts) do
        local part = player.Character:FindFirstChild(partName)
        if part and IsVisible(player, partName) then
            return part
        end
    end
    return nil
end

-- تعديل IsVisible لدعم partName
local function IsVisible(player, partName)
    if not player or not player.Character or not player.Character:FindFirstChild(partName) then return false end 
    if IgnoreWalls then return true end 
    local params = RaycastParams.new() 
    params.FilterType = Enum.RaycastFilterType.Exclude 
    params.FilterDescendantsInstances = {LocalPlayer.Character} 
    local ray = workspace:Raycast(Camera.CFrame.Position, (player.Character[partName].Position - Camera.CFrame.Position).Unit * 1000, params) 
    return ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) 
end 

local function CreateFOVCircle() 
    if FOVCircle then FOVCircle:Remove() end 
    FOVCircle = Drawing.new("Circle") 
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) 
    FOVCircle.Radius = FOVRadius 
    FOVCircle.Color = Color3.new(math.random(), math.random(), math.random())  -- Random color on creation
    FOVCircle.Thickness = 2 
    FOVCircle.Filled = false 
    FOVCircle.Visible = (AimbotEnabled or killAllAimbotEnabled) and ShowFOVCircle 
end 

local function UpdateFOVCircle() 
    if FOVCircle then 
        if movingFOVCircleEnabled then
            FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)  -- Follow mouse
            FOVCircle.Radius = FOVRadius
            FOVCircle.Color = FOVColor
        else
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) 
            local currentRadius = FOVRadius
            if DynamicFOV and CurrentTarget then
                local distance = (Camera.CFrame.Position - CurrentTarget.Character[TargetPart].Position).Magnitude
                currentRadius = math.clamp(MinFOVRadius + (distance * DynamicFOVMultiplier), MinFOVRadius, MaxFOVRadius)
            end
            FOVCircle.Radius = currentRadius 
            FOVCircle.Color = FOVColor 
        end
        FOVCircle.Visible = (AimbotEnabled or killAllAimbotEnabled) and ShowFOVCircle 
    end 
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
    local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(player) or player.Character:FindFirstChild(TargetPart)
    if AimMovingTargetsOnly and targetPart then
        local velocity = targetPart.AssemblyLinearVelocity.Magnitude
        if velocity < VelocityThreshold then return false end
    end
    -- Additional checks for AimOnSight, AimOnApproach, AimFaceToFace
    if AimOnSight then
        -- Check if in line of sight
        if not IsVisible(player, TargetPart) then return false end
    end
    if AimOnApproach then
        -- Check if approaching (velocity towards player)
        local direction = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Unit
        if targetPart.AssemblyLinearVelocity:Dot(direction) > 0 then return false end  -- If dot product positive, not approaching
    end
    if AimFaceToFace then
        -- Check if facing each other
        local myFacing = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
        local targetFacing = player.Character.HumanoidRootPart.CFrame.LookVector
        if myFacing:Dot(targetFacing) < -0.5 then return false end  -- If dot negative and low, facing each other
    end
    return player.Character and targetPart and humanoid and IsVisible(player, targetPart.Name) 
end 

-- تعديل GetClosestPlayerInFOV لدعم TargetPriority
local function GetBestTarget() 
    local bestPlayer, bestScore = nil, math.huge
    local center = movingFOVCircleEnabled and Vector2.new(Mouse.X, Mouse.Y) or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) 
    for _, player in pairs(Players:GetPlayers()) do 
        if IsValidTarget(player) then 
            local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(player) or player.Character[TargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position) 
            if onScreen then 
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude 
                if distance > FOVRadius then continue end  -- Ensure within FOV circle
                local score = distance
                if TargetPriority == "Lowest Health" then
                    score = player.Character.Humanoid.Health
                elseif TargetPriority == "Highest Threat" then
                    score = -distance  -- أقرب = أعلى تهديد (negative for max)
                end
                if score < bestScore then 
                    bestPlayer = player 
                    bestScore = score 
                end 
            end 
        end 
    end 
    return bestPlayer 
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
        if SilentAim and (AimbotEnabled or killAllAimbotEnabled) and CurrentTarget and CurrentTarget.Character then 
            local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(CurrentTarget) or CurrentTarget.Character:FindFirstChild(TargetPart)
            if targetPart then
                local predictedPos = GetPredictedPosition(targetPart) 
                if index == "Hit" then 
                    return CFrame.new(predictedPos) 
                elseif index == "Target" then 
                    return targetPart 
                end 
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
        if killAllAimbotEnabled and CurrentTarget and CurrentTarget.Character then 
            local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(CurrentTarget) or CurrentTarget.Character:FindFirstChild(TargetPart)
            if targetPart then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, GetPredictedPosition(targetPart)) 
            end
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

-- دالة جديدة لـ CalculateHitChance (للـ stats)
local function CalculateHitChance(target)
    if not target then return 0 end
    local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(target) or target.Character[TargetPart]
    local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
    return math.clamp(100 - (distance / BulletSpeed * (100 - AimAccuracy) / 100), 0, 100)
end

-- مراقبة الكيلز للـ stats و Auto-Switch
local killMonitorConnection = nil
local function EnableKillMonitor()
    if killMonitorConnection then return end
    killMonitorConnection = RunService.Heartbeat:Connect(function()
        if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character.Humanoid then
            if CurrentTarget.Character.Humanoid.Health <= 0 then
                if EnableStats then
                    Stats.Kills = Stats.Kills + 1
                    Rayfield:Notify({ Title = "Stats", Content = "Kills: " .. Stats.Kills .. " | Misses: " .. Stats.Misses, Duration = 3 })
                end
                if AutoSwitchOnKill then
                    CurrentTarget = GetBestTarget()
                end
            end
        end
    end)
end

local function DisableKillMonitor()
    if killMonitorConnection then killMonitorConnection:Disconnect(); killMonitorConnection = nil end
end

RunService.RenderStepped:Connect(function() 
    if AimbotEnabled or SilentAim then 
        CurrentTarget = StickToTarget and CurrentTarget and IsValidTarget(CurrentTarget) and CurrentTarget or GetBestTarget() 
        if SilentAim and not CurrentTarget and not hasNotifiedNoTarget then 
            Rayfield:Notify({ Title = "Silent Aim", Content = "No valid target found in FOV!", Duration = 2, Image = 4483362458 }) 
            hasNotifiedNoTarget = true 
        elseif CurrentTarget then 
            hasNotifiedNoTarget = false 
        end 
    end 
    UpdateFOV() 
    UpdateFOVCircle()
    
    -- Triggerbot Logic
    if TriggerbotEnabled and CurrentTarget and Mouse.Target and Mouse.Target:IsDescendantOf(CurrentTarget.Character) then
        wait(TriggerDelay / 1000)
        -- افترض أن لديك دالة fire، أو استخدم mouse1press إذا متاح
        -- mouse1press()  -- uncomment إذا كان exploit يدعم
        if EnableStats then
            if math.random(100) > CalculateHitChance(CurrentTarget) then
                Stats.Misses = Stats.Misses + 1
            end
        end
    end
    
    -- Anti-Recoil Logic (في الـ camera lerp)
    if AntiRecoilEnabled and AimbotEnabled and CurrentTarget then
        -- افترض equipped weapon، أضف vertical offset
        local recoilOffset = Vector3.new(0, RecoilFactor, 0)
        Camera.CFrame = Camera.CFrame * CFrame.new(recoilOffset)
    end
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
            EnableKillMonitor()
            aimbotConnection = RunService.RenderStepped:Connect(function() 
                UpdateFOVCircle() 
                if AimbotEnabled then 
                    CurrentTarget = StickToTarget and CurrentTarget and IsValidTarget(CurrentTarget) and CurrentTarget or GetBestTarget() 
                    if not SilentAim and CurrentTarget and CurrentTarget.Character then 
                        local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(CurrentTarget) or CurrentTarget.Character:FindFirstChild(TargetPart)
                        if targetPart then
                            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, GetPredictedPosition(targetPart)), Smoothness) 
                        end
                    end 
                end 
            end) 
        else 
            if aimbotConnection then 
                aimbotConnection:Disconnect() 
                aimbotConnection = nil 
            end 
            DisableKillMonitor()
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
    Range = {0.01, 1.0}, 
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
    Range = {30, 360}, 
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
    Callback = function(Value) AimAccuracy = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Hit Chance Variance", 
    Range = {0, 50}, 
    Increment = 1, 
    Suffix = "%", 
    CurrentValue = 0, 
    Flag = "HIT_CHANCE_VARIANCE", 
    Callback = function(Value) HitChanceVariance = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Aim Precision", 
    Range = {0, 100}, 
    Increment = 1, 
    Suffix = "%", 
    CurrentValue = 100, 
    Flag = "AIM_PRECISION", 
    Callback = function(Value) AimPrecision = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Target Lock Strength", 
    Range = {0, 1}, 
    Increment = 0.1, 
    CurrentValue = 0.5, 
    Flag = "TARGET_LOCK_STRENGTH", 
    Callback = function(Value) TargetLockStrength = Value end 
})

CombatTab:CreateToggle({ 
    Name = "Aim on Sight", 
    CurrentValue = false, 
    Flag = "AIM_ON_SIGHT", 
    Callback = function(Value) AimOnSight = Value end 
})

CombatTab:CreateToggle({ 
    Name = "Aim on Approach", 
    CurrentValue = false, 
    Flag = "AIM_ON_APPROACH", 
    Callback = function(Value) AimOnApproach = Value end 
})

CombatTab:CreateToggle({ 
    Name = "Aim Face to Face", 
    CurrentValue = false, 
    Flag = "AIM_FACE_TO_FACE", 
    Callback = function(Value) AimFaceToFace = Value end 
})

-- إضافات جديدة للـ UI

CombatTab:CreateSlider({ 
    Name = "Offset Spread (studs)", 
    Range = {0, 5}, 
    Increment = 0.1, 
    CurrentValue = 1.0, 
    Flag = "OFFSET_SPREAD", 
    Callback = function(Value) OffsetSpread = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Prediction Multiplier", 
    Range = {0.5, 2}, 
    Increment = 0.1, 
    CurrentValue = 1.0, 
    Flag = "PRED_MULTIPLIER", 
    Callback = function(Value) PredictionMultiplier = Value end 
})

CombatTab:CreateToggle({ 
    Name = "Aim Moving Targets Only", 
    CurrentValue = false, 
    Flag = "AIM_MOVING_ONLY", 
    Callback = function(Value) AimMovingTargetsOnly = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Velocity Threshold", 
    Range = {1, 20}, 
    Increment = 1, 
    CurrentValue = 5, 
    Flag = "VEL_THRESHOLD", 
    Callback = function(Value) VelocityThreshold = Value end 
})

CombatTab:CreateToggle({ 
    Name = "Auto-Switch on Kill", 
    CurrentValue = false, 
    Flag = "AUTO_SWITCH_KILL", 
    Callback = function(Value) AutoSwitchOnKill = Value end 
})

CombatTab:CreateDropdown({ 
    Name = "Target Priority", 
    Options = {"Closest", "Lowest Health", "Highest Threat"}, 
    CurrentOption = {"Closest"}, 
    MultipleOptions = false, 
    Flag = "TARGET_PRIORITY", 
    Callback = function(Option) TargetPriority = Option[1] end 
})

CombatTab:CreateToggle({ 
    Name = "Enable Triggerbot", 
    CurrentValue = false, 
    Flag = "TRIGGERBOT", 
    Callback = function(Value) TriggerbotEnabled = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Trigger Delay (ms)", 
    Range = {0, 500}, 
    Increment = 50, 
    CurrentValue = 100, 
    Flag = "TRIGGER_DELAY", 
    Callback = function(Value) TriggerDelay = Value end 
})

CombatTab:CreateToggle({ 
    Name = "Anti-Recoil", 
    CurrentValue = false, 
    Flag = "ANTI_RECOIL", 
    Callback = function(Value) AntiRecoilEnabled = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Recoil Factor", 
    Range = {0, 1}, 
    Increment = 0.1, 
    CurrentValue = 0.5, 
    Flag = "RECOIL_FACTOR", 
    Callback = function(Value) RecoilFactor = Value end 
})

CombatTab:CreateDropdown({ 
    Name = "Scan Mode", 
    Options = {"Fixed", "Dynamic"}, 
    CurrentOption = {"Fixed"}, 
    MultipleOptions = false, 
    Flag = "SCAN_MODE", 
    Callback = function(Option) ScanMode = Option[1] end 
})

CombatTab:CreateToggle({ 
    Name = "Dynamic FOV", 
    CurrentValue = false, 
    Flag = "DYNAMIC_FOV", 
    Callback = function(Value) DynamicFOV = Value; UpdateFOVCircle() end 
})

CombatTab:CreateSlider({ 
    Name = "Min FOV Radius", 
    Range = {10, 200}, 
    Increment = 10, 
    CurrentValue = 50, 
    Flag = "MIN_FOV_RADIUS", 
    Callback = function(Value) MinFOVRadius = Value; UpdateFOVCircle() end 
})

CombatTab:CreateSlider({ 
    Name = "Max FOV Radius", 
    Range = {100, 500}, 
    Increment = 10, 
    CurrentValue = 300, 
    Flag = "MAX_FOV_RADIUS", 
    Callback = function(Value) MaxFOVRadius = Value; UpdateFOVCircle() end 
})

CombatTab:CreateSlider({ 
    Name = "Dynamic FOV Multiplier", 
    Range = {0.01, 0.5}, 
    Increment = 0.01, 
    CurrentValue = 0.1, 
    Flag = "DYN_FOV_MULT", 
    Callback = function(Value) DynamicFOVMultiplier = Value; UpdateFOVCircle() end 
})

CombatTab:CreateToggle({ 
    Name = "Enable Stats", 
    CurrentValue = false, 
    Flag = "ENABLE_STATS", 
    Callback = function(Value) EnableStats = Value end 
}) 

-- ميزة جديدة: No Miss Bullets
CombatTab:CreateToggle({ 
    Name = "No Miss Bullets", 
    CurrentValue = false, 
    Flag = "NO_MISS_BULLETS", 
    Callback = function(Value) NoMissBullets = Value end 
})

CombatTab:CreateSlider({ 
    Name = "Bullet Magnet Strength", 
    Range = {0, 1}, 
    Increment = 0.1, 
    CurrentValue = 0.5, 
    Flag = "BULLET_MAGNET", 
    Callback = function(Value) BulletMagnetStrength = Value end 
})

CombatTab:CreateToggle({ 
    Name = "Moving FOV Circle", 
    CurrentValue = false, 
    Flag = "MOVING_FOV_CIRCLE", 
    Callback = function(Value) movingFOVCircleEnabled = Value; UpdateFOVCircle() end 
})

-- New: Weapon Check
CombatTab:CreateToggle({ 
    Name = "Weapon Check", 
    CurrentValue = false, 
    Flag = "WEAPON_CHECK", 
    Callback = function(Value) 
        weaponCheckEnabled = Value 
        if Value then 
            connections.weaponCheck = RunService.Heartbeat:Connect(function() 
                local char = LocalPlayer.Character 
                if char then 
                    local tool = char:FindFirstChildOfClass("Tool") 
                    AimbotEnabled = tool ~= nil 
                else 
                    AimbotEnabled = false 
                end 
                -- إذا لم يكن هناك tool، أوقف الـ aimbot كاملاً كأنه disabled
                if not AimbotEnabled then
                    if aimbotConnection then 
                        aimbotConnection:Disconnect() 
                        aimbotConnection = nil 
                    end 
                    if FOVCircle then FOVCircle:Remove() FOVCircle = nil end 
                    DisableSilentAim() 
                end
            end) 
        else 
            if connections.weaponCheck then connections.weaponCheck:Disconnect() end 
            AimbotEnabled = false  -- Reset if disabled
        end 
    end 
})

-- New: Smart Aim Bot
CombatTab:CreateToggle({ 
    Name = "Smart Aim Bot", 
    CurrentValue = false, 
    Flag = "SMART_AIM", 
    Callback = function(Value) 
        smartAimBotEnabled = Value 
        if Value then 
            closestAimEnabled = false  -- Disable Closest if Smart is enabled
            aimbotConnection = RunService.Heartbeat:Connect(function() 
                if smartAimBotEnabled then 
                    CurrentTarget = GetBestTarget()  -- Use advanced selection
                    if CurrentTarget and CurrentTarget.Character then 
                        local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(CurrentTarget) or CurrentTarget.Character:FindFirstChild(TargetPart)
                        if targetPart then
                            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, GetPredictedPosition(targetPart)), Smoothness) 
                        end
                    end 
                end 
            end) 
        else 
            if aimbotConnection then aimbotConnection:Disconnect() end 
        end 
    end 
})

-- New: Closest Aim
CombatTab:CreateToggle({ 
    Name = "Closest Aim", 
    CurrentValue = false, 
    Flag = "CLOSEST_AIM", 
    Callback = function(Value) 
        closestAimEnabled = Value 
        if Value then 
            smartAimBotEnabled = false  -- Disable Smart if Closest is enabled
            aimbotConnection = RunService.Heartbeat:Connect(function() 
                if closestAimEnabled then 
                    CurrentTarget = GetBestTarget()  -- Use closest only
                    if CurrentTarget and CurrentTarget.Character then 
                        local targetPart = (ScanMode == "Dynamic") and GetBestVisiblePart(CurrentTarget) or CurrentTarget.Character:FindFirstChild(TargetPart)
                        if targetPart then
                            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, GetPredictedPosition(targetPart)), Smoothness) 
                        end
                    end 
                end 
            end) 
        else 
            if aimbotConnection then aimbotConnection:Disconnect() end 
        end 
    end 
})
  
-- // TELEPORT SECTION  
local TeleportTab = Window:CreateTab("Teleports", 4483362458)  

-- General Teleports Section  
TeleportTab:CreateLabel("General Teleports")  

local generalLocations = {  
    "Maintenance", "Security", "OC Lockers", "RIOT Lockers", "Ventilation", "Maximum", "Generator", "Outside", "Escape Base", "Escape"  
}  

local generalCfValues = {  
    CFrame.new(172.34, 23.10, -143.87),  
    CFrame.new(224.47, 23.10, -167.90),  
    CFrame.new(137.60, 23.10, -169.93),  
    CFrame.new(165.63, 23.10, -192.25),  
    CFrame.new(76.96, -7.02, -19.21),  
    CFrame.new(99.85, -8.87, -156.13),  
    CFrame.new(100.95, -8.82, -57.59),  
    CFrame.new(350.22, 5.40, -171.09),  
    CFrame.new(749.02, -0.97, -470.45),  
    CFrame.new(307.06, 5.40, -177.88)  
}  

TeleportTab:CreateDropdown({  
    Name = "Select Location",  
    Options = generalLocations,  
    CurrentOption = {},  
    MultipleOptions = false,  
    Flag = "GENERAL_TELEPORT_DROPDOWN",  
    Callback = function(Option)  
        local selected = Option[1]  
        local index = table.find(generalLocations, selected)  
        if index then  
            LocalPlayer.Character:PivotTo(generalCfValues[index])  
        end  
    end  
})  

-- Item Teleports Section  
TeleportTab:CreateLabel("Item Teleports")  

TeleportTab:CreateButton({  
    Name = "Get a Gun",  
    Callback = function()  
        -- Add your get a gun script here  
    end  
})  

TeleportTab:CreateButton({  
    Name = "Keycard",  
    Callback = function()  
        -- Add your keycard script here  
    end  
})  

-- Gun Spawner Section  
TeleportTab:CreateLabel("Gun Spawner (Locations)")  

local gunOptions = {"max", "min", "booking"}  

TeleportTab:CreateDropdown({  
    Name = "Select Locations",  
    Options = gunOptions,  
    CurrentOption = {},  
    MultipleOptions = false,  
    Flag = "GUN_DROPDOWN",  
    Callback = function(Option)  
        -- Optional: Handle selection if needed before spawn  
    end  
})  

TeleportTab:CreateButton({  
    Name = "Spawn Gun",  
    Callback = function()  
        local selected = Rayfield:GetFlag("GUN_DROPDOWN")  
        if selected and selected[1] then  
            -- Add your spawn gun script here based on selected[1]  
        else  
            Rayfield:Notify({ Title = "Error", Content = "No gun type selected!", Duration = 3, Image = 4483362458 })  
        end  
    end  
})  

-- Player Spawner Section  
TeleportTab:CreateLabel("Gun Spawner (Players)")  

local playerNames = {}  
for _, player in pairs(Players:GetPlayers()) do  
    table.insert(playerNames, player.Name)  
end  

TeleportTab:CreateDropdown({  
    Name = "Select Player",  
    Options = playerNames,  
    CurrentOption = {},  
    MultipleOptions = false,  
    Flag = "PLAYER_DROPDOWN",  
    Callback = function(Option)  
        -- Optional: Handle selection if needed  
    end  
})  

TeleportTab:CreateButton({  
    Name = "Spawn",  
    Callback = function()  
        local selected = Rayfield:GetFlag("PLAYER_DROPDOWN")  
        if selected and selected[1] then  
            -- Add your spawn for player script here based on selected[1]  
        else  
            Rayfield:Notify({ Title = "Error", Content = "No player selected!", Duration = 3, Image = 4483362458 })  
        end  
    end  
})     
  
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
  
-- Fake Run Variable  
local fakerun = false  
  
-- Fake Run Toggle  
PlayerTab:CreateToggle({  
    Name = "Anti-Cuff Freeze",  
    CurrentValue = false,  
    Flag = "AntiCuffFreeze",  
    Callback = function(Value)  
        fakerun = Value  
    end  
})  
  
-- Anti-Cuff Freeze Function  
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
  
-- // MISC SECTION  
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
