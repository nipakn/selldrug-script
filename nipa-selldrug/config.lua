Config = {}

Config.SellDrugsKey = 38

Config.TextDistance = 2.7 

Config.CancelLuck = 90

Config.RobLuck = 10

Config.AlertCopsLuck = 50

Config.OrderTime = 5000

Config.SecondsAfterPoliceGetAlert = 10000


Config.MoneyEarned = {
    [5] = {min = 500, max = 1500},
    [10] = {min = 1500, max = 3000},
    [15] = {min = 3000, max = 4500},
    [20] = {min = 4500, max = 6000},
    [25] = {min = 6000, max = 7500},
    [30] = {min = 7500, max = 9000},
    [35] = {min = 9000, max = 10500},
    [40] = {min = 10500, max = 12000},
    [45] = {min = 12000, max = 13500},
    [50] = {min = 13500, max = 15000}
}

Config.AlertBlip = {
    ["blip-sprite"] = 306,
    ["blip-display"] = 4,
    ["blip-scale"] = 0.8,
    ["blip-colour"] = 1,
}

Config.Translation = {
    ["presstosell"] = '~w~E to sell drugs',
    ["interested"] = 'Yes, Im interested.',
    ["not-interested"] = 'No thanks, im not interested.',
    ["convo"] = "Conversation",
    ["rob-dont-have-money"] = 'You dont even have anything to rob?!?',
    ["dont-have-drugs-to-sell"] = 'You dont even have those drugs?!',
    ["robbing-text"] = 'Give me your money now!',
    ["menu-how-much-want-to-sell"] = 'How much you want to sell?',
    ["alert-to-police"] = 'This guy tried to sell drugs to me, I took pic of him.',
    ["alert-text2"] = 'Drug Dealing (Caller)',
    ["alert-text3"] = '911 - Alert',
    ["alert-blip"] = 'Caller',
    ["robber-took"] = 'Robber took %s€ from you.', -- %s this is a placeholder for the dynamic variables
    ["you-sold"] = 'You sold %sx %s for $%s.', -- %s this is a placeholder for the dynamic variables
    ["donthave-ms"] = 'You dont have enough of this item to sell'
}

RegisterNetEvent('nd-selldrugs:config:sellmenu', function()
        local myMenu = {
            {
                id = 1,
                header = 'Conversation',
                txt = 'Selling drugs'
            },
            {
                id = 2,
                header = 'Cannabis',
                txt = 'Sell cannabis',
                params = {
                    event = 'nd-selldrugs:client:selldrugs',
                    args = {
                        thisdrug = "cannabis" -- item name here
                     }
                } 
            },
            {
                id = 3,
                header = 'Marijuana',
                txt = 'Sell marijuana',
                params = {
                    event = 'nd-selldrugs:client:selldrugs',
                    args = {
                       thisdrug = "marijuana" -- item name here
                    }
                }
            }
        }
    exports['zf_context']:openMenu(myMenu)
end)