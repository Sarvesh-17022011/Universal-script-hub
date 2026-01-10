-- [[ UNIVERSAL HUB - NO LIBRARY VERSION ]]
local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cleanup
if CoreGui:FindFirstChild("SarveshHub") then CoreGui:FindFirstChild("SarveshHub"):Destroy() end

-- [[ UI CONSTRUCT ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SarveshHub"

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5) -- Perfect Centering
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 110, 0, 10)
Container.Size = UDim2.new(1, -120, 1, -20)
Container.BackgroundTransparency = 1

-- [[ STATE VARIABLES ]]
local Character = Player.Character or Player.CharacterAdded:Wait()
local FlyEnabled, FlySpeed, WalkSpeed, InfJump, Noclip = false, 50, 16, false, false
local ESPEnabled, KillAura = false, false

-- [[ COMPONENT CREATOR ]]
local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 5)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, -10, 0, 30)
    TabBtn.Position = UDim2.new(0, 5, 0, (#Sidebar:GetChildren()-1)*35 + 5)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)
    return Page
end

-- [[ TABS SETUP ]]
local Home = CreateTab("Home")
local PlayerTab = CreateTab("Player")
local Combat = CreateTab("Combat")
local Teleport = CreateTab("Teleport")

-- [[ PLAYER FEATURES ]]
local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local sFrame = Instance.new("Frame", parent)
    sFrame.Size = UDim2.new(1, 0, 0, 40)
    sFrame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", sFrame)
    label.Text = text .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    
    local bar = Instance.new("TextButton", sFrame)
    bar.Position = UDim2.new(0, 0, 0, 25)
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Text = ""
    bar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    bar.MouseButton1Click:Connect(function()
        local mousePos = UIS:GetMouseLocation().X - bar.AbsolutePosition.X
        local percent = math.clamp(mousePos/bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percent)
        label.Text = text .. ": " .. val
        callback(val)
    end)
end

-- [[ FEATURE LOGIC ]]
AddToggle(PlayerTab, "Fly", function(v) 
    FlyEnabled = v 
    if v then
        task.spawn(function()
            local bv = Instance.new("BodyVelocity", Character.HumanoidRootPart)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            while FlyEnabled do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

AddSlider(PlayerTab, "WalkSpeed", 16, 250, 16, function(v) Character.Humanoid.WalkSpeed = v end)
AddToggle(PlayerTab, "Noclip", function(v) NoclipEnabled = v end)
AddToggle(Combat, "Player ESP", function(v) ESPEnabled = v end)

-- [[ AUTO-REFRESHING PLAYER TELEPORT ]]
local TPContainer = Instance.new("Frame", Teleport)
TPContainer.Size = UDim2.new(1, 0, 1, 0)
TPContainer.BackgroundTransparency = 1

local function RefreshTP()
    for _, v in pairs(TPContainer:GetChildren()) do v:Destroy() end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player then
            local pBtn = Instance.new("TextButton", TPContainer)
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.Text = "TP to " .. p.Name
            pBtn.MouseButton1Click:Connect(function()
                Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            end)
        end
    end
end

task.spawn(function()
    while task.wait(5) do RefreshTP() end
end)

-- [[ SYSTEMS HANDLER ]]
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if ESPEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character)
            end
        end
    end
end)

Home.Visible = true
RefreshTP()
