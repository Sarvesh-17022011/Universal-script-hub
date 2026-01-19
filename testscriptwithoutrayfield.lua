-- --- 1. CORE SETTINGS & DRAGGING ---
local ScreenGui = Instance.new("ScreenGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

ScreenGui.Name = "UniversalHub_Final"
ScreenGui.ResetOnSpawn = false
local success, err = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 350)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Mobile/PC Dragging Script
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end end)

-- Header Section
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35); Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Header.BorderSizePixel = 0; Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "Universal Script Hub"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 16; Title.TextXAlignment = 0; Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 25); CloseBtn.Position = UDim2.new(1, -35, 0, 5); CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(150,50,50); CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- --- 2. TAB SYSTEM NAVIGATION ---
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(0, 80, 1, -35); TabButtons.Position = UDim2.new(0, 0, 0, 35); TabButtons.BackgroundColor3 = Color3.fromRGB(35, 35, 35); TabButtons.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabButtons; TabListLayout.Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -85, 1, -40); ContentArea.Position = UDim2.new(0, 85, 0, 40); ContentArea.BackgroundTransparency = 1; ContentArea.Parent = MainFrame

local HomeTab = Instance.new("ScrollingFrame")
HomeTab.Size = UDim2.new(1, 0, 1, 0); HomeTab.BackgroundTransparency = 1; HomeTab.ScrollBarThickness = 2; HomeTab.Parent = ContentArea

local MainTab = Instance.new("ScrollingFrame")
MainTab.Size = UDim2.new(1, 0, 1, 0); MainTab.BackgroundTransparency = 1; MainTab.Visible = false; MainTab.ScrollBarThickness = 2; MainTab.Parent = ContentArea

local function showTab(tab)
    HomeTab.Visible = (tab == HomeTab)
    MainTab.Visible = (tab == MainTab)
end

local function createTabBtn(name, target)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(50,50,50); btn.TextColor3 = Color3.new(1,1,1); btn.Parent = TabButtons
    btn.MouseButton1Click:Connect(function() showTab(target) end)
end
createTabBtn("Home", HomeTab)
createTabBtn("Main", MainTab)

-- --- 3. FULL HOME TAB (RESTORED FEATURES) ---
local HomeLayout = Instance.new("UIListLayout"); HomeLayout.Parent = HomeTab; HomeLayout.Padding = UDim.new(0, 8)

-- Player Dropdown
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Size = UDim2.new(1, -10, 0, 35); DropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60); DropdownFrame.Parent = HomeTab

local SelectedPlayerLabel = Instance.new("TextLabel")
SelectedPlayerLabel.Size = UDim2.new(1, -40, 1, 0); SelectedPlayerLabel.Position = UDim2.new(0, 10, 0, 0); SelectedPlayerLabel.Text = "Select a Player..."; SelectedPlayerLabel.TextColor3 = Color3.new(1,1,1); SelectedPlayerLabel.BackgroundTransparency = 1; SelectedPlayerLabel.TextXAlignment = 0; SelectedPlayerLabel.Parent = DropdownFrame

local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Size = UDim2.new(0, 30, 0, 30); DropdownBtn.Position = UDim2.new(1, -32, 0, 2); DropdownBtn.Text = "V"; DropdownBtn.Parent = DropdownFrame

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, 0, 0, 120); PlayerListFrame.Position = UDim2.new(0, 0, 1, 2); PlayerListFrame.Visible = false; PlayerListFrame.ZIndex = 50; PlayerListFrame.BackgroundColor3 = Color3.fromRGB(45,45,45); PlayerListFrame.AutomaticCanvasSize = 2; PlayerListFrame.Parent = DropdownFrame
Instance.new("UIListLayout", PlayerListFrame)

-- Info Box
local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(1, -10, 0, 100); InfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); InfoFrame.Parent = HomeTab

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -20, 1, -20); InfoText.Position = UDim2.new(0, 10, 0, 10); InfoText.BackgroundTransparency = 1; InfoText.TextColor3 = Color3.new(0.9, 0.9, 0.9); InfoText.TextXAlignment = 0; InfoText.TextYAlignment = 0; InfoText.RichText = true; InfoText.Text = "Select a player to view info."; InfoText.Parent = InfoFrame

-- Game Info
local GameFrame = Instance.new("Frame")
GameFrame.Size = UDim2.new(1, -10, 0, 70); GameFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); GameFrame.Parent = HomeTab

