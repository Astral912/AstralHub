-- Wings of Glory v10+ – 3KM EASY HITS | Fuselage Beast Mode
-- Same as v10 but HitboxSize = 120 + smoother Stepped

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 120  -- 3KM range god
local Transparency = 0.2  -- Brighter glow

local expandedFuselages = {}

local function expandFuselage(model)
    local fuselage = model.PrimaryPart or model:FindFirstChild("Fuselage")
    if fuselage and fuselage:IsA("BasePart") and not expandedFuselages[fuselage] then
        expandedFuselages[fuselage] = true
        
        spawn(function()
            while fuselage.Parent do
                pcall(function()
                    fuselage.Size = Vector3.new(HitboxSize, HitboxSize * 0.7, HitboxSize)
                    fuselage.Transparency = Transparency
                    fuselage.CanCollide = false
                    fuselage.Material = Enum.Material.Neon  -- BRIGHTER
                    fuselage.BrickColor = BrickColor.new("Bright blue")
                    fuselage.NetworkOwnership = nil
                end)
                wait(0.05)  -- Faster spam = smoother
            end
        end)
        print("🚀 MAXED Fuselage: " .. model.Name)
    end
end

local function isEnemy(model)
    if model == LocalPlayer.Character then return false end
    local plr = Players:GetPlayerFromCharacter(model)
    return plr and (not plr.Team or plr.Team ~= LocalPlayer.Team)
end

RunService.Stepped:Connect(function()
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") and isEnemy(model) and model.PrimaryPart then
            expandFuselage(model)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    expandedFuselages = {}
end)

print("🎖️ v10+ LOADED! 3KM FUSELAGE BEAST MODE – UNSTOPPABLE!")
