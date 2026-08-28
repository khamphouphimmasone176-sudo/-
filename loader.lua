local PlaceId = game.PlaceId

local MapScripts = {
    [107778070777162] = "https://raw.githubusercontent.com/khamphouphimmasone176-sudo/-/refs/heads/main/steal.lua",
}

if MapScripts[PlaceId] then
    loadstring(game:HttpGet(MapScripts[PlaceId]))()
else
    print("แมพนี้ยังไม่ได้ใส่สคริปต์")
end
