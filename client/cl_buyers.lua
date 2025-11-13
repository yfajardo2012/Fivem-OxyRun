-- client/cl_buyers.lua
local buyerPed   = nil
local buyerZone  = nil
local buyerBlip  = nil
local lastIdx    = nil
local buyerCD    = false

local NPC_CD = Config.Cooldown.npc

local function cleanup()
    if buyerZone then exports.ox_target:removeZone(buyerZone) buyerZone = nil end
    if buyerBlip then RemoveBlip(buyerBlip) buyerBlip = nil end
    if buyerPed and DoesEntityExist(buyerPed) then DeleteEntity(buyerPed) buyerPed = nil end
end

local function spawnBuyer()
    if buyerPed then return end

    local idx
    repeat idx = math.random(1, 13) until idx ~= lastIdx
    lastIdx = idx

    local data = Config.Buyers['npc'..idx]
    if not data then return end

    cleanup()

    local model = Config.Models[math.random(#Config.Models)]
    local hash = GetHashKey(model)
    requestModel(hash)

    buyerPed = CreatePed(4, hash, data.coordx, data.coordy, data.coordz - 1.0, data.heading, false, true)
    FreezeEntityPosition(buyerPed, true)
    SetEntityInvincible(buyerPed, true)
    SetBlockingOfNonTemporaryEvents(buyerPed, true)

    buyerBlip = AddBlipForCoord(data.coordx, data.coordy, data.coordz)
    SetBlipSprite(buyerBlip, 514) SetBlipColour(buyerBlip, 1) SetBlipScale(buyerBlip, 0.8)
    SetBlipAsShortRange(buyerBlip, true)
    BeginTextCommandSetBlipName('STRING') AddTextComponentString('Drug Buyer') EndTextCommandSetBlipName(buyerBlip)

    buyerZone = exports.ox_target:addBoxZone({
        coords = vec3(data.coordx, data.coordy, data.coordz),
        size   = vec3(2, 2, 2),
        options = {
            {
                name     = 'oxyrun_sell_oxy',
                icon     = 'fas fa-pills',
                label    = 'Sell Oxycodone ($30)',
                onSelect = function()
                    local success = math.random() < 0.70
                    if success then
                        TriggerServerEvent('oxyrun:sellOxy')
                        TriggerEvent('oxyrun:sellAnim', 'oxy')
                    else
                        lib.notify(Config.Notify.dealFailed)
                        exports['ps-dispatch']:DrugSale()
                        cleanup()
                        startBuyerCD()
                        TaskWanderStandard(buyerPed)
                    end
                end
            },
            {
                name     = 'oxyrun_sell_heroin',
                icon     = 'fas fa-syringe',
                label    = 'Sell Heroin ($55)',
                onSelect = function()
                    local success = math.random() < 0.70
                    if success then
                        TriggerServerEvent('oxyrun:sellHeroin')
                        TriggerEvent('oxyrun:sellAnim', 'heroin')
                    else
                        lib.notify(Config.Notify.dealFailed)
                        exports['ps-dispatch']:DrugSale()
                        cleanup()
                        startBuyerCD()
                        TaskWanderStandard(buyerPed)
                    end
                end
            }
        }
    })

    lib.notify(Config.Notify.buyerFound)
end

local function startBuyerCD()
    buyerCD = true
    local mins = math.random(NPC_CD.min, NPC_CD.max)
    SetTimeout(mins * 60 * 1000, function()
        buyerCD = false
        spawnBuyer()
    end)
end

RegisterNetEvent('oxyrun:startSelling', function()
    if buyerCD then return end
    spawnBuyer()
end)

RegisterNetEvent('oxyrun:startSellingAfterBuy', function()
    startBuyerCD()
end)

RegisterNetEvent('oxyrun:noDrugs', function()
    cleanup()
end)

RegisterNetEvent('oxyrun:sellAnim', function()
    local player = PlayerPedId()
    requestAnimDict('mp_common')

    local bagPlayer = CreateObject(`xm3_prop_xm3_bag_coke_01a`, 0, 0, 0, true, true, true)
    AttachEntityToEntity(bagPlayer, player, GetPedBoneIndex(player, 0x188E), 0.08, -0.06, -0.01, 96.0, 20.0, 180.0, true, true, false, true, 1, true)

    TaskPlayAnim(player, 'mp_common', 'givetake1_a', 8.0, -8.0, 1000, 49, 0, false, false, false)
    TaskPlayAnim(buyerPed, 'mp_common', 'givetake1_a', 8.0, -8.0, 1000, 49, 0, false, false, false)

    Wait(1000)
    DeleteEntity(bagPlayer)

    local bagBuyer = CreateObject(`xm3_prop_xm3_bag_coke_01a`, 0, 0, 0, true, true, true)
    AttachEntityToEntity(bagBuyer, buyerPed, GetPedBoneIndex(buyerPed, 0x188E), 0.08, -0.06, -0.01, 96.0, 20.0, 180.0, true, true, false, true, 1, true)
    Wait(900)
    ClearPedTasks(buyerPed)
    DeleteEntity(bagBuyer)

    FreezeEntityPosition(buyerPed, false)
    TaskWanderStandard(buyerPed)

    cleanup()
    TriggerServerEvent('oxyrun:verifyStock')
end)