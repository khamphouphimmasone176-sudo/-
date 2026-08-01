local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "My Custom Hub | Universal",
   LoadingTitle = "กำลังโหลดระบบ...",
   LoadingSubtitle = "by Kiew",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "MyScriptConfig"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

-- 🛡️ ระบบ Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
    Rayfield:Notify({ Title = "Anti-AFK", Content = "ป้องกันการหลุดจากเกมแล้ว!", Duration = 5 })
end)

-- ==================== [ แท็บที่ 1: เมนูหลัก ] ====================
local MainTab = Window:CreateTab("เมนูหลัก", 4483362458)

MainTab:CreateSection("ระบบวนลูป (Loop System)")

for i = 1, 8 do
    local loopActive = false
    MainTab:CreateToggle({
       Name = "ปุ่มวนลูปที่ " .. i,
       CurrentValue = false,
       Flag = "LoopToggle" .. i,
       Callback = function(Value)
           loopActive = Value
           if Value then
               task.spawn(function()
                   while loopActive do
                       -- 📍 ใส่โค้ดที่นี่
                       task.wait(1)
                   end
               end)
           end
       end,
    })
end


-- ==================== [ แท็บที่ 2: ผู้เล่น ] ====================
local PlayerTab = Window:CreateTab("ผู้เล่น", 4483362458)

-- ⚡ ย้ายระบบ FPS Booster มาไว้ที่นี่
PlayerTab:CreateSection("ระบบเพิ่มความลื่น (FPS Booster)")
PlayerTab:CreateButton({
   Name = "⚡ เปิดใช้งาน FPS Booster (ลดกระตุก)",
   Callback = function()
       pcall(function()
           local terrain = workspace:FindFirstChildOfClass('Terrain')
           if terrain then
               terrain.WaterWaveSize = 0
               terrain.WaterWaveSpeed = 0
               terrain.WaterReflectance = 0
               terrain.WaterTransparency = 0
           end
           local lighting = game:GetService("Lighting")
           lighting.GlobalShadows = false
           lighting.FogEnd = 9e9
           for _, v in pairs(lighting:GetChildren()) do
               if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
                   v.Enabled = false
               end
           end
           for _, v in pairs(game:GetDescendants()) do
               if v:IsA("BasePart") then
                   v.Material = Enum.Material.SmoothPlastic
                   v.Reflectance = 0
               elseif v:IsA("Decal") or v:IsA("Texture") then
                   v:Destroy()
               elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                   v.Enabled = false
               end
           end
       end)
       Rayfield:Notify({ Title = "FPS Booster", Content = "ปรับความลื่นสำเร็จ!", Duration = 3 })
   end,
})

PlayerTab:CreateSection("ปรับแต่งตัวละคร")

local NoclipEnabled = false
local InfJumpEnabled = false
local ESPEnabled = false

local InvisiblePlatform = nil
local PlatformBaseY = nil
local CurrentHeightValue = 0

local function ResetAirWalk()
    CurrentHeightValue = 0
    PlatformBaseY = nil
    if InvisiblePlatform then
        InvisiblePlatform:Destroy()
        InvisiblePlatform = nil
    end
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {char}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), raycastParams)
        if rayResult then
            hrp.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
        end
    end
end

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled and game.Players.LocalPlayer.Character then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState("Jumping") end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and InvisiblePlatform and PlatformBaseY and CurrentHeightValue > 0 then
        InvisiblePlatform.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, PlatformBaseY + CurrentHeightValue - 3.5, char.HumanoidRootPart.Position.Z)
    end
    
    if ESPEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("ESPHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "ESPHighlight"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.Adornee = p.Character
                hl.Parent = p.Character
            end
        end
    end
end)

PlayerTab:CreateSlider({
   Name = "ความเร็วการเดิน (WalkSpeed)", Range = {16, 250}, Increment = 1, Suffix = "Speed", CurrentValue = 16,
   Callback = function(v)
       if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
       end
   end,
})

PlayerTab:CreateSlider({
   Name = "แรงกระโดด (JumpPower)", Range = {50, 500}, Increment = 5, Suffix = "Power", CurrentValue = 50,
   Callback = function(v)
       if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
           game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
           game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
       end
   end,
})

