-- Wings of Glory Hitbox v7 – SERVER DOORS for REAL HITS + Visual | Grok 2026
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 60  -- Door size (big for planes)
local VisualSize = 80  -- Visual glow size

local doors = {}  -- Track doors to clean

local function createDoor(targetPart)
    if not targetPart or not targetPart.Parent then return end
    
    -- Visual expand (client)
    pcall(function()
        targetPart.Size = Vector3.new(VisualSize, VisualSize*0.6, VisualSize)
        targetPart.Transparency = 0.3
        targetPart.CanCollide = false
        targetPart.Material = Enum.Material.ForceField
        targetPart.BrickColor = BrickColor.new("Bright blue")
    end)
    
    -- Server door (invisible collision bubble)
    local door = targetPart:Clone()
    door.Name = targetPart.Name .. "_HitboxDoor"
    door.Size = Vector3.new(HitboxSize, HitboxSize*0.8, HitboxSize)
    door.Transparency = 1  -- Invisible
    door.CanCollide = true
    door.Anchored = false
    door.AssemblyLinearVelocity = Vector3.new()  -- Force replication
    door.Parent = Workspace
    
    -- Weld door to target (server sees collision)
    local weld = Instance.new("WeldConstraint", door)
    weld.Part0 = targetPart
    weld.Part1 = door
    
    doors[door] = targetPart  -- Track
end

RunService.Heartbeat:Connect(function()
    -- Expand/create doors on enemy models
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character then
            -- Target main parts (Fuselage/Body/Root – auto-finds largest)
            for _, part in pairs(model:GetDescendants()) do
                if part:IsA("BasePart") and part.Size.Magnitude > 3 then  -- Likely body
                    createDoor(part)
                end
            end
        end
    end
    
    -- Cleanup old doors every 2s
    if tick() % 2 < 0.1 then
        for door, _ in pairs(doors) do
            if door and door.Parent then door:Destroy() end
        end
        doors = {}
    end
end)

print("Hitbox v7 Loaded! Doors created (invisible hits + blue visual) – Shoot anywhere near enemies!")
