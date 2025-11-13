-- server/server.lua
local ox_inventory = exports.ox_inventory

RegisterNetEvent('oxyrun:buyOxy', function(amount)
    local src = source
    local cash = ox_inventory:GetItem(src, 'money', nil, true) or 0
    if cash < Config.Price.oxy then
        lib.notify(src, Config.Notify.notEnoughCash)
        return
    end

    ox_inventory:RemoveItem(src, 'money', Config.Price.oxy)
    ox_inventory:AddItem(src, 'oxy', amount)
    TriggerClientEvent('oxyrun:receiveDrugs', src, 'oxy')
    TriggerClientEvent('oxyrun:startSellingAfterBuy', src)
end)

RegisterNetEvent('oxyrun:buyHeroin', function(amount)
    local src = source
    local cash = ox_inventory:GetItem(src, 'money', nil, true) or 0
    if cash < Config.Price.heroin then
        lib.notify(src, Config.Notify.notEnoughCash)
        return
    end

    ox_inventory:RemoveItem(src, 'money', Config.Price.heroin)
    ox_inventory:AddItem(src, 'heroin', amount)
    TriggerClientEvent('oxyrun:receiveDrugs', src, 'heroin')
    TriggerClientEvent('oxyrun:startSellingAfterBuy', src)
end)

RegisterNetEvent('oxyrun:sellOxy', function()
    local src = source
    local cnt = ox_inventory:GetItem(src, 'oxy', nil, true) or 0
    if cnt == 0 then return end

    local sell = math.random(1, math.min(3, cnt))
    local payout = sell * Config.Price.oxySell

    ox_inventory:RemoveItem(src, 'oxy', sell)
    ox_inventory:AddItem(src, 'money', payout)
end)

RegisterNetEvent('oxyrun:sellHeroin', function()
    local src = source
    local cnt = ox_inventory:GetItem(src, 'heroin', nil, true) or 0
    if cnt == 0 then return end

    local sell = math.random(1, math.min(3, cnt))
    local payout = sell * Config.Price.heroinSell

    ox_inventory:RemoveItem(src, 'heroin', sell)
    ox_inventory:AddItem(src, 'money', payout)
end)

RegisterNetEvent('oxyrun:verifyStock', function()
    local src = source
    local hasOxy = (ox_inventory:GetItem(src, 'oxy', nil, true) or 0) > 0
    local hasHeroin = (ox_inventory:GetItem(src, 'heroin', nil, true) or 0) > 0
    if hasOxy or hasHeroin then
        TriggerClientEvent('oxyrun:startSelling', src)
    else
        TriggerClientEvent('oxyrun:noDrugs', src)
    end
end)