local AirWalkSlider = PlayerTab:CreateSlider({
   Name = "ระดับความสูงการเดินบนอากาศ", Range = {0, 100}, Increment = 1, Suffix = "Studs", CurrentValue = 0,
   Callback = function(Value)
       CurrentHeightValue = Value
       local char = game.Players.LocalPlayer.Character
       if not char or not char:FindFirstChild("HumanoidRootPart") then return end
       local hrp = char.HumanoidRootPart
       if Value > 0 then
           if not PlatformBaseY then PlatformBaseY = hrp.Position.Y end
           if not InvisiblePlatform or not InvisiblePlatform.Parent then
               InvisiblePlatform = Instance.new("Part")
               InvisiblePlatform.Size = Vector3.new(15, 1, 15)
               InvisiblePlatform.Transparency = 1
               InvisiblePlatform.Anchored = true
               InvisiblePlatform.CanCollide = true
               InvisiblePlatform.Parent = workspace
           end
           hrp.CFrame = CFrame.new(hrp.Position.X, PlatformBaseY + Value, hrp.Position.Z)
       else
           ResetAirWalk()
       end
   end,
})

PlayerTab:CreateButton({
   Name = "🛑 ปิดการลอยตัว & ลงสู่พื้นทันที",
   Callback = function()
       ResetAirWalk()
       AirWalkSlider:Set(0)
       Rayfield:Notify({ Title = "Air Walk", Content = "ลงสู่พื้นเรียบร้อย!", Duration = 3 })
   end,
})

PlayerTab:CreateToggle({ Name = "วิ่งทะลุกำแพง (Noclip)", CurrentValue = false, Callback = function(v) NoclipEnabled = v end })
PlayerTab:CreateToggle({ Name = "กระโดดไม่จำกัด (Infinite Jump)", CurrentValue = false, Callback = function(v) InfJumpEnabled = v end })
PlayerTab:CreateToggle({ Name = "มองทะลุผู้เล่น (ESP)", CurrentValue = false, Callback = function(v) 
    ESPEnabled = v 
    if not v then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight:Destroy() end
        end
    end
end })


-- ==================== [ แท็บที่ 3: เทเลพอร์ต ] ====================
local TeleportTab = Window:CreateTab("เทเลพอร์ต", 4483362458)
TeleportTab:CreateSection("วาร์ปไปหาผู้เล่น")

local SelectedPlayerName = nil

local function GetPlayerList()
    local players = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then table.insert(players, p.Name) end
    end
    if #players == 0 then table.insert(players, "ไม่มีผู้เล่นอื่นในเซิร์ฟ") end
    return players
end

local PlayerDropdown = TeleportTab:CreateDropdown({
   Name = "เลือกผู้เล่นที่ต้องการวาร์ป",
   Options = GetPlayerList(),
   CurrentOption = GetPlayerList()[1] or "",
   Callback = function(Option)
       SelectedPlayerName = type(Option) == "table" and Option[1] or Option
   end,
})

TeleportTab:CreateButton({
   Name = "🔄 อัปเดตรายชื่อผู้เล่น",
   Callback = function()
       PlayerDropdown:Refresh(GetPlayerList(), true)
       Rayfield:Notify({ Title = "Player List", Content = "อัปเดตเรียบร้อย!", Duration = 2 })
   end,
})

TeleportTab:CreateButton({
   Name = "🚀 วาร์ปไปหาผู้เล่นที่เลือก",
   Callback = function()
       if SelectedPlayerName and SelectedPlayerName ~= "ไม่มีผู้เล่นอื่นในเซิร์ฟ" then
           local target = game.Players:FindFirstChild(SelectedPlayerName)
           local myChar = game.Players.LocalPlayer.Character
           if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
               myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
               Rayfield:Notify({ Title = "Teleport", Content = "วาร์ปสำเร็จ!", Duration = 2 })
           else
               Rayfield:Notify({ Title = "Error", Content = "ไม่พบตัวละครเป้าหมาย", Duration = 2 })
           end
       end
   end,
})

Rayfield:LoadConfiguration()
