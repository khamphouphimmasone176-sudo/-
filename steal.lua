local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Phantom Hub - Test Kick",
   LoadingTitle = "Testing UI...",
   LoadingSubtitle = "by Kiew",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Test", 4483362458)

Tab:CreateSection("Diagnostic Button")

Tab:CreateButton({
   Name = "Kick Me (Test UI)",
   Callback = function()
      game.Players.LocalPlayer:Kick("เทส UI สำเร็จ! สคริปต์รันติดแล้ว")
   end,
})
