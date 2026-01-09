local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Script Hub | Premium",
   LoadingTitle = "Initializing Systems...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UniversalHubConfig",
      FileName = "MainHub"
   },
})

-- [[ GLOBAL VARIABLES ]]
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Logic States
local FlyEnabled, FlySpeed, InfJumpEnabled, NoclipEnabled = false, 50, false, false
local ForceFieldEnabled, ESPEnabled, KillAuraEnabled, KillAuraRange = false, false, false, 20
local FullbrightEnabled, InfZoomEnabled, InvisibilityEnabled = false, false, false
local SelectedPlayer, TP_SelectedPlayer, Info_SelectedPlayer = nil, nil, nil
local OriginalZoomDist = Player.CameraMaxZoomDistance

-- Update Character Reference on Respawn
Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = NewCharacter:WaitForChild("Humanoid")
end)

-- [[ 1. HOME TAB: PLAYER INTEL ]]
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateSection("Information")
HomeTab:CreateLabel("Universal Hub Loaded Successfully")

HomeTab:CreateSection("Player Intelligence (Live Stats)")
local InfoDropdown = HomeTab:CreateDropdown({
   Name = "Select Player to Inspect",
   Options = {"None"},
   CurrentOption = {"None"},
   Callback = function(Option)
      Info_SelectedPlayer = game.Players:FindFirstChild(Option[1])
   end,
})

local StatsLabel = HomeTab:CreateParagraph({Title = "Player Stats", Content = "Select a player to see their data."})

-- [[ 2. PLAYER TAB: MOVEMENT ]]
local PlayerTab = Window:CreateTab("Player", 4483345998)
PlayerTab:CreateSection("Flight Control")

PlayerTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "Fly_T",
   Callback = function(Value)
      FlyEnabled = Value
      if FlyEnabled then
         local BV = Instance.new("BodyVelocity", Character.HumanoidRootPart)
         local BG = Instance.new("BodyGyro", Character.HumanoidRootPart)
         BV.MaxForce, BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(math.huge, math.huge, math.huge)
         task.spawn(function()
            while FlyEnabled do
               local Cam = workspace.CurrentCamera
               local Dir = Vector3.new(0,0,0)
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Cam.CFrame.LookVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Cam.CFrame.LookVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Cam.CFrame.RightVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Cam.CFrame.RightVector end
               BV.Velocity = Dir * FlySpeed
               BG.CFrame = Cam.CFrame
               task.wait()
            end
            BV:Destroy() BG:Destroy()
         end)
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {1, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) FlySpeed = Value end,
})

PlayerTab:CreateSection("Ground Movement")
PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) Humanoid.WalkSpeed = Value end,
})

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) InfJumpEnabled = Value end,
})

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) NoclipEnabled = Value end,
})

-- [[ 3. COMBAT TAB: OFFENSE/DEFENSE ]]
local CombatTab = Window:CreateTab("Combat", 4483345998)
CombatTab:CreateSection("Protection")

CombatTab:CreateToggle({
   Name = "Force Field (God Mode)",
   CurrentValue = false,
   Callback = function(Value)
      ForceFieldEnabled = Value
      task.spawn(function()
         while ForceFieldEnabled do
            if not Character:FindFirstChildOfClass("ForceField") then Instance.new("ForceField", Character) end
            task.wait(0.1)
         end
         if Character:FindFirstChildOfClass("ForceField") then Character:FindFirstChildOfClass("ForceField"):Destroy() end
      end)
   end,
})

CombatTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
      task.spawn(function()
         while ESPEnabled do
            for _, v in pairs(game.Players:GetPlayers()) do
               if v ~= Player and v.Character and not v.Character:FindFirstChild("ESPHighlight") then
                  local H = Instance.new("Highlight", v.Character)
                  H.Name = "ESPHighlight"
                  H.FillColor = Color3.fromRGB(255, 0, 0)
               end
            end
            task.wait(1)
         end
      end)
   end,
})

CombatTab:CreateSection("Kill Aura")
CombatTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Callback = function(Value)
      KillAuraEnabled = Value
      task.spawn(function()
         while KillAuraEnabled do
            for _, v in pairs(game.Players:GetPlayers()) do
               if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                  if (Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude <= KillAuraRange then
                     local Tool = Character:FindFirstChildOfClass("Tool")
                     if Tool then Tool:Activate() end
                  end
               end
            end
            task.wait(0.1)
         end
      end)
   end,
})

CombatTab:CreateSlider({
   Name = "Aura Range",
   Range = {5, 50},
   Increment = 1,
   CurrentValue = 20,
   Callback = function(Value) KillAuraRange = Value end,
})

-- [[ 4. MAIN TAB: VISUALS ]]
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Callback = function(Value)
      FullbrightEnabled = Value
      task.spawn(function()
         while FullbrightEnabled do
            game.Lighting.Brightness, game.Lighting.ClockTime, game.Lighting.GlobalShadows = 2, 14, false
            task.wait(0.5)
         end
         game.Lighting.GlobalShadows = true
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Infinite Zoom",
   CurrentValue = false,
   Callback = function(Value)
      Player.CameraMaxZoomDistance = Value and 10000 or OriginalZoomDist
   end,
})

MainTab:CreateToggle({
   Name = "Invisibility (Ghost)",
   CurrentValue = false,
   Callback = function(Value)
      InvisibilityEnabled = Value
      if InvisibilityEnabled and Character:FindFirstChild("LowerTorso") then
         Character.LowerTorso.RootRigJoint:Destroy()
         Rayfield:Notify({Title = "Ghost Mode", Content = "Invis Active. Reset to appear again.", Duration = 5})
      end
   end,
})

-- [[ 5. TELEPORT TAB ]]
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local TP_Dropdown = TeleportTab:CreateDropdown({
   Name = "Select Target Player",
   Options = {"None"},
   CurrentOption = {"None"},
   Callback = function(Option) TP_SelectedPlayer = game.Players:FindFirstChild(Option[1]) end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      if TP_SelectedPlayer and TP_SelectedPlayer.Character then
         Character.HumanoidRootPart.CFrame = TP_SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Spawn",
   Callback = function()
      local Spawn = workspace:FindFirstChildOfClass("SpawnLocation")
      if Spawn then Character.HumanoidRootPart.CFrame = Spawn.CFrame * CFrame.new(0, 3, 0) end
   end,
})

-- [[ BACKGROUND LOOPS ]]
-- Update Lists
task.spawn(function()
   while true do
      local pList = {}
      for _, v in pairs(game.Players:GetPlayers()) do table.insert(pList, v.Name) end
      InfoDropdown:Refresh(pList)
      TP_Dropdown:Refresh(pList)
      task.wait(5)
   end
end)

-- Update Home Stats
task.spawn(function()
   while true do
      if Info_SelectedPlayer then
         local LS = Info_SelectedPlayer:FindFirstChild("leaderstats")
         local str = "Age: "..Info_SelectedPlayer.AccountAge.."d\nID: "..Info_SelectedPlayer.UserId
         if LS then for _, s in pairs(LS:GetChildren()) do str = str.."\n"..s.Name..": "..tostring(s.Value) end end
         StatsLabel:Set({Title = "Stats: "..Info_SelectedPlayer.Name, Content = str})
      end
      task.wait(1)
   end
end)

-- Physics Handlers (InfJump & Noclip)
game:GetService("UserInputService").JumpRequest:Connect(function() if InfJumpEnabled then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and Character then
        for _, v in pairs(Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

Rayfield:LoadConfiguration()
