-- client/client.lua
local ped         = nil
local zoneId      = nil
local blip        = nil
local currentDrug = nil
local dealerKeys  = { oxy = {}, heroin = {} }

local DEALER_MODELS = {
    oxy    = `a_m_m_og_boss_01`,
    heroin = `a_m_m_malibu_01`
}

local CD_CFG = Config.Cooldown.delivery
local deliveryCD  = { oxy = false, heroin = false }
local cdEndTime   = { oxy = 0, heroin = 0 }

-- Polyfill SetInterval
if not SetInterval then
    local intervals = {}
    SetInterval = function(func, ms)
        local id = #intervals + 1
        intervals[id] = { func = func, ms = ms, last = GetGameTimer() }
        return id
    end
    CreateThread(function()
        while true do
            Wait(0)
            local now = GetGameTimer()
            for id, int in pairs(intervals) do
                if now - int.last >= int.ms then
                    int.func()
                    int.last = now
                end
            end
        end
    end)
end

-- Requests
local function requestModel(hash)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(10) end
    end
end

local function requestAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(10) end
    end
end

local function notify(data) lib.notify(data) end

local function startCD(drug)
    deliveryCD[drug] = true
    local mins = math.random(CD_CFG.min, CD_CFG.max)
    cdEndTime[drug] = GetGameTimer() + mins * 60 * 1000
    SetTimeout(mins * 60 * 1000, function() deliveryCD[drug] = false end)
end

local function remainingMins(drug)
    if not deliveryCD[drug] then return 0 end
    return math.max(0, (cdEndTime[drug] - GetGameTimer()) / 60000)
end

local function spawnDealer()
    -- Random drug & location
    currentDrug = math.random() < 0.5 and 'oxy' or 'heroin'
    local keys = dealerKeys[currentDrug]
    local idx = math.random(1, #keys)
    local key = keys[idx]
    local dealer = Config.Dealers[currentDrug][key]
    if not dealer then return end

    -- Cleanup
    if zoneId then exports.ox_target:removeZone(zoneId) zoneId = nil end
    if blip then RemoveBlip(blip) blip = nil end
    if ped and DoesEntityExist(ped) then DeleteEntity(ped) ped = nil end

    -- Spawn
    requestModel(DEALER_MODELS[currentDrug])
    ped = CreatePed(4, DEALER_MODELS[currentDrug], dealer.coordx, dealer.coordy, dealer.coordz - 1.0, dealer.heading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- Blip
    blip = AddBlipForCoord(dealer.coordx, dealer.coordy, dealer.coordz)
    SetBlipSprite(blip, currentDrug == 'oxy' and 51 or 403)
    SetBlipColour(blip, currentDrug == 'oxy' and 0 or 1)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(currentDrug == 'oxy' and 'Oxycodone Dealer' or 'Heroin Dealer')
    EndTextCommandSetBlipName(blip)

    -- Target
    zoneId = exports.ox_target:addBoxZone({
        coords = vec3(dealer.coordx, dealer.coordy, dealer.coordz),
        size   = vec3(2, 2, 2),
        rotation = 0,
        options = {
            {
                name     = 'oxyrun_buy_oxy',
                icon     = 'fas fa-pills',
                label    = 'Buy Oxycodone ($350)',
                canInteract = function() return currentDrug == 'oxy' and not deliveryCD.oxy end,
                onSelect = function()
                    local amount = math.random(1, 10)
                    TriggerServerEvent('oxyrun:buyOxy', amount)
                    startCD('oxy')
                end
            },
            {
                name     = 'oxyrun_buy_heroin',
                icon     = 'fas fa-syringe',
                label    = 'Buy Heroin ($800)',
                canInteract = function() return currentDrug == 'heroin' and not deliveryCD.heroin end,
                onSelect = function()
                    local amount = math.random(1, 10)
                    TriggerServerEvent('oxyrun:buyHeroin', amount)
                    startCD('heroin')
                end
            }
        }
    })
end

CreateThread(function()
    for k in pairs(Config.Dealers.oxy) do dealerKeys.oxy[#dealerKeys.oxy + 1] = k end
    for k in pairs(Config.Dealers.heroin) do dealerKeys.heroin[#dealerKeys.heroin + 1] = k end

    if #dealerKeys.oxy == 0 and #dealerKeys.heroin == 0 then return end

    spawnDealer()
    SetInterval(spawnDealer, 10 * 60 * 1000)  -- Rotate
end)

RegisterNetEvent('oxyrun:receiveDrugs', function(drug)
    local player = PlayerPedId()
    requestAnimDict('mp_common')

    local bagDealer = CreateObject(`xm3_prop_xm3_bag_coke_01a`, 0, 0, 0, true, true, true)
    local bagPlayer = CreateObject(`xm3_prop_xm3_bag_coke_01a`, 0, 0, 0, true, true, true)

    AttachEntityToEntity(bagDealer, ped, GetPedBoneIndex(ped, 0x188E), 0.08, -0.06, -0.01, 96.0, 20.0, 180.0, true, true, false, true, 1, true)

    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, -8.0, 1000, 49, 0, false, false, false)
    TaskPlayAnim(player, 'mp_common', 'givetake1_a', 8.0, -8.0, 1000, 49, 0, false, false, false)

    Wait(1000)
    DeleteEntity(bagDealer)

    AttachEntityToEntity(bagPlayer, player, GetPedBoneIndex(player, 0x188E), 0.08, -0.06, -0.01, 96.0, 20.0, 180.0, true, true, false, true, 1, true)
    Wait(900)
    ClearPedTasks(player)
    DeleteEntity(bagPlayer)

    notify(Config.Notify.startJob)
    Wait(1500)
    TriggerServerEvent('oxyrun:verifyStock')
end)