--[[
Blox Fruits Auto Menu (Stable - Mobile & PC)
- ESP Buah, Auto Teleport Buah, Notif Mythical
- Auto Kill Thunder/Monkey
- Teleport Island (Sea 1,2,3, Tiki Outpost)
- Auto Raid (buy chip, pilih raid, auto kill melee)
- Auto Haki/Instinct/V3 (all race)
- Semua tombol ON/OFF, menu draggable
- GUI dijamin muncul di PlayerGui/CoreGui
]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ========== Satu ScreenGui ==========
local function safeCreateScreenGui(name)
    local gui
    pcall(function()
        gui = Instance.new("ScreenGui")
        gui.Name = name
        gui.ResetOnSpawn = false
        gui.Parent = player.PlayerGui
    end)
    if not gui or not gui.Parent then
        -- fallback ke CoreGui
        gui = Instance.new("ScreenGui")
        gui.Name = name
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui
    end
    return gui
end

local scr = safeCreateScreenGui("BF_MainMenu")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0, 65, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(35,35,40)
frame.Active = true
frame.Draggable = true
frame.Parent = scr

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,34)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,221,80)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 23
title.Text = "Blox Fruits Auto Menu"
title.TextStrokeTransparency = 0.7

-- ========== TOMBOL SHOW/HIDE ==========
local toggleBtn = Instance.new("TextButton", scr)
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0, 10, 0, 90)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,90)
toggleBtn.TextColor3 = Color3.new(1,1,0)
toggleBtn.Text = "≡"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 34
toggleBtn.ZIndex = 10

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
frame.Visible = true

-- ========== STATE ==========
local ESP_ON, TP_ON, THUNDER_ON = true, true, true
local AUTO_HAKI_ON, AUTO_RAID_ON = true, true

-- ========== TOMBOL FITUR ==========
local y = 40
function AddButton(text, state, cb)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-20,0,32)
    btn.Position = UDim2.new(0,10,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text .. ": "..(state and "ON" or "OFF")
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": "..(state and "ON" or "OFF")
        cb(state)
    end)
    y = y + 38
    return btn
end

AddButton("ESP Buah", ESP_ON, function(v) ESP_ON = v end)
AddButton("Auto Teleport Buah", TP_ON, function(v) TP_ON = v end)
AddButton("Auto Kill Thunder", THUNDER_ON, function(v) THUNDER_ON = v end)
AddButton("Auto Haki/Instinct/V3", AUTO_HAKI_ON, function(v) AUTO_HAKI_ON = v end)
AddButton("Auto Raid", AUTO_RAID_ON, function(v) AUTO_RAID_ON = v end)

-- ========== PILIH RAID ==========
local raidTypes = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}
local currentRaid = raidTypes[1]
local raidDropdown = Instance.new("TextButton", frame)
raidDropdown.Size = UDim2.new(1,-20,0,28)
raidDropdown.Position = UDim2.new(0,10,0,y)
raidDropdown.BackgroundColor3 = Color3.fromRGB(90,80,120)
raidDropdown.TextColor3 = Color3.fromRGB(255,255,255)
raidDropdown.Font = Enum.Font.SourceSansBold
raidDropdown.TextSize = 16
raidDropdown.Text = "Raid: " .. currentRaid
raidDropdown.MouseButton1Click:Connect(function()
    local idx = table.find(raidTypes, currentRaid) or 1
    idx = idx + 1
    if idx > #raidTypes then idx = 1 end
    currentRaid = raidTypes[idx]
    raidDropdown.Text = "Raid: "..currentRaid
end)
y = y + 34

-- ========== TELEPORT ISLAND (Pop Up) ==========
local tpIslandBtn = Instance.new("TextButton", frame)
tpIslandBtn.Size = UDim2.new(1,-20,0,32)
tpIslandBtn.Position = UDim2.new(0,10,0,y)
tpIslandBtn.BackgroundColor3 = Color3.fromRGB(110,110,90)
tpIslandBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpIslandBtn.Font = Enum.Font.SourceSansBold
tpIslandBtn.TextSize = 18
tpIslandBtn.Text = "Teleport Island"
y = y + 38

