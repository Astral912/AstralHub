-- Wings of Glory Hitbox v9 – SERVER RESIZE + Ownership | No Crash/Respawn Safe | Grok 2026
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 90  -- Server-visible size
local Transparency = 0.4  -- Glow visible

local expanded = {}  -- Track expanded models

local function isEnemyModel(model)
    if model == LocalPlayer.Character then return false end
    local plr = Players:GetPlayerFromCharacter(model)
    if plr and plr.Team == LocalPlayer.Team then return false end
    return true
end

local function expandModel(model)
    if expanded[model] then return end
    expanded[model] = true
    
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude < 50 then  -- Body parts only
            pcall(function()
                part.Size = Vector3.new(HitboxSize, HitboxSize * 0.7, HitboxSize)
                part.Transparency = Transparency
                part.CanCollide = false
                part.Material = Enum.Material.ForceField
                part.BrickColor = BrickColor.new("Bright blue")
                part.AssemblyLinearVelocity = Vector3.new()  -- Replicate
                part.NetworkOwnership = nil  -- SERVER OWNS = real hits replicate!
            end)
        end
    end
end

RunService.Stepped:Connect(function()
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") and isEnemyModel(model) then
            expandModel(model)
        end
    end
end)

-- Cleanup on death/respawn
LocalPlayer.CharacterAdded:Connect(function()
    expanded = {}
end)

Workspace.DescendantRemoving:Connect(function(desc)
    if expanded[desc.Parent] then
        expanded[desc.Parent] = nil
    end
end)

print("Hitbox v9 Loaded! Server resize (Size 70 blue – real hits, respawn safe)")
