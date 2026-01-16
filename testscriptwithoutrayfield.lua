-- [[ SERVICES ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ MAIN UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProHub_Final"
ScreenGui.ResetOnSpawn = false
-- Parent to CoreGui for executors, or PlayerGui for Studio testing
local parent = (gethui and gethui()) or (runSenv and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = parent

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- [[ TOP BAR / MARGIN ]]
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "  PRO SCRIPT HUB | V1.0"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 40, 1, 0)
MinBtn.Position = UDim2.new(1, -85, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = TopBar

-- [[ SIDEBAR ]]
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 120, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 2)
SideLayout.Parent = SideBar

-- [[ PAGE CONTAINER ]]
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -130, 1, -50)
PageContainer.Position = UDim2.new(0, 125, 0, 45)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- [[ TOGGLE BUTTON (For Minimize) ]]
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
OpenBtn.Text = "OPEN"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- [[ HELPER FUNCTIONS ]]
local pages = {}

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = SideBar
    
    local pg = Instance.new("ScrollingFrame")
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = false
    pg.ScrollBarThickness = 3
    pg.Parent = PageContainer
    
    local pgLayout = Instance.new("UIListLayout")
    pgLayout.Padding = UDim.new(0, 8)
    pgLayout.Parent = pg
    
    pages[name] = pg
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pg.Visible = true
    end)
    return pg
end

local function createSlider(name, min, max, default, parent, callback)
    local title = Instance.new("TextLabel")
    title.Text = name .. ": " .. default
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Parent = parent

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 10)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderFrame.Parent = parent

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    bar.BorderSizePixel = 0
    bar.Parent = sliderFrame

    local function update(input)
        local pos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        bar.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (pos * (max - min)))
        title.Text = name .. ": " .. val
        callback(val)
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            update(input)
            local moveCon; moveCon = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                    update(move)
                end
            end)
            UserInputService.InputEnded:Connect(function(up)
                if up.UserInputType == Enum.UserInputType.MouseButton1 or up.UserInputType == Enum.UserInputType.Touch then
                    moveCon:Disconnect()
                end
            end)
        end
    end)
end

local function createToggle(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = parent
    Instance.new("UICorner", btn)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(50, 50, 50)
        callback(enabled)
    end)
end

-- [[ TAB 1: HOME (PLAYER & GAME INFO) ]]
local homePg = createTab("Home")
homePg.Visible = true

local pList = Instance.new("ScrollingFrame")
pList.Size = UDim2.new(1, -10, 0, 100)
pList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
pList.Parent = homePg
Instance.new("UIListLayout", pList)

local infoBox = Instance.new("TextLabel")
infoBox.Size = UDim2.new(1, -10, 0, 80)
infoBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
infoBox.TextColor3 = Color3.new(1, 1, 1)
infoBox.Text = "Select player..."
infoBox.TextWrapped = true
infoBox.Parent = homePg

local gameInfo = Instance.new("TextLabel")
gameInfo.Size = UDim2.new(1, -10, 0, 40)
gameInfo.Text = "Game: " .. game.Name .. "\nID: " .. game.PlaceId
gameInfo.Parent = homePg

local selectedHomePlayer = nil
task.spawn(function()
    while task.wait(2) do
        for _, v in pairs(pList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            local b = Instance.new("TextButton", pList)
            b.Size = UDim2.new(1, 0, 0, 25)
            b.Text = p.Name
            b.MouseButton1Click:Connect(function() selectedHomePlayer = p end)
        end
        if selectedHomePlayer and selectedHomePlayer.Parent then
            infoBox.Text = "Name: " .. selectedHomePlayer.Name .. "\nTeam: " .. tostring(selectedHomePlayer.Team) .. "\nHealth: " .. (selectedHomePlayer.Character and selectedHomePlayer.Character.Humanoid.Health or 0)
        end
    end
end)

-- [[ TAB 2: MAIN (OBJECT EXPLORER) ]]
local mainPg = createTab("Main")
local objList = Instance.new("ScrollingFrame", mainPg)
objList.Size = UDim2.new(1, -10, 0, 120)
objList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UIListLayout", objList)

local objInfo = Instance.new("TextLabel", mainPg)
objInfo.Size = UDim2.new(1, -10, 0, 80)
objInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
objInfo.Text = "Interactables scan..."

task.spawn(function()
    while task.wait(5) do
        for _, v in pairs(objList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") or v:IsA("ClickDetector") then
                local b = Instance.new("TextButton", objList)
                b.Size = UDim2.new(1,0,0,25); b.Text = v.ClassName .. ": " .. v.Parent.Name
                b.MouseButton1Click:Connect(function() objInfo.Text = "Path: " .. v:GetFullName() end)
            end
        end
    end
end)

-- [[ TAB 3: PLAYER ]]
local playerPg = createTab("Player")
local flySpeed = 50
local flying, noclip, infJump = false, false, false

createSlider("WalkSpeed", 16, 300, 16, playerPg, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)
createSlider("Fly Speed", 10, 500, 50, playerPg, function(v) flySpeed = v end)
createToggle("Fly", playerPg, function(state) 
    flying = state 
    if state then
        local bv = Instance.new("BodyVelocity", LocalPlayer.Character.PrimaryPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)
createToggle("NoClip", playerPg, function(state) noclip = state end)
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
createToggle("Inf Jump", playerPg, function(state) infJump = state end)
UserInputService.JumpRequest:Connect(function() if infJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

-- [[ TAB 4: COMBAT ]]
local combatPg = createTab("Combat")
local auraRange, auraEnabled, espEnabled = 20, false, false

createSlider("Aura Range", 5, 100, 20, combatPg, function(v) auraRange = v end)
createToggle("Kill Aura", combatPg, function(state) auraEnabled = state end)
createToggle("Player ESP", combatPg, function(state) espEnabled = state end)

task.spawn(function()
    while task.wait(0.1) do
        if auraEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= auraRange then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
    end
end)

-- [[ TAB 5: TELEPORT ]]
local teleportPg = createTab("Teleport")
local tpScroll = Instance.new("ScrollingFrame", teleportPg)
tpScroll.Size = UDim2.new(1, -10, 0, 150)
tpScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UIListLayout", tpScroll)

local function tp(cf) if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = cf end end

local spawnBtn = Instance.new("TextButton", teleportPg)
spawnBtn.Size = UDim2.new(1,-10,0,35); spawnBtn.Text = "TP to Spawn"; spawnBtn.BackgroundColor3 = Color3.fromRGB(0,80,200)
spawnBtn.MouseButton1Click:Connect(function() tp(CFrame.new(0,50,0)) end)

task.spawn(function()
    while task.wait(3) do
        for _, v in pairs(tpScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local b = Instance.new("TextButton", tpScroll)
                b.Size = UDim2.new(1,0,0,25); b.Text = "TP to: " .. p.Name
                b.MouseButton1Click:Connect(function() if p.Character then tp(p.Character.HumanoidRootPart.CFrame) end end)
            end
        end
    end
end)

-- [[ DRAGGING & MINIMIZE LOGIC ]]
local function makeDrag(obj, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) dragging = false end)
end

makeDrag(MainFrame, TopBar)
makeDrag(OpenBtn, OpenBtn)

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
