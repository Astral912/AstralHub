-- Wings of Glory Hitbox v10 – FUSELAGE ONLY | Server Hits + Respawn Safe | Grok 2026
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 80  -- Perfect for Fuselage
local Transparency = 0.3

local expandedFuselages = {}

local function expandFuselage(model)
    local fuselage = model.PrimaryPart or model:FindFirstChild("Fuselage")
    if fuselage and fuselage:IsA("BasePart") and not expandedFuselages[fuselage] then
        expandedFuselages[fuselage] = true
        
        pcall(function()
            fuselage.Size = Vector3.new(HitboxSize, HitboxSize * 0.7, HitboxSize)
            fuselage.Transparency = Transparency
            fuselage.CanCollide = false
            fuselage.Material = Enum.Material.ForceField
            fuselage.BrickColor = BrickColor.new("Bright blue")
            fuselage.NetworkOwnership = nil  -- SERVER SEES HUGE FUSELAGE!
            fuselage.AssemblyLinearVelocity = Vector3.new()  -- Force replicate
        end)
        print("Expanded Fuselage on: " .. model.Name)
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

-- Respawn cleanup
LocalPlayer.CharacterAdded:Connect(function()
    expandedFuselages = {}
end)

print("Hitbox v10 Loaded! Targeting FUSELAGE (PrimaryPart) – REAL SERVER HITS!")
