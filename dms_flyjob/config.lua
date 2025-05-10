Config = {}

Config.job = {
    jobs = false,
    jobname = 'police'
}

Config.NPC = {
    Ped = 's_m_m_dockwork_01', --採點座標npc
    x = -1522.59,              --採點座標x
    y = -3216.89,              --採點座標y
    z = 14.65,                 --採點座標z
    h = 330.65,                --採點座標h
    --Blip
    BlipSprite = 307,          -- 設置地圖圖標顯示 網址在這: https://docs.fivem.net/game-references/blips/
    BlipDisplay = 4,           -- 設置地圖顯示 網址在這: https://runtime.fivem.net/doc/natives/#_0x9029B2F3DA924928
    BlipScale = 0.7,           -- 設置地圖圖標大小
    BlipColour = 5,            -- 設置地圖圖標顏色 網址在這: https://docs.fivem.net/game-references/blips/
    BlipNameOnMap = '空中運輸', -- 地圖上名稱
}

Config.Vehicles = {--使用飛機
   'besra',
}

Config.zones = {--取貨點
    vector3(-1749.29, -2903.56, 13.94)
}

Config.zones2 = {--交貨點
    vector3(1729.6145, 3316.2600, 41.2170),
    vector3(-1819.26, 2964.62, 32.81),
    vector3(88.8763, 6364.7495, 31.2258),
    vector3(3572.6621, 3794.0007, 30.0666),
    vector3(1964.9751, 543.6141, 161.3490),
    vector3(523.8354, -3025.5349, 6.0003),
    vector3(3082.71, -4671.32, 16.07),
    vector3(674.4374, 6469.9644, 30.2801),
}

Config.zones3 = vector3(-1493.08, -3237.35, 13.94)--公司

Config.addexp = {
    expmax = 2000,              --最大等級
    givexp = math.random(1), --交貨後給予等級
    random = 100,               --50%會給等級
    random2 = 0               --50%不會給等級
}

Config.exp = {--等級多少到多少之間給予多少錢
    [1] = {xp = 1, xp1 = 100, money = 100000},
    [2] = {xp = 101, xp1 = 200, money = 200000},
    [3] = {xp = 201, xp1 = 300, money = 200000},
    [4] = {xp = 301, xp1 = 400, money = 200000},
    [5] = {xp = 401, xp1 = 500, money = 250000},
    [6] = {xp = 501, xp1 = 600, money = 280000},
    [7] = {xp = 601, xp1 = 700, money = 280000},
    [8] = {xp = 701, xp1 = 800, money = 300000},
    [9] = {xp = 801, xp1 = 900, money = 310000},
    [10] = {xp = 901, xp1 = 1000, money = 500000},
}

Config.locales = {--翻譯
    [1] = "空運選單",
    [2] = "空運職業",
    [3] = "開始空運",
    [4] = "查看等級",
    [5] = "關閉選單",
    [7] = " 你目前等級 ",
    [9] = "按 ~r~E~w~ 裝取貨物",
    [10] = "裝取貨物中",
    [11] = "你必須駕駛指定飛機",
    [13] = "按 ~r~E~w~ 交貨",
    [15] = "按 ~r~E~w~ 返回公司",
    [16] = "返回公司",
    [17] = "接貨點",
    [18] = "交貨點",
    [19] = "公司",
    [20] = '你獲得了 ',
    [21] = '你已經是最高等了',
    [22] = '沒有獲得經驗',
    [23] = '你獲得了 ',
    [24] = '經驗',
    [25] = '錢',
    [26] = '你職業不對',
}