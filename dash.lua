--[[
    BLOX FRUITS: AUTO TELEPORT & ESP BUAH + JARAK + NOTIF MYTHICAL + AUTO KILL THUNDER STUCK / ELECTRIFIED MONKEY
    Menu draggable, show/hide, semua fitur bisa ON/OFF dari menu!
    Gunakan dengan risiko sendiri!
--]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- MENU GUI
local scr = Instance.new("ScreenGui", game.CoreGui)
scr.Name = "FruitESPMenu"

-- Tombol show/hide kecil di pojok
local toggleBtn = Instance.new("TextButton", scr)
toggleBtn.Size = UDim2.new(0,40, 0,40)
toggleBtn.Position = UDim2.new(0, 10, 0, 90)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)
toggleBtn.TextColor3 = Color3.new(1,1,0)
toggleBtn.Text = "≡"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 26
toggleBtn.ZIndex = 10

local frame = Instance.new("Frame", scr)
frame.Size = UDim2.new(0, 240, 0, 155)
frame.Position = UDim2.new(0, 60, 0, 90)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BackgroundTransparency = 0.18
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,28)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 19
title.Text = "Fruit ESP & Teleport"
title.TextStrokeTransparency = 0.7

local espButton = Instance.new("TextButton", frame)
espButton.Size = UDim2.new(1,-20,0,25)
espButton.Position = UDim2.new(0,10,0,35)
espButton.BackgroundColor3 = Color3.fromRGB(60,60,80)
espButton.TextColor3 = Color3.fromRGB(255,255,255)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 15
espButton.Text = "ESP: ON"

local tpButton = Instance.new("TextButton", frame)
tpButton.Size = UDim2.new(1,-20,0,25)
tpButton.Position = UDim2.new(0,10,0,65)
tpButton.BackgroundColor3 = Color3.fromRGB(60,60,80)
tpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextSize = 15
tpButton.Text = "Auto Teleport: ON"

local thunderButton = Instance.new("TextButton", frame)
thunderButton.Size = UDim2.new(1,-20,0,25)
thunderButton.Position = UDim2.new(0,10,0,95)
thunderButton.BackgroundColor3 = Color3.fromRGB(60,100,100)
thunderButton.TextColor3 = Color3.fromRGB(255,255,255)
thunderButton.Font = Enum.Font.SourceSansBold
thunderButton.TextSize = 15
thunderButton.Text = "Auto Kill Thunder Event: ON"

local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(1,-20,0,30)
infoLabel.Position = UDim2.new(0,10,0,125)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(120,255,255)
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 15
infoLabel.Text = "Notifikasi Mythical/Legendary aktif!"

-- State
local ESP_ON = true
local TP_ON = true
local THUNDER_ON = true
local MENU_SHOWN = true

-- Fungsi ESP untuk setiap buah
function addESPToFruit(fruit)
    if fruit:FindFirstChild("ESPLabel") then return end

    local bill = Instance.new("BillboardGui", fruit)
    bill.Name = "ESPLabel"
    bill.Size = UDim2.new(0, 150, 0, 40)
    bill.AlwaysOnTop = true
    bill.StudsOffset = Vector3.new(0, 2, 0)
    bill.Adornee = fruit:FindFirstChild("Handle") or fruit

    local nameLabel = Instance.new("TextLabel", bill)
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextScaled = true
    nameLabel.Text = fruit.Name

    local distLabel = Instance.new("TextLabel", bill)
    distLabel.Position = UDim2.new(0,0,0.5,0)
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(0,255,255)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    distLabel.Font = Enum.Font.SourceSansBold
    distLabel.TextScaled = true

    -- Update jarak secara real time
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if not ESP_ON or fruit.Parent == nil or not fruit:IsDescendantOf(game.Workspace) then
            if bill then bill:Destroy() end
            if conn then conn:Disconnect() end
            return
        end
        local dist = (hrp.Position - fruit.Position).Magnitude
        distLabel.Text = string.format("Jarak: %.1f m", dist/2)
    end)
end

function removeAllFruitESP()
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            local esp = v:FindFirstChild("ESPLabel")
            if esp then esp:Destroy() end
        end
    end
end

function updateAllFruitESP()
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            if ESP_ON then
                addESPToFruit(v)
            else
                local esp = v:FindFirstChild("ESPLabel")
                if esp then esp:Destroy() end
            end
        end
    end
end

function autoTPToNearestFruit()
    if not TP_ON then return end
    local fruits = {}
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            table.insert(fruits,v)
        end
    end
    if #fruits > 0 then
        table.sort(fruits, function(a,b)
            return (hrp.Position-a.Position).Magnitude < (hrp.Position-b.Position).Magnitude
        end)
        local nearest = fruits[1]
        if nearest then
            hrp.CFrame = nearest.CFrame + Vector3.new(0,3,0)
        end
    end
end

-- Event listener: jika ada buah spawn, langsung ESP & auto teleport (jika aktif)
workspace.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and string.find(child.Name, "Fruit") then
        wait(0.1)
        if ESP_ON then addESPToFruit(child) end
        if TP_ON then autoTPToNearestFruit() end

        -- Notifikasi Mythical/Legendary
        if legendaryFruits[child.Name] then
            showNotification(child.Name)
        end
    end

    -- Juga auto kill Thunder Stuck/Monkey jika fitur aktif dan ada yang spawn
    if THUNDER_ON and targetNPCNames[child.Name] then
        spawn(function() attackTargetNPC(child) end)
    end
end)

-- Inisialisasi ESP untuk buah yang sudah ada
updateAllFruitESP()

-- Loop auto teleport buah
spawn(function()
    while true do
        if TP_ON then autoTPToNearestFruit() end
        wait(2)
    end
end)

-- Loop update ESP jika on/off
spawn(function()
    while true do
        updateAllFruitESP()
        wait(1)
    end
end)

-- Tombol ESP
espButton.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    espButton.Text = ESP_ON and "ESP: ON" or "ESP: OFF"
    updateAllFruitESP()
end)

-- Tombol Teleport
tpButton.MouseButton1Click:Connect(function()
    TP_ON = not TP_ON
    tpButton.Text = TP_ON and "Auto Teleport: ON" or "Auto Teleport: OFF"
end)

-- Tombol Auto Kill Thunder Event
thunderButton.MouseButton1Click:Connect(function()
    THUNDER_ON = not THUNDER_ON
    thunderButton.Text = THUNDER_ON and "Auto Kill Thunder Event: ON" or "Auto Kill Thunder Event: OFF"
end)

-- Agar frame bisa digeser
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Show/Hide menu
toggleBtn.MouseButton1Click:Connect(function()
    MENU_SHOWN = not MENU_SHOWN
    frame.Visible = MENU_SHOWN
end)

-- Awal: menu langsung tampil
frame.Visible = true

--[[ Notifikasi buah Mythical & Legendary spawn ]]
local legendaryFruits = {
    ["Dragon Fruit"] = true,
    ["Leopard Fruit"] = true,
    ["Dough Fruit"] = true,
    ["Venom Fruit"] = true,
    ["Shadow Fruit"] = true,
    ["Spirit Fruit"] = true,
    ["Control Fruit"] = true,
    ["Mammoth Fruit"] = true,
    ["T-Rex Fruit"] = true,
    ["Kitsune Fruit"] = true,
    ["Lightning Fruit"] = true,
    ["Gravity Fruit"] = true,
    ["Buddha Fruit"] = true,
    ["Portal Fruit"] = true,
    -- Tambahkan buah lainnya jika ada update!
}

local function showNotification(fruitName)
    if game.CoreGui:FindFirstChild("FruitNotif") then
        game.CoreGui.FruitNotif:Destroy()
    end
    local notif = Instance.new("ScreenGui", game.CoreGui)
    notif.Name = "FruitNotif"

    local frame = Instance.new("Frame", notif)
    frame.Size = UDim2.new(0, 350, 0, 70)
    frame.Position = UDim2.new(0.5, -175, 0.12, 0)
    frame.BackgroundColor3 = Color3.fromRGB(60,0,0)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,215,0)
    label.Font = Enum.Font.SourceSansBold
    label.TextStrokeTransparency = 0
    label.TextSize = 26
    label.Text = "‼️ BUAH LANGKA MUNCUL: " .. fruitName .. " ‼️"

    -- Suara notifikasi
    local sound = Instance.new("Sound", frame)
    sound.SoundId = "rbxassetid://911882856"
    sound.Volume = 1
    sound:Play()

    game:GetService("Debris"):AddItem(notif, 5)
end

-- Cek buah langka di awal script
for _,v in pairs(workspace:GetChildren()) do
    if v:IsA("Tool") and string.find(v.Name, "Fruit") then
        if legendaryFruits[v.Name] then
            showNotification(v.Name)
        end
    end
end

--[[ AUTO KILL THUNDER STUCK & [Electrified] Monkey ]]
local targetNPCNames = {
    ["Thunder Stuck"] = true,
    ["Thunderstuck"] = true,
    ["Thunder_Stuck"] = true,
    ["[Electrified] Monkey [Lv. 14]"] = true,
    ["[Snowbandit] Monkey [Lv. 90]"] = true,
}

function attackTargetNPC(npcObj)
    -- Jika dipanggil dengan NPC baru, serang satu itu saja!
    if npcObj and npcObj:FindFirstChild("HumanoidRootPart") and npcObj:FindFirstChild("Humanoid") then
        local humanoid = npcObj.Humanoid
        while THUNDER_ON and humanoid.Health > 0 and npcObj.Parent and workspace:FindFirstChild(npcObj.Name) do
            hrp.CFrame = npcObj.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(0.15)
        end
        return
    end

    -- Jika tidak, loop semua NPC target
    for _,npc in pairs(workspace:GetChildren()) do
        if THUNDER_ON and targetNPCNames[npc.Name] and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
            local humanoid = npc.Humanoid
            while THUNDER_ON and humanoid.Health > 0 and npc.Parent and workspace:FindFirstChild(npc.Name) do
                hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(0.15)
            end
        end
    end
end

-- Loop auto kill Thunder Event
spawn(function()
    while true do
        if THUNDER_ON then
            attackTargetNPC()
        end
        wait(0.5)
    end
end)

--[[ --- Tambahan pada script utama: TELEPORT ISLAND MENU (SEA 1, 2, 3) --- ]]

-- DATA ISLAND (Sea 1)
local islands_sea1 = {
    ["Starter Island"] = CFrame.new(1105, 16, 1647),
    ["Jungle"] = CFrame.new(-1599, 36, 153),
    ["Pirate Village"] = CFrame.new(-1120, 4, 3855),
    ["Desert"] = CFrame.new(1095, 17, 4276),
    ["Middle Island"] = CFrame.new(-531, 8, 4172),
    ["Frozen Village"] = CFrame.new(114, 28, -1336),
    ["Marine Fortress"] = CFrame.new(-4508, 20, 4268),
    ["Skylands"] = CFrame.new(-4840, 717, -2622),
    ["Prison"] = CFrame.new(5077, 41, 4745),
    ["Colosseum"] = CFrame.new(-1837, 7, -2740),
    ["Magma Village"] = CFrame.new(-5472, 15, 8513),
    ["Underwater City"] = CFrame.new(3874, 5, -1898),
    ["Fountain City"] = CFrame.new(5288, 44, 4037),
    ["Shank's Room"] = CFrame.new(-1407, 29, -2855)
}
-- DATA ISLAND (Sea 2)
local islands_sea2 = {
    ["Kingdom of Rose"] = CFrame.new(1050, 17, 1165),
    ["Green Zone"] = CFrame.new(-3846, 142, 355),
    ["Graveyard"] = CFrame.new(-5413, 8, -1397),
    ["Dark Arena"] = CFrame.new(5856, 5, -1106),
    ["Snow Mountain"] = CFrame.new(1388, 29, -1297),
    ["Hot and Cold"] = CFrame.new(-592, 6, -5077),
    ["Cursed Ship"] = CFrame.new(923, 125, 32885),
    ["Ice Castle"] = CFrame.new(5451, 28, -6536),
    ["Forgotten Island"] = CFrame.new(-3052, 238, -10191),
    ["Usoap's Island"] = CFrame.new(4745, 8, 2844)
}
-- DATA ISLAND (Sea 3)
local islands_sea3 = {
    ["Port Town"] = CFrame.new(-288, 44, 5536),
    ["Hydra Island"] = CFrame.new(5228, 604, 345),
    ["Great Tree"] = CFrame.new(2365, 25, -6458),
    ["Floating Turtle"] = CFrame.new(-11099, 331, -8762),
    ["Castle on the Sea"] = CFrame.new(-5500, 314, -2855),
    ["Haunted Castle"] = CFrame.new(-9515, 142, 6062),
    ["Sea of Treats"] = CFrame.new(-1868, 8, -12064),
    ["Cake Land"] = CFrame.new(-2022, 36, -12029),
    ["Tiki Outpost"] = CFrame.new(-16521, 98, -174),
}

