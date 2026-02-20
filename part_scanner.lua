-- Wings of Glory Part Scanner | Prints planes + parts to Delta console
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("=== Scanning Planes & Parts ===")
local planeCount = 0
for _, obj in pairs(Workspace:GetChildren()) do
    if obj:IsA("Model") and (string.find(string.lower(obj.Name), "plane") or string.find(string.lower(obj.Name), "wildcat") or string.find(string.lower(obj.Name), "f4f") or obj:FindFirstChild("Fuselage")) then
        planeCount = planeCount + 1
        print("PLANE #" .. planeCount .. ": " .. obj.Name)
        local owner = obj:FindFirstChild("Owner") or obj:FindFirstChild("Pilot")
        if owner then print("  Owner: " .. (owner.Value and owner.Value.Name or "Unknown")) end
        for _, part in pairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                print("  PART: " .. part.Name .. " (Size: " .. tostring(part.Size) .. ")")
            end
        end
        print("---")
    end
end
print("Scan done! Copy PART names (e.g., Fuselage) for hitbox fix.")
