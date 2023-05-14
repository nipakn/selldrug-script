
RegisterNetEvent('nd-selldrugs:server:palert', function(testpedcoords)
    TriggerClientEvent('nd-selldrugs:client:palert', -1, testpedcoords)
end)

RegisterNetEvent('nd-selldrugs:server:SVcheck', function(npcID)
    TriggerClientEvent('nd-selldrugs:client:interactwithnpc', -1, npcID)
end)

RegisterNetEvent('nd-selldrug:server:selldrug', function(drug, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if drug and amount then
            local item = xPlayer.getInventoryItem(drug)
            if item and item.count then
                amountnumber = tonumber(amount)
                if amountnumber then
                    local moneyearned = 0
                    local moneyconfig = Config.MoneyEarned[amountnumber]
                    if moneyconfig then
                        moneyearned = math.random(moneyconfig.min, moneyconfig.max)
                    else
                        print("Invalid amount value")
                    end

                    if amountnumber >= 5 and amountnumber <= item.count then
                        xPlayer.removeInventoryItem(drug, amountnumber)
                        xPlayer.addMoney(moneyearned)
                        TriggerClientEvent('nd-selldrugs:client:animSV', source)
                        local message = string.format(Config.Translation["you-sold"], amountnumber, drug, moneyearned)
                        TriggerClientEvent('esx:showNotification', source, message)                        
                    else
                        TriggerClientEvent('nd-selldrugs:client:donthaveMS', source)
                    end
                else
                    print("Invalid amount value")
                end
            else
                print("Failed to get inventory item")
            end
        else
            print("Invalid drug or amount value")
        end
    else
        print("Failed to get player")
    end
end)


RegisterNetEvent('nd-selldrug:server:tookmoney', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local moneyamount = math.random(500,5000)
        if xPlayer.getMoney() >= moneyamount then
            xPlayer.removeMoney(moneyamount)
            local message = string.format(Config.Translation["robber-took"], moneyamount)
            TriggerClientEvent('esx:showNotification', source, message)
            TriggerClientEvent('nd-selldrugs:client:animSV', source)
        else
           TriggerClientEvent('nd-selldrugs:client:donthavemoney', source)
        end
    else
        print('Failed to get player from ID: ' .. source)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == "nipa-selldrug") == false then
        print('Pidä se nimi siinä missö se olikin....')
        Wait(3000)
        os.exit()
    end
end)