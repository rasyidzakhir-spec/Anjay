-- 🌟 DASH Masterpack V5 - Modular GUI Farming & PvP
-- Untuk edukasi & eksperimen di private server

local player = game.Players.LocalPlayer
local hrp = player.Character:WaitForChild("HumanoidRootPart")

-- 🌟 GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DASH_Masterpack"

local panel = Instance.new("Frame", screenGui)
panel.Size = UDim2.new(0, 240, 0, 400)
panel.Position = UDim2.new(0.5, -120, 0.5, -200)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.Visible = false

local toggleMain = Instance.new("TextButton", screenGui)
toggleMain.Size = UDim2.new(0, 120, 0, 40)
toggleMain.Position = UDim2.new(0.5, -60, 0.9, 0)
toggleMain.Text = "DASH Menu"
toggleMain.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleMain.TextColor3 = Color3.new(1, 1, 1)
toggleMain.Font = Enum.Font.GothamBold
toggleMain.TextSize = 18
toggleMain.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- 🌟 Toggle Table
local toggle = {
    autoFarm = false,
    autoAimPvP = false,
    espFruit = false,
    autoTeleportFruit = false,
    teleportIsland = false,
    switchSea = false,
    thunderstruck = false
}

-- 🌟 Island & Sea Mapping
local islands = {
    ["Sea 1"] = {["Starter Island"] = CFrame.new(100, 10, 200)},
    ["Sea 2"] = {["Green Zone"] = CFrame.new(-2500, 60, 1200)},
    ["Sea 3"] = {["Hydra Island"] = CFrame.new(5000, 100, -3000)}
}
local seaPortals = {
    ["Sea 1"] = CFrame.new(1000, 50, -500),
    ["Sea 2"] = CFrame.new(-2000, 100, 800),
    ["Sea 3"] = CFrame.new(5000, 150, -3000)
}

-- 🌟 Feature Buttons
local function createFeatureButton(name, posY)
    local btn = Instance.new("TextButton", panel)
    btn.Size = UDim2.new(0, 220, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(function()
        toggle[name] = not toggle[name]
        btn.Text = name .. ": " .. (toggle[name] and "ON" or "OFF")
    end)
end

local features = {"autoFarm", "autoAimPvP", "espFruit", "autoTeleportFruit", "teleportIsland", "switchSea", "thunderstruck"}
for i, name in ipairs(features) do
    createFeatureButton(name, (i - 1) * 45 + 10)
end

-- 🌟 Feature Functions
function autoFarm()
    local level = player.Data.Level.Value
    local quest = "Bandit" -- Ganti sesuai mapping level
    local npc = workspace.Enemies:FindFirstChild(quest)
    if npc and npc:FindFirstChild("Humanoid") then
        hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        npc.Humanoid.Health = 0
    end
end

function autoAimPvP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
    end
end

function espFruit()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj.Name:find("Fruit") then
            if not obj:FindFirstChild("ESP") then
                local esp = Instance.new("BillboardGui", obj)
                esp.Name = "ESP"
                esp.Size = UDim2.new(0, 100, 0, 40)
                esp.AlwaysOnTop = true
                local label = Instance.new("TextLabel", esp)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = obj.Name
                label.TextColor3 = Color3.new(1, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
            end
        end
    end
end

function autoTeleportFruit()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj.Name:find("Fruit") and obj:FindFirstChild("Handle") then
            hrp.CFrame = obj.Handle.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

function teleportToIsland()
    hrp.CFrame = islands["Sea 2"]["Green Zone"] -- Ganti sesuai pilihan
end

function switchSea()
    hrp.CFrame = seaPortals["Sea 3"] -- Ganti sesuai target
end

function thunderKill()
    for _, npc in pairs(workspace.Enemies:GetChildren()) do
        if npc.Name:find("Electri") and npc:FindFirstChild("Humanoid") then
            hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            npc.Humanoid.Health = 0
        end
    end
end

-- 🌟 Main Loop
game:GetService("RunService").Heartbeat:Connect(function()
    if toggle.autoFarm then autoFarm() end
    if toggle.autoAimPvP then autoAimPvP() end
    if toggle.espFruit then espFruit() end
    if toggle.autoTeleportFruit then autoTeleportFruit() end
    if toggle.teleportIsland then teleportToIsland() end
    if toggle.switchSea then switchSea() end
    if toggle.thunderstruck then thunderKill() end
end)