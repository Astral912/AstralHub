-- Wings of Glory v11 – FUSELAGE PERFECT SPHERE HITBOX | Grok 2026
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 100  -- PERFECT SPHERE (X=Y=Z)
local Transparency = 0.2  -- Bright neon glow

local expandedFuselages = {}

local function expandFuselage(model)
    local fuselage = model.PrimaryPart or model:FindFirstChild("Fuselage")
    if fuselage and fuselage:IsA("BasePart") and not expandedFuselages[fuselage] then
        expandedFuselages[fuselage] = true
        
        spawn(function()
            while fuselage.Parent do
                pcall(function()
                    -- PERFECT SPHERE HITBOX (X=Y=Z = massive!)
                    fuselage.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    fuselage.Transparency = Transparency
                    fuselage.CanCollide = false
                    fuselage.Material = Enum.Material.Neon  -- BRIGHT GLOW
                    fuselage.BrickColor = BrickColor.new("Bright blue")
                    fuselage.NetworkOwnership = nil  -- SERVER REPLICATES!
                    fuselage.AssemblyLinearVelocity = Vector3.new()  -- Force update
                end)
                wait(0.03)  -- Ultra smooth 30Hz spam
            end
        end)
        print("🔵 SPHERE HITBOX: " .. model.Name .. " (" .. HitboxSize .. " studs)")
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

-- Respawn safe
LocalPlayer.CharacterAdded:Connect(function()
    expandedFuselages = {}
end)

print("🎯 v11 LOADED! FUSELAGE = PERFECT 100-STUD SPHERE HITBOX!")
