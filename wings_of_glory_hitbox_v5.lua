-- Wings of Glory Hitbox Expander v5 – Team-Safe + Fuselage Focus | Grok 2026
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 80  -- Massive for planes
local Transparency = 0.5  -- Semi-visible neon

local function expandFuselage(part)
    if part and part:IsA("BasePart") and (part.Name == "Fuselage" or part.Name == "Body" or part.Name == "RootPart" or part.Name == "PrimaryPart") then
        pcall(function()
            part.Size = Vector3.new(HitboxSize, HitboxSize * 0.6, HitboxSize)
            part.Transparency = Transparency
            part.CanCollide = false
            part.Material = Enum.Material.ForceField  -- Glows blue
            part.BrickColor = BrickColor.new("Bright blue")
        end)
    end
end

local function isEnemy(model)
    -- Skip self
    if model == LocalPlayer.Character then return false end
    
    -- Find owner/player
    local owner = model:FindFirstChild("Owner") or model:FindFirstChild("Pilot") or model.Parent:FindFirstChildOfClass("ObjectValue")
    local plr = Players:GetPlayerFromCharacter(model) or (owner and owner.Value)
    
    if plr and plr \~= LocalPlayer then
        -- Team check (skip teammates)
        if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            return false
        end
        return true
    end
    return false  -- Unknown = skip
end

local function findEnemyPlanes()
    local count = 0
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and isEnemy(obj) then
            -- Plane if has Fuselage/etc.
            if obj:FindFirstChild("Fuselage") or obj:FindFirstChild("Body") or obj:FindFirstChild("RootPart") then
                count = count + 1
            end
        end
    end
    print("Found " .. count .. " enemy planes! Expanding Fuselages...")
    return count > 0
end

-- Main loop (every frame)
RunService.Heartbeat:Connect(function()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and isEnemy(obj) then
            for _, part in pairs(obj:GetDescendants()) do
                expandFuselage(part)
            end
        end
    end
end)

-- Initial scan
spawn(function()
    wait(3)  -- Wait for spawn
    findEnemyPlanes()
end)

print("Wings of Glory Hitbox v5 Loaded! Size: " .. HitboxSize .. " – Teams Safe + Fuselage Only")
