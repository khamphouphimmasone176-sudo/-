local PlaceId = game.PlaceId

local MapScripts = {
    [11111111] = "ลิงก์_Raw_ของไฟล์_farm.lua",   -- ถ้าอยู่แมพนี้ มันจะไปดึงโค้ดในไฟล์ farm.lua มาเปิด
    [2222222]  = "ลิงก์_Raw_ของไฟล์_steal.lua",  -- ถ้าอยู่แมพนี้ มันจะไปดึงโค้ดในไฟล์ steal.lua มาเปิด
}

if MapScripts[PlaceId] then
    loadstring(game:HttpGet(MapScripts[PlaceId]))()
else
    -- ถ้าไปเล่นแมพอื่นที่ไม่ได้ใส่ไว้ในตารางด้านบน มันจะมาเปิดไฟล์หลักอันนี้แทน
    loadstring(game:HttpGet("ลิงก์_Raw_ของไฟล์_main.lua"))()
end
