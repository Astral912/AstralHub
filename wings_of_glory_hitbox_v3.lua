-- Wings of Glory Hitbox Expander v3 – Fixed for Delta | Grok 2026
-- Targets plane models + characters, skips self, no invalid properties

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or game.Players.LocalPlayer  -- Fallback

local HitboxSize = 35     -- Adjust (20-50 good for planes)
local Transparency = 0.75 -- 1 = fully invisible
local UpdateRate = 1/30   -- Smooth loop

local expanded = {}       -- Track to avoid re-processing

local function isValidPart(part)
    return part:IsA("BasePart") 
        and part.Parent 
        and part.Parent \~= (LocalPlayer.Character or nil)
        and part.Size.Magnitude < 100  -- Skip huge static parts
end

local function expandPart(part)
    if not isValidPart(part) then return end
    
    pcall(function()  -- Safe resize (ignores if locked)
        part.Size = Vector3.new(HitboxSize, HitboxSize / 2, HitboxSize)
        part.Transparency = Transparency
        part.CanCollide = false
        part.Material = Enum.Material.ForceField
    end)
    
    expanded[part] = true
end

local function findTargets()
    local targets = {}
    
    -- Plane models in workspace
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") then
            local hasPlane = obj:FindFirstChild("Fuselage") or obj:FindFirstChild("Body") 
                          or obj:FindFirstChild("Wings") or obj:FindFirstChild("RootPart") 
                          or obj:FindFirstChild("PrimaryPart") 
                          or string.find(string.lower(obj.Name), "plane")
            
            if hasPlane then
                local owner = obj:FindFirstChild("Owner") or obj:FindFirstChild("Pilot") 
                           or obj:FindFirstChild(LocalPlayer.Name)
                
                if not owner or (owner:IsA("ObjectValue") and owner.Value \~= LocalPlayer) then
                    table.insert(targets, obj)
                end
            end
        end
    end
    
    -- Enemy players / placeholders
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            table.insert(targets, plr.Character)
        end
    end
    
    return targets
end

-- Loop
local conn
conn = RunService.Heartbeat:Connect(function()
    local targets = findTargets()
    for _, model in ipairs(targets) do
        for _, desc in ipairs(model:GetDescendants()) do
            expandPart(desc)
        end
    end
    
    -- Reset cache occasionally
    if math.floor(tick()) % 5 == 0 then
        expanded = {}
    end
end)

-- Cleanup
Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer and conn then
        conn:Disconnect()
    end
end)

print("Wings of Glory Hitbox v3 Loaded! Size:", HitboxSize, "– Enjoy!")
