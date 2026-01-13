--[[
    GEMINI UNIVERSAL HUB V3 (UPDATED)
    Features: Advanced Directional Fly, ESP, Kill Aura, Object Scanner, Multi-Tab UI
    No External Libraries Required
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
local Mouse = LocalPlayer:GetMouse()

-- TOGGLES & SETTINGS
local Flying = false
local FlySpeed = 50
local Noclipping = false
local KillAura = false
local AuraRange = 20
local InfiniteJump = false
local EspEnabled = false
local ScanKeywords = {"Chest", "Safe", "Box", "Crate", "Money", "Gold", "Item", "Tool"}
local KeysDown = {W = false, S = false, A = false, D = false, E = false, Q = false}

-- PREVENT DUPLICATES
if CoreGui:FindFirstChild("GeminiHub") then CoreGui.GeminiHub:Destroy() end

-- UI ROOT
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "GeminiHub"
MainGui.Parent = CoreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- TOP BAR (DRAGGABLE)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "GEMINI UNIVERSAL HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

-- PAGE CONTAINER
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -135, 1, -60)
PageContainer.Position = UDim2.new(0, 130, 0, 55)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- UTILITY FUNCTIONS
local function MakeDraggable(obj, target)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

local Pages = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Sidebar
    Instance.new("UICorner", btn)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
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

local function AddButton(txt, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function AddSlider(txt, min, max, parent, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = txt .. " (" .. min .. ")"
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    
    local bar = Instance.new("TextButton", container)
    bar.Size = UDim2.new(1, 0, 0, 15)
    bar.Position = UDim2.new(0, 0, 0, 25)
    bar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    bar.Text = ""
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    
    local function update(input)
        local ratio = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        local val = math.floor(min + (max - min) * ratio)
        label.Text = txt .. " (" .. val .. ")"
        callback(val)
    end
    bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then update(input) end end)
end

-- FLY INPUT TRACKING
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode.Name
    if KeysDown[key] ~= nil then KeysDown[key] = true end
end)

UserInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode.Name
    if KeysDown[key] ~= nil then KeysDown[key] = false end
end)

local function GetFlyDirection()
    local dir = Vector3.new(0,0,0)
    if KeysDown.W then dir = dir + Camera.CFrame.LookVector end
    if KeysDown.S then dir = dir - Camera.CFrame.LookVector end
    if KeysDown.D then dir = dir + Camera.CFrame.RightVector end
    if KeysDown.A then dir = dir - Camera.CFrame.RightVector end
    if KeysDown.E then dir = dir + Vector3.new(0,1,0) end
    if KeysDown.Q then dir = dir - Vector3.new(0,1,0) end
    return dir
end

-- MAIN LOOP (FLY, NOCLIP)
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        if Flying then
            root.Velocity = GetFlyDirection() * FlySpeed
        end
        if Noclipping then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        end
    end
end)

-- TABS INITIALIZATION
local HomeTab = CreateTab("Home")
local MainTab = CreateTab("Main")
local PlayerTab = CreateTab("Player")
local CombatTab = CreateTab("Combat")
local TeleportTab = CreateTab("Teleports")
local ThemeTab = CreateTab("Themes")

--- [HOME TAB] ---
local gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local infoText = Instance.new("TextLabel", HomeTab)
infoText.Size = UDim2.new(1, 0, 0, 80)
infoText.Text = "Game: "..gameName.."\nID: "..game.PlaceId.."\nUser: "..LocalPlayer.Name
infoText.TextColor3 = Color3.new(1,1,1)
infoText.BackgroundTransparency = 1
infoText.TextWrapped = true

local pList = Instance.new("ScrollingFrame", HomeTab)
pList.Size = UDim2.new(1, 0, 0, 200)
pList.BackgroundColor3 = Color3.new(0,0,0)
pList.BackgroundTransparency = 0.5
Instance.new("UIListLayout", pList)

