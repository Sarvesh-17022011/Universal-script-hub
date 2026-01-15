-- [[ ADVANCED UNIVERSAL HUB - NO LIBRARIES ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Clean up
if CoreGui:FindFirstChild("UltraHub") then CoreGui.UltraHub:Destroy() end

-- [[ ROOT GUI ]]
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "UltraHub"
Screen.ResetOnSpawn = false

-- [[ MINIMIZE BUTTON (MOBILE FRIENDLY) ]]
local ToggleBtn = Instance.new("TextButton", Screen)
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "HUB"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn)

-- [[ MAIN FRAME ]]
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Standard dragging for desktop/mobile

local MainCorner = Instance.new("UICorner", Main)

-- [[ TOP BAR ]]
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "  ULTRA SCRIPT HUB"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", TopBar)
Close.Text = "X"
Close.Position = UDim2.new(1, -35, 0, 0)
Close.Size = UDim2.new(0, 35, 1, 0)
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.new(1, 0, 0)
Close.MouseButton1Click:Connect(function() Screen:Destroy() end)

local Min = Instance.new("TextButton", TopBar)
Min.Text = "-"
Min.Position = UDim2.new(1, -70, 0, 0)
Min.Size = UDim2.new(0, 35, 1, 0)
Min.BackgroundTransparency = 1
Min.TextColor3 = Color3.new(1, 1, 1)

Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    ToggleBtn.Visible = true
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    ToggleBtn.Visible = false
end)

-- [[ CONTENT SETUP ]]
local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(0, 100, 1, -35)
Nav.Position = UDim2.new(0, 0, 0, 35)
Nav.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -110, 1, -45)
Container.Position = UDim2.new(0, 105, 0, 40)
Container.BackgroundTransparency = 1

local NavLayout = Instance.new("UIListLayout", Nav)

-- [[ TABS SYSTEM ]]
function CreateTab(name)
    local btn = Instance.new("TextButton", Nav)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    
    local page = Instance.new("ScrollingFrame", Container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0,0,5,0)
    Instance.new("UIListLayout", page).Padding = UDim.new(0,5)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Container:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
    return page
end

local Home = CreateTab("Home")
local MainTab = CreateTab("Main")
local PlayerTab = CreateTab("Player")
local Teleport = CreateTab("Teleport")
local Combat = CreateTab("Combat")
local Themes = CreateTab("Themes")

-- [[ HOME TAB: AUTO-REFRESH PLAYER LIST ]]
local InfoLabel = Instance.new("TextLabel", Home)
InfoLabel.Size = UDim2.new(1,0,0,50)
InfoLabel.Text = "Game ID: "..game.PlaceId.."\nName: "..game.Name
InfoLabel.TextColor3 = Color3.new(1,1,1)
InfoLabel.BackgroundTransparency = 1

local PlayerList = Instance.new("Frame", Home)
PlayerList.Size = UDim2.new(1,0,0,200)
PlayerList.BackgroundTransparency = 1
local ListLayout = Instance.new("UIListLayout", PlayerList)

function UpdatePlayerList()
    for _, child in pairs(PlayerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local pBtn = Instance.new("TextButton", PlayerList)
        pBtn.Size = UDim2.new(1,0,0,30)
        pBtn.Text = p.Name
        pBtn.MouseButton1Click:Connect(function()
            local stats = p:FindFirstChild("leaderstats")
            local info = "Stats: "
            if stats then
                for _, s in pairs(stats:GetChildren()) do info = info..s.Name..": "..tostring(s.Value).." " end
            else
                info = "No Leaderstats Found"
            end
            InfoLabel.Text = "Viewing: "..p.Name.."\n"..info
        end)
    end
end
task.spawn(function() while task.wait(5) do UpdatePlayerList() end end)
UpdatePlayerList()

-- [[ MAIN TAB: OBJECT SCANNER ]]
local function AddObjectLabel(parent, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1,0,0,25)
    l.Text = text
    l.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    l.BackgroundTransparency = 1
end

local function ScanObjects()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
            AddObjectLabel(MainTab, obj.ClassName..": "..obj.Parent.Name)
        end
    end
end
ScanObjects()

-- [[ THEMES TAB ]]
local function AddColorBtn(color, name)
    local b = Instance.new("TextButton", Themes)
    b.Size = UDim2.new(1,0,0,35)
    b.BackgroundColor3 = color
    b.Text = name
    b.MouseButton1Click:Connect(function() Main.BackgroundColor3 = color end)
end
AddColorBtn(Color3.fromRGB(40, 0, 0), "Dark Red")
AddColorBtn(Color3.fromRGB(0, 40, 40), "Teal")
AddColorBtn(Color3.fromRGB(20, 20, 20), "Default")

-- [[ COMBAT & PLAYER EXAMPLES ]]
local function CreateButton(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,0,0,40)
    b.Text = text
    b.MouseButton1Click:Connect(callback)
end

CreateButton(PlayerTab, "Infinite Jump", function()
    UserInputService.JumpRequest:Connect(function()
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
end)

CreateButton(Teleport, "TP to Random Player", function()
    local all = Players:GetPlayers()
    local random = all[math.random(1, #all)]
    if random ~= LocalPlayer then LocalPlayer.Character:MoveTo(random.Character.HumanoidRootPart.Position) end
end)

-- Finish
Home.Visible = true