local allSeas = {
    ["Sea 1"] = islands_sea1,
    ["Sea 2"] = islands_sea2,
    ["Sea 3"] = islands_sea3
}

-- GUI: Tombol utama di menu
local tpIslandBtn = Instance.new("TextButton", frame)
tpIslandBtn.Size = UDim2.new(1,-20,0,25)
tpIslandBtn.Position = UDim2.new(0,10,0,125)
tpIslandBtn.BackgroundColor3 = Color3.fromRGB(110,110,90)
tpIslandBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpIslandBtn.Font = Enum.Font.SourceSansBold
tpIslandBtn.TextSize = 15
tpIslandBtn.Text = "Teleport Island"

-- Frame pilihan teleport (pop up kecil)
local tpFrame = Instance.new("Frame", scr)
tpFrame.Size = UDim2.new(0, 220, 0, 120)
tpFrame.Position = UDim2.new(0, 320, 0, 120)
tpFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpFrame.BackgroundTransparency = 0.1
tpFrame.Visible = false
tpFrame.Active = true
tpFrame.Draggable = true

local closeTp = Instance.new("TextButton", tpFrame)
closeTp.Size = UDim2.new(0,24,0,24)
closeTp.Position = UDim2.new(1,-28,0,4)
closeTp.BackgroundColor3 = Color3.fromRGB(120,60,60)
closeTp.Text = "X"
closeTp.Font = Enum.Font.SourceSansBold
closeTp.TextSize = 15

local seaLabel = Instance.new("TextLabel", tpFrame)
seaLabel.Size = UDim2.new(0, 80, 0, 22)
seaLabel.Position = UDim2.new(0, 10, 0, 8)
seaLabel.BackgroundTransparency = 1
seaLabel.TextColor3 = Color3.fromRGB(255,255,0)
seaLabel.Font = Enum.Font.SourceSansBold
seaLabel.TextSize = 15
seaLabel.Text = "Pilih Sea:"

local seaDropdown = Instance.new("TextButton", tpFrame)
seaDropdown.Size = UDim2.new(0, 100, 0, 22)
seaDropdown.Position = UDim2.new(0, 90, 0, 8)
seaDropdown.BackgroundColor3 = Color3.fromRGB(80,80,100)
seaDropdown.TextColor3 = Color3.fromRGB(255,255,255)
seaDropdown.Font = Enum.Font.SourceSans
seaDropdown.TextSize = 15
seaDropdown.Text = "Sea 1"

