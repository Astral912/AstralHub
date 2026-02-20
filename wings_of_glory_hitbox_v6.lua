-- Wings of Glory Hitbox v6 – Expands ALL Enemy Models/Parts | Universal
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local HitboxSize = 80
local Transparency = 0.5

local function expandPart(part)
    if part and part:IsA("BasePart") and part.Size.Magnitude < 50 and part.Parent ~= LocalPlayer.Character then
        pcall(function()
            part.Size = Vector3.new(HitboxSize, HitboxSize*0.6, HitboxSize)
            part.Transparency = Transparency
            part.CanCollide = true
            part.Material = Enum.Material.ForceField
            part.BrickColor = BrickColor.new("Bright blue")
        end)
    end
end

RunService.Heartbeat:Connect(function()
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character then
            for _, part in pairs(model:GetDescendants()) do
                expandPart(part)
            end
        end
    end
end)

print("Hitbox v6 Loaded! Expanding ALL enemy parts (Size 80 blue glow)")
