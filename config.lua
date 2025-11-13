Config = {}

Config.TARGET = 'ox'

Config.Cooldown = {
    npc      = { min = 1, max = 3 },
    delivery = { min = 10, max = 15 }
}

Config.Price = {
    oxy        = 350,
    heroin     = 800,
    oxySell    = 30,
    heroinSell = 55,
}

Config.Dealers = {
    oxy = {
        npc1 = { coordx = -1561.5404, coordy = -413.0152, coordz = 37.0961, heading = 180.9050 },
        npc2 = { coordx = -1102.3456, coordy = -1492.1234, coordz = 4.5678, heading = 120.0000 },
        npc3 = { coordx = 138.5678, coordy = -1543.7890, coordz = 29.0123, heading = 45.0000 },
        npc4 = { coordx = 845.2345, coordy = -1023.4567, coordz = 27.8901, heading = 270.0000 },
        npc5 = { coordx = 1189.0123, coordy = 2645.6789, coordz = 37.8901, heading = 90.0000 },
    },
    heroin = {
        npc1 = { coordx = -1561.5404, coordy = -413.0152, coordz = 37.0961, heading = 180.9050 },
        npc2 = { coordx = -63.4567, coordy = -1229.0123, coordz = 28.5678, heading = 200.0000 },
        npc3 = { coordx = 425.6789, coordy = -980.1234, coordz = 30.4567, heading = 160.0000 },
        npc4 = { coordx = -1456.7890, coordy = 890.2345, coordz = 192.3456, heading = 300.0000 },
        npc5 = { coordx = 1956.1234, coordy = 3756.7890, coordz = 32.0123, heading = 30.0000 },
    },
}

Config.Models = {
    "a_m_m_hillbilly_02","a_m_m_salton_04","a_m_m_polynesian_01","a_m_m_salton_02",
    "a_m_m_salton_03","a_m_m_skater_01","a_m_m_soucent_04","a_m_m_soucent_03",
    "a_m_m_skidrow_01","a_m_m_socenlat_01","a_m_m_soucent_01","a_m_o_beach_01",
    "a_m_o_soucent_03","a_m_o_tramp_01","a_m_o_soucent_02","a_m_o_salton_01",
    "a_f_m_skidrow_01","a_f_m_tourist_01","a_f_m_trampbeac_01","a_f_o_indian_01",
    "a_f_y_clubcust_02","a_f_y_hipster_02","a_f_y_rurmeth_01"
}

Config.Buyers = {
    npc1  = {coordx = -1067.0746, coordy = -504.5410, coordz = 35.0798, heading = 25.4282},
    npc2  = {coordx = 54.5449,    coordy = 163.6573,  coordz = 103.7610, heading = 273.0411},
    npc3  = {coordx = 167.4547,   coordy = -1248.3344,coordz = 28.1984, heading = 78.3712},
    npc4  = {coordx = -324.8175, coordy = -1356.3646,coordz = 30.2957, heading = 99.2964},
    npc5  = {coordx = -1995.7758,coordy = -504.8550, coordz = 11.0130, heading = 238.6174},
    npc6  = {coordx = -3102.0952,coordy = 367.3326,  coordz = 6.1191,  heading = 147.8980},
    npc7  = {coordx = -1690.8997,coordy = -431.7747, coordz = 41.3730, heading = 246.4736},
    npc8  = {coordx = -1496.6851,coordy = -318.3724, coordz = 45.9418, heading = 126.6329},
    npc9  = {coordx = -1336.2859,coordy = -226.7334, coordz = 41.9637, heading = 297.6121},
    npc10 = {coordx = -297.0966, coordy = 303.4752,  coordz = 89.7184, heading = 0.0307},
    npc11 = {coordx = -497.5015, coordy = 79.3391,   coordz = 54.9189, heading = 80.6300},
    npc12 = {coordx = -594.6409, coordy = 179.6907,  coordz = 64.3169, heading = 170.0314},
    npc13 = {coordx = 59.7535,   coordy = -41.5417,  coordz = 68.2935, heading = 253.3634},
}

Config.Notify = {
    dealFailed    = {title='Oxyrun', description='Deal failed!', duration=8000, type='error'},
    notEnoughCash = {title='Oxyrun', description='Not enough cash!', duration=8000, type='error'},
    startJob      = {title='Oxyrun', description='Start delivering!', duration=8000, type='info'},
    buyerFound    = {title='Oxyrun', description='Buyer located!', duration=8000, type='success'},
}