local islandLabel = Instance.new("TextLabel", tpFrame)
islandLabel.Size = UDim2.new(0, 80, 0, 22)
islandLabel.Position = UDim2.new(0, 10, 0, 40)
islandLabel.BackgroundTransparency = 1
islandLabel.TextColor3 = Color3.fromRGB(255,255,0)
islandLabel.Font = Enum.Font.SourceSansBold
islandLabel.TextSize = 15
islandLabel.Text = "Pilih Island:"

local islandDropdown = Instance.new("TextButton", tpFrame)
islandDropdown.Size = UDim2.new(0, 160, 0, 22)
islandDropdown.Position = UDim2.new(0, 10, 0, 62)
islandDropdown.BackgroundColor3 = Color3.fromRGB(80,80,100)
islandDropdown.TextColor3 = Color3.fromRGB(255,255,255)
islandDropdown.Font = Enum.Font.SourceSans
islandDropdown.TextSize = 14
islandDropdown.Text = "Starter Island"

local teleportBtn = Instance.new("TextButton", tpFrame)
teleportBtn.Size = UDim2.new(0, 100, 0, 28)
teleportBtn.Position = UDim2.new(0, 60, 0, 90)
teleportBtn.BackgroundColor3 = Color3.fromRGB(60,120,80)
teleportBtn.TextColor3 = Color3.fromRGB(255,255,255)
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.Text = "Teleport"
teleportBtn.TextSize = 16

-- Dropdown select logic
local seaNames = {"Sea 1", "Sea 2", "Sea 3"}
local currentSea = "Sea 1"
local currentIsland = "Starter Island"

-- Dropdown Sea
seaDropdown.MouseButton1Click:Connect(function()
    local new = table.find(seaNames, currentSea) or 1
    new = new + 1
    if new > #seaNames then new = 1 end
    currentSea = seaNames[new]
    seaDropdown.Text = currentSea
    -- update island list
    local isl = next(allSeas[currentSea])
    currentIsland = isl
    islandDropdown.Text = isl
end)

-- Dropdown Island
islandDropdown.MouseButton1Click:Connect(function()
    local islands = allSeas[currentSea]
    local keys, idx = {}, 1
    for k in pairs(islands) do table.insert(keys, k) end
    table.sort(keys)
    for i,v in ipairs(keys) do if v == currentIsland then idx = i break end end
    idx = idx + 1
    if idx > #keys then idx = 1 end
    currentIsland = keys[idx]
    islandDropdown.Text = currentIsland
end)

-- Teleport action
teleportBtn.MouseButton1Click:Connect(function()
    local cframe = allSeas[currentSea][currentIsland]
    if cframe and hrp then
        hrp.CFrame = cframe + Vector3.new(0,5,0)
    end
end)

-- Show/hide teleport frame
tpIslandBtn.MouseButton1Click:Connect(function()
    tpFrame.Visible = not tpFrame.Visible
end)
closeTp.MouseButton1Click:Connect(function()
    tpFrame.Visible = false
end)

-- Posisi & island awal
seaDropdown.Text = currentSea
islandDropdown.Text = currentIsland

-- Agar frame teleport bisa digeser
local dragging2, dragInput2, dragStart2, startPos2
tpFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = true
        dragStart2 = input.Position
        startPos2 = tpFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging2 = false
            end
        end)
    end
end)
tpFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput2 = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput2 and dragging2 then
        local delta = input.Position - dragStart2
        tpFrame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    end
end)

--[[
    BLOX FRUITS AUTO RAID: BUY CHIP + PILIH RAID + AUTO KILL (MELEE)
    Gunakan dengan risiko sendiri!
--]]

local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local runService = game:GetService("RunService")

-- Data raid & chip
local raidTypes = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}
local raidRemoteName = "Raids"
local buyChipRemote = remotes:FindFirstChild("CommF_")

-- GUI MENU
local scr = Instance.new("ScreenGui", game.CoreGui)
scr.Name = "AutoRaidMenu"

local frame = Instance.new("Frame", scr)
frame.Size = UDim2.new(0, 270, 0, 140)
frame.