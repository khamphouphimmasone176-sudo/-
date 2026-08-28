local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Phantom Hub - Farm Mode",
   LoadingTitle = "Loading Farm Script...",
   LoadingSubtitle = "by Kiew",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Farm", 4483362458)

Tab:CreateSection("Auto Farm Systems")

-- ฟังก์ชันเปิด-ปิดออโต้ฟาร์ม
Tab:CreateToggle({
   Name = "Auto Farm Coins",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      if Value then
         print("เปิดระบบฟาร์มแล้ว!")
         -- ใส่โค้ดลูปฟาร์มของคุณตรงนี้
      else
         print("ปิดระบบฟาร์มแล้ว!")
      end
   end,
})

-- ฟังก์ชันสไลเดอร์ปรับความเร็ว
Tab:CreateSlider({
   Name = "WalkSpeed Farm",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})
