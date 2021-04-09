ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

------ début du script ------

------ Début Enumerator ------

--[[The MIT License (MIT)
Copyright (c) 2017 IllidanS4
Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]
local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
  }
  
  local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
      local iter, id = initFunc()
      if not id or id == 0 then
        disposeFunc(iter)
        return
      end
      
      local enum = {handle = iter, destructor = disposeFunc}
      setmetatable(enum, entityEnumerator)
      
      local next = true
      repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
      until not next
      
      enum.destructor, enum.handle = nil, nil
      disposeFunc(iter)
    end)
  end
  
  
  function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
  end

  ------ Fin Enumerator --------


Citizen.CreateThread(function()
  RequestAnimDict('amb@medic@standing@kneel@base')
  RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
    while true do
      for ped in EnumeratePeds() do
        Citizen.Wait(1)
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            local animalPos = GetEntityCoords(ped)
            if GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, animalPos.x, animalPos.y, animalPos.z, true) < 1.5 and ped ~= GetPlayerPed(-1) then --Proche d'un ped
              if GetPedType(ped) == 28 then --Proche d'un animal
                    if IsPedDeadOrDying(ped)then --Proche d'un animal mort
                      while GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, animalPos.x, animalPos.y, animalPos.z, true) < 1.8 do
                        BeginTextCommandDisplayHelp("STRING")
                        AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_TALK~ pour dépecer")
                        EndTextCommandDisplayHelp(0, false, false, 500)
                        if IsControlJustPressed(0, 38) then
                          if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_KNIFE") then
                            RequestAnimDict('amb@medic@standing@kneel@base')
                            RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
                            TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
                            TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
                            Citizen.Wait(10000)
                            if GetEntityModel(ped) == GetHashKey("a_c_boar") then
                              TriggerServerEvent('chasse:additem', "chasse_sanglier", 1)
                              DeletePed(ped)
                            end
                            if GetEntityModel(ped) == GetHashKey("a_c_chickenhawk") then
                              TriggerServerEvent('chasse:additem', "chasse_faucon", 1)
                              DeletePed(ped)
                            end
                            if GetEntityModel(ped) == GetHashKey("a_c_cormorant") then
                              TriggerServerEvent('chasse:additem', "chasse_cormorant", 1)
                              DeletePed(ped)
                            end
                            if GetEntityModel(ped) == GetHashKey("a_c_coyote") then
                              TriggerServerEvent('chasse:additem', "chasse_coyote", 1)
                              DeletePed(ped)
                            end
                            if GetEntityModel(ped) == GetHashKey("a_c_deer") then
                              TriggerServerEvent('chasse:additem', "chasse_cerf", 1)
                              DeletePed(ped)
                            end
                            if GetEntityModel(ped) == GetHashKey("a_c_mtlion") then
                              TriggerServerEvent('chasse:additem', "chasse_cougar", 1)
                              DeletePed(ped)
                            end
                            if GetEntityModel(ped) == GetHashKey("a_c_rabbit_01") then
                              TriggerServerEvent('chasse:additem', "chasse_lapin", 1)
                              DeletePed(ped)
                            end
                            ClearPedTasks(GetPlayerPed(-1))
                            break
                          else
                            BeginTextCommandDisplayHelp("STRING")
                            AddTextComponentSubstringPlayerName("Equipez vous d'un couteau de chasse")
                            EndTextCommandDisplayHelp(0, false, false, 3000)
                            Citizen.Wait(3000)
                          end
                        end
                        local playerPos = GetEntityCoords(GetPlayerPed(-1))
                        if GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, animalPos.x, animalPos.y, animalPos.z, true) > 1.8 then
                          break
                        end
                        Citizen.Wait(5)
                      end
                    end
              end
            end
      end
      Citizen.Wait(3000)
    end

end)