local islands_sea1 = {
    ["Starter Island"]=CFrame.new(1105, 16, 1647),["Jungle"]=CFrame.new(-1599, 36, 153),["Pirate Village"]=CFrame.new(-1120, 4, 3855),
    ["Desert"]=CFrame.new(1095, 17, 4276),["Middle Island"]=CFrame.new(-531, 8, 4172),["Frozen Village"]=CFrame.new(114, 28, -1336),
    ["Marine Fortress"]=CFrame.new(-4508, 20, 4268),["Skylands"]=CFrame.new(-4840, 717, -2622),["Prison"]=CFrame.new(5077, 41, 4745),
    ["Colosseum"]=CFrame.new(-1837, 7, -2740),["Magma Village"]=CFrame.new(-5472, 15, 8513),["Underwater City"]=CFrame.new(3874, 5, -1898),
    ["Fountain City"]=CFrame.new(5288, 44, 4037),["Shank's Room"]=CFrame.new(-1407, 29, -2855)
}
local islands_sea2 = {
    ["Kingdom of Rose"]=CFrame.new(1050, 17, 1165),["Green Zone"]=CFrame.new(-3846, 142, 355),["Graveyard"]=CFrame.new(-5413, 8, -1397),
    ["Dark Arena"]=CFrame.new(5856, 5, -1106),["Snow Mountain"]=CFrame.new(1388, 29, -1297),["Hot and Cold"]=CFrame.new(-592, 6, -5077),
    ["Cursed Ship"]=CFrame.new(923, 125, 32885),["Ice Castle"]=CFrame.new(5451, 28, -6536),["Forgotten Island"]=CFrame.new(-3052, 238, -10191),["Usoap's Island"]=CFrame.new(4745, 8, 2844)
}
local islands_sea3 = {
    ["Port Town"]=CFrame.new(-288, 44, 5536),["Hydra Island"]=CFrame.new(5228, 604, 345),["Great Tree"]=CFrame.new(2365, 25, -6458),
    ["Floating Turtle"]=CFrame.new(-11099, 331, -8762),["Castle on the Sea"]=CFrame.new(-5500, 314, -2855),["Haunted Castle"]=CFrame.new(-9515, 142, 6062),
    ["Sea of Treats"]=CFrame.new(-1868, 8, -12064),["Cake Land"]=CFrame.new(-2022, 36, -12029),["Tiki Outpost"]=CFrame.new(-16521, 98, -174)
}
local allSeas = {["Sea 1"]=islands_sea1,["Sea 2"]=islands_sea2,["Sea 3"]=islands_sea3}
local seaNames = {"Sea 1","Sea 2","Sea 3"}
local tpFrame = Instance.new("Frame", scr) tpFrame.Size = UDim2.new(0, 240, 0, 140) tpFrame.Position = UDim2.new(0, 410, 0, 110) tpFrame.BackgroundColor3 = Color3.fromRGB(60,60,60) tpFrame.BackgroundTransparency = 0.1 tpFrame.Visible = false tpFrame.Active = true tpFrame.Draggable = true
local closeTp = Instance.new("TextButton", tpFrame) closeTp.Size = UDim2.new(0,28,0,28) closeTp.Position = UDim2.new(1,-32,0,4) closeTp.BackgroundColor3 = Color3.fromRGB(120,60,60) closeTp.Text = "X" closeTp.Font = Enum.Font.SourceSansBold closeTp.TextSize = 16
local seaDropdown = Instance.new("TextButton", tpFrame) seaDropdown.Size = UDim2.new(0, 110, 0, 22) seaDropdown.Position = UDim2.new(0, 10, 0, 8) seaDropdown.BackgroundColor3 = Color3.fromRGB(80,80,100) seaDropdown.TextColor3 = Color3.fromRGB(255,255,255) seaDropdown.Font = Enum.Font.SourceSans seaDropdown.TextSize = 15 seaDropdown.Text = "Sea 1"
local islandDropdown = Instance.new("TextButton", tpFrame) islandDropdown.Size = UDim2.new(0, 180, 0, 22) islandDropdown.Position = UDim2.new(0, 10, 0, 40) islandDropdown.BackgroundColor3 = Color3.fromRGB(80,80,100) islandDropdown.TextColor3 = Color3.fromRGB(255,255,255) islandDropdown.Font = Enum.Font.SourceSans islandDropdown.TextSize = 14 islandDropdown.Text = "Starter Island"
local teleportBtn = Instance.new("TextButton", tpFrame) teleportBtn.Size = UDim2.new(0, 120, 0, 32) teleportBtn.Position = UDim2.new(0, 60, 0, 90) teleportBtn.BackgroundColor3 = Color3.fromRGB(60,120,80) teleportBtn.TextColor3 = Color3.fromRGB(255,255,255) teleportBtn.Font = Enum.Font.SourceSansBold teleportBtn.Text = "Teleport" teleportBtn.TextSize = 17
local currentSea, currentIsland = "Sea 1", "Starter Island"
tpIslandBtn.MouseButton1Click:Connect(function() tpFrame.Visible = not tpFrame.Visible end)
closeTp.MouseButton1Click:Connect(function() tpFrame.Visible = false end)
seaDropdown.MouseButton1Click:Connect(function()
    local new = table.find(seaNames, currentSea) or 1
    new = new + 1; if new > #seaNames then new = 1 end
    currentSea = seaNames[new]
    seaDropdown.Text = currentSea
    local isl = next(allSeas[currentSea])
    currentIsland = isl
    islandDropdown.Text = isl
end)
islandDropdown.MouseButton1Click:Connect(function()
    local islands = allSeas[currentSea]
    local keys, idx = {}, 1
    for k in pairs(islands) do table.insert(keys, k) end
    table.sort(keys)
    for i,v in ipairs(keys) do if v == currentIsland then idx = i break end end
    idx = idx + 1; if idx > #keys then idx = 1 end
    currentIsland = keys[idx]
    islandDropdown.Text = currentIsland
end)
teleportBtn.MouseButton1Click:Connect(function()
    local cframe = allSeas[currentSea][currentIsland]
    if cframe and hrp then hrp.CFrame = cframe + Vector3.new(0,5,0) end
end)
seaDropdown.Text = currentSea islandDropdown.Text = currentIsland

