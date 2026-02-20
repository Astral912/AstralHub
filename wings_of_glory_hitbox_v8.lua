-- Wings of Glory Hitbox v8 – RESPAWN SAFE Doors + Visual | Anti-Crash | Grok 2026
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 60
local VisualSize = 80

local doors = {}
local connections = {}

local function cleanupDoors()
    for door, _ in pairs(doors) do
        if door and door.Parent then
            door:Destroy()
        end
    end
    doors = {}
end

local function createDoor(model)
    if doors[model] then return end  -- 1 door per model
    
    -- Find largest part (body/Fuselage)
    local largestPart = nil
    local maxSize = 0
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude > maxSize and part.Name ~= "HitboxDoor" then
            largestPart = part
            maxSize = part.Size.Magnitude
        end
    end
    
    if largestPart then
        -- Visual
        pcall(function()
            largestPart.Size = Vector3.new(VisualSize, VisualSize*0.6, VisualSize)
            largestPart.Transparency = 0.3
            largestPart.CanCollide = false
            largestPart.Material = Enum.Material.ForceField
            largestPart.BrickColor = BrickColor.new("Bright blue")
        end)
        
        -- Door
        local door = largestPart:Clone()
        door.Name = "HitboxDoor"
        door.Size = Vector3.new(HitboxSize, HitboxSize*0.8, HitboxSize)
        door.Transparency = 1
        door.CanCollide = true
        door.Anchored = false
        door.Parent = Workspace
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = largestPart
        weld.Part1 = door
        weld.Parent = door
        
        doors[model] = door
    end
end

local function updateDoors()
    cleanupDoors()  -- Fresh doors every frame (safe)
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character then
            createDoor(model)
        end
    end
end

-- Main loop
local conn = RunService.Stepped:Connect(updateDoors)

-- Respawn fix
LocalPlayer.CharacterAdded:Connect(function()
    cleanupDoors()
end)

-- Leave cleanup
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer.Parent then
        conn:Disconnect()
        cleanupDoors()
    end
end)

print("Hitbox v8 Loaded! Respawn-safe doors (Size 60 invisible hits + blue visual)")
