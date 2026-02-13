-- Wings of Glory Hitbox Expander v2 by Grok (2026) | Clean & Updated for Planes
-- Expands enemy plane parts (Fuselage, Body, Wings, etc.) + player placeholders
-- Adjustable size via variables below

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 35 -- Change this (20-50 recommended for planes)
local Transparency = 0.75 -- 0 = visible, 1 = invisible
local UpdateRate = 1/30 -- FPS-like loop (higher = smoother but more lag)

local expandedParts = {} -- Cache to avoid spam

local function expandPart(part)
    if part:IsA("BasePart") and part.Parent \~= LocalPlayer.Character and part.Size.Magnitude < 100 then
        part.OriginalSize = part.Size -- Backup (optional)
        part.Size = Vector3.new(HitboxSize, HitboxSize / 2, HitboxSize) -- Wider for planes
        part.Transparency = Transparency
        part.CanCollide = false
        part.Material = Enum.Material.ForceField -- Neon glow optional
        expandedParts[part] = true
    end
end

local function getEnemyPlanes()
    local enemies = {}
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") then
            -- Check for plane models (common names/parts in WoG)
            local hasPlanePart = obj:FindFirstChild("Fuselage") or obj:FindFirstChild("Body") or 
                                 obj:FindFirstChild("Wings") or obj:FindFirstChild("RootPart") or 
                                 obj:FindFirstChild("PrimaryPart") or obj.Name:lower():find("plane")
            if hasPlanePart then
                -- Skip if owned by you
                local owner = obj:FindFirstChild("Owner") or obj:FindFirstChild("Pilot") or obj:FindFirstChild(LocalPlayer.Name)
                if not owner or (owner:IsA("ObjectValue") and owner.Value \~= LocalPlayer) then
                    table.insert(enemies, obj)
                end
            end
        end
    end
    -- Also include player characters/placeholders
    for _, plr in pairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            table.insert(enemies, plr.Character)
        end
    end
    return enemies
end

-- Main loop
local connection
connection = RunService.Heartbeat:Connect(function()
    local planes = getEnemyPlanes()
    for _, model in pairs(planes) do
        for _, part in pairs(model:GetDescendants()) do
            expandPart(part)
        end
    end
    -- Clean cache every 5 sec
    if tick() % 5 < UpdateRate then
        expandedParts = {}
    end
end)

-- Cleanup on leave
Players.PlayerRemoving:Connect(function()
    if connection then
        connection:Disconnect()
    end
end)

print("Wings of Glory Hitbox Expander v2 loaded! Size:", HitboxSize)