-- ========== FITUR UTAMA ==========

-- ESP & AUTO TP BUAH + NOTIF
local legendaryFruits = {["Dragon Fruit"]=true,["Leopard Fruit"]=true,["Dough Fruit"]=true,["Venom Fruit"]=true,["Shadow Fruit"]=true,["Spirit Fruit"]=true,["Control Fruit"]=true,["Mammoth Fruit"]=true,["T-Rex Fruit"]=true,["Kitsune Fruit"]=true,["Lightning Fruit"]=true,["Gravity Fruit"]=true,["Buddha Fruit"]=true,["Portal Fruit"]=true}
function addESPToFruit(fruit) if fruit:FindFirstChild("ESPLabel") then return end local bill = Instance.new("BillboardGui", fruit) bill.Name = "ESPLabel" bill.Size = UDim2.new(0, 150, 0, 40) bill.AlwaysOnTop = true bill.StudsOffset = Vector3.new(0,2,0) bill.Adornee = fruit:FindFirstChild("Handle") or fruit local nameLabel = Instance.new("TextLabel", bill) nameLabel.Size = UDim2.new(1, 0, 0.5, 0) nameLabel.BackgroundTransparency = 1 nameLabel.TextColor3 = Color3.fromRGB(255,255,0) nameLabel.TextStrokeTransparency = 0 nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0) nameLabel.Font = Enum.Font.SourceSansBold nameLabel.TextScaled = true nameLabel.Text = fruit.Name local distLabel = Instance.new("TextLabel", bill) distLabel.Position = UDim2.new(0,0,0.5,0) distLabel.Size = UDim2.new(1, 0, 0.5, 0) distLabel.BackgroundTransparency = 1 distLabel.TextColor3 = Color3.fromRGB(0,255,255) distLabel.TextStrokeTransparency = 0 distLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0) distLabel.Font = Enum.Font.SourceSansBold distLabel.TextScaled = true local conn; conn = game:GetService("RunService").RenderStepped:Connect(function() if not ESP_ON or fruit.Parent == nil or not fruit:IsDescendantOf(game.Workspace) then if bill then bill:Destroy() end if conn then conn:Disconnect() end return end local dist = (hrp.Position - fruit.Position).Magnitude distLabel.Text = string.format("Jarak: %.1f m", dist/2) end) end
function updateAllFruitESP() for _,v in pairs(workspace:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") then if ESP_ON then addESPToFruit(v) else local esp = v:FindFirstChild("ESPLabel") if esp then esp:Destroy() end end end end end
function autoTPToNearestFruit() if not TP_ON then return end local fruits = {} for _,v in pairs(workspace:GetChildren()) do if v:IsA("Tool") and string.find(v.Name, "Fruit") then table.insert(fruits,v) end end if #fruits > 0 then table.sort(fruits, function(a,b) return (hrp.Position-a.Position).Magnitude < (hrp.Position-b.Position).Magnitude end) local nearest = fruits[1] if nearest then hrp.CFrame = nearest.CFrame + Vector3.new(0,3,0) end end end
workspace.ChildAdded:Connect(function(child) if child:IsA("Tool") and string.find(child.Name, "Fruit") then wait(0.1) if ESP_ON then addESPToFruit(child) end if TP_ON then autoTPToNearestFruit() end if legendaryFruits[child.Name] then pcall(function()
    local notif = Instance.new("ScreenGui") notif.Name = "FruitNotif" notif.Parent = scr local frame2 = Instance.new("Frame", notif) frame2.Size = UDim2.new(0, 350, 0, 70) frame2.Position = UDim2.new(0.5, -175, 0.13, 0) frame2.BackgroundColor3 = Color3.fromRGB(60,0,0) frame2.BackgroundTransparency = 0.1 frame2.BorderSizePixel = 0 local label = Instance.new("TextLabel", frame2) label.Size = UDim2.new(1, 0, 1, 0) label.BackgroundTransparency = 1 label.TextColor3 = Color3.fromRGB(255,215,0) label.Font = Enum.Font.SourceSansBold label.TextStrokeTransparency = 0 label.TextSize = 26 label.Text = "‼️ BUAH LANGKA MUNCUL: " .. child.Name .. " ‼️" local sound = Instance.new("Sound", frame2) sound.SoundId = "rbxassetid://911882856" sound.Volume = 1 sound:Play() game:GetService("Debris"):AddItem(notif, 5) end) end end end)
spawn(function() while true do if TP_ON then autoTPToNearestFruit() end wait(2) end end)
spawn(function() while true do updateAllFruitESP() wait(1) end end)

-- AUTO KILL THUNDER EVENT
local targetNPCNames = {["Thunder Stuck"]=true,["Thunderstuck"]=true,["Thunder_Stuck"]=true,["[Electrified] Monkey [Lv. 14]"]=true,["[Snowbandit] Monkey [Lv. 90]"]=true}
function attackTargetNPC() for _,npc in pairs(workspace:GetChildren()) do if THUNDER_ON and targetNPCNames[npc.Name] and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then local humanoid = npc.Humanoid while THUNDER_ON and humanoid.Health > 0 and npc.Parent and workspace:FindFirstChild(npc.Name) do hrp.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0,3,0) game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) wait(0.15) end end end end
spawn(function() while true do if THUNDER_ON then attackTargetNPC() end wait(0.5) end end)

