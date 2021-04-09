ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('chasse:additem')

AddEventHandler('chasse:additem', function(item, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local item = item
    local amount = amount
    xPlayer.addInventoryItem(item, amount)
end)