local GameText = Instance.new("TextLabel")
GameText.Size = UDim2.new(1, -20, 1, -20); GameText.Position = UDim2.new(0, 10, 0, 10); GameText.BackgroundTransparency = 1; GameText.TextColor3 = Color3.fromRGB(100, 200, 255); GameText.TextXAlignment = 0; GameText.Font = 3; GameText.Parent = GameFrame

local selectedPlayer = nil
local function updatePlayerInfo()
    if not selectedPlayer or not game.Players:FindFirstChild(selectedPlayer.Name) then return end
    local p = selectedPlayer
    local team = p.Team and p.Team.Name or "Neutral"
    local statsStr = ""
    local ls = p:FindFirstChild("leaderstats")
    if ls then for _, v in pairs(ls:GetChildren()) do statsStr = statsStr .. "\n" .. v.Name .. ": " .. tostring(v.Value) end end
    InfoText.Text = "<b>Name:</b> " .. p.Name .. "\n<b>Team:</b> " .. team .. statsStr
end

DropdownBtn.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        for _, v in pairs(PlayerListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in pairs(game.Players:GetPlayers()) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 25); b.Text = p.Name; b.ZIndex = 51; b.Parent = PlayerListFrame
            b.MouseButton1Click:Connect(function() selectedPlayer = p; SelectedPlayerLabel.Text = p.Name; PlayerListFrame.Visible = false; updatePlayerInfo() end)
        end
    end
end)

local gName = "Unknown"
pcall(function() gName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
GameText.Text = "Game: " .. gName .. "\nID: " .. game.PlaceId .. "\nJob: " .. game.JobId:sub(1,6)

-- --- 4. MAIN TAB (INTERACTABLES) ---
Instance.new("UIListLayout", MainTab).Padding = UDim.new(0, 5)

local function trigger(obj)
    if obj:IsA("ProximityPrompt") then fireproximityprompt(obj)
    elseif obj:IsA("ClickDetector") then fireclickdetector(obj)
    elseif obj:IsA("TouchTransmitter") then 
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, obj.Parent, 0)
        task.wait(0.1)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, obj.Parent, 1)
    end
end