-- AUTO HAKI/INSTINCT/V3
local busoKey, instinctKey = Enum.KeyCode.J, Enum.KeyCode.K
local v3Keys = {["Human"]=Enum.KeyCode.T,["Mink"]=Enum.KeyCode.T,["Fishman"]=Enum.KeyCode.T,["Skypiea"]=Enum.KeyCode.T,["Ghoul"]=Enum.KeyCode.T,["Cyborg"]=Enum.KeyCode.T}
function pressKey(key) local vu = game:GetService("VirtualUser") vu:SetKeyDown(key.Name:lower()) wait(0.1) vu:SetKeyUp(key.Name:lower()) end
spawn(function() while true do if AUTO_HAKI_ON then pressKey(busoKey) wait(0.5) pressKey(instinctKey) wait(0.5) end wait(5) end end)
spawn(function() while true do if AUTO_HAKI_ON then local race = player.Data and player.Data.Race and player.Data.Race.Value or "" local v3Key = v3Keys[race] if v3Key then pressKey(v3Key) wait(0.2) end end wait(10) end end)

-- AUTO RAID (BUY CHIP, PILIH RAID, AUTO KILL)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local buyChipRemote = remotes:FindFirstChild("CommF_")
function buyChipAndStartRaid(raidName) local res1 = buyChipRemote:InvokeServer("RaidsNpc", "Select", raidName) wait(0.3) local res2 = buyChipRemote:InvokeServer("RaidsNpc", "Buy") wait(0.3) pcall(function() buyChipRemote:InvokeServer("RaidsNpc", "Start", raidName) end) end
function autoRaidAttackLoop() spawn(function() while true do if AUTO_RAID_ON and workspace:FindFirstChild("Map") then for _, mob in pairs(workspace.Map:GetChildren()) do if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then hrp.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,3,0) game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) wait(0.1) end end end wait(0.25) end end) end
autoRaidAttackLoop()
spawn(function() while true do if AUTO_RAID_ON then if workspace:FindFirstChild("RaidEntrance") and (not workspace:FindFirstChild("Map")) then buyChipAndStartRaid(currentRaid) end end wait(4) end end)