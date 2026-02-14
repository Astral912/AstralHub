‎-- Wings of Glory Hitbox Expander v4 – Delta Fix | Grok 2026
‎-- Simplified for no errors, targets planes + characters
‎
‎local Players = game:GetService("Players")
‎local RunService = game:GetService("RunService")
‎local Workspace = game:GetService("Workspace")
‎
‎local LocalPlayer = Players.LocalPlayer or Players:WaitForChild("LocalPlayer")
‎
‎local HitboxSize = 35
‎local Transparency = 0.75
‎
‎local function expandPart(part)
‎    if part and part:IsA("BasePart") and part.Parent and part.Parent \~= LocalPlayer.Character and part.Size.Magnitude < 100 then
‎        pcall(function()
‎            part.Size = Vector3.new(HitboxSize, HitboxSize / 2, HitboxSize)
‎            part.Transparency = Transparency
‎            part.CanCollide = false
‎            part.Material = Enum.Material.ForceField
‎        end)
‎    end
‎end
‎
‎local function findTargets()
‎    local targets = {}
‎    for _, obj in ipairs(Workspace:GetChildren()) do
‎        if obj:IsA("Model") then
‎            local hasPlane = obj:FindFirstChild("Fuselage") or obj:FindFirstChild("Body") or obj:FindFirstChild("Wings") or obj:FindFirstChild("RootPart") or obj:FindFirstChild("PrimaryPart") or string.lower(obj.Name):find("plane")
‎            if hasPlane then
‎                local owner = obj:FindFirstChild("Owner") or obj:FindFirstChild("Pilot") or obj:FindFirstChild(LocalPlayer.Name)
‎                if not owner or (owner:IsA("ObjectValue") and owner.Value \~= LocalPlayer) then
‎                    table.insert(targets, obj)
‎                end
‎            end
‎        end
‎    end
‎    for _, plr in ipairs(Players:GetPlayers()) do
‎        if plr \~= LocalPlayer and plr.Character then
‎            table.insert(targets, plr.Character)
‎        end
‎    end
‎    return targets
‎end
‎
‎local conn = RunService.Heartbeat:Connect(function()
‎    local targets = findTargets()
‎    for _, model in ipairs(targets) do
‎        for _, desc in ipairs(model:GetDescendants()) do
‎            expandPart(desc)
‎        end
‎    end
‎end)
‎
‎Players.PlayerRemoving:Connect(function(plr)
‎    if plr == LocalPlayer and conn then conn:Disconnect() end
‎end)
‎
‎print("Wings of Glory Hitbox v4 Loaded! Size: " .. HitboxSize .. " – Ready!")
