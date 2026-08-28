local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Phantom Hub - Steal & Combat",
   LoadingTitle = "Loading Steal Script...",
   LoadingSubtitle = "by Kiew",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Steal & Teleport", 4483362458)

Tab:CreateSection("Instant Actions")

-- ฟังก์ชันปุ่มกดทำงานทันที (ไม่ใช่เปิดปิด)
Tab:CreateButton({
   Name = "Teleport to Base",
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         -- ตัวอย่างวาร์ปไปพิกัดตัวอย่าง
         player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
         print("วาร์ปกลับฐานแล้ว!")
      end
   end,
})

-- ฟังก์ชันปุ่มกดขโมยของ
Tab:CreateButton({
   Name = "Instant Steal Item",
   Callback = function(Value)
      print("กดสั่งขโมยไอเทมสำเร็จ!")
      -- ใส่โค้ดฟังก์ชันขโมยตรงนี้
   end,
})
