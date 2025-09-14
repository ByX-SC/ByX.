-- Load Rayfield UI Library
local success, Rayfield = pcall(function() return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() end)
if not success then
    warn("Failed to load Rayfield: " .. tostring(Rayfield))
    return
end
print("Rayfield loaded successfully!")

-- Create the Window
local Window = Rayfield:CreateWindow({
    Name = "Anti OC Spray Final",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Optimized Anti OC Spray",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
    Theme = "DarkBlue"
})

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera

-- Anti OC Spray Logic
local antiOCSprayEnabled = false
local defaultWalkSpeed = 16
local defaultJumpPower = 25 -- Adjusted to match your game's default JumpPower
local connection = nil -- Initialize connection variable

local PlayerTab = Window:CreateTab("Anti OC", 4483362458)

PlayerTab:CreateToggle({
    Name = "Anti OC Spray",
    CurrentValue = false,
    Flag = "ANTI_OC_SPRAY_FINAL",
    Callback = function(Value)
        antiOCSprayEnabled = Value
        if antiOCSprayEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                defaultWalkSpeed = humanoid.WalkSpeed -- Save current WalkSpeed
                defaultJumpPower = humanoid.JumpPower or 25 -- Save or set default JumpPower
            end

            -- Monitor and disable effects
            connection = RunService.Heartbeat:Connect(function()
                if antiOCSprayEnabled then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        local hum = char.Humanoid
                        -- Maintain WalkSpeed and JumpPower
                        if hum.WalkSpeed ~= defaultWalkSpeed then
                            hum.WalkSpeed = defaultWalkSpeed
                            print("Restored WalkSpeed to: " .. defaultWalkSpeed)
                        end
                        if hum.JumpPower ~= defaultJumpPower then
                            hum.JumpPower = defaultJumpPower
                            print("Restored JumpPower to: " .. defaultJumpPower)
                        end
                    end

                    -- Disable only OC Spray related GUI
                    local playerGui = LocalPlayer.PlayerGui
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and gui.Enabled and (gui.Name:lower():find("pepper") or gui.Name:lower():find("spray") or gui.Name:lower():find("ocspray")) then
                            gui.Enabled = false
                            print("Disabled OC Spray GUI: " .. gui.Name)
                        end
                    end

                    -- Check Lighting effects
                    for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
                        if (effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect")) and effect.Enabled then
                            effect.Enabled = false
                            print("Disabled visual effect: " .. effect.Name)
                        end
                    end
                end
            end)

            -- Monitor Backpack for OC Spray
            LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if antiOCSprayEnabled and child.Name == "OC Spray" then
                    local localScript = child:FindFirstChild("LocalScript")
                    if localScript then
                        localScript.Disabled = true
                        print("Disabled OC Spray LocalScript")
                    end
                end
            end)

            Rayfield:Notify({
                Title = "Protection Activated",
                Content = "Anti OC Spray enabled. Check console if needed.",
                Duration = 5,
                Image = 4483362458
            })
        else
            if connection then
                connection:Disconnect() -- Disconnect only if connection exists
            end
            Rayfield:Notify({
                Title = "Protection Deactivated",
                Content = "Anti OC Spray disabled.",
                Duration = 5,
                Image = 4483362458
            })
        end
    end
})

print("Anti OC Spray Final UI loaded! Toggle to test.")
