-- [[ UNIVERSAL HUB - EXECUTOR VERSION ]]
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

-- Executor-specific Parenting (Hides UI from game and prevents reset deletion)
local ParentUI = gethui and gethui() or CoreGui

-- 1. Cleanup previous versions
if ParentUI:FindFirstChild("SarveshHub_Ultimate") then 
    ParentUI:FindFirstChild("SarveshHub_Ultimate"):Destroy() 
end

-- 2. Global State Variables
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local FlyEnabled, FlySpeed, WalkSpeedValue = false, 50, 16
local NoclipEnabled, InfJump = false, false
local KillAura, KillAuraRange = false, 20
local ESPEnabled, SelectedESPPlayer = false, nil
local UITheme = Color3.fromRGB(0, 255, 150)
local GodModeEnabled = false

Player.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
end)

-- 3. Core UI Construction
local ScreenGui = Instance.new("ScreenGui", ParentUI)
ScreenGui.Name = "SarveshHub_Ultimate"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 380)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true 
Instance.new("UICorner", Main)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Visible = false
OpenBtn.Text = "HUB"
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = UITheme
OpenStroke.Thickness = 2

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 130, 0, 10)
Container.Size = UDim2.new(1, -140, 1, -20)
Container.BackgroundTransparency = 1

-- 4. Component Functions
local function CreateTab(name, pos)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = (pos == 1)
    Page.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.Position = UDim2.new(0, 5, 0, (pos-1)*40 + 10)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        Page.Visible = true
    end)
    return Page
end

local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and UITheme or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local SFrame = Instance.new("Frame", parent)
    SFrame.Size = UDim2.new(1, 0, 0, 50); SFrame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", SFrame)
    Label.Size = UDim2.new(1, 0, 0, 20); Label.Text = text .. ": " .. default; Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", SFrame)
    Bar.Size = UDim2.new(1, -20, 0, 8); Bar.Position = UDim2.new(0, 10, 0, 30); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = UITheme
    
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. val
        callback(val)
    end
    
    local dragging = false
    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
end

local function ClearESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPTag") then
                p.Character.Head.ESPTag:Destroy()
            end
        end
    end
end

-- 5. Tabs
local HomeTab = CreateTab("Home", 1)
local PlayerTab = CreateTab("Player", 2)
local CombatTab = CreateTab("Combat", 3)
local MainTab = CreateTab("Main", 4)
local TeleportTab = CreateTab("Teleport", 5)

-- HOME TAB
local StatBox = Instance.new("TextLabel", HomeTab)
StatBox.Size = UDim2.new(1, 0, 0, 100); StatBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30); StatBox.TextColor3 = Color3.fromRGB(255,255,255); StatBox.Text = "Select player"; Instance.new("UICorner", StatBox)

local function RefreshHome()
    for _, v in pairs(HomeTab:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", HomeTab); b.Size = UDim2.new(1,0,0,30); b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.fromRGB(255,255,255)
        b.MouseButton1Click:Connect(function()
            local str = "Name: "..p.Name.."\n"
            local ls = p:FindFirstChild("leaderstats")
            if ls then for _, v in pairs(ls:GetChildren()) do str = str..v.Name..": "..tostring(v.Value).." " end end
            StatBox.Text = str
        end)
    end
end
task.spawn(function() while task.wait(5) do RefreshHome() end end)

-- PLAYER TAB: 3D Directional Fly
AddToggle(PlayerTab, "Fly", function(v) 
    FlyEnabled = v 
    if v then
        task.spawn(function()
            local bv = Instance.new("BodyVelocity", Character.HumanoidRootPart)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            while FlyEnabled do
                local cam = workspace.CurrentCamera.CFrame
                local move = Humanoid.MoveDirection
                local vel = Vector3.new(0,0,0)
                if move.Magnitude > 0 then
                    local look = cam.LookVector
                    local right = cam.RightVector
                    local fwd = look.X * move.X + look.Z * move.Z
                    local side = right.X * move.X + right.Z * move.Z
                    vel = (look * fwd) + (right * side)
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0, 1, 0) end
                bv.Velocity = vel.Unit * FlySpeed
                if vel.Magnitude == 0 then bv.Velocity = Vector3.new(0,0,0) end
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)
AddSlider(PlayerTab, "Fly Speed", 1, 300, 50, function(v) FlySpeed = v end)
AddSlider(PlayerTab, "Walk Speed", 16, 250, 16, function(v) WalkSpeedValue = v end)
AddToggle(PlayerTab, "Inf Jump", function(v) InfJump = v end)
AddToggle(PlayerTab, "Noclip", function(v) NoclipEnabled = v end)

-- COMBAT TAB
AddToggle(CombatTab, "Kill Aura", function(v) KillAura = v end)
AddSlider(CombatTab, "Range", 5, 50, 20, function(v) KillAuraRange = v end)
AddToggle(CombatTab, "Target ESP", function(v) ESPEnabled = v; if not v then ClearESP() end end)
local CombatList = Instance.new("Frame", CombatTab); CombatList.Size = UDim2.new(1,0,0,100); CombatList.BackgroundTransparency = 1; Instance.new("UIListLayout", CombatList)
local function RefreshCombat()
    for _, v in pairs(CombatList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do if p ~= Player then
        local b = Instance.new("TextButton", CombatList); b.Size = UDim2.new(1,0,0,25); b.Text = "Select: "..p.Name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.fromRGB(200,200,200)
        b.MouseButton1Click:Connect(function() SelectedESPPlayer = p; ClearESP() end)
    end end
end
task.spawn(function() while task.wait(5) do RefreshCombat() end end)

-- MAIN TAB (God Mode Added)
AddToggle(MainTab, "God Mode (ForceField)", function(v)
    GodModeEnabled = v
    if v then
        task.spawn(function()
            while GodModeEnabled do
                if Character and not Character:FindFirstChildOfClass("ForceField") then
                    Instance.new("ForceField", Character).Visible = true
                end
                task.wait(0.5)
            end
            if Character and Character:FindFirstChildOfClass("ForceField") then 
                Character:FindFirstChildOfClass("ForceField"):Destroy() 
            end
        end)
    end
end)
AddToggle(MainTab, "Fullbright", function(v) Lighting.Brightness = v and 2 or 1; Lighting.GlobalShadows = not v; Lighting.ClockTime = v and 14 or 12 end)
local Hop = Instance.new("TextButton", MainTab); Hop.Size = UDim2.new(1,0,0,35); Hop.Text = "Server Hop"; Hop.BackgroundColor3 = Color3.fromRGB(60,60,60); Hop.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", Hop)
Hop.MouseButton1Click:Connect(function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
    for _, s in pairs(x.data) do if s.playing < s.max and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id) break end end
end)

local function AddTheme(name, color)
    local b = Instance.new("TextButton", MainTab); b.Size = UDim2.new(1,0,0,30); b.Text = name; b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() UITheme = color; OpenStroke.Color = color; ClearESP() end)
end
AddTheme("Neon Green", Color3.fromRGB(0, 255, 150))
AddTheme("Ocean Blue", Color3.fromRGB(0, 150, 255))
AddTheme("Blood Red", Color3.fromRGB(255, 50, 50))

-- TELEPORT TAB
local function RefreshTP()
    for _, v in pairs(TeleportTab:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do if p ~= Player then
        local b = Instance.new("TextButton", TeleportTab); b.Size = UDim2.new(1,0,0,30); b.Text = "TP to "..p.Name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() if p.Character then Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0) end end)
    end end
end
task.spawn(function() while task.wait(5) do RefreshTP() end end)

-- 6. Main Processing Loop
RunService.Stepped:Connect(function()
    if NoclipEnabled and Character then for _, v in pairs(Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if Humanoid and not FlyEnabled then Humanoid.WalkSpeed = WalkSpeedValue end
    
    if KillAura then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude <= KillAuraRange then
                    local t = Character:FindFirstChildOfClass("Tool")
                    if t then t:Activate() end
                end
            end
        end
    end
    
    if ESPEnabled and SelectedESPPlayer and SelectedESPPlayer.Character then
        local char = SelectedESPPlayer.Character
        local head = char:FindFirstChild("Head")
        if head then
            if not char:FindFirstChild("Highlight") then local h = Instance.new("Highlight", char); h.FillColor = UITheme end
            if not head:FindFirstChild("ESPTag") then
                local b = Instance.new("BillboardGui", head); b.Name = "ESPTag"; b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255,255,255); l.Font = Enum.Font.GothamBold; l.TextStrokeTransparency = 0
            end
            local d = math.floor((Character.HumanoidRootPart.Position - head.Position).Magnitude)
            head.ESPTag.TextLabel.Text = SelectedESPPlayer.DisplayName .. "\n[" .. d .. "m]"
        end
    elseif not ESPEnabled then
        ClearESP()
    end
end)

UIS.JumpRequest:Connect(function() if InfJump then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- Close/Open Logic
local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5); Close.Text = "-"; Close.BackgroundColor3 = Color3.fromRGB(50,50,50); Close.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)
