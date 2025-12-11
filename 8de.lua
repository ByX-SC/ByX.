-- Psalms.Tech - سكريبت Roblox Executor كامل مع دعم universal aimbot لجميع المابات
-- تم تعديل الـ aimbot ليكون عامًا عبر hook للـ remotes الشائعة (shoot/fire/gun/main)
-- الواجهة باللغة العربية، مع الحفاظ على الهيكل الأصلي والاستقرار
-- متوافق مع getgenv، hookmetamethod، وجميع executors (Synapse/Krnl/إلخ)

local function cooked(Sex3)
    if Sex3 then  
        if getgenv().executed then
            return  
        end
        getgenv().executed = true

        local startTime = os.clock()

        repeat wait() until game:IsLoaded()

        loadstring(game:HttpGet("https://raw.githubusercontent.com/shakar60/RickWare.CC/refs/heads/main/Misc/Bypasses", true))()

        if not LPH_OBFUSCATED then
            LPH_JIT = function(...) return ... end
            LPH_NO_VIRTUALIZE = function(...) return ... end
        end

        local getcustom = string.find(identifyexecutor(), "Delta")

        local Library

        local assetsupport = string.find(identifyexecutor(), "Wave") or string.find(identifyexecutor(), "Seliware") or string.find(identifyexecutor(), "AWP") or string.find(identifyexecutor(), "Argon") or string.find(identifyexecutor(), "Swift")

        if assetsupport then
            Library = loadstring(game:HttpGet("https://pastebin.com/raw/LixdnWjB", true))()
        else
            Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/CongoOhioDog/35476decfcca390e13120470a8907d26/raw/ec47708b7c28850ea497567972fee63c91f5a893/lol", true))()
        end

        local function getAsset(path)
            if getcustom then
                return getcustomasset(string.format("images_stuff/%s", path))
            else
                return "rbxassetid://0"
            end
        end

        downloadSound = LPH_NO_VIRTUALIZE(function(SoundName, SoundUrl)
            local SoundPath = string.format("images_stuff/%s", SoundName)
            if not isfile(SoundPath) then
                writefile(SoundPath, game:HttpGet(SoundUrl))
            end
            return SoundPath
        end)

        local Psalms = {
            Tech = {
                Enabled = false,
                rediction = false,
                AutoPredMode = "PingBased",
                APMODE = "Calculate",
                
                RealPart = "HumanoidRootPart",
                SelectedPart = "HumanoidRootPart",
                AirPart = "RightFoot",
                
                HorizontalPrediction = 0.1,
                VerticalPrediction = 0.1,
                HorizontalPrediction2 = 0.1,
                VerticalPrediction2 = 0.1,
                
                jumpoffset = 0,
                jumpoffset2 = -0.3,
                jumpoffset3 = 0.270,
                
                ShootDelay = 0.22,
                NoGroundShot = false,
                AutoAir = false,
                
                TracerEnabled = true,
                LookAt = false,
                
                Camera = false,
                CamPrediction1 = 0.1,
                CamPrediction2 = 0.1,
                SilentMode = false, 
                smoothness = 0.9,
                speedvalue = 1,
                MacroSpeed = 0.2,
                AntiCurve = false,
                ResolverEnabled = false,
                
                easingStyle = "Sine",
                easingDirection = "Out",
                isTargetPlrMode = true,
                shootDelay = 0.114,
                lastShootTime = 0,
                TriggerPot = true, 
                
                JumpBreak = false,
                network = false,
                UseVertical = false,
                DotC = Color3.fromRGB(0, 0, 0),
                WallCheck = false,
                FriendCheck = false, 
                KOCheck = false, 
                SeatedCheck = false, 
                TeamCheck = false,
                UnlockOnKO = false,
                CamWallCheck = false, 
                CAMKo = false,
                bool_at_tp = false, 
                MacroDance = "YungBlud",
                MacroDanceDelay = 0.300,
            }
        }

        Psalms.Tech.SelectedPart = Psalms.Tech.RealPart

        local Sleeping = false

        local TargetAimbot = {
            Enabled = true,
            Keybind = Enum.KeyCode.Q,
            Autoselect = false,
            Prediction = 0.145, 
            RealPrediction = 0.145, 
            Resolver = false, 
            ResolverType = "Recalculate", 
            JumpOffset = 0.06, 
            RealJumpOffset = 0.09, 
            HitParts = {"HumanoidRootPart"}, 
            RealHitPart = "HumanoidRootPart", 
            KoCheck = false, 
            LookAt = false,
            CSync = {
                Enabled = false,
                Type = "Orbit",
                Distance = 10,
                Height = 2,
                Speed = 10,
                RandomAmount = 10,
                Color = Color3.fromRGB(255, 255, 255),
                Saved = nil,
                Visualize = false,
            },
            ViewAt = false,
            Tracer = false,
            Highlight = true,
            HighlightColor1 = Color3.fromRGB(255, 255, 255),
            HighlightColor2 = Color3.fromRGB(255, 255, 255),
            Stats = false, 
            UseFov = false,
            HitEffect = false,
            HitEffectType = "Coom",
            HitEffectColor = Color3.fromRGB(255, 255, 255),
            HitSounds = false,
            HitSound = "Bameware",
            HitChams = false,
            HitChamsMaterial = Enum.Material.Neon,
            HitChamsDuration = 2,
            HitChamsColor = Color3.fromRGB(255, 0, 0),
            HitChamColorEnabled = false,
            HitChamsTransparency = 0,
            HitChamsAcc = false, 
            SkeleColor = Color3.fromRGB(155, 0, 155)
        }

        local Highlight = false

        local function toggleAimViewer()
            local players = game:GetService("Players")
            local player = players.LocalPlayer
            player.CharacterAdded:Connect(function()
                local gui = player.PlayerGui:WaitForChild("gui")
                local aimViewerFrame = gui.Settings.ScrollingFrame.aimviewer
                aimViewerFrame.Visible = true
            end)

            local gui = player.PlayerGui:WaitForChild("gui")
            local aimViewerFrame = gui.Settings.ScrollingFrame.aimviewer
            aimViewerFrame.Visible = true
        end

        local UserInputService, Players, ReplicatedStorage, RunService, Workspace, Stats = 
            cloneref(game:GetService("UserInputService")), cloneref(game:GetService("Players")), cloneref(game:GetService("ReplicatedStorage")), 
            cloneref(game:GetService("RunService")), cloneref(game:GetService("Workspace")), cloneref(game:GetService("Stats"))

        local CoreGui, StarterGui, SoundService, HttpService = 
            cloneref(game:GetService("CoreGui")), cloneref(game:GetService("StarterGui")), cloneref(game:GetService("SoundService")), cloneref(game:GetService("HttpService"))

        local LocalPlayer = cloneref(Players.LocalPlayer)
        local Camera = cloneref(Workspace.CurrentCamera)

        local TargBindEnabled, TargetPlr, TargResolvePos = true, nil, nil
        local TargHighlight = Instance.new("Highlight")

        local AvatarEditorService = game:GetService("AvatarEditorService")
        TargHighlight.Parent = CoreGui
        TargHighlight.FillColor = TargetAimbot.HighlightColor1
        TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
        TargHighlight.FillTransparency = 0.5
        TargHighlight.OutlineTransparency = 0
        TargHighlight.Enabled = false

        local AChams = false
        local updateBreatheEffect = LPH_NO_VIRTUALIZE(function() 
            if AChams then
                local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                TargHighlight.FillTransparency = 100 * breathe_effect * 0.01
                TargHighlight.OutlineTransparency = 100 * breathe_effect * 0.01
            end
        end) 

        local HitEffectModule = {
            Locals = {
                Type = {
                    ["Nova"] = nil,
                    ["Crescent Slash"] = nil,
                    ["Coom"] = nil,
                    ["Cosmic Explosion"] = nil,
                    ["Slash"] = nil,
                    ["Atomic Slash"] = nil,
                    ["AuraBurst"] = nil,
                    ["Thunder"] = nil, 
                },
            },
            Functions = {},
            Settings = {HitEffect = {Color = TargetAimbot.HitEffectColor}}
        }

        local sounds = {
            BlackPencil = "https://github.com/Shatapmatehabibi/Hitsounds/raw/main/bananapencil.mp3.mp3",
            UWU = "https://github.com/CongoOhioDog/SoundS/blob/main/Uwu.mp3?raw=true",
            Plooh = "https://github.com/CongoOhioDog/SoundS/blob/main/plooh.mp3?raw=true",
            Hrntai = "https://github.com/CongoOhioDog/SoundS/blob/main/Hrntai.wav?raw=true",
            Henta01 = "https://github.com/CongoOhioDog/SoundS/blob/main/henta01.wav?raw=true",
            Bruh = "https://github.com/CongoOhioDog/SoundS/blob/main/psalms%20bruh%20sample.mp3?raw=true",
            BoneBreakage = "https://github.com/CongoOhioDog/SoundS/blob/main/psalms%20bone%20breakage.mp3?raw=true",
            Fein = "https://github.com/CongoOhioDog/SoundS/blob/main/psalms%20highly%20defined%20fein.mp3?raw=true",
            Unicorn = "https://github.com/CongoOhioDog/SoundS/blob/main/shiny%20unicorn%20for%20dh%20_%20psalms.mp3?raw=true",
            Kitty = "https://github.com/CongoOhioDog/SoundS/blob/main/Kitty.mp3?raw=true",
            Bird = "https://github.com/CongoOhioDog/SoundS/blob/main/bird%20chirping%20for%20DH%20_%20psalms%20audio.mp3?raw=true",
            BirthdayCake = "https://github.com/CongoOhioDog/SoundS/blob/main/Birthday%20cake%20for%20dh%20_%20psalms.mp3?raw=true", 
            KenCarson =  "https://github.com/CongoOhioDog/SoundS/blob/main/ken_carson_-_jennifer_s_body_offici(2).mp3?raw=true"
        }

        for name, url in pairs(sounds) do
            _G[name .. "Path"] = downloadSound(name .. ".mp3", url)
        end

        local hitsounds = {
            ["RIFK7"]          = "rbxassetid://9102080552",
            ["Bubble"]         = "rbxassetid://9102092728",
            ["Minecraft"]      = "rbxassetid://5869422451",
            ["Cod"]            = "rbxassetid://160432334",
            ["Bameware"]       = "rbxassetid://6565367558",
            ["Neverlose"]      = "rbxassetid://6565370984",
            ["Gamesense"]      = "rbxassetid://4817809188",
            ["Rust"]           = "rbxassetid://6565371338",
            ["BlackPencil"]    = getAsset("BlackPencil.mp3"),
            ["UWU"]            = getAsset("Uwu.mp3"),
            ["Plooh"]          = getAsset("plooh.mp3"),
            ["Moan"]           = getAsset("Hrntai.mp3"),
            ["Hentai"]         = getAsset("Henta01.mp3"),
            ["Bruh"]           = getAsset("Bruh.mp3"),
            ["BoneBreakage"]   = getAsset("BoneBreakage.mp3"),
            ["Fein"]           = getAsset("Fein.mp3"),
            ["Unicorn"]        = getAsset("Unicorn.mp3"),
            ["Kitty"]          = getAsset("Kitty.mp3"),
            ["Bird"]           = getAsset("Bird.mp3"),
            ["BirthdayCake"]   = getAsset("BirthdayCake.mp3"),
            ["KenCarson"]      = getAsset("KenCarson.mp3")
        }

        local HitChamsFolder = Instance.new("Folder")
        HitChamsFolder.Name = "HitChamsFolder"
        HitChamsFolder.Parent = Workspace

        -- Crescent Slash Effect
        do
            local Attachment = Instance.new("Attachment")
            Attachment.Name = "Attachment"
            HitEffectModule.Locals.Type["Crescent Slash"] = Attachment

            local Glow = Instance.new("ParticleEmitter")
            Glow.Name = "Glow"
            Glow.Lifetime = NumberRange.new(0.16, 0.16)
            Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
            Glow.Color = ColorSequence.new(Color3.fromRGB(91, 177, 252))
            Glow.Speed = NumberRange.new(0, 0)
            Glow.Brightness = 5
            Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
            Glow.Enabled = false
            Glow.ZOffset = -0.0565939
            Glow.Rate = 50
            Glow.Texture = "rbxassetid://8708637750"
            Glow.Parent = Attachment

            local Gradient1 = Instance.new("ParticleEmitter")
            Gradient1.Name = "Gradient1"
            Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
            Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
            Gradient1.Color = ColorSequence.new(Color3.fromRGB(115, 201, 255))
            Gradient1.Speed = NumberRange.new(0, 0)
            Gradient1.Brightness = 6
            Gradient1.Size = NumberSequence.new(0, 11.6261358)
            Gradient1.Enabled = false
            Gradient1.ZOffset = 0.9187313
            Gradient1.Rate = 50
            Gradient1.Texture = "rbxassetid://8196169974"
            Gradient1.Parent = Attachment

            local Shards = Instance.new("ParticleEmitter")
            Shards.Name = "Shards"
            Shards.Lifetime = NumberRange.new(0.19, 0.7)
            Shards.SpreadAngle = Vector2.new(-90, 90)
            Shards.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
            Shards.Drag = 10
            Shards.VelocitySpread = -90
            Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
            Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
            Shards.Brightness = 4
            Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
            Shards.Enabled = false
            Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
            Shards.ZOffset = 0.5705321
            Shards.Rate = 50
            Shards.Texture = "rbxassetid://8030734851"
            Shards.Rotation = NumberRange.new(90, 90)
            Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
            Shards.Parent = Attachment

            -- باقي الـ particles لـ Crescent Slash (كامل من الأصلي)
            local ShardsDark = Instance.new("ParticleEmitter")
            ShardsDark.Name = "ShardsDark"
            ShardsDark.Lifetime = NumberRange.new(0.19, 0.35)
            ShardsDark.SpreadAngle = Vector2.new(-90, 90)
            ShardsDark.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
            ShardsDark.Drag = 10
            ShardsDark.VelocitySpread = -90
            ShardsDark.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
            ShardsDark.Speed = NumberRange.new(97.7530136, 146.9970093)
            ShardsDark.Brightness = 4
            ShardsDark.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.290774, 0.6734411, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
            ShardsDark.Enabled = false
            ShardsDark.ZOffset = 0.5705321
            ShardsDark.Rate = 50
            ShardsDark.Texture = "rbxassetid://8030734851"
            ShardsDark.Rotation = NumberRange.new(90, 90)
            ShardsDark.Orientation = Enum.ParticleOrientation.VelocityParallel
            ShardsDark.Parent = Attachment

            local Specs = Instance.new("ParticleEmitter")
            Specs.Name = "Specs"
            Specs.Lifetime = NumberRange.new(0.33, 1.4)
            Specs.SpreadAngle = Vector2.new(360, -1000)
            Specs.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
            Specs.Drag = 10
            Specs.VelocitySpread = 360
            Specs.Speed = NumberRange.new(36.7492523, 146.9970093)
            Specs.Brightness = 7
            Specs.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)})
            Specs.Enabled = false
            Specs.Acceleration = Vector3.new(0, 36.74925231933594, 0)
            Specs.Rate = 50
            Specs.Texture = "rbxassetid://8030760338"
            Specs.EmissionDirection = Enum.NormalId.Right
            Specs.Parent = Attachment

            local Specs1 = Instance.new("ParticleEmitter")
            Specs1.Name = "Specs"
            Specs1.Lifetime = NumberRange.new(0.33, 1.75)
            Specs1.SpreadAngle = Vector2.new(90, -90)
            Specs1.Color = ColorSequence.new(Color3.fromRGB(106, 171, 255))
            Specs1.Drag = 9
            Specs1.VelocitySpread = 90
            Specs1.Speed = NumberRange.new(42.2616425, 73.4985046)
            Specs1.Brightness = 6
            Specs1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.210774, 0.3978962, 0.1855686), NumberSequenceKeypoint.new(1, 0)})
            Specs1.Enabled = false
            Specs1.Acceleration = Vector3.new(0, -20.21208953857422, 0)
            Specs1.ZOffset = 0.5144895
            Specs1.Rate = 50
            Specs1.Texture = "rbxassetid://8030760338"
            Specs1.Parent = Attachment

            local Specs2 = Instance.new("ParticleEmitter")
            Specs2.Name = "Specs"
            Specs2.Lifetime = NumberRange.new(0.19, 1.2)
            Specs2.SpreadAngle = Vector2.new(360, -1000)
            Specs2.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
            Specs2.Drag = 10
            Specs2.VelocitySpread = 360
            Specs2.Speed = NumberRange.new(36.7492523, 146.9970093)
            Specs2.Brightness = 7
            Specs2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)})
            Specs2.Enabled = false
            Specs2.Acceleration = Vector3.new(0, 36.74925231933594, 0)
            Specs2.Rate = 50
            Specs2.Texture = "rbxassetid://8030760338"
            Specs2.EmissionDirection = Enum.NormalId.Right
            Specs2.Parent = Attachment

            local Specs21 = Instance.new("ParticleEmitter")
            Specs21.Name = "Specs2"
            Specs21.Lifetime = NumberRange.new(0.19, 1.35)
            Specs21.SpreadAngle = Vector2.new(90, -90)
            Specs21.Color = ColorSequence.new(Color3.fromRGB(106, 171, 255))
            Specs21.Drag = 12
            Specs21.VelocitySpread = 90
            Specs21.Speed = NumberRange.new(42.2616425, 73.4985046)
            Specs21.Brightness = 6
            Specs21.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.216774, 0.5721694, 0.1855686), NumberSequenceKeypoint.new(1, 0)})
            Specs21.Enabled = false
            Specs21.Acceleration = Vector3.new(0, -20.21208953857422, 0)
            Specs21.ZOffset = 0.5144895
            Specs21.Rate = 50
            Specs21.Texture = "rbxassetid://8030760338"
            Specs21.Parent = Attachment

            local ddddddddddddddddddd = Instance.new("ParticleEmitter")
            ddddddddddddddddddd.Name = "ddddddddddddddddddd"
            ddddddddddddddddddd.Lifetime = NumberRange.new(0.19, 0.37)
            ddddddddddddddddddd.SpreadAngle = Vector2.new(90, -90)
            ddddddddddddddddddd.LockedToPart = true
            ddddddddddddddddddd.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6429392, 0), NumberSequenceKeypoint.new(1, 0)})
            ddddddddddddddddddd.LightEmission = 1
            ddddddddddddddddddd.Color = ColorSequence.new(Color3.fromRGB(90, 184, 255), Color3.fromRGB(165, 251, 255))
            ddddddddddddddddddd.Drag = 6
            ddddddddddddddddddd.TimeScale = 0.7
            ddddddddddddddddddd.VelocitySpread = 90
            ddddddddddddddddddd.Speed = NumberRange.new(81.5833435, 110.2477646)
            ddddddddddddddddddd.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.410774, 0.6711507, 0.3356177), NumberSequenceKeypoint.new(1, 0)})
            ddddddddddddddddddd.Enabled = false
            ddddddddddddddddddd.Acceleration = Vector3.new(0, -81.58334350585938, 0)
            ddddddddddddddddddd.ZOffset = 0.8345273
            ddddddddddddddddddd.Rate = 50
            ddddddddddddddddddd.Texture = "rbxassetid://1053546634"
            ddddddddddddddddddd.RotSpeed = NumberRange.new(-444, 166)
            ddddddddddddddddddd.Rotation = NumberRange.new(-360, 360)
            ddddddddddddddddddd.Parent = Attachment

            local large_shard = Instance.new("ParticleEmitter")
            large_shard.Name = "large_shard"
            large_shard.Lifetime = NumberRange.new(0.19, 0.28)
            large_shard.SpreadAngle = Vector2.new(-90, 90)
            large_shard.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
            large_shard.Drag = 10
            large_shard.VelocitySpread = -90
            large_shard.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
            large_shard.Speed = NumberRange.new(97.7530136, 146.9970093)
            large_shard.Brightness = 4
            large_shard.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.260774, 3.515605, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
            large_shard.Enabled = false
            large_shard.ZOffset = 0.5705321
            large_shard.Rate = 50
            large_shard.Texture = "rbxassetid://8030734851"
            large_shard.Rotation = NumberRange.new(90, 90)
            large_shard.Orientation = Enum.ParticleOrientation.VelocityParallel
            large_shard.Parent = Attachment

            local out_Specs = Instance.new("ParticleEmitter")
            out_Specs.Name = "out_Specs"
            out_Specs.Lifetime = NumberRange.new(0.19, 1)
            out_Specs.SpreadAngle = Vector2.new(44, -1000)
            out_Specs.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
            out_Specs.Drag = 10
            out_Specs.VelocitySpread = 44
            out_Specs.Speed = NumberRange.new(36.7492523, 146.9970093)
            out_Specs.Brightness = 7
            out_Specs.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.244774, 0.5469525, 0.1433053), NumberSequenceKeypoint.new(1, 0)})
            out_Specs.Enabled = false
            out_Specs.Acceleration = Vector3.new(0, -3.215559720993042, 0)
            out_Specs.Rate = 50
            out_Specs.Texture = "rbxassetid://8030760338"
            out_Specs.EmissionDirection = Enum.NormalId.Right
            out_Specs.Parent = Attachment

            local Effect = Instance.new("ParticleEmitter")
            Effect.Name = "Effect"
            Effect.Lifetime = NumberRange.new(0.4, 0.7)
            Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
            Effect.SpreadAngle = Vector2.new(360, -360)
            Effect.LockedToPart = true
            Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
            Effect.LightEmission = 1
            Effect.Color = ColorSequence.new(Color3.fromRGB(92, 161, 252))
            Effect.Drag = 1
            Effect.VelocitySpread = 360
            Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
            Effect.Brightness = 2.0999999
            Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
            Effect.Enabled = false
            Effect.ZOffset = 0.4777403
            Effect.Rate = 50
            Effect.Texture = "rbxassetid://9484012464"
            Effect.RotSpeed = NumberRange.new(-150, -150)
            Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
            Effect.Rotation = NumberRange.new(50, 50)
            Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            Effect.Parent = Attachment

            local Crescents = Instance.new("ParticleEmitter")
            Crescents.Name = "Crescents"
            Crescents.Lifetime = NumberRange.new(0.19, 0.38)
            Crescents.SpreadAngle = Vector2.new(-360, 360)
            Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
            Crescents.LightEmission = 1
            Crescents.Color = ColorSequence.new(Color3.fromRGB(92, 161, 252))
            Crescents.VelocitySpread = -360
            Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
            Crescents.Brightness = 20
            Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
            Crescents.Enabled = false
            Crescents.ZOffset = 0.4542207
            Crescents.Rate = 50
            Crescents.Texture = "rbxassetid://12509373457"
            Crescents.RotSpeed = NumberRange.new(800, 1000)
            Crescents.Rotation = NumberRange.new(-360, 360)
            Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            Crescents.Parent = Attachment
        end

        -- Cosmic Explosion Effect
        do
            local Attachment = Instance.new("Attachment")
            Attachment.Name = "Attachment"
            HitEffectModule.Locals.Type["Cosmic Explosion"] = Attachment

            local Glow = Instance.new("ParticleEmitter")
            Glow.Name = "Glow"
            Glow.Lifetime = NumberRange.new(0.16, 0.16)
            Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
            Glow.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            Glow.Speed = NumberRange.new(0, 0)
            Glow.Brightness = 5
            Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
            Glow.Enabled = false
            Glow.ZOffset = -0.0565939
            Glow.Rate = 50
            Glow.Texture = "rbxassetid://8708637750"
            Glow.Parent = Attachment

            local Effect = Instance.new("ParticleEmitter")
            Effect.Name = "Effect"
            Effect.Lifetime = NumberRange.new(0.4, 0.7)
            Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
            Effect.SpreadAngle = Vector2.new(360, -360)
            Effect.LockedToPart = true
            Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
            Effect.LightEmission = 1
            Effect.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            Effect.Drag = 1
            Effect.VelocitySpread = 360
            Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
            Effect.Brightness = 2.0999999
            Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
            Effect.Enabled = false
            Effect.ZOffset = 0.4777403
            Effect.Rate = 50
            Effect.Texture = "rbxassetid://9484012464"
            Effect.RotSpeed = NumberRange.new(-150, -150)
            Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
            Effect.Rotation = NumberRange.new(50, 50)
            Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            Effect.Parent = Attachment

            local Gradient1 = Instance.new("ParticleEmitter")
            Gradient1.Name = "Gradient1"
            Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
            Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
            Gradient1.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            Gradient1.Speed = NumberRange.new(0, 0)
            Gradient1.Brightness = 6
            Gradient1.Size = NumberSequence.new(0, 11.6261358)
            Gradient1.Enabled = false
            Gradient1.ZOffset = 0.9187313
            Gradient1.Rate = 50
            Gradient1.Texture = "rbxassetid://8196169974"
            Gradient1.Parent = Attachment

            local Shards = Instance.new("ParticleEmitter")
            Shards.Name = "Shards"
            Shards.Lifetime = NumberRange.new(0.19, 0.7)
            Shards.SpreadAngle = Vector2.new(-90, 90)
            Shards.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            Shards.Drag = 10
            Shards.VelocitySpread = -90
            Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
            Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
            Shards.Brightness = 4
            Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
            Shards.Enabled = false
            Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
            Shards.ZOffset = 0.5705321
            Shards.Rate = 50
            Shards.Texture = "rbxassetid://8030734851"
            Shards.Rotation = NumberRange.new(90, 90)
            Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
            Shards.Parent = Attachment

            local Crescents = Instance.new("ParticleEmitter")
            Crescents.Name = "Crescents"
            Crescents.Lifetime = NumberRange.new(0.19, 0.38)
            Crescents.SpreadAngle = Vector2.new(-360, 360)
            Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
            Crescents.LightEmission = 10
            Crescents.Color = ColorSequence.new(Color3.fromRGB(160, 96, 255))
            Crescents.VelocitySpread = -360
            Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
            Crescents.Brightness = 4
            Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
            Crescents.Enabled = false
            Crescents.ZOffset = 0.4542207
            Crescents.Rate = 50
            Crescents.Texture = "rbxassetid://12509373457"
            Crescents.RotSpeed = NumberRange.new(800, 1000)
            Crescents.Rotation = NumberRange.new(-360, 360)
            Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            Crescents.Parent = Attachment

            local ParticleEmitter2 = Instance.new("ParticleEmitter")
            ParticleEmitter2.Name = "ParticleEmitter2"
            ParticleEmitter2.FlipbookFramerate = NumberRange.new(20, 20)
            ParticleEmitter2.Lifetime = NumberRange.new(0.19, 0.38)
            ParticleEmitter2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
            ParticleEmitter2.SpreadAngle = Vector2.new(360, 360)
            ParticleEmitter2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.209842, 0.5), NumberSequenceKeypoint.new(0.503842, 0.263333), NumberSequenceKeypoint.new(0.799842, 0.5), NumberSequenceKeypoint.new(1, 1)})
            ParticleEmitter2.LightEmission = 1
            ParticleEmitter2.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            ParticleEmitter2.VelocitySpread = 360
            ParticleEmitter2.Speed = NumberRange.new(0.0161231, 0.0161231)
            ParticleEmitter2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 4.3125), NumberSequenceKeypoint.new(0.3985056, 7.9375), NumberSequenceKeypoint.new(1, 10)})
            ParticleEmitter2.Enabled = false
            ParticleEmitter2.ZOffset = 0.15
            ParticleEmitter2.Rate = 100
            ParticleEmitter2.Texture = "http://www.roblox.com/asset/?id=12394566430"
            ParticleEmitter2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
            ParticleEmitter2.Rotation = NumberRange.new(39, 999)
            ParticleEmitter2.Orientation = Enum.ParticleOrientation.VelocityParallel
            ParticleEmitter2.Parent = Attachment
        end

        -- Coom Effect
        do
            local Attachment = Instance.new("Attachment")
            HitEffectModule.Locals.Type["Coom"] = Attachment

            local Foam = Instance.new("ParticleEmitter")
            Foam.Name = "Foam"
            Foam.LightInfluence = 0.5
            Foam.Lifetime = NumberRange.new(1, 1)
            Foam.SpreadAngle = Vector2.new(360, -360)
            Foam.VelocitySpread = 360
            Foam.Squash = NumberSequence.new(1)
            Foam.Speed = NumberRange.new(20, 20)
            Foam.Brightness = 2.5
            Foam.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.1016692, 0.6508875, 0.6508875), NumberSequenceKeypoint.new(0.6494689, 1.4201183, 0.4127519), NumberSequenceKeypoint.new(1, 0)})
            Foam.Enabled = false
            Foam.Acceleration = Vector3.new(0, -66.04029846191406, 0)
            Foam.Rate = 100
            Foam.Texture = "rbxassetid://8297030850"
            Foam.Rotation = NumberRange.new(-90, -90)
            Foam.Orientation = Enum.ParticleOrientation.VelocityParallel
            Foam.Parent = Attachment
        end

        -- Slash Effect
        do
            local Attachment = Instance.new("Attachment")
            HitEffectModule.Locals.Type["Slash"] = Attachment

            local Crescents = Instance.new("ParticleEmitter")
            Crescents.Name = "Crescents"
            Crescents.Lifetime = NumberRange.new(0.19, 0.38)
            Crescents.SpreadAngle = Vector2.new(-360, 360)
            Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
            Crescents.LightEmission = 10
            Crescents.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 96, 255)), ColorSequenceKeypoint.new(0.3160622, Color3.fromRGB(160, 96, 255)), ColorSequenceKeypoint.new(0.5146805, Color3.fromRGB(154, 82, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 96, 255))})
            Crescents.VelocitySpread = -360
            Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
            Crescents.Brightness = 4
            Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
            Crescents.Enabled = false
            Crescents.ZOffset = 0.4542207
            Crescents.Rate = 50
            Crescents.Texture = "rbxassetid://12509373457"
            Crescents.RotSpeed = NumberRange.new(800, 1000)
            Crescents.Rotation = NumberRange.new(-360, 360)
            Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            Crescents.Parent = Attachment
        end

        -- Atomic Slash Effect
        do
            local Attachment = Instance.new("Attachment")
            HitEffectModule.Locals.Type["Atomic Slash"] = Attachment

            local Crescents = Instance.new("ParticleEmitter")
            Crescents.Name = "Crescents"
            Crescents.Lifetime = NumberRange.new(0.19, 0.38)
            Crescents.SpreadAngle = Vector2.new(-360, 360)
            Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
            Crescents.LightEmission = 10
            Crescents.Color = ColorSequence.new(Color3.fromRGB(160, 96, 255))
            Crescents.VelocitySpread = -360
            Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
            Crescents.Brightness = 4
            Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
            Crescents.Enabled = false
            Crescents.ZOffset = 0.4542207
            Crescents.Rate = 50
            Crescents.Texture = "rbxassetid://12509373457"
            Crescents.RotSpeed = NumberRange.new(800, 1000)
            Crescents.Rotation = NumberRange.new(-360, 360)
            Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            Crescents.Parent = Attachment

            local Glow = Instance.new("ParticleEmitter")
            Glow.Name = "Glow"
            Glow.Lifetime = NumberRange.new(0.16, 0.16)
            Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
            Glow.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            Glow.Speed = NumberRange.new(0, 0)
            Glow.Brightness = 5
            Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
            Glow.Enabled = false
            Glow.ZOffset = -0.0565939
            Glow.Rate = 50
            Glow.Texture = "rbxassetid://8708637750"
            Glow.Parent = Attachment

            local Effect = Instance.new("ParticleEmitter")
            Effect.Name = "Effect"
            Effect.Lifetime = NumberRange.new(0.4, 0.7)
            Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
            Effect.SpreadAngle = Vector2.new(360, -360)
            Effect.LockedToPart = true
            Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
            Effect.LightEmission = 1
            Effect.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            Effect.Drag = 1
            Effect.VelocitySpread = 360
            Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
            Effect.Brightness = 2.0999999
            Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
            Effect.Enabled = false
            Effect.ZOffset = 0.4777403
            Effect.Rate = 50
            Effect.Texture = "rbxassetid://9484012464"
            Effect.RotSpeed = NumberRange.new(-150, -150)
            Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
            Effect.Rotation = NumberRange.new(50, 50)
            Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            Effect.Parent = Attachment

            local Gradient1 = Instance.new("ParticleEmitter")
            Gradient1.Name = "Gradient1"
            Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
            Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
            Gradient1.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
            Gradient1.Speed = NumberRange.new(0, 0)
            Gradient1.Brightness = 6
            Gradient1.Size = NumberSequence.new(0, 11.6261358)
            Gradient1.Enabled = false
            Gradient1.ZOffset = 0.9187313
            Gradient1.Rate = 50
            Gradient1.Texture = "rbxassetid://8196169974"
            Gradient1.Parent = Attachment

            local Shards = Instance.new("ParticleEmitter")
            Shards.Name = "Shards"
            Shards.Lifetime = NumberRange.new(0.19, 0.7)
            Shards.SpreadAngle = Vector2.new(-90, 90)
            Shards.Color = ColorSequence.new(Color3.fromRGB(179, 145, 253))
            Shards.Drag = 10
            Shards.VelocitySpread = -90
            Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
            Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
            Shards.Brightness = 4
            Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
            Shards.Enabled = false
            Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
            Shards.ZOffset = 0.5705321
            Shards.Rate = 50
            Shards.Texture = "rbxassetid://8030734851"
            Shards.Rotation = NumberRange.new(90, 90)
            Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
            Shards.Parent = Attachment
        end

        -- Aura Burst Effect
        do
            local attachment = Instance.new("Attachment")
            attachment.Name = "Attachment"
            HitEffectModule.Locals.Type["AuraBurst"] = attachment

            local useparticle2 = Instance.new('ParticleEmitter')
            useparticle2.Name = "useparticle2"
            useparticle2.Acceleration = Vector3.new(0, 10, 0)
            useparticle2.Brightness = 10
            useparticle2.Color = ColorSequence.new(Color3.new(0, 1, 0.333333), Color3.new(0, 0, 1))
            useparticle2.Drag = 3
            useparticle2.Enabled = false
            useparticle2.Lifetime = NumberRange.new(0.3, 10)
            useparticle2.LightEmission = 1
            useparticle2.Rate = 50
            useparticle2.RotSpeed = NumberRange.new(-150, 150)
            useparticle2.Rotation = NumberRange.new(-360, 360)
            useparticle2.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.19467, 0.819203),
                NumberSequenceKeypoint.new(1, 0)
            })
            useparticle2.Speed = NumberRange.new(4.49742, 34.4802)
            useparticle2.SpreadAngle = Vector2.new(360, 360)
            useparticle2.Texture = "rbxassetid://16171528032"
            useparticle2.Parent = attachment

            local useparticle = Instance.new('ParticleEmitter')
            useparticle.Name = "useparticle"
            useparticle.Acceleration = Vector3.new(0, 10, 0)
            useparticle.Brightness = 10
            useparticle.Color = ColorSequence.new(Color3.new(0, 1, 0.403922), Color3.new(0.12549, 0, 1))
            useparticle.Drag = 3
            useparticle.Enabled = false
            useparticle.Lifetime = NumberRange.new(0.3, 10)
            useparticle.LightEmission = 1
            useparticle.Rate = 50
            useparticle.RotSpeed = NumberRange.new(-150, 150)
            useparticle.Rotation = NumberRange.new(-360, 360)
            useparticle.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.19467, 0.819203),
                NumberSequenceKeypoint.new(1, 0)
            })
            useparticle.Speed = NumberRange.new(4.49742, 34.4802)
            useparticle.SpreadAngle = Vector2.new(360, 360)
            useparticle.Texture = "rbxassetid://16171528032"
            useparticle.Parent = attachment

            local circles2 = Instance.new('ParticleEmitter')
            circles2.Name = "circles2"
            circles2.Acceleration = Vector3.new(0, 0, 0.001)
            circles2.Brightness = 10
            circles2.Color = ColorSequence.new(Color3.new(0, 1, 0.541176), Color3.new(0.0784314, 0, 1))
            circles2.Enabled = false
            circles2.Lifetime = NumberRange.new(0.9, 0.9)
            circles2.LightInfluence = 0.35
            circles2.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            circles2.Rate = 4
            circles2.RotSpeed = NumberRange.new(150, 150)
            circles2.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.20394, 8.79781),
                NumberSequenceKeypoint.new(1, 10)
            })
            circles2.Speed = NumberRange.new(0.01, 0.01)
            circles2.SpreadAngle = Vector2.new(360, 360)
            circles2.Texture = "http://www.roblox.com/asset/?id=6835970470"
            circles2.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.840125, 0.83125),
                NumberSequenceKeypoint.new(1, 1)
            })
            circles2.Parent = attachment

            local circles = Instance.new('ParticleEmitter')
            circles.Name = "circles"
            circles.Acceleration = Vector3.new(0, 0, 0.001)
            circles.Brightness = 10
            circles.Color = ColorSequence.new(Color3.new(0, 1, 0.45098), Color3.new(0.133333, 0, 1))
            circles.Enabled = false
            circles.Lifetime = NumberRange.new(0.9, 0.9)
            circles.LightInfluence = 0.35
            circles.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            circles.Rate = 4
            circles.RotSpeed = NumberRange.new(150, 150)
            circles.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.20394, 8.79781),
                NumberSequenceKeypoint.new(1, 10)
            })
            circles.Speed = NumberRange.new(0.01, 0.01)
            circles.SpreadAngle = Vector2.new(360, 360)
            circles.Texture = "http://www.roblox.com/asset/?id=6835970470"
            circles.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.840125, 0.83125),
                NumberSequenceKeypoint.new(1, 1)
            })
            circles.Parent = attachment
        end

        -- Thunder Effect
        do
            local attachment = Instance.new("Attachment")
            attachment.Name = "Attachment"
            HitEffectModule.Locals.Type["Thunder"] = attachment

            local ELECTRIC2 = Instance.new('ParticleEmitter')
            ELECTRIC2.Parent = attachment
            ELECTRIC2.Name = "ELECTRIC"
            ELECTRIC2.Brightness = 3
            ELECTRIC2.Color = ColorSequence.new(Color3.new(0, 0.52549, 0.780392), Color3.new(1, 0, 1))
            ELECTRIC2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
            ELECTRIC2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
            ELECTRIC2.Lifetime = NumberRange.new(1, 3)
            ELECTRIC2.LightEmission = 1
            ELECTRIC2.Orientation = Enum.ParticleOrientation.FacingCameraWorldUp
            ELECTRIC2.Rate = 5
            ELECTRIC2.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 19),
                NumberSequenceKeypoint.new(1, 0)
            })
            ELECTRIC2.Speed = NumberRange.new(0, 0)
            ELECTRIC2.SpreadAngle = Vector2.new(-360, 360)
            ELECTRIC2.Texture = "rbxassetid://10547286472"
            ELECTRIC2.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.25, 1),
                NumberSequenceKeypoint.new(1, 1)
            })

            local ParticleEmitter = Instance.new('ParticleEmitter') 
            ParticleEmitter.Color = ColorSequence.new(
                Color3.fromRGB(0, 0, 255),
                Color3.fromRGB(0, 0, 255),
                Color3.fromRGB(0, 0, 255),
                Color3.fromRGB(0, 0, 139)
            )
            ParticleEmitter.Drag = 5
            ParticleEmitter.Lifetime = NumberRange.new(0.4, 0.4)
            ParticleEmitter.LightEmission = 0.5
            ParticleEmitter.Rate = 5
            ParticleEmitter.Parent = attachment
            ParticleEmitter.RotSpeed = NumberRange.new(200, 250)
            ParticleEmitter.Rotation = NumberRange.new(-360, 360)
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 7),
                NumberSequenceKeypoint.new(1, 0)
            })
            ParticleEmitter.Speed = NumberRange.new(0, 0)
            ParticleEmitter.Texture = "http://www.roblox.com/asset/?id=467188845"
            ParticleEmitter.Transparency = NumberSequence.new(0, 0.43125, 0, 0.299656, 0.04375, 0, 0.874618, 0, 0, 1, 0, 0)
            ParticleEmitter.ZOffset = 1
        end

        -- Nova Effect
        do
            local part = Instance.new("Part")
            part.Parent = ReplicatedStorage
            local attachment = Instance.new("Attachment")
            attachment.Name = "Attachment"
            attachment.Parent = part
            HitEffectModule.Locals.Type["Nova"] = attachment

            local function createParticleEmitter(acceleration)
                local emitter = Instance.new("ParticleEmitter")
                emitter.Name = "ParticleEmitter"
                emitter.Acceleration = acceleration
                emitter.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.495, HitEffectModule.Settings.HitEffect.Color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                })
                emitter.Lifetime = NumberRange.new(0.5, 0.5)
                emitter.LightEmission = 1
                emitter.LockedToPart = true
                emitter.Rate = 1
                emitter.Rotation = NumberRange.new(0, 360)
                emitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 10),
                    NumberSequenceKeypoint.new(1, 1)
                })
                emitter.Speed = NumberRange.new(0, 0)
                emitter.Texture = "rbxassetid://1084991215"
                emitter.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(0.534, 0.25),
                    NumberSequenceKeypoint.new(1, 0.5),
                    NumberSequenceKeypoint.new(1, 0)
                })
                emitter.ZOffset = 1
                emitter.Parent = attachment
                return emitter
            end

            createParticleEmitter(Vector3.new(0, 0, 1))
            local perpendicularEmitter = createParticleEmitter(Vector3.new(0, 1, -0.001))
            perpendicularEmitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
        end

        HitEffectModule.Functions.Effect = function(character, color)
            if not TargetAimbot.HitEffect and character then return end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end

            local effectAttachment = HitEffectModule.Locals.Type[TargetAimbot.HitEffectType]:Clone()
            effectAttachment.Parent = humanoidRootPart

            for _, emitter in pairs(effectAttachment:GetChildren()) do
                if emitter:IsA("ParticleEmitter") then
                    emitter.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(0.495, color),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                    })
                    emitter:Emit()
                end
            end

            task.delay(2, function()
                effectAttachment:Destroy()
            end)
        end

        local PlayHitSound = LPH_NO_VIRTUALIZE(function() 
            if TargetAimbot.HitSounds and hitsounds[TargetAimbot.HitSound] then
                local sound = Instance.new("Sound")
                sound.SoundId = hitsounds[TargetAimbot.HitSound]
                sound.Parent = SoundService
                sound:Play()
                sound.Ended:Connect(function()
                    sound:Destroy()
                end)
            end
        end) 

        local TweenService = game:GetService("TweenService")

        local HitChams = LPH_NO_VIRTUALIZE(function(Player)
            if not TargetAimbot.HitChams then return end

            if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.Archivable = true
                local Cloned = Player.Character:Clone()
                Cloned.Name = "Player Clone"

                local BodyParts = {
                    "Head", "UpperTorso", "LowerTorso",
                    "LeftUpperArm", "LeftLowerArm", "LeftHand",
                    "RightUpperArm", "RightLowerArm", "RightHand",
                    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                    "RightUpperLeg", "RightLowerLeg", "RightFoot"
                }

                for _, Part in ipairs(Cloned:GetChildren()) do
                    if Part:IsA("BasePart") then
                        local PartValid = false
                        for _, validPart in ipairs(BodyParts) do
                            if Part.Name == validPart then
                                PartValid = true
                                break
                            end
                        end
                        
                        if not PartValid then
                            Part:Destroy()
                        end
                    elseif Part:IsA("Accessory") or Part:IsA("Tool") or Part.Name == "face" or Part:IsA("Shirt") or Part:IsA("Pants") or Part:IsA("Hat") then
                        Part:Destroy()
                    end
                end

                if Cloned:FindFirstChild("Humanoid") then
                    Cloned.Humanoid:Destroy()
                end

                for _, BodyPart in ipairs(Cloned:GetChildren()) do
                    if BodyPart:IsA("BasePart") then
                        BodyPart.CanCollide = false
                        BodyPart.Anchored = true
                        BodyPart.Transparency = TargetAimbot.HitChamsTransparency
                        BodyPart.Color = TargetAimbot.HitChamsColor
                        BodyPart.Material = TargetAimbot.HitChamsMaterial
                    end
                end

                if Cloned:FindFirstChild("Head") then
                    local Head = Cloned.Head
                    Head.Transparency = TargetAimbot.HitChamsTransparency
                    Head.Color = TargetAimbot.HitChamsColor
                    Head.Material = TargetAimbot.HitChamsMaterial

                    if Head:FindFirstChild("face") then
                        Head.face:Destroy()
                    end
                end

                Cloned.Parent = game.Workspace

                local tweenInfo = TweenInfo.new(
                    TargetAimbot.HitChamsDuration,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    0,
                    true
                )

                for _, BodyPart in ipairs(Cloned:GetChildren()) do
                    if BodyPart:IsA("BasePart") then
                        local tween = TweenService:Create(BodyPart, tweenInfo, { Transparency = 1 })
                        tween:Play()
                    end
                end

                task.delay(TargetAimbot.HitChamsDuration, function()
                    if Cloned and Cloned.Parent then
                        Cloned:Destroy()
                    end
                end)
            end
        end) 

        local Client = Players.LocalPlayer
        local Mouse = Client:GetMouse()

        local HitChamsSkeleton = LPH_NO_VIRTUALIZE(function(Player)
            if not TargetAimbot.HitChamsAcc then return end

            if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- كود الهيكل العظمي للـ hit chams (مختصر، يمكن توسيع من الأصلي)
                -- استخدم Highlight أو Beam للـ skeleton lines
                local skeleton = Instance.new("Highlight")
                skeleton.Parent = Player.Character
                skeleton.Color = TargetAimbot.SkeleColor
                skeleton.FillTransparency = 1
                skeleton.OutlineTransparency = 0
                task.delay(TargetAimbot.HitChamsDuration, function()
                    if skeleton then
                        skeleton:Destroy()
                    end
                end)
            end
        end)

        -- Universal Aimbot Hook - يعمل في جميع المابات
        local UniversalHook = nil
        local remotes = {}
        local function SetupUniversalAimbot()
            -- البحث عن remotes شائعة
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") and (string.find(obj.Name:lower(), "shoot") or string.find(obj.Name:lower(), "fire") or string.find(obj.Name:lower(), "gun") or string.find(obj.Name:lower(), "main") or string.find(obj.Name:lower(), "remote")) then
                    table.insert(remotes, obj)
                end
            end

            if #remotes == 0 then
                warn("تحذير: لم يتم العثور على remotes مناسبة للـ Aimbot. تأكد من اللعبة.")
                return
            end

            UniversalHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}

                if method == "FireServer" and table.find(remotes, self) and Psalms.Tech.Enabled and TargetAimbot.Enabled and TargetPlr and TargetPlr.Character then
                    local targetPos = TargetPlr.Character[Psalms.Tech.SelectedPart or "HumanoidRootPart"].Position
                    -- إضافة prediction و jump offset
                    local velocity = TargetPlr.Character.HumanoidRootPart.Velocity
                    targetPos = targetPos + (velocity * Psalms.Tech.Prediction) + Vector3.new(0, Psalms.Tech.JumpOffset, 0)

                    -- استبدال position في args (شائع في args[2] أو args[3])
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = targetPos
                            break
                        end
                    end

                    -- تشغيل التأثيرات
                    PlayHitSound()
                    HitEffectModule.Functions.Effect(TargetPlr.Character, TargetAimbot.HitEffectColor)
                    HitChams(TargetPlr)
                    HitChamsSkeleton(TargetPlr)
                end

                return UniversalHook(self, ...)
            end))

            Library:Notification("تم تفعيل الـ Aimbot العام لجميع المابات", 3)
        end

        -- تشغيل الـ hook بعد التحميل
        task.spawn(function()
            task.wait(2)
            SetupUniversalAimbot()
        end)

        -- إعداد الـ UI بالعربية
        local Window = Library:Window({Name = "Psalms.Tech - واجهة عربية", LoadingTitle = "جاري التحميل..."})

        -- تبويب التقنية الرئيسية (Tech)
        local Tab1 = Window:Tab({Name = "التقنية الرئيسية"})
        local TechSection = Tab1:Section({Name = "إعدادات الـ Aimbot", Side = "Left"})

        TechSection:Toggle({
            Name = "تفعيل الـ Aimbot",
            Flag = "AimbotEnabled",
            Default = Psalms.Tech.Enabled,
            Callback = function(a)
                Psalms.Tech.Enabled = a
            end
        })

        TechSection:Toggle({
            Name = "وضع الصامت (Silent Mode)",
            Flag = "SilentMode",
            Default = Psalms.Tech.SilentMode,
            Callback = function(a)
                Psalms.Tech.SilentMode = a
            end
        })

        TechSection:Slider({
            Name = "التنبؤ الأفقي",
            Flag = "HorizontalPrediction",
            Min = 0,
            Max = 1,
            Default = Psalms.Tech.HorizontalPrediction,
            Decimals = 0.01,
            Callback = function(a)
                Psalms.Tech.HorizontalPrediction = a
            end
        })

        TechSection:Slider({
            Name = "التنبؤ الرأسي",
            Flag = "VerticalPrediction",
            Min = 0,
            Max = 1,
            Default = Psalms.Tech.VerticalPrediction,
            Decimals = 0.01,
            Callback = function(a)
                Psalms.Tech.VerticalPrediction = a
            end
        })

        TechSection:Toggle({
            Name = "التحقق من الجدران (Wall Check)",
            Flag = "WallCheck",
            Default = Psalms.Tech.WallCheck,
            Callback = function(a)
                Psalms.Tech.WallCheck = a
            end
        })

        TechSection:Toggle({
            Name = "التحقق من الأصدقاء (Friend Check)",
            Flag = "FriendCheck",
            Default = Psalms.Tech.FriendCheck,
            Callback = function(a)
                Psalms.Tech.FriendCheck = a
            end
        })

        TechSection:Toggle({
            Name = "التحقق من الـ KO",
            Flag = "KOCheck",
            Default = Psalms.Tech.KOCheck,
            Callback = function(a)
                Psalms.Tech.KOCheck = a
            end
        })

        TechSection:Toggle({
            Name = "كسر التنبؤ بالقفز (Jump Break)",
            Flag = "JumpBreak",
            Default = Psalms.Tech.JumpBreak,
            Callback = function(a)
                Psalms.Tech.JumpBreak = a
            end
        })

        TechSection:Toggle({
            Name = "مضاد الشبكة (Anti Network)",
            Flag = "Network",
            Default = Psalms.Tech.network,
            Callback = function(a)
                Psalms.Tech.network = a
            end
        })

        -- تبويب الهدف (Target)
        local Tab2 = Window:Tab({Name = "الهدف والتصويب"})
        local TargetSection = Tab2:Section({Name = "إعدادات الهدف", Side = "Left"})

        TargetSection:Toggle({
            Name = "تفعيل الهدف",
            Flag = "TargetEnabled",
            Default = TargetAimbot.Enabled,
            Callback = function(a)
                TargetAimbot.Enabled = a
            end
        })

        TargetSection:Keybind({
            Name = "مفتاح الهدف",
            Flag = "TargetKeybind",
            Default = TargetAimbot.Keybind,
            Callback = function(key)
                TargetAimbot.Keybind = key
            end
        })

        TargetSection:List({
            Name = "نوع الـ Resolver",
            Flag = "ResolverType",
            Options = {"Recalculate", "PingBased"},
            Default = TargetAimbot.ResolverType,
            Callback = function(a)
                TargetAimbot.ResolverType = a
            end
        })

        TargetSection:Slider({
            Name = "التنبؤ",
            Flag = "Prediction",
            Min = 0,
            Max = 1,
            Default = TargetAimbot.Prediction,
            Decimals = 0.01,
            Callback = function(a)
                TargetAimbot.Prediction = a
            end
        })

        TargetSection:Slider({
            Name = "إزاحة القفز",
            Flag = "JumpOffset",
            Min = 0,
            Max = 1,
            Default = TargetAimbot.JumpOffset,
            Decimals = 0.01,
            Callback = function(a)
                TargetAimbot.JumpOffset = a
            end
        })

        TargetSection:List({
            Name = "أجزاء الضرب",
            Flag = "HitParts",
            Options = {"HumanoidRootPart", "Head", "RightFoot"},
            Default = TargetAimbot.RealHitPart,
            Callback = function(a)
                TargetAimbot.RealHitPart = a
                Psalms.Tech.SelectedPart = a
            end
        })

        TargetSection:Toggle({
            Name = "التحقق من الـ KO",
            Flag = "KoCheck",
            Default = TargetAimbot.KoCheck,
            Callback = function(a)
                TargetAimbot.KoCheck = a
            end
        })

        TargetSection:Toggle({
            Name = "النظر إلى الهدف (LookAt)",
            Flag = "LookAt",
            Default = TargetAimbot.LookAt,
            Callback = function(a)
                TargetAimbot.LookAt = a
            end
        })

        TargetSection:Toggle({
            Name = "المتابعة البصرية (ViewAt)",
            Flag = "ViewAt",
            Default = TargetAimbot.ViewAt,
            Callback = function(a)
                TargetAimbot.ViewAt = a
            end
        })

        TargetSection:Toggle({
            Name = "الخط الممتد (Tracer)",
            Flag = "Tracer",
            Default = TargetAimbot.Tracer,
            Callback = function(a)
                TargetAimbot.Tracer = a
            end
        })

        TargetSection:Toggle({
            Name = "التسليط الضوئي (Highlight)",
            Flag = "Highlight",
            Default = TargetAimbot.Highlight,
            Callback = function(a)
                TargetAimbot.Highlight = a
                TargHighlight.Enabled = a
            end
        })

        TargetSection:Colorpicker({
            Name = "لون التسليط 1",
            Flag = "HighlightColor1",
            Default = TargetAimbot.HighlightColor1,
            Callback = function(a)
                TargetAimbot.HighlightColor1 = a
                TargHighlight.FillColor = a
            end
        })

        TargetSection:Colorpicker({
            Name = "لون التسليط 2",
            Flag = "HighlightColor2",
            Default = TargetAimbot.HighlightColor2,
            Callback = function(a)
                TargetAimbot.HighlightColor2 = a
                TargHighlight.OutlineColor = a
            end
        })

        TargetSection:Toggle({
            Name = "إحصائيات الهدف",
            Flag = "Stats",
            Default = TargetAimbot.Stats,
            Callback = function(a)
                TargetAimbot.Stats = a
            end
        })

        TargetSection:Toggle({
            Name = "استخدام FOV",
            Flag = "UseFov",
            Default = TargetAimbot.UseFov,
            Callback = function(a)
                TargetAimbot.UseFov = a
            end
        })

        -- قسم كشف الضربات (Hit Detection)
        local HitSection = Tab2:Section({Name = "كشف الضربات", Side = "Right"})

        HitSection:Toggle({
            Name = "تأثيرات الضربة",
            Flag = "HitEffect",
            Default = TargetAimbot.HitEffect,
            Callback = function(a)
                TargetAimbot.HitEffect = a
            end
        })

        HitSection:List({
            Name = "نوع التأثير",
            Flag = "HitEffectType",
            Options = {"Nova", "Crescent Slash", "Coom", "Cosmic Explosion", "Slash", "Atomic Slash", "AuraBurst", "Thunder"},
            Default = TargetAimbot.HitEffectType,
            Callback = function(a)
                TargetAimbot.HitEffectType = a
            end
        })

        HitSection:Colorpicker({
            Name = "لون التأثير",
            Flag = "HitEffectColor",
            Default = TargetAimbot.HitEffectColor,
            Callback = function(a)
                TargetAimbot.HitEffectColor = a
                HitEffectModule.Settings.HitEffect.Color = a
            end
        })

        HitSection:Toggle({
            Name = "أصوات الضربة",
            Flag = "HitSounds",
            Default = TargetAimbot.HitSounds,
            Callback = function(a)
                TargetAimbot.HitSounds = a
            end
        })

        HitSection:List({
            Name = "نوع الصوت",
            Flag = "HitSound",
            Options = {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", "BlackPencil", "UWU", "Plooh", "Moan", "Hentai", "Bruh", "BoneBreakage", "Fein", "Unicorn", "Kitty", "Bird", "BirthdayCake", "KenCarson"},
            Default = TargetAimbot.HitSound,
            Callback = function(a)
                TargetAimbot.HitSound = a
            end
        })

        HitSection:Toggle({
            Name = "تشام الضربة (Hit Chams)",
            Flag = "HitChams",
            Default = TargetAimbot.HitChams,
            Callback = function(a)
                TargetAimbot.HitChams = a
            end
        })

        HitSection:Colorpicker({
            Name = "لون التشام",
            Flag = "HitChamsColor",
            Default = TargetAimbot.HitChamsColor,
            Callback = function(a)
                TargetAimbot.HitChamsColor = a
            end
        })

        HitSection:Slider({
            Name = "مدة التشام",
            Flag = "HitChamsDuration",
            Min = 0,
            Max = 10,
            Default = TargetAimbot.HitChamsDuration,
            Decimals = 0.1,
            Callback = function(a)
                TargetAimbot.HitChamsDuration = a
            end
        })

        HitSection:Slider({
            Name = "الشفافية",
            Flag = "HitChamsTransparency",
            Min = 0,
            Max = 1,
            Default = TargetAimbot.HitChamsTransparency,
            Decimals = 0.01,
            Callback = function(a)
                TargetAimbot.HitChamsTransparency = a
            end
        })

        HitSection:List({
            Name = "مادة التشام",
            Flag = "HitChamsMaterial",
            Options = {"Neon", "SmoothPlastic", "ForceField"},
            Default = TargetAimbot.HitChamsMaterial.Name,
            Callback = function(a)
                TargetAimbot.HitChamsMaterial = Enum.Material[a]
            end
        })

        HitSection:Toggle({
            Name = "هيكل عظمي الضربة",
            Flag = "HitSkele",
            Default = TargetAimbot.HitChamsAcc,
            Callback = function(a)
                TargetAimbot.HitChamsAcc = a
            end
        })

        HitSection:Colorpicker({
            Name = "لون الهيكل العظمي",
            Flag = "SkeleColor",
            Default = TargetAimbot.SkeleColor,
            Callback = function(a)
                TargetAimbot.SkeleColor = a
            end
        })

        -- تبويب كسر التنبؤ (Prediction Breaker)
        local Tab3 = Window:Tab({Name = "كسر التنبؤ"})
        local BreakerSection = Tab3:Section({Name = "مضاد التصويب", Side = "Left"})

        BreakerSection:Toggle({
            Name = "تنبؤ بالقفز",
            Flag = "JumpPredAnti",
            Default = Psalms.Tech.JumpBreak,
            Callback = function(a)
                Psalms.Tech.JumpBreak = a
            end
        })

        BreakerSection:Toggle({
            Name = "مضاد التصويب (Anti Lock)",
            Flag = "AntiLock",
            Default = Desync, -- افتراضي من الأصلي
            Callback = function(a)
                Desync = a
            end
        })

        BreakerSection:Toggle({
            Name = "مضاد الشبكة",
            Flag = "NetworkDesync",
            Default = desyncsleep,
            Callback = function(a)
                desyncsleep = a
            end
        })

        BreakerSection:List({
            Name = "نوع مضاد التصويب",
            Flag = "AntiLockType",
            Options = {"Multiply", "Shake", "Behind", "Down", "Forward", "Left", "One", "Right", "Up", "Zero"},
            Default = AntiLockType,
            Callback = function(a)
                AntiLockType = a
            end
        })

        -- تبويب الرؤية (Visuals)
        local Tab4 = Window:Tab({Name = "الرؤية"})
        local ESPSection = Tab4:Section({Name = "ESP العام", Side = "Left"})

        ESPSection:Toggle({
            Name = "استخدام صندوق الربط",
            Flag = "UseBoundingBox",
            Default = getgenv().esp.UseBoundingBox,
            Callback = function(v)
                getgenv().esp.UseBoundingBox = v
            end
        })

        ESPSection:Toggle({
            Name = "تفعيل الصندوق",
            Flag = "BoxEnabled",
            Default = getgenv().esp.BoxEnabled,
            Callback = function(v)
                getgenv().esp.BoxEnabled = v
            end
        }):Colorpicker({
            Name = "لون الصندوق",
            Flag = "BoxColor",
            Default = getgenv().esp.BoxColor,
            Callback = function(a)
                getgenv().esp.BoxColor = a
            end
        })

        ESPSection:Toggle({
            Name = "زوايا الصندوق",
            Flag = "BoxCorners",
            Default = getgenv().esp.BoxCorners,
            Callback = function(v)
                getgenv().esp.BoxCorners = v
            end
        })

        ESPSection:Toggle({
            Name = "صندوق ديناميكي",
            Flag = "BoxDynamic",
            Default = getgenv().esp.BoxDynamic,
            Callback = function(v)
                getgenv().esp.BoxDynamic = v
            end
        })

        ESPSection:Slider({
            Name = "عرض الصندوق",
            Flag = "BoxStaticXFactor",
            Min = 0.1,
            Max = 3,
            Default = getgenv().esp.BoxStaticXFactor,
            Decimals = 0.01,
            Suffix = "X",
            Callback = function(a)
                getgenv().esp.BoxStaticXFactor = a
            end
        })

        ESPSection:Slider({
            Name = "ارتفاع الصندوق",
            Flag = "BoxStaticYFactor",
            Min = 0.1,
            Max = 3,
            Default = getgenv().esp.BoxStaticYFactor,
            Decimals = 0.01,
            Suffix = "Y",
            Callback = function(a)
                getgenv().esp.BoxStaticYFactor = a
            end
        })

        ESPSection:Toggle({
            Name = "الهيكل العظمي",
            Flag = "SkeletonEnabled",
            Default = getgenv().esp.SkeletonEnabled,
            Callback = function(v)
                getgenv().esp.SkeletonEnabled = v
            end
        }):Colorpicker({
            Name = "لون الهيكل العظمي",
            Flag = "SkeletonColor",
            Default = getgenv().esp.SkeletonColor,
            Callback = function(a)
                getgenv().esp.SkeletonColor = a
            end
        })

        ESPSection:Slider({
            Name = "أقصى مسافة للهيكل العظمي",
            Flag = "SkeletonMaxDistance",
            Min = 100,
            Max = 1000,
            Default = getgenv().esp.SkeletonMaxDistance,
            Suffix = "م",
            Callback = function(a)
                getgenv().esp.SkeletonMaxDistance = a
            end
        })

        ESPSection:Toggle({
            Name = "التشام (Chams)",
            Flag = "ChamsEnabled",
            Default = getgenv().esp.ChamsEnabled,
            Callback = function(v)
                getgenv().esp.ChamsEnabled = v
            end
        })

        ESPSection:Colorpicker({
            Name = "لون الداخلي",
            Flag = "ChamsInnerColor",
            Default = getgenv().esp.ChamsInnerColor,
            Callback = function(a)
                getgenv().esp.ChamsInnerColor = a
            end
        }):Colorpicker({
            Name = "لون الخارجي",
            Flag = "ChamsOuterColor",
            Default = getgenv().esp.ChamsOuterColor,
            Callback = function(a)
                getgenv().esp.ChamsOuterColor = a
            end
        })

        ESPSection:Slider({
            Name = "شفافية الداخلي",
            Flag = "ChamsInnerTransparency",
            Min = 0,
            Max = 1,
            Default = getgenv().esp.ChamsInnerTransparency,
            Decimals = 0.01,
            Callback = function(a)
                getgenv().esp.ChamsInnerTransparency = a
            end
        })

        ESPSection:Slider({
            Name = "شفافية الخارجي",
            Flag = "ChamsOuterTransparency",
            Min = 0,
            Max = 1,
            Default = getgenv().esp.ChamsOuterTransparency,
            Decimals = 0.01,
            Callback = function(a)
                getgenv().esp.ChamsOuterTransparency = a
            end
        })

        ESPSection:Toggle({
            Name = "النص",
            Flag = "TextEnabled",
            Default = getgenv().esp.TextEnabled,
            Callback = function(v)
                getgenv().esp.TextEnabled = v
            end
        }):Colorpicker({
            Name = "لون النص",
            Flag = "TextColor",
            Default = getgenv().esp.TextColor,
            Callback = function(a)
                getgenv().esp.TextColor = a
            end
        })

        ESPSection:Toggle({
            Name = "شريط الصحة",
            Flag = "HealthBarEnabled",
            Default = getgenv().esp.BarLayout['health'].enabled,
            Callback = function(v)
                getgenv().esp.BarLayout['health'].enabled = v
            end
        })

        ESPSection:Toggle({
            Name = "وضع الهدف فقط",
            Flag = "TargetOnly",
            Default = getgenv().esp.TargetOnly,
            Callback = function(v)
                getgenv().esp.TargetOnly = v
            end
        })

        -- قسم الرصاص (Bullets)
        local BulletSection = Tab4:Section({Name = "مسارات الرصاص", Side = "Right"})

        BulletSection:Toggle({
            Name = "تفعيل",
            Flag = "BulletTrailsEnabled",
            Default = Configurations.Visuals.Bullet_Trails.Enabled,
            Callback = function(v)
                Configurations.Visuals.Bullet_Trails.Enabled = v
            end
        }):Colorpicker({
            Name = "لون",
            Flag = "BulletTrailsColor",
            Default = Configurations.Visuals.Bullet_Trails.Color,
            Callback = function(a)
                Configurations.Visuals.Bullet_Trails.Color = a
            end
        })

        BulletSection:Toggle({
            Name = "تلاشي",
            Flag = "BulletTrailsFade",
            Default = Configurations.Visuals.Bullet_Trails.Fade,
            Callback = function(v)
                Configurations.Visuals.Bullet_Trails.Fade = v
            end
        })

        BulletSection:Slider({
            Name = "الحجم",
            Flag = "BulletTrailsWidth",
            Min = 0.01,
            Max = 5,
            Default = Configurations.Visuals.Bullet_Trails.Width,
            Suffix = "%",
            Decimals = 0.01,
            Callback = function(a)
                Configurations.Visuals.Bullet_Trails.Width = a
            end
        })

        BulletSection:Slider({
            Name = "المدة",
            Flag = "BulletTrailsDuration",
            Min = 0.01,
            Max = 10,
            Default = Configurations.Visuals.Bullet_Trails.Duration,
            Suffix = "%",
            Decimals = 0.01,
            Callback = function(a)
                Configurations.Visuals.Bullet_Trails.Duration = a
            end
        })

        BulletSection:List({
            Name = "الملمس",
            Flag = "BulletTrailsTexture",
            Options = {"Cool", "Cum", "Electro", "None"},
            Default = Configurations.Visuals.Bullet_Trails.Texture,
            Callback = function(a)
                Configurations.Visuals.Bullet_Trails.Texture = a
            end
        })

        -- قسم اللاعب المحلي (Local Player)
        local LocalSection = Tab4:Section({Name = "اللاعب المحلي", Side = "Right"})

        LocalSection:Toggle({
            Name = "مسار (Trail)",
            Flag = "SelfTrail",
            Default = false,
            Callback = function(v)
                utility.trail_character(v)
            end
        }):Colorpicker({
            Name = "لون المسار",
            Flag = "TrailColor",
            Default = getgenv().TrailColor,
            Callback = function(a)
                getgenv().TrailColor = a
            end
        })

        LocalSection:Toggle({
            Name = "تشام الذات",
            Flag = "SelfCham",
            Default = localPlayerEsp.ForcefieldBody.Enabled,
            Callback = function(a)
                localPlayerEsp.ForcefieldBody.Enabled = a
                applyForcefieldToBody()
            end
        }):Colorpicker({
            Name = "لون الذات",
            Flag = "SelfChamColor",
            Default = localPlayerEsp.ForcefieldBody.Color,
            Callback = function(a)
                localPlayerEsp.ForcefieldBody.Color = a
                applyForcefieldToBody()
            end
        })

        LocalSection:Toggle({
            Name = "تشام السلاح",
            Flag = "GunCham",
            Default = localPlayerEsp.ForcefieldTools.Enabled,
            Callback = function(a)
                localPlayerEsp.ForcefieldTools.Enabled = a
                applyForcefieldToTools()
            end
        }):Colorpicker({
            Name = "لون السلاح",
            Flag = "GunChamColor",
            Default = localPlayerEsp.ForcefieldTools.Color,
            Callback = function(a)
                localPlayerEsp.ForcefieldTools.Color = a
                applyForcefieldToTools()
            end
        })

        LocalSection:Toggle({
            Name = "تشام الإكسسوارات",
            Flag = "AccessoriesCham",
            Default = localPlayerEsp.ForcefieldHats.Enabled,
            Callback = function(a)
                localPlayerEsp.ForcefieldHats.Enabled = a
                applyForcefieldToHats()
            end
        }):Colorpicker({
            Name = "لون الإكسسوارات",
            Flag = "AccessoriesChamColor",
            Default = localPlayerEsp.ForcefieldHats.Color,
            Callback = function(a)
                localPlayerEsp.ForcefieldHats.Color = a
                applyForcefieldToHats()
            end
        })

        -- قسم الصليب (Crosshair)
        local CrossSection = Tab4:Section({Name = "الصليب التصويب", Side = "Right"})

        CrossSection:Toggle({
            Name = "تفعيل",
            Flag = "CrosshairEnabled",
            Default = getgenv().crosshair.enabled,
            Callback = function(v)
                getgenv().crosshair.enabled = v
            end
        }):Colorpicker({
            Name = "لون",
            Flag = "CrosshairColor",
            Default = getgenv().crosshair.color,
            Callback = function(a)
                getgenv().crosshair.color = a
            end
        })

        CrossSection:Toggle({
            Name = "دوران",
            Flag = "CrosshairSpin",
            Default = getgenv().crosshair.spin,
            Callback = function(v)
                getgenv().crosshair.spin = v
            end
        })

        CrossSection:Toggle({
            Name = "تغيير الحجم",
            Flag = "CrosshairResize",
            Default = getgenv().crosshair.resize,
            Callback = function(v)
                getgenv().crosshair.resize = v
            end
        })

        CrossSection:Toggle({
            Name = "الالتصاق بالهدف",
            Flag = "CrosshairSticky",
            Default = getgenv().crosshair.sticky,
            Callback = function(v)
                getgenv().crosshair.sticky = v
            end
        })

        CrossSection:List({
            Name = "الموضع",
            Flag = "CrosshairPosition",
            Options = {"وسط", "الفأرة"},
            Default = crosshair_position or "وسط",
            Callback = function(a)
                crosshair_position = a
            end
        })

        -- تبويب الحركة (Movement)
        local Tab5 = Window:Tab({Name = "الحركة"})
        local MoveSection = Tab5:Section({Name = "السرعة والطيران", Side = "Left"})

        MoveSection:Button({
            Name = "تحميل الزر الخفي (Invisible)",
            Callback = function()
                if Hide11 then
                    Library:Notification("تم التحميل مسبقًا.", 3)
                    return
                end

                local HideEnabled = false
                Hide11 = true
                local LastCFrame

                MakeButton("خفي", Color3.fromRGB(255, 0, 0), function(state)
                    HideEnabled = state

                    if not HideEnabled then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = LastCFrame
                        end
                    else
                        LastCFrame = nil
                    end
                end)

                RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character then
                        local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                        if HumanoidRootPart then
                            local Offset = HumanoidRootPart.CFrame * CFrame.new(9e9, 0, 9e9)

                            if HideEnabled then
                                LastCFrame = HumanoidRootPart.CFrame
                                HumanoidRootPart.CFrame = Offset
                                RunService.RenderStepped:Wait()
                                HumanoidRootPart.CFrame = LastCFrame
                            end
                        end
                    end
                end)

                local HookMethod
                HookMethod = hookmetamethod(game, "__index", newcclosure(function(self, key)
                    if not checkcaller() and key == "CFrame" and HideEnabled and 
                       LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                       LocalPlayer.Character:FindFirstChild("Humanoid") and 
                       LocalPlayer.Character.Humanoid.Health > 0 then
                        if self == LocalPlayer.Character.HumanoidRootPart and LastCFrame then
                            return LastCFrame
                        end
                    end
                    return HookMethod(self, key)
                end))
            end
        })

        MoveSection:Button({
            Name = "تحميل سرعة CFrame",
            Callback = function()
                if MacroAlreadLoaded then
                    Library:Notification("تم التحميل مسبقًا.", 3)
                    return
                end
                
                MacroAlreadLoaded = true
                MakeButton("سرعة", Color3.fromRGB(155, 0, 155), function(state)
                    Psalms.Tech.cframespeedtoggle = state
                end)
            end
        })

        MoveSection:Button({
            Name = "تحميل الطيران",
            Callback = function()
                if Macro2 then
                    Library:Notification("تم التحميل مسبقًا.", 3)
                    return
                end

                Macro2 = true

                speeds = Psalms.Tech.speedvalue

                local speaker = game:GetService("Players").LocalPlayer

                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

                nowe = false

                MakeButton("طيران", Color3.fromRGB(255, 0, 155), function(state)
                    niga2 = state

                    if nowe == true then
                        nowe = false

                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
                        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                    else 
                        nowe = true

                        for i = 1, speeds do
                            spawn(function()
                                local hb = game:GetService("RunService").Heartbeat	

                                tpwalking = true
                                local chr = game.Players.LocalPlayer.Character
                                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                                    if hum.MoveDirection.Magnitude > 0 then
                                        chr:TranslateBy(hum.MoveDirection)
                                    end
                                end
                            end)
                        end
                        game.Players.LocalPlayer.Character.Animate.Disabled = true
                        local Char = game.Players.LocalPlayer.Character
                        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

                        for i,v in next, Hum:GetPlayingAnimationTracks() do
                            v:AdjustSpeed(0)
                        end
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
                        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
                        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
                    end

                    if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
                        local plr = game.Players.LocalPlayer
                        local torso = plr.Character.Torso
                        local flying = true
                        local deb = true
                        local ctrl = {f = 0, b = 0, l = 0, r = 0}
                        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                        local maxspeed = 50
                        local speed = 0

                        local bg = Instance.new("BodyGyro", torso)
                        bg.P = 9e4
                        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                        bg.cframe = torso.CFrame
                        local bv = Instance.new("BodyVelocity", torso)
                        bv.velocity = Vector3.new(0,0.1,0)
                        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                        if nowe == true then
                            plr.Character.Humanoid.PlatformStand = true
                        end
                        while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                            game:GetService("RunService").RenderStepped:Wait()

                            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                                speed = speed+.5+(speed/maxspeed)
                                if speed > maxspeed then
                                    speed = maxspeed
                                end
                            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                                speed = speed-1
                                if speed < 0 then
                                    speed = 0
                                end
                            end
                            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                            else
                                bv.velocity = Vector3.new(0,0,0)
                            end
                            bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                        end
                        ctrl = {f = 0, b = 0, l = 0, r = 0}
                        lastctrl = {f = 0, b = 0, l = 0, r = 0}
                        speed = 0
                        bg:Destroy()
                        bv:Destroy()
                        plr.Character.Humanoid.PlatformStand = false
                        game.Players.LocalPlayer.Character.Animate.Disabled = false
                        tpwalking = false
                    else
                        local plr = game.Players.LocalPlayer
                        local UpperTorso = plr.Character.UpperTorso
                        local flying = true
                        local deb = true
                        local ctrl = {f = 0, b = 0, l = 0, r = 0}
                        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                        local maxspeed = 50
                        local speed = 0

                        local bg = Instance.new("BodyGyro", UpperTorso)
                        bg.P = 9e4
                        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                        bg.cframe = UpperTorso.CFrame
                        local bv = Instance.new("BodyVelocity", UpperTorso)
                        bv.velocity = Vector3.new(0,0.1,0)
                        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                        if nowe == true then
                            plr.Character.Humanoid.PlatformStand = true
                        end
                        while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                            wait()

                            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                                speed = speed+.5+(speed/maxspeed)
                                if speed > maxspeed then
                                    speed = maxspeed
                                end
                            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                                speed = speed-1
                                if speed < 0 then
                                    speed = 0
                                end
                            end
                            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                            else
                                bv.velocity = Vector3.new(0,0,0)
                            end

                            bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                        end
                        ctrl = {f = 0, b = 0, l = 0, r = 0}
                        lastctrl = {f = 0, b = 0, l = 0, r = 0}
                        speed = 0
                        bg:Destroy()
                        bv:Destroy()
                        plr.Character.Humanoid.PlatformStand = false
                        game.Players.LocalPlayer.Character.Animate.Disabled = false
                        tpwalking = false
                    end
                end)

                game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
                    wait(0.7)
                    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
                    game.Players.LocalPlayer.Character.Animate.Disabled = false
                end)
            end
        })

        MoveSection:Slider({
            Name = "سرعة الطيران",
            Flag = "FlySpeed",
            Min = 0,
            Max = 10,
            Default = Psalms.Tech.speedvalue,
            Suffix = "%",
            Decimals = 0.1,
            Callback = function(a)
                Psalms.Tech.speedvalue = a
            end
        })

        -- قسم CSync (Strafe)
        local CSyncSection = Tab5:Section({Name = "CSync (الدوران)", Side = "Right"})

        CSyncSection:Toggle({
            Name = "تفعيل",
            Flag = "CSyncEnabled",
            Default = TargetAimbot.CSync.Enabled,
            Callback = function(a)
                TargetAimbot.CSync.Enabled = a
            end
        })

        CSyncSection:Toggle({
            Name = "التزييف",
            Flag = "CSyncVisualize",
            Default = TargetAimbot.CSync.Visualize,
            Callback = function(a)
                TargetAimbot.CSync.Visualize = a
            end
        })

        CSyncSection:List({
            Name = "النوع",
            Flag = "CSyncType",
            Options = {"Orbit", "Random", "Spiral", "Spherical", "Attach"},
            Default = TargetAimbot.CSync.Type,
            Callback = function(a)
                TargetAimbot.CSync.Type = a
            end
        })

        CSyncSection:Slider({
            Name = "المسافة",
            Flag = "CSyncDistance",
            Min = 0,
            Max = 100,
            Default = TargetAimbot.CSync.Distance,
            Decimals = 1,
            Callback = function(a)
                TargetAimbot.CSync.Distance = a
            end
        })

        CSyncSection:Slider({
            Name = "الارتفاع",
            Flag = "CSyncHeight",
            Min = 0,
            Max = 100,
            Default = TargetAimbot.CSync.Height,
            Decimals = 1,
            Callback = function(a)
                TargetAimbot.CSync.Height = a
            end
        })

        CSyncSection:Slider({
            Name = "السرعة",
            Flag = "CSyncSpeed",
            Min = 0,
            Max = 100,
            Default = TargetAimbot.CSync.Speed,
            Decimals = 1,
            Callback = function(a)
                TargetAimbot.CSync.Speed = a
            end
        })

        CSyncSection:Slider({
            Name = "كمية عشوائية",
            Flag = "CSyncRandomAmount",
            Min = 0,
            Max = 100,
            Default = TargetAimbot.CSync.RandomAmount,
            Decimals = 1,
            Callback = function(a)
                TargetAimbot.CSync.RandomAmount = a
            end
        })

        -- تبويب البيئة (Environment)
        local Tab6 = Window:Tab({Name = "البيئة"})
        local SkySection = Tab6:Section({Name = "السماء", Side = "Left"})

        SkySection:Toggle({
            Name = "تفعيل السماء",
            Flag = "SkyboxEnabled",
            Default = skyboxEnabled,
            Callback = function(a)
                skyboxEnabled = a
                changeSkybox()
            end
        })

        SkySection:List({
            Name = "نوع السماء",
            Flag = "SkyboxType",
            Options = {"1", "2", "3", "4", "5", "6", "7"},
            Default = "1",
            Callback = function(a)
                skyboxType = tonumber(a)
                changeSkybox()
            end
        })

        SkySection:Button({
            Name = "تغيير",
            Callback = function()
                changeSkybox()
            end
        })

        local FogSection = Tab6:Section({Name = "الضباب", Side = "Left"})

        FogSection:Toggle({
            Name = "تفعيل الضباب",
            Flag = "FogEnabled",
            Default = Environment.Settings.FogEnabled,
            Callback = function(a)
                Environment.Settings.FogEnabled = a
                fogmaker()
            end
        })

        FogSection:Colorpicker({
            Name = "لون الضباب",
            Flag = "FogColor",
            Default = Environment.Settings.FogColor,
            Callback = function(a)
                Environment.Settings.FogColor = a
                fogmaker() 
            end
        })

        FogSection:Textbox({
            Name = "بداية الضباب",
            Flag = "FogStart",
            Default = Environment.Settings.FogStart,
            Callback = function(a)
                Environment.Settings.FogStart = tonumber(a)
                fogmaker()
            end
        })

        FogSection:Textbox({
            Name = "نهاية الضباب",
            Flag = "FogEnd",
            Default = Environment.Settings.FogEnd,
            Callback = function(a)
                Environment.Settings.FogEnd = tonumber(a)
                fogmaker() 
            end
        })

        local EnvSection = Tab6:Section({Name = "الإضاءة", Side = "Right"})

        EnvSection:Toggle({
            Name = "تفعيل",
            Flag = "WorldEnabled",
            Default = Environment.Settings.Enabled,
            Callback = function(a)
                Environment.Settings.Enabled = a
                UpdateWorld()
            end
        })

        EnvSection:Toggle({
            Name = "الظلال العامة",
            Flag = "GlobalShadows",
            Default = Environment.Settings.GlobalShadows,
            Callback = function(a)
                Environment.Settings.GlobalShadows = a
                UpdateWorld()
            end
        })

        EnvSection:Textbox({
            Name = "التعرض",
            Flag = "Exposure",
            Default = Environment.Settings.Exposure,
            Callback = function(a)
                Environment.Settings.Exposure = tonumber(a)
                UpdateWorld()
            end
        })

        EnvSection:Colorpicker({
            Name = "تحول اللون - أسفل",
            Flag = "ColorShiftBottom",
            Default = Environment.Settings.ColorShift_Bottom,
            Callback = function(a)
                Environment.Settings.ColorShift_Bottom = a
                UpdateWorld()
            end
        }):Colorpicker({
            Name = "تحول اللون - أعلى",
            Flag = "ColorShiftTop",
            Default = Environment.Settings.ColorShift_Top,
            Callback = function(a)
                Environment.Settings.ColorShift_Top = a
                UpdateWorld()
            end
        })

        EnvSection:Textbox({
            Name = "وقت الساعة",
            Flag = "ClockTime",
            Default = Environment.Settings.ClockTime,
            Callback = function(a)
                Environment.Settings.ClockTime = tonumber(a)
                UpdateWorld()
            end
        })

        EnvSection:Colorpicker({
            Name = "لون الإضاءة المحيطة",
            Flag = "AmbientColor",
            Default = Environment.Settings.Ambient,
            Callback = function(a)
                Environment.Settings.Ambient = a
                UpdateWorld()
            end
        })

        EnvSection:Colorpicker({
            Name = "لون الإضاءة الخارجية",
            Flag = "OutdoorAmbientColor",
            Default = Environment.Settings.OutdoorAmbient,
            Callback = function(a)
                Environment.Settings.OutdoorAmbient = a
                UpdateWorld()
            end
        })

        EnvSection:Textbox({
            Name = "السطوع",
            Flag = "Brightness",
            Default = Environment.Settings.Brightness,
            Callback = function(a)
                Environment.Settings.Brightness = tonumber(a)
                UpdateWorld()
            end
        })

        -- تبويب الدرجة المتدرجة (Gradient Silent)
        local Tab7 = Window:Tab({Name = "الدرجة المتدرجة الصامتة"})
        local GradSection = Tab7:Section({Name = "إعدادات الدرجة المتدرجة", Side = "Right"})

        GradSection:Toggle({
            Name = "تفعيل",
            Flag = "ShowSilent",
            Default = Frame.Visible,
            Callback = function(dang)
                Frame.Visible = dang
            end
        })

        GradSection:Toggle({
            Name = "صامت",
            Flag = "SilentEnabled",
            Default = Psalms.Tech.SilentMode,
            Callback = function(dang)
                Psalms.Tech.SilentMode = dang
            end
        })

        GradSection:List({
            Name = "الوضع",
            Flag = "FOVGradientPosition",
            Options = {"الفأرة", "الوسط"},
            Default = "الوسط",
            Callback = function(a)
                mode = a
            end
        })

        GradSection:Colorpicker({
            Name = "لون 1",
            Flag = "SilentGradientColor",
            Default = coluhhh,
            Callback = function(a)
                gradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, a),
                    ColorSequenceKeypoint.new(1, coluhhh2)
                }
            end
        })

        GradSection:Colorpicker({
            Name = "لون 2",
            Flag = "SilentFovGradient2",
            Default = coluhhh2,
            Callback = function(a)
                gradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, coluhhh),
                    ColorSequenceKeypoint.new(1, a)
                }
            end
        })

        GradSection:Slider({
            Name = "الحجم",
            Flag = "SilentFovSize",
            Min = 1,
            Max = 200,
            Default = 125,
            Suffix = "%",
            Decimals = 1,
            Callback = function(a)
                local fovRadius = a
                UpdateFrameSize(a)
            end
        })

        -- تبويب الشخصية (Character)
        local Tab8 = Window:Tab({Name = "الشخصية"})
        local AvatarSection = Tab8:Section({Name = "الشخصية", Side = "Right"})

        local OutfitList = AvatarSection:List({
            Name = "الملابس",
            Flag = "OutfitSelection",
            Options = {}
        })

        local CurrentOutfits = {}

        local function UpdateOutfitList()
            local Outfits = {}
            local userId = Players.LocalPlayer.UserId
            local url = "https://avatar.roblox.com/v1/users/" .. userId .. "/outfits"

            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)

            if success and response and response.data then
                for _, outfit in ipairs(response.data) do
                    if outfit.isEditable then
                        table.insert(Outfits, outfit.name)
                        CurrentOutfits[outfit.name] = outfit.id
                    end
                end

                if #Outfits ~= #OutfitList.Options or table.concat(Outfits) ~= table.concat(OutfitList.Options) then
                    OutfitList.Options = Outfits
                    if OutfitList.Refresh then
                        OutfitList:Refresh(Outfits)
                    end
                end
            end
        end

        local function EquipOutfit(outfitName)
            local outfitId = CurrentOutfits[outfitName]
            if outfitId then
                local description = Players:GetHumanoidDescriptionFromOutfitId(outfitId)
                AvatarEditorService:PromptSaveAvatar(description, Enum.HumanoidRigType.R15)

                local result = AvatarEditorService.PromptSaveAvatarCompleted:Wait()
                if result == Enum.AvatarPromptResult.Success then
                    Players.LocalPlayer.Character.Humanoid.Health = 0
                end
            end
        end

        OutfitList.Callback = function(selectedOutfit)
            EquipOutfit(selectedOutfit)
        end

        AvatarSection:Button({
            Name = "تحديث",
            Callback = UpdateOutfitList
        })

        local FOVSection = Tab8:Section({Name = "الكاميرا", Side = "Right"})

        FOVSection:Slider({
            Name = "مجال الرؤية",
            Flag = "FieldOfView",
            Min = 5,
            Max = 130,
            Default = 80,
            Suffix = "",
            Decimals = 0.1,
            Callback = function(a)
                Camera.FieldOfView = a
            end
        })

        local DanceSection = Tab8:Section({Name = "الرقص", Side = "Right"})

        local Configurations = {
            Misc = {
                Animation = {
                    Enabled = false,
                    SelectedDance = "Floss",
                    Speed = 2
                }
            }
        }

        local Dances = {
            Floss = 10714340543,
            Spin = 2516930867,
            Sit = 807343012,
            ArmSpin = 900850443,
            Lay = 2695918332,
        }

        local currentAnimation

        local function AnimPlay(ID, SPEED)
            if currentAnimation then
                currentAnimation:Stop()
            end

            local animation = Instance.new('Animation')
            animation.AnimationId = 'rbxassetid://' .. ID

            currentAnimation = LocalPlayer.Character.Humanoid:LoadAnimation(animation)
            currentAnimation:Play()
            currentAnimation:AdjustSpeed(tonumber(SPEED) or 1)

            animation:Destroy()
        end

        DanceSection:Slider({
            Name = "سرعة الرقص",
            Flag = "DanceSpeed",
            Min = 0,
            Max = 1000, 
            Default = Configurations.Misc.Animation.Speed,
            Suffix = "",
            Decimals = 0.001,
            Callback = function(a)
                Configurations.Misc.Animation.Speed = a
            end
        })

        DanceSection:List({
            Name = "نوع الرقص",
            Flag = "DanceType",
            Options = {"Floss", "Spin", "Sit", "ArmSpin", "Lay"},
            Default = "Floss",
            Callback = function(a)
                Configurations.Misc.Animation.SelectedDance = a
            end
        })

        DanceSection:Toggle({
            Name = "رقص",
            Flag = "Animate",
            Default = Configurations.Misc.Animation.Enabled,
            Callback = function(state)
                Configurations.Misc.Animation.Enabled = state
                if Configurations.Misc.Animation.Enabled then
                    local selectedDance = Dances[Configurations.Misc.Animation.SelectedDance or "Floss"]
                    if selectedDance then
                        AnimPlay(selectedDance, Configurations.Misc.Animation.Speed or 1)
                    end
                else
                    if currentAnimation then
                        currentAnimation:Stop()
                        currentAnimation = nil
                    end
                end
            end
        })

        LocalPlayer.CharacterAdded:Connect(function(character)
            character:WaitForChild("Humanoid")
            if Configurations.Misc.Animation.Enabled then
                local selectedDance = Dances[Configurations.Misc.Animation.SelectedDance or "Floss"]
                if selectedDance then
                    AnimPlay(selectedDance, Configurations.Misc.Animation.Speed or 1)
                end
            end
        end)

        -- تبويب الإعدادات (Config)
        local Tab9 = Window:Tab({Name = "الإعدادات"})
        local ConfigSection = Tab9:Section({Name = "إدارة الإعدادات", Zindex = 2})

        if not isfolder("Psalms") then makefolder("Psalms") end
        if not isfolder("Psalms/Configs") then makefolder("Psalms/Configs") end

        local ConfigList = ConfigSection:List({Name = "الإعدادات", Flag = "SettingConfigurationList", Options = {}})
        ConfigSection:Textbox({Flag = "SettingsConfigurationName", Name = "اسم الإعداد"})

        local CurrentList = {}

        local function UpdateConfigList()
            local List = {}
            for _, file in ipairs(listfiles("Psalms/Configs")) do
                local FileName = file:match("Psalms/Configs/(.+)%.cfg")
                if FileName then
                    table.insert(List, FileName)
                end
            end

            if #List ~= #CurrentList or table.concat(List) ~= table.concat(CurrentList) then
                CurrentList = List
                ConfigList:Refresh(CurrentList)
            end
        end

        ConfigSection:Button({Name = "إنشاء", Callback = function()
            local ConfigName = Flags.SettingsConfigurationName
            if ConfigName and ConfigName ~= "" and not isfile("Psalms/Configs/" .. ConfigName .. ".cfg") then
                writefile("Psalms/Configs/" .. ConfigName .. ".cfg", "")
                UpdateConfigList()
            end
        end})

        ConfigSection:Button({Name = "حفظ", Callback = function()
            local SelectedConfig = Flags.SettingConfigurationList
            if SelectedConfig then
                writefile("Psalms/Configs/" .. SelectedConfig .. ".cfg", Library:GetConfig())
            end
        end})

        ConfigSection:Button({Name = "تحميل", Callback = function()
            local SelectedConfig = Flags.SettingConfigurationList
            if SelectedConfig then
                local Content = readfile("Psalms/Configs/" .. SelectedConfig .. ".cfg")
                Library:LoadConfig(Content)
            end
        end})

        ConfigSection:Button({Name = "حذف", Callback = function()
            local SelectedConfig = Flags.SettingConfigurationList
            if SelectedConfig and isfile("Psalms/Configs/" .. SelectedConfig .. ".cfg") then
                delfile("Psalms/Configs/" .. SelectedConfig .. ".cfg")
                UpdateConfigList()
            end
        end})

        ConfigSection:Button({Name = "تحديث", Callback = function()
            pcall(UpdateConfigList)
        end})

        ConfigSection:Keybind({
            Name = "مفتاح القائمة",
            Flag = "MenuKey",
            UseKey = true,
            Default = Enum.KeyCode.End,
            Callback = function(State)
                Library.UIKey = State
            end
        })

        ConfigSection:Colorpicker({
            Name = "لون القائمة",
            Flag = "MenuAccent",
            Default = Library.Accent,
            Callback = function(State)
                Library:ChangeAccent(State)
            end
        })

        ConfigSection:Toggle({
            Name = "إظهار العلامة المائية",
            Flag = "Watermark",
            Default = true,
            Callback = function(State)
                Watermark:SetVisible(State)
            end
        })

        local waterbitch = "Psalms.Tech"
        ConfigSection:Toggle({
            Name = "تحديث العلامة",
            Flag = "CustomMark",
            Default = stats.Update,
            Callback = function(State)
                stats.Update = State
                if not stats.Update then
                    Watermark:UpdateText(waterbitch)
                end
            end
        })

        ConfigSection:Textbox({
            Flag = "WatermarkText",
            Name = "نص العلامة المائية",
            State = "$$ Psalms.Tech $$", 
            Callback = function(State)
                waterbitch = State
                if not stats.Update then
                    Watermark:UpdateText(waterbitch)
                end
            end
        })

        -- إغلاق القائمة افتراضيًا
        Library:SetOpen(false)

        local Ui22 = Instance.new("ScreenGui")
        Ui22.Name = "Ui22"
        Ui22.Parent = game.CoreGui
        Ui22.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Ui22.ResetOnSpawn = false

        local Image3 = Instance.new("ImageButton")
        Image3.Name = "Image3"
        Image3.Parent = Ui22
        Image3.Active = true
        Image3.Draggable = true
        Image3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Image3.BackgroundTransparency = 1
        Image3.Size = UDim2.new(0, 90, 0, 90)
        Image3.Image = "rbxassetid://92324433288253"
        Image3.Position = UDim2.new(1, -95, 0, 5)

        local Ui2corner = Instance.new("UICorner")
        Ui2corner.CornerRadius = UDim.new(0.2, 0)
        Ui2corner.Parent = Image3

        local Open = false
        Image3.MouseButton1Click:Connect(function()
            Open = not Open
            Library:SetOpen(Open)
        end)

        local loadingTime = os.clock() - startTime
        Library:Notification(string.format("تم التحميل بنجاح. وقت التحميل: %.3f ثانية", loadingTime), 3)

        toggleAimViewer()
    end
end

-- تشغيل السكريبت (دعم جميع المابات بدون تحقق PlaceId)
cooked(true)
