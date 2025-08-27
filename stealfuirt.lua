-- 🌟 DASH's Modular Utility Panel for Steal a Fruit
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local replicated = game:GetService("ReplicatedStorage")

-- 🔧 SETTINGS
local config = {
    autoLockBase = true,
    unlimitedJump = true,
    speedRun = true,
    noclip = false,
    espBuah = true,
    uiVisible = true
}

-- 🧱 UI PANEL
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DASHPanel"
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = config.uiVisible

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 60)
toggleButton.Text = "Toggle Panel"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)

toggleButton.MouseButton1Click:Connect(function()
    config.uiVisible = not config.uiVisible
    frame.Visible = config.uiVisible
end)

-- 🧠 Auto Lock Base via RemoteEvent
local function autoLockBase()
    local base = workspace:FindFirstChild("YourBase") -- ganti sesuai nama base
    local unlockTimer = base and base:FindFirstChild("UnlockTimer")
    local lockEvent = replicated:FindFirstChild("LockBaseEvent")

    if unlockTimer and lockEvent then
        unlockTimer:GetPropertyChangedSignal("Value"):Connect(function()
            if config.autoLockBase and unlockTimer.Value <= 0 then
                lockEvent:FireServer(base.Name)
                print("🔒 Base terkunci otomatis!")
            end
        end)
    end
end

-- 🦘 Unlimited Jump
uis.JumpRequest:Connect(function()
    if config.unlimitedJump and char:FindFirstChild("Humanoid") then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 💨 Speed Run
rs.Heartbeat:Connect(function()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and config.speedRun then
        local hasFruit = player.Backpack:FindFirstChild("Fruit") or char:FindFirstChild("Fruit")
        humanoid.WalkSpeed = hasFruit and 100 or 50
    end
end)

-- 🧱 NoClip
rs.Stepped:Connect(function()
    if config.noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 🍍 ESP Buah
local function createESP(fruit)
    if fruit:FindFirstChild("ESPLabel") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.Adornee = fruit
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = fruit.Name
    label.TextColor3 = Color3.new(1, 1, 0)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true

    billboard.Parent = fruit
end

local fruitFolder = workspace:FindFirstChild("FruitSpawn")
if fruitFolder and config.espBuah then
    fruitFolder.ChildAdded:Connect(function(fruit)
        wait(0.5)
        createESP(fruit)
    end)
    for _, fruit in pairs(fruitFolder:GetChildren()) do
        createESP(fruit)
    end
end

-- 🚀 Inisialisasi
autoLockBase()
print("✅ DASH Panel aktif. Gunakan tombol 'Toggle Panel' untuk buka/tutup.")