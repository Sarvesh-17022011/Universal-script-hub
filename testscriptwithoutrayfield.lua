-- [[ UNIVERSAL HUB - FULL CUSTOM ENGINE ]]
local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- 1. Cleanup
if CoreGui:FindFirstChild("SarveshHub_Max") then CoreGui:FindFirstChild("SarveshHub_Max"):Destroy() end

-- 2. UI Setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SarveshHub_Max"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- 3. Sidebar & Container
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 130, 0, 10)
Container.Size = UDim2.new(1, -140, 1, -20)
Container.BackgroundTransparency = 1

-- 4. Global Variables & Logic
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local FlyEnabled, FlySpeed, InfJump, Noclip = false, 50, false, false
local ESPEnabled, KillAura, KillAuraRange = false, false, 20
local Fullbright, InfZoom = false, false
local OriginalZoom = Player.CameraMaxZoomDistance

Player.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
end)

-- 5. Feature Creators
local function CreateTab(name, pos)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = (pos == 1)
    Page.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 5)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.Position = UDim2.new(0, 5, 0, (pos-1)*40 + 10)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.Gotham
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
end

-- 6. Setup Tabs
local HomeTab = CreateTab("Home", 1)
local PlayerTab = CreateTab("Player", 2)
local CombatTab = CreateTab("Combat", 3)
local VisualTab = CreateTab("Visuals", 4)
local TeleportTab = CreateTab("Teleport", 5)

-- [[ HOME TAB ]]
local Welcome = Instance.new("TextLabel", HomeTab)
Welcome.Size = UDim2.new(1,0,0,30)
Welcome.Text = "Universal Hub Premium"
Welcome.TextColor3 = Color3.fromRGB(255,255,255)
Welcome.BackgroundTransparency = 1

-- [[ PLAYER TAB ]]
AddToggle(PlayerTab, "Fly", function(v) 
    FlyEnabled = v 
    if v then
        task.spawn(function()
            local bv = Instance.new("BodyVelocity", Character:WaitForChild("HumanoidRootPart"))
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            while FlyEnabled do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)
AddToggle(PlayerTab, "Noclip", function(v) NoclipEnabled = v end)
AddToggle(PlayerTab, "Inf Jump", function(v) InfJump = v end)

-- [[ COMBAT TAB ]]
AddToggle(CombatTab, "Kill Aura", function(v) KillAura = v end)
AddToggle(CombatTab, "ESP", function(v) ESPEnabled = v end)

-- [[ VISUAL TAB ]]
AddToggle(VisualTab, "Fullbright", function(v) 
    Fullbright = v 
    Lighting.Brightness = v and 2 or 1
    Lighting.GlobalShadows = not v
    Lighting.ClockTime = v and 14 or 12
end)
AddToggle(VisualTab, "Inf Zoom", function(v) 
    Player.CameraMaxZoomDistance = v and 10000 or OriginalZoom 
end)

-- [[ TELEPORT TAB ]]
local TP_List = Instance.new("Frame", TeleportTab)
TP_List.Size = UDim2.new(1, 0, 1, 0)
TP_List.BackgroundTransparency = 1
local TP_Layout = Instance.new("UIListLayout", TP_List)

local function UpdateTP()
    for _, v in pairs(TP_List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player then
            local b = Instance.new("TextButton", TP_List)
            b.Size = UDim2.new(1, 0, 0, 25)
            b.Text = "Goto: " .. p.Name
            b.BackgroundColor3 = Color3.fromRGB(40,40,40)
            b.TextColor3 = Color3.fromRGB(200,200,200)
            b.MouseButton1Click:Connect(function()
                Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end)
        end
    end
end
task.spawn(function() while true do UpdateTP() task.wait(10) end end)

-- [[ BACKGROUND LOOPS ]]
UIS.JumpRequest:Connect(function() if InfJump then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and Character then
        for _, v in pairs(Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if ESPEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character)
            end
        end
    end
    if KillAura then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist <= KillAuraRange then
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- Close Button
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("Premium Universal Hub Loaded!")