local function UpdatePlayers()
    for _, v in pairs(pList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        AddButton(p.Name, pList, function()
            infoText.Text = "Target: "..p.Name.."\nAccount Age: "..p.AccountAge.." days\nTeam: "..(p.Team and p.Team.Name or "None")
        end)
    end
end
AddButton("Refresh Players", HomeTab, UpdatePlayers)

--- [MAIN TAB] - OBJECT SCANNER ---
local objList = Instance.new("ScrollingFrame", MainTab)
objList.Size = UDim2.new(1, 0, 0, 300)
objList.BackgroundTransparency = 0.5
Instance.new("UIListLayout", objList)

AddButton("Scan Workspace Objects", MainTab, function()
    for _, v in pairs(objList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, obj in pairs(workspace:GetDescendants()) do
        local match = false
        for _, word in pairs(ScanKeywords) do if string.find(string.lower(obj.Name), string.lower(word)) then match = true break end end
        if match and (obj:IsA("BasePart") or obj:IsA("Model")) then
            AddButton("["..obj.ClassName.."] "..obj.Name, objList, function()
                LocalPlayer.Character:MoveTo(obj:IsA("Model") and obj:GetModelCFrame().p or obj.Position)
            end)
        end
    end
end)

--- [PLAYER TAB] ---
AddButton("Toggle Directional Fly", PlayerTab, function()
    Flying = not Flying
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        if not Flying then root.Velocity = Vector3.new(0,0,0) end
    end
end)

AddSlider("Fly Speed", 10, 300, PlayerTab, function(v) FlySpeed = v end)
AddSlider("WalkSpeed", 16, 300, PlayerTab, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)

AddButton("Toggle Noclip", PlayerTab, function()
    Noclipping = not Noclipping
end)

AddButton("Infinite Jump", PlayerTab, function()
    InfiniteJump = not InfiniteJump
    UserInputService.JumpRequest:Connect(function() 
        if InfiniteJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end 
    end)
end)

--- [COMBAT TAB] ---
AddButton("Advanced Kill Aura", CombatTab, function()
    KillAura = not KillAura
    task.spawn(function()
        while KillAura do
            task.wait(0.1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hum = p.Character:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 and (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < AuraRange then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
    end)
end)

AddSlider("Aura Range", 5, 50, CombatTab, function(v) AuraRange = v end)

AddButton("Toggle ESP", CombatTab, function()
    EspEnabled = not EspEnabled
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if EspEnabled then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "GeminiESP"
                h.FillTransparency = 0.5
                h.OutlineColor = Color3.new(1, 0, 0)
            elseif p.Character:FindFirstChild("GeminiESP") then
                p.Character.GeminiESP:Destroy()
            end
        end
    end
end)

--- [TELEPORT TAB] ---
AddButton("TP to Spawn", TeleportTab, function()
    local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0,5,0) end
end)

--- [THEMES TAB] ---
local function SetTheme(color)
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundColor3 = color}):Play()
end
AddButton("Dark Gray", ThemeTab, function() SetTheme(Color3.fromRGB(30,30,30)) end)
AddButton("Midnight", ThemeTab, function() SetTheme(Color3.fromRGB(15,15,25)) end)
AddButton("Ocean", ThemeTab, function() SetTheme(Color3.fromRGB(10,40,60)) end)

-- UI CONTROLS
local CloseBtn = AddButton("X", TopBar, function() MainGui:Destroy() end)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local MinBtn = AddButton("-", TopBar, function()
    MainFrame.Visible = false
    local Restore = Instance.new("TextButton", MainGui)
    Restore.Size = UDim2.new(0, 120, 0, 40)
    Restore.Position = UDim2.new(0, 20, 1, -60)
    Restore.Text = "RESTORE HUB"
    Restore.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Restore.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Restore)
    Restore.MouseButton1Click:Connect(function() MainFrame.Visible = true; Restore:Destroy() end)
end)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 7)

MakeDraggable(TopBar, MainFrame)
Pages["Home"].Visible = true
