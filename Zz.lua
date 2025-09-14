-- Load Rayfield UI Library
local success, Rayfield = pcall(function() return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() end)
if not success then
    warn("Failed to load Rayfield: " .. tostring(Rayfield))
    return
end
print("Rayfield loaded successfully!")

-- Create the Window
local Window = Rayfield:CreateWindow({
    Name = "Anti OC Spray Debug",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Debugging Anti OC Spray",
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

-- Anti OC Spray Logic
local antiOCSprayEnabled = false
local defaultWalkSpeed = 16
local defaultJumpPower = 25 -- Adjusted to match your game's default JumpPower

local PlayerTab = Window:CreateTab("Debug", 4483362458)

PlayerTab:CreateToggle({
    Name = "Anti OC Spray",
    CurrentValue = false,
    Flag = "ANTI_OC_SPRAY_DEBUG",
    Callback = function(Value)
        antiOCSprayEnabled = Value
        if antiOCSprayEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                defaultWalkSpeed = humanoid.WalkSpeed -- Save default speed
                defaultJumpPower = humanoid.JumpPower or 25 -- Save or set default JumpPower
            end

            -- Monitor and disable effects
            local connection = RunService.Heartbeat:Connect(function()
                if antiOCSprayEnabled then
                    -- Maintain WalkSpeed and JumpPower
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.WalkSpeed = defaultWalkSpeed
                        char.Humanoid.JumpPower = defaultJumpPower
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
                            print("Disabled effect: " .. effect.Name)
                        end
                    end
                else
                    connection:Disconnect()
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
                Title = "Debug Started",
                Content = "Anti OC Spray enabled. Check console for logs.",
                Duration = 5,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Debug Stopped",
                Content = "Anti OC Spray disabled.",
                Duration = 5,
                Image = 4483362458
            })
        end
    end
})

print("Anti OC Spray Debug UI loaded! Toggle to test and check console.")
