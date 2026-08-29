local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game.Players
local player = Players.LocalPlayer

-- สร้าง UI เล็กๆ มุมขวาบนสุดเพื่อแสดงสถานะการขโมยไข่
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggStatusUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusText"
statusLabel.Size = UDim2.new(0, 260, 0, 75)
statusLabel.Position = UDim2.new(1, -270, 0, 10) -- มุมขวาบนสุด
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusLabel.BackgroundTransparency = 0.4
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Code
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.TextWrapped = true
statusLabel.Visible = false
statusLabel.Parent = screenGui

local function updateUI(text)
   statusLabel.Text = " [ Phantom Hub Status ]\n" .. text
end

local Window = Rayfield:CreateWindow({
   Name = "Phantom Hub - Ultimate Egg Stealer",
   LoadingTitle = "Loading Target Lock System...",
   LoadingSubtitle = "by Kiew",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Auto Farm", 4483362458)

Tab:CreateSection("Target Lock & Auto Loop System")

local autoFarmActive = false
local moveSpeed = 90

Tab:CreateSlider({
   Name = "Movement Speed (ความเร็วปลอดภัย)",
   Range = {40, 200},
   Increment = 10,
   CurrentValue = 90,
   Flag = "SafeSpeed",
   Callback = function(Value)
      moveSpeed = Value
   end,
})

-- ปุ่มเปิด-ปิดระบบฟาร์มวนลูปอัตโนมัติ พร้อมล็อกเป้าไข่แรร์
Tab:CreateToggle({
   Name = "Auto Steal & Loop (ฟาร์มวนลูปออโต้)",
   CurrentValue = false,
   Flag = "AutoFarmLoop",
   Callback = function(Value)
      autoFarmActive = Value
      statusLabel.Visible = Value
      
      if not autoFarmActive then
         updateUI("สถานะ: ปิดการทำงาน")
         return
      end
      
      -- เริ่มต้นลูปการทำงานอัตโนมัติ
      task.spawn(function()
         while autoFarmActive do
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
               task.wait(1)
               continue
            end
            local rootPart = character.HumanoidRootPart
            
            local eggFolder = workspace:FindFirstChild("AreaEggSlotsClient")
            local basesFolder = workspace:FindFirstChild("Bases")
            
            if not eggFolder then
               updateUI("สถานะ: ไม่พบโฟลเดอร์ไข่!")
               task.wait(2)
               continue
            end
            
            -- 1. สแกนและล็อกเป้าหมายไข่ที่ใหญ่และแรร์ที่สุด
            updateUI("สถานะ: กำลังสแกนหาไข่แรร์...")
            local targetEgg = nil
            local maxVolume = 0
            local targetName = "Unknown"
            
            for _, egg in ipairs(eggFolder:GetChildren()) do
               local part = egg:IsA("Model") and egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")
               if part then
                  local volume = part.Size.X * part.Size.Y * part.Size.Z
                  if volume > maxVolume then
                     maxVolume = volume
                     targetEgg = part
                     targetName = egg.Name
                  end
               end
            end
            
            if not targetEgg then
               updateUI("สถานะ: รอไข่เกิดใหม่...")
               task.wait(1)
               continue
            end
            
            -- อัปเดตข้อมูลขึ้น UI ขวาบนสุด
            updateUI(string.format("🎯 ล็อกเป้า: ไข่แรร์\n📦 น้ำหนัก/ขนาด: %.1f\n🚀 สถานะ: กำลังบินไปเอา", maxVolume))
            
            -- 2. บินไปหาไข่แบบเกาะติดพื้น
            local targetPos = targetEgg.Position + Vector3.new(0, 1.2, 0)
            local reachedEgg = false
            
            local conn
            conn = RunService.Stepped:Connect(function(_, dt)
               if not autoFarmActive or not character or not character:FindFirstChild("HumanoidRootPart") then
                  if conn then conn:Disconnect() end
                  return
               end
               
               local curPos = rootPart.Position
               local dir = (targetPos - curPos)
               local dist = dir.Magnitude
               
               if dist > 3 then
                  rootPart.CFrame = CFrame.new(curPos + dir.Unit * math.min(moveSpeed * dt, dist), targetPos)
               else
                  if conn then conn:Disconnect() end
                  reachedEgg = true
               end
            end)
            
            -- รอจนกว่าจะบินไปถึง
            while autoFarmActive and not reachedEgg do
               task.wait(0.05)
            end
            
            if not autoFarmActive then break end
            
            -- 3. ทำการกดขโมยไข่
            updateUI(string.format("🎯 ล็อกเป้า: ไข่แรร์\n📦 น้ำหนัก/ขนาด: %.1f\n⚡ สถานะ: กำลังหยิบไข่!", maxVolume))
            
            local actualEggModel = targetEgg.Parent
            for _, v in ipairs(actualEggModel:GetDescendants()) do
               if v:IsA("ClickDetector") then
                  fireclickdetector(v)
               elseif v:IsA("ProximityPrompt") then
                  fireproximityprompt(v)
               end
            end
            firetouchinterest(rootPart, targetEgg, 0)
            firetouchinterest(rootPart, targetEgg, 1)
            
            task.wait(0.3)
            
            -- 4. ค้นหาฐาน (Base) เพื่อวิ่งหนีเข้าเขตเซฟ
            local nearestBase = nil
            local shortestDist = math.huge
            
            if basesFolder then
               for _, base in ipairs(basesFolder:GetChildren()) do
                  local bPart = base:IsA("BasePart") and base or base:FindFirstChild("Center") or base:FindFirstChildWhichIsA("BasePart")
                  if bPart then
                     local dist = (rootPart.Position - bPart.Position).Magnitude
                     if dist < shortestDist then
                        shortestDist = dist
                        nearestBase = bPart
                     end
                  end
               end
            end
            
            local basePos = nearestBase and (nearestBase.Position + Vector3.new(0, 2, 0)) or (rootPart.Position + Vector3.new(0, 2, -30))
            
            updateUI(string.format("🎯 ล็อกเป้า: ไข่แรร์\n📦 น้ำหนัก/ขนาด: %.1f\n🏠 สถานะ: หนีเข้าเขตเซฟ", maxVolume))
            
            local reachedBase = false
            local returnConn
            returnConn = RunService.Stepped:Connect(function(_, rDt)
               if not autoFarmActive or not character or not character:FindFirstChild("HumanoidRootPart") then
                  if returnConn then returnConn:Disconnect() end
                  return
               end
               
               local cPos = rootPart.Position
               local dir = (basePos - cPos)
               local dist = dir.Magnitude
               
               if dist > 3 then
                  rootPart.CFrame = CFrame.new(cPos + dir.Unit * math.min(moveSpeed * rDt, dist), basePos)
               else
                  if returnConn then returnConn:Disconnect() end
                  reachedBase = true
               end
            end)
            
            while autoFarmActive and not reachedBase do
               task.wait(0.05)
            end
            
            updateUI("สถานะ: ส่งไข่สำเร็จ! พักรอมอบตัวรอบใหม่...")
            task.wait(1.5) -- หน่วงเวลาก่อนสแกนรอบถัดไป
         end
      end)
   end,
})