local function refreshInteracts()
    for _, v in pairs(MainTab:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") or v:IsA("ClickDetector") or v:IsA("TouchTransmitter") then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -10, 0, 30); b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.TextColor3 = Color3.new(1,1,1); b.Text = "Trigger: " .. v.Parent.Name; b.Parent = MainTab
            b.MouseButton1Click:Connect(function() trigger(v) end)
        end
    end
end

-- Update Loops
RunService.RenderStepped:Connect(function() if selectedPlayer then updatePlayerInfo() end end)
task.spawn(function() while task.wait(5) do if MainTab.Visible then refreshInteracts() end end end)
-- --- 5. PLAYER TAB (CHEAT FEATURES) ---

local PlayerTab = Instance.new("ScrollingFrame")
PlayerTab.Size = UDim2.new(1, 0, 1, 0)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Visible = false
PlayerTab.ScrollBarThickness = 2
PlayerTab.Parent = ContentArea

createTabBtn("Player", PlayerTab)
local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerTab
PlayerLayout.Padding = UDim.new(0, 8)

-- --- SETTINGS & VARIABLES ---
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local infJumpEnabled = false

-- --- HELPER: CREATE BUTTON ---
local function createButton(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- --- HELPER: CREATE SLIDER ---
local function createSlider(name, min, max, parent, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. min
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Parent = frame

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 0, 20)
    sliderBtn.Position = UDim2.new(0, 0, 0, 25)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderBtn.Text = ""
    sliderBtn.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.size(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    bar.BorderSizePixel = 0
    bar.Parent = sliderBtn

    local function move()
        local mousePos = UIS:GetMouseLocation().X
        local relativePos = mousePos - sliderBtn.AbsolutePosition.X
        local percentage = math.clamp(relativePos / sliderBtn.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percentage)
        bar.Size = UDim2.new(percentage, 0, 1, 0)
        label.Text = name .. ": " .. value
        callback(value)
    end

    sliderBtn.MouseButton1Down:Connect(function()
        local moveConn
        moveConn = UIS.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                move()
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                moveConn:Disconnect()
            end
        end)
        move()
    end)
end

-- --- FEATURE LOGIC ---

-- Fly
createButton("Toggle Fly", PlayerTab, function()
    flyEnabled = not flyEnabled
    local bv, bg
    if flyEnabled then
        bv = Instance.new("BodyVelocity", char:WaitForChild("HumanoidRootPart"))
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Name = "FlyBV"
        bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.P = 1e4
        bg.Name = "FlyBG"
    else
        if char.HumanoidRootPart:FindFirstChild("FlyBV") then char.HumanoidRootPart.FlyBV:Destroy() end
        if char.HumanoidRootPart:FindFirstChild("FlyBG") then char.HumanoidRootPart.FlyBG:Destroy() end
    end
end)

createSlider("Fly Speed", 1, 300, PlayerTab, function(v) flySpeed = v end)

-- WalkSpeed
createSlider("Walk Speed", 16, 250, PlayerTab, function(v) 
    lp.Character.Humanoid.WalkSpeed = v 
end)

-- Inf Jump
createButton("Inf Jump", PlayerTab, function()
    infJumpEnabled = not infJumpEnabled
end)

UIS.JumpRequest:Connect(function()
    if infJumpEnabled then lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- Noclip
createButton("Noclip", PlayerTab, function()
    noclipEnabled = not noclipEnabled
end)

-- Invisibility (Clientside bypass)
createButton("Invisible", PlayerTab, function()
    local oldPos = char.HumanoidRootPart.CFrame
    char.HumanoidRootPart.CFrame = CFrame.new(0, 99999, 0)
    task.wait(0.2)
    local fake = char:Clone()
    fake.Parent = workspace
    char.HumanoidRootPart.CFrame = oldPos
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
    end
end)

-- --- FLY & NOCLIP LOOP ---
RunService.Stepped:Connect(function()
    char = lp.Character
    if flyEnabled and char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local bv = root:FindFirstChild("FlyBV")
        local bg = root:FindFirstChild("FlyBG")
        if bv and bg then
            bg.CFrame = workspace.CurrentCamera.CFrame
            local direction = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
            bv.Velocity = direction * flySpeed
        end
    end
    if noclipEnabled then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
-- --- 6. COMBAT TAB (KILL AURA & ESP) ---

local CombatTab = Instance.new("ScrollingFrame")
CombatTab.Size = UDim2.new(1, 0, 1, 0)
CombatTab.BackgroundTransparency = 1
CombatTab.Visible = false
CombatTab.ScrollBarThickness = 2
CombatTab.Parent = ContentArea

createTabBtn("Combat", CombatTab)
local CombatLayout = Instance.new("UIListLayout")
CombatLayout.Parent = CombatTab
CombatLayout.Padding = UDim.new(0, 8)

-- --- SETTINGS ---
local killAuraEnabled = false
local killAuraRange = 20
local espEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)

-- --- KILL AURA LOGIC ---
createButton("Toggle Kill Aura", CombatTab, function()
    killAuraEnabled = not killAuraEnabled
end)

createSlider("Aura Range", 5, 50, CombatTab, function(v)
    killAuraRange = v
end)

task.spawn(function()
    while task.wait(0.1) do
        if killAuraEnabled then
            local p = game.Players.LocalPlayer
            local char = p.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            
            if tool then
                for _, enemy in pairs(game.Players:GetPlayers()) do
                    if enemy ~= p and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - enemy.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= killAuraRange and enemy.Character.Humanoid.Health > 0 then
                            -- Standard tool activation
                            tool:Activate()
                            -- Some games require manual remote firing; this is universal activation
                        end
                    end
                end
            end
        end
    end
end)

-- --- ESP LOGIC ---
createButton("Toggle ESP", CombatTab, function()
    espEnabled = not espEnabled
    if not espEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then
                p.Character.ESPHighlight:Destroy()
                if p.Character.Head:FindFirstChild("ESPNameTag") then
                    p.Character.Head.ESPNameTag:Destroy()
                end
            end
        end
    end
end)

local function createESP(plr)
    if not espEnabled or plr == game.Players.LocalPlayer or not plr.Character then return end
    
    -- Highlight
    local hl = plr.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
    hl.Name = "ESPHighlight"
    hl.FillColor = espColor
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.5
    hl.Parent = plr.Character
    
    -- Billboard Name/Distance Tag
    local head = plr.Character:FindFirstChild("Head")
    if head and not head:FindFirstChild("ESPNameTag") then
        local bb = Instance.new("BillboardGui")
        bb.Name = "ESPNameTag"
        bb.Size = UDim2.new(0, 100, 0, 50)
        bb.AlwaysOnTop = true
        bb.ExtentsOffset = Vector3.new(0, 3, 0)
        bb.Parent = head
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.new(1,1,1)
        txt.TextStrokeTransparency = 0
        txt.Font = Enum.Font.SourceSansBold
        txt.TextSize = 14
        txt.Parent = bb
    end
    
    local tag = head:FindFirstChild("ESPNameTag")
    if tag then
        local dist = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
        tag.TextLabel.Text = plr.Name .. "\n[" .. dist .. "m]"
        tag.TextLabel.TextColor3 = espColor
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            createESP(p)
        end
    end
end)

-- --- ESP COLOR PICKER ---
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(1, 0, 0, 20)
ColorLabel.Text = "ESP Colors:"
ColorLabel.TextColor3 = Color3.new(1, 1, 1)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Parent = CombatTab

local ColorGrid = Instance.new("Frame")
ColorGrid.Size = UDim2.new(1, -10, 0, 40)
ColorGrid.BackgroundTransparency = 1
ColorGrid.Parent = CombatTab

local GridL = Instance.new("UIGridLayout")
GridL.Parent = ColorGrid
GridL.CellSize = UDim2.new(0, 35, 0, 35)

local colors = {
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 150, 255),
    Yellow = Color3.fromRGB(255, 255, 0),
    White = Color3.fromRGB(255, 255, 255)
}

for name, color in pairs(colors) do
    local cBtn = Instance.new("TextButton")
    cBtn.Text = ""
    cBtn.BackgroundColor3 = color
    cBtn.Parent = ColorGrid
    cBtn.MouseButton1Click:Connect(function()
        espColor = color
    end)
end
-- --- 7. TELEPORT TAB (PLAYER & SPAWN) ---

local TeleportTab = Instance.new("ScrollingFrame")
TeleportTab.Size = UDim2.new(1, 0, 1, 0)
TeleportTab.BackgroundTransparency = 1
TeleportTab.Visible = false
TeleportTab.ScrollBarThickness = 2
TeleportTab.Parent = ContentArea

createTabBtn("Teleport", TeleportTab)
local TeleportLayout = Instance.new("UIListLayout")
TeleportLayout.Parent = TeleportTab
TeleportLayout.Padding = UDim.new(0, 8)

-- --- SPAWN TELEPORT ---
createButton("Teleport to Spawn", TeleportTab, function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Find the first SpawnLocation in the game
        local spawnPos = workspace:FindFirstChildOfClass("SpawnLocation")
        if spawnPos then
            char.HumanoidRootPart.CFrame = spawnPos.CFrame + Vector3.new(0, 3, 0)
        else
            -- Fallback if no SpawnLocation object is found (Teleports to map center)
            char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
end)

-- --- PLAYER TELEPORT LIST ---
local TPLabel = Instance.new("TextLabel")
TPLabel.Size = UDim2.new(1, 0, 0, 25)
TPLabel.Text = "Select Player to Teleport:"
TPLabel.TextColor3 = Color3.new(1, 1, 1)
TPLabel.BackgroundTransparency = 1
TPLabel.Font = Enum.Font.SourceSansBold
TPLabel.Parent = TeleportTab

local TPPlayerList = Instance.new("Frame")
TPPlayerList.Size = UDim2.new(1, -10, 0, 200) -- Adjust height based on needs
TPPlayerList.BackgroundTransparency = 1
TPPlayerList.Parent = TeleportTab

local TPListLayout = Instance.new("UIListLayout")
TPListLayout.Parent = TPPlayerList
TPListLayout.Padding = UDim.new(0, 5)

-- Function to refresh the TP list
local function refreshTPList()
    -- Clear existing buttons
    for _, child in pairs(TPPlayerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    -- Add players
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            pBtn.Text = "Goto: " .. plr.Name
            pBtn.TextColor3 = Color3.new(1, 1, 1)
            pBtn.BorderSizePixel = 0
            pBtn.Parent = TPPlayerList
            
            pBtn.MouseButton1Click:Connect(function()
                local me = game.Players.LocalPlayer.Character
                local target = plr.Character
                if me and target and target:FindFirstChild("HumanoidRootPart") then
                    me.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                end
            end)
        end
    end
end

-- Initial Refresh
refreshTPList()

-- Auto-Refresh Player List for TP every 5 seconds
task.spawn(function()
    while task.wait(5) do
        if TeleportTab.Visible then
            refreshTPList()
        end
    end
end)
