--[[
    GEMINI UNIVERSAL HUB V3 (UPDATED)
    Features: All-Button Toggles, Invisible Mode, Multi-Tab UI
]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")

-- VARIABLES
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- TOGGLES & SETTINGS
local Flying = false
local FlySpeed = 50
local Noclipping = false
local KillAura = false
local AuraRange = 20
local InfiniteJump = false
local EspEnabled = false
local InvisibleActive = false
local KeysDown = {W = false, S = false, A = false, D = false, E = false, Q = false}

-- PREVENT DUPLICATES
if CoreGui:FindFirstChild("GeminiHub") then CoreGui.GeminiHub:Destroy() end

-- UI ROOT
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "GeminiHub"
MainGui.Parent = CoreGui

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = MainGui
Instance.new("UICorner", MainFrame)

-- TOP BAR (DRAGGABLE)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar)

-- SIDEBAR & PAGE CONTAINER
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.Parent = MainFrame
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -135, 1, -60)
PageContainer.Position = UDim2.new(0, 130, 0, 55)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- HELPER: TOGGLE BUTTON CREATOR
local function AddToggleButton(txt, parent, callback, isInvisibleBtn)
    local btn = Instance.new("TextButton")
    local active = false
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = txt
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = parent
    Instance.new("UICorner", btn)

    -- Style logic
    if isInvisibleBtn then
        btn.BackgroundTransparency = 1
    else
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end

    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.TextColor3 = Color3.fromRGB(0, 255, 0) -- Turn text green
            if not isInvisibleBtn then btn.BackgroundColor3 = Color3.fromRGB(40, 80, 40) end
        else
            btn.TextColor3 = Color3.new(1, 1, 1) -- Back to white
            if not isInvisibleBtn then btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
        end
        callback(active)
    end)
    return btn
end

-- TAB CREATOR
local Pages = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Parent = Sidebar
    Instance.new("UICorner", btn)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 2, 0)
    page.Parent = PageContainer
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)
    
    Pages[name] = page
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        page.Visible = true
    end)
    return page
end

-- TABS
local PlayerTab = CreateTab("Player")
local CombatTab = CreateTab("Combat")

-- PLAYER FEATURES
AddToggleButton("Invisible Mode", PlayerTab, function(state)
    InvisibleActive = state
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = state and 1 or 0
            end
        end
    end
end, true) -- Set to true for the invisible background style

AddToggleButton("Fly", PlayerTab, function(state) Flying = state end)
AddToggleButton("Noclip", PlayerTab, function(state) Noclipping = state end)

-- COMBAT FEATURES
AddToggleButton("Kill Aura", CombatTab, function(state) KillAura = state end)
AddToggleButton("ESP", CombatTab, function(state) EspEnabled = state end)

-- Restore visibility on first tab
Pages["Player"].Visible = true
