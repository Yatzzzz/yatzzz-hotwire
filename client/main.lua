ESX = nil
myKeys = {}
latestvehicle = nil
factor = 0
local fuckingRETARDED = false
whatthefuckisthisdoing = 0
local searchedVehs = {}
local hotwiredVehs = {}
local isActive = false
local haskeys = {}
local Time = 10 * 1000 -- Time for each stage (ms)
local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local anim = "machinic_loop_mechandplayer"
local flags = 49
local trackedVehicles = {}
local hassearched = {}
local duzkontaklandi = {}
local maymuncuklandi = {}
local PlayerData = {}
local yatzzzbirazbekle = false
local Plakalar = {}

local duzKontakSes = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(50)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	Citizen.Wait(1000)
	ESX.TriggerServerCallback('yatzzz_carlock:GetPlates', function(plaka)
        Plakalar = plaka
        for i = 1, #plaka do
            if not hasKey(plaka[i]) then
               table.insert(myKeys,plaka[i])
            end
        end
	end)
end)


RegisterCommand("anahtarver", function()
    TriggerEvent("x-hotwire:yatzzzf3inahtar")
end)


RegisterNetEvent('x-hotwire:yatzzzf3inahtar')
AddEventHandler('x-hotwire:yatzzzf3inahtar', function()
    local usedPed = PlayerPedId()
    local coordA = GetEntityCoords(usedPed, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(usedPed, 0.0, 100.0, 0.0)

    
    if #myKeys == 0 then
        exports['mythic_notify']:DoHudText('error', "Verebileceğin bir anahtarın yok!", 4000)
        return
    end
    
    if IsPedInAnyVehicle(usedPed, false) then
        vehicle = GetVehiclePedIsIn(usedPed, false)
    else
        vehicle = getVehicleInDirection(coordA, coordB)
    end 

    if vehicle == nil or not DoesEntityExist(vehicle) then
        exports['mythic_notify']:DoHudText('error', "Araç bulunamadı! Araca doğru bakmalısın.", 6000)
        return
    end

     if not hasKey(GetVehicleNumberPlateText(vehicle)) then
           exports['mythic_notify']:DoHudText('error', "Anahtarı verebilmek için o aracın anahtarına sahip olman gerekiyor.", 4000)
       return
    end

    if GetDistanceBetweenCoords(GetEntityCoords(vehicle), GetEntityCoords(usedPed, 0)) > 5 then
        exports['mythic_notify']:DoHudText('error', "Araçtan çok uzaksın!", 4000)
        return
    end


    local plate = GetVehicleNumberPlateText(vehicle)
    local yatzzzPlate = GetVehicleNumberPlateText(vehicle)
    --for i = 1, #Plakalar, 1 do
       -- if yatzzzPlate == Plakalar[i].plate then
            t, distance = GetClosestPlayer()
            if(distance ~= -1 and distance < 5) then
                TriggerServerEvent("ARPF:GiveKeys", GetPlayerServerId(t), yatzzzPlate)
            else
                exports['mythic_notify']:DoHudText('error', 'Yanında oyuncu yok!')
            end
        --end
    --end           
end)


function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = PlayerPedId(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(PlayerPedId(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

RegisterNetEvent('yatzzz-arackilit:plakaekle-xhotwire')
AddEventHandler('yatzzz-arackilit:plakaekle-xhotwire', function(yeniplaka)
    if yeniplaka ~= nil then
        table.insert(Plakalar, {
            plate = yeniplaka
        })
    else
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local plaka = GetVehicleNumberPlateText(vehicle)
        table.insert(Plakalar, {
            plate = plaka
        })
    end
end)

RegisterNetEvent('ARPF:spawn:recivekeys')
AddEventHandler('ARPF:spawn:recivekeys', function(plate)
    if plate == nil then
        return
    end
    
    if not hasKey(plate) then
        table.insert(myKeys, plate)
        TriggerEvent("esx_carlock:addPlate", plate)
        exports['mythic_notify']:DoHudText('inform', "Aracın anahtarını aldın.", 6000)
    else
        exports['mythic_notify']:DoHudText('error', "Bu aracın anahtarı zaten sende var.", 6000)
    end
end)

function hasKey(plate)
    local has = false
      for _,v in pairs(myKeys) do
      if v ~= nil and v == plate then
          has = true
      end
    end
    return has
end

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle
  
    for i = 0, 100 do
      rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0) 
      a, b, c, d, vehicle = GetRaycastResult(rayHandle)
      
      offset = offset - 1
  
      if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end
  
      return vehicle ~= nil and vehicle or 0
end

RegisterNetEvent('ARPF:recivekeys')
AddEventHandler('ARPF:recivekeys', function(name,plates)
    
    ped = PlayerPedId()
    local coordA = GetEntityCoords(ped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 100.0, 0.0)
    local veh = getVehicleInDirection(coordA, coordB)

    local plate = GetVehicleNumberPlateText(veh)
    if ESX.Math.Trim(plate) == ESX.Math.Trim(plates) then
        TrackVehicle(plate, veh)
        trackedVehicles[plate].canTurnOver = true
        exports['mythic_notify']:DoHudText('inform', name.." kişisinden "..plate.. " plakalı aracın anahtarını aldın.", 6000)
        Citizen.Wait(50)
        TriggerEvent("esx_carlock:addPlate", plate)
        TriggerEvent("yatzzz-arackilit:plakaekle-xhotwire", plate)
    end
end)

RegisterNetEvent('disc-hotwire:forceTurnOver')
AddEventHandler('disc-hotwire:forceTurnOver', function(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TrackVehicle(plate, vehicle)
    trackedVehicles[plate].canTurnOver = true
end)

RegisterNetEvent('disc-hotwire:maymuncuk')
AddEventHandler('disc-hotwire:maymuncuk', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then 
        local vehicle = GetVehiclePedIsIn(playerPed)
        local plate = GetVehicleNumberPlateText(vehicle)

        if GetIsVehicleEngineRunning(vehicle) then
            return
        end

        if trackedVehicles[plate].canTurnOver then
            return
        end
        chance = math.random(1,5)
        if Config.TestMod then
            time = 2500
            time2 = 1000
            time3 = 3000
        else
            time = 15000
            time2 = 20000
            time3 = 25000
        end
        duzKontakSes = true
        TriggerEvent("animation:repaircar", 22000)
        TriggerEvent("x-hotwire:duzKontakSes")
        exports['mythic_notify']:DoHudText('inform', 'Düz kontak yapmak için kapağı çıkarıyorsun')
        exports["t0sic_loadingbar"]:StartDelayedFunction("Aşama 1", time, function()
            --TriggerEvent("yatzzz-stres:stres-arttir", 80)
            exports['mythic_notify']:DoHudText('inform', 'Düz kontak için doğru kabloları bulmaya çalışıyorsun')
            TriggerEvent("animation:repaircar", 19000)
            exports["t0sic_loadingbar"]:StartDelayedFunction("Aşama 2", time2, function()

                --TriggerEvent("yatzzz-stres:stres-arttir", 80)
                exports['mythic_notify']:DoHudText('inform', 'Düz kontak için doğru kabloları bulmaya çalışıyorsun')
                TriggerEvent("animation:repaircar", 30000)
                exports["t0sic_loadingbar"]:StartDelayedFunction("Aşama 3", time3, function()
                    TriggerEvent("yatzzz-stres:stres-arttir", 80)
                    exports['mythic_notify']:DoHudText('success', 'Düz kontak başarılı', 5000)
                    alarmChance = math.random(100)
                    if alarmChance <= 45 then
                        SetVehicleAlarm(vehicle, true)
                        SetVehicleAlarmTimeLeft(vehicle, 25 * 1000)
                        TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 16, 0)
                    else
                        TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 16, 0)
                    end
                    trackedVehicles[plate].canTurnOver = true
                    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                    TriggerEvent("esx_carlock:addPlate", vehicleProps.plate)
                    TriggerEvent("yatzzz-arackilit:plakaekle-xhotwire", vehicleProps.plate)
                    maymuncuklandi[plate] = true 
                    duzKontakSes = false
                    searchedVehs[vehicle] = false
                end)
            end)
        end)
    end
end)

RegisterNetEvent('disc-hotwire:hotwire')
AddEventHandler('disc-hotwire:hotwire', function()

    local playerPed = PlayerPedId()

    --vehicle = GetVehiclePedIsIn(ped, false)

    local vehicle = VehicleInFront()
    state = GetVehicleDoorLockStatus(vehicle)

    -- İtemsiz Düz Kontak
    if not fuckingRETARDED then
        fuckingRETARDED = true
        TriggerEvent("keys:shutoffengine")
        Citizen.Wait(100)
            if not IsPedInAnyVehicle(playerPed) then
                fuckingRETARDED = false
                whatthefuckisthisdoing = 0
                return
            end
            if isActive then
                fuckingRETARDED = false
                whatthefuckisthisdoing = 0
                return
            end
            vehicle = GetVehiclePedIsIn(playerPed, false)
            plate = GetVehicleNumberPlateText(vehicle)
            -- if GetIsVehicleEngineRunning(vehicle) or IsVehicleEngineStarting(vehicle) then
            --     fuckingRETARDED = false
            --     print("1413")
            --     whatthefuckisthisdoing = 0
            --     return
            -- end

            if trackedVehicles[plate].canTurnOver then
                fuckingRETARDED = false
                whatthefuckisthisdoing = 0
                return
            end

            local carTimer = GetVehicleHandlingFloat(veh, 'CHandlingData', 'nMonetaryValue')
            if carTimer > 120000 then
                carTimer = 120000
            end
            if carTimer < 45000 then
                carTimer = 45000
            end

            carTimer = math.random(math.ceil(carTimer/2),math.ceil(carTimer))
            whatthefuckisthisdoing = carTimer
            isActive = true
            duzKontakSes = true
            TriggerEvent("x-hotwire:duzKontakSes")
            time = 20000
            time2 = 16000
            time3 = 20000
            TriggerEvent("animation:repaircar", 30000)

            exports['mythic_notify']:DoHudText('inform', 'Düz kontak yapmak için kapağı çıkarıyorsun...')
            TriggerEvent("mythic_progbar:client:progress", {
                name = "hotwire1",
                duration = time,
                label = 'AŞAMA 1...',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(status)
                if not status then
                    --TriggerEvent('esx_status:add', 'stress', 10000)
                    exports['mythic_notify']:DoHudText('inform', 'Düz kontak için doğru kabloları bulmaya çalışıyorsun...')
                    TriggerEvent("animation:repaircar", 26000)
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "hotwire2",
                        duration = time2,
                        label = 'AŞAMA 2...',
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                    }, function(status)
                        if not status then    
                            --TriggerEvent('esx_status:add', 'stress', 10000)
                            exports['mythic_notify']:DoHudText('inform', 'Düz kontak için doğru kabloları bulmaya çalışıyorsun...')
                            TriggerEvent("animation:repaircar", 30000)                    
                            local sans = math.random(1,2)
                            if sans == 2 then 
                                TriggerEvent("yatzzz:hotwireAlert")
                            end
        
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "hotwire3",
                                duration = time3,
                                label = 'AŞAMA 3...',
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                            }, function(status)
                                if not status then  
                                    --TriggerEvent('esx_status:add', 'stress', 10000)
                                    duzKontakSes = false
                                    ClearPedSecondaryTask(playerPed)
                                    
                                    SetVehicleAlarm(vehicle, true)
                                    SetVehicleAlarmTimeLeft(vehicle, 25 * 1000)
                                    SetVehicleDoorsLocked(vehicle, 1)
                                    ClearPedTasks(playerPed)
                                    trackedVehicles[plate].canTurnOver = true
                                    RemoveAnimDict(animDict)                        
                                    isActive = false
                                    searchedVehs[vehicle] = false
                                    Citizen.Wait(1000)
                                    whatthefuckisthisdoing = 0
                                    fuckingRETARDED = false    
                                    Citizen.Wait(1000)
                                    TriggerEvent("keys:addNew", vehicle, plt)
                                    if trackedVehicles[plate].canTurnOver then
                                        trackedVehicles[plate].state = 1
                                    end
                                    exports['mythic_notify']:DoHudText('success', 'Düz kontak başarılı', 5000)
                                else
                                    isActive = false
                                    searchedVehs[vehicle] = false
                                    fuckingRETARDED = false
                                    ClearPedSecondaryTask(playerPed)
                                    ClearPedTasks(playerPed)
                                    duzKontakSes = false
                                    exports['mythic_notify']:DoHudText('error', 'Düz kontak iptal edildi! Artık bu aracı kullanamazsın!', 5000)
                                end 
                            end)
                        else
                            isActive = false
                            searchedVehs[vehicle] = false
                            fuckingRETARDED = false
                            ClearPedSecondaryTask(playerPed)
                            ClearPedTasks(playerPed)
                            duzKontakSes = false
                            exports['mythic_notify']:DoHudText('error', 'Düz kontak iptal edildi! Artık bu aracı kullanamazsın!', 5000)
                        end  
                    end)
                else
                    isActive = false
                    searchedVehs[vehicle] = false
                    fuckingRETARDED = false
                    ClearPedSecondaryTask(playerPed)
                    ClearPedTasks(playerPed)
                    duzKontakSes = false
                    exports['mythic_notify']:DoHudText('error', 'Düz kontak iptal edildi!', 5000)

                end   
            end)
    end
end)

RegisterNetEvent('keys:received')
AddEventHandler('keys:received', function(plate)
    if plate == nil then
        return
    end

    if not hasKey(plate) then
        table.insert(myKeys, plate)
        TrackVehicle(plate, GetVehiclePedIsIn(PlayerPedId(), false))
        TriggerEvent("esx_carlock:addPlate", ESX.Math.Trim(plate))
        trackedVehicles[plate].canTurnOver = true
        whatthefuckisthisdoing = 0
        fuckingRETARDED = false
        TriggerEvent("yatzzz-arackilit:plakaekle-xhotwire", plate)

        if trackedVehicles[plate].canTurnOver then --yeni kod
            trackedVehicles[plate].state = 1
        end
        exports['mythic_notify']:DoHudText('inform', "Aracın anahtarını aldın.", 6000)
    else
        exports['mythic_notify']:DoHudText('error', "Bu aracın anahtarı zaten sende var.", 6000)
    end
end)

RegisterNetEvent('keys:addNew')
AddEventHandler('keys:addNew', function(veh, plate)
  if veh == nil then
    return
  end

  plate = plate or GetVehicleNumberPlateText(veh)
  if not hasKey(plate) then
    table.insert(myKeys, plate)
    TrackVehicle(plate, GetVehiclePedIsIn(PlayerPedId(), false))
    TriggerEvent("esx_carlock:addPlate", ESX.Math.Trim(plate))
    trackedVehicles[plate].canTurnOver = true
    whatthefuckisthisdoing = 0
    fuckingRETARDED = false
    TriggerEvent("yatzzz-arackilit:plakaekle-xhotwire", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
  end



  SetVehRadioStation(veh, "OFF")
  SetVehicleDoorsLocked(veh, 1)
end)



function searchvehicle()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())

    plate = GetVehicleNumberPlateText(vehicle)

    if trackedVehicles[plate].canTurnOver == false then
        if not fuckingRETARDED then
            fuckingRETARDED = true

            TriggerEvent("keys:shutoffengine")
            local luck = math.random(20,69)
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                exports['mythic_notify']:DoHudText('error', 'Aracın içinde değilsin!')
                searchedVehs[vehicle] = false
                fuckingRETARDED = false
                return
            end

            if luck >= 66 then --66
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "hotwire_foundkey",
                    duration = 6000,
                    label = 'Aracın anahtarını buldun...',
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then                    
                        trackedVehicles[plate].canTurnOver = true
                        Citizen.Wait(500)
                        searchedVehs[vehicle] = false
                        whatthefuckisthisdoing = 0
                        fuckingRETARDED = false    
                        Citizen.Wait(1000)
                        TriggerEvent("keys:addNew", vehicle, plt)
                        if trackedVehicles[plate].canTurnOver then
                            trackedVehicles[plate].state = 1
                        end
                        exports['mythic_notify']:DoHudText('inform', 'Motor çalıştırıldı.')  
                    end
                end)
            elseif luck >= 40 and luck <= 65 then  
                searchedVehs[vehicle] = false
                TriggerServerEvent("disc-hotwire:giveItem")
                fuckingRETARDED = false
            elseif luck >= 15 and luck <= 39 then  
                TriggerServerEvent("disc-hotwire:givereward")
                searchedVehs[vehicle] = false
                fuckingRETARDED = false                    
                
            else
                searchedVehs[vehicle] = false
                fuckingRETARDED = false
                exports['mythic_notify']:DoHudText('error', 'Hiçbir şey bulamadın!')  
            end
            fuckingRETARDED = false

        end
    end
end




Citizen.CreateThread(function()
    local performanscd = 1000
    local playerPed = PlayerPedId()
    while true do
        Citizen.Wait(performanscd)
        playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed)
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                performanscd = 10
                local plate = GetVehicleNumberPlateText(vehicle)
                TrackVehicle(plate, vehicle)
                local aracclas = GetVehicleClass(vehicle)
                if not trackedVehicles[plate].canTurnOver and aracclas ~= 15 and aracclas ~= 16 and aracclas ~= 19 and aracclas ~= 13 and aracclas ~= 10 and aracclas ~= 11 and aracclas ~= 17 then
                    
                    if not searchedVehs[vehicle] then
                        SetVehicleEngineOn(vehicle, false, false)
                        local kaput = GetEntityBoneIndexByName(vehicle, 'engine')
                        local vehiclePos = GetWorldPositionOfEntityBone(vehicle, kaput)
                        DisableControlAction(0, 59) -- leaning left/right
                        DisableControlAction(0, 60) -- leaning up/down
                        --if not searchedVehs[vehicle] then
                        if (latestveh ~= vehicle and not hasKey(plate)) or not hasKey(plate) then
                            TriggerEvent("keys:shutoffengine")
                        end                        
                        if whatthefuckisthisdoing > 0 then
                            if hassearched[plate] == false or hassearched[plate] == nil then 
                                DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[G] Ara / [H] Düz kontak")

                               --DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[~g~H~w~] Düz Kontak [~g~Z~w~] Ara") --[~g~G~w~] Maymuncukla")
                            elseif hassearched[plate] == true then 

                                DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[H] Düz kontak" )
                                ---DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[~g~H~w~] Düz Kontak") --[~g~G~w~] Maymuncukla")
                            end
            
                            if IsControlJustPressed(0, 304) and not duzkontaklandi[plate] == true then
                                Citizen.Wait(400)
            
                                searchedVehs[vehicle] = true
                                TriggerEvent("disc-hotwire:hotwire")
                            end
            
                            if IsControlJustPressed(0, 47) and not hassearched[plate] == true then 
                                searchedVehs[vehicle] = true
                                Citizen.Wait(400)
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "hotwire_search",
                                    duration = 14000,
                                    label = 'Araç aranıyor..',
                                    useWhileDead = false,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                }, function(status)
                                    if not status then    
                                        searchvehicle()
                                        searchedVehs[vehicle] = false
                                        hassearched[plate] = true 
                                    else
                                        exports["mythic_notify"]:DoHudText("error", "Araç arama iptal edildi!")
                                        searchedVehs[vehicle] = false
                                        hassearched[plate] = true 
                                    end
                                end)

                            end
                        end
                    end
                end  
                latestveh = vehicle              
            end
        else
            performanscd = 1000
        end
    end
end)


local runningshutoff = false
 RegisterNetEvent('keys:shutoffengine')
 AddEventHandler('keys:shutoffengine', function()

      whatthefuckisthisdoing = 1000
      if runningshutoff then
        return
      end
      runningshutoff = true
      local veh = GetVehiclePedIsUsing(PlayerPedId())

      while whatthefuckisthisdoing > 0 do

           Citizen.Wait(1)
           SetVehicleEngineOn(veh,0,1,1)
          whatthefuckisthisdoing = whatthefuckisthisdoing - 1  
       end

       whatthefuckisthisdoing = 0
       runningshutoff = false
 end)


function arackontrol(playerPed, coords, vehicle, plate, seat)
    TrackVehicle(plate, vehicle)
    local aracclas = GetVehicleClass(vehicle)
    if not trackedVehicles[plate].canTurnOver and aracclas ~= 15 and aracclas ~= 16 and aracclas ~= 19 and aracclas ~= 13 and aracclas ~= 10 and aracclas ~= 11 and aracclas ~= 17 then
        SetVehicleEngineOn(vehicle, false, false)
        local kaput = GetEntityBoneIndexByName(vehicle, 'engine')
        local vehiclePos = GetWorldPositionOfEntityBone(vehicle, kaput)
        DisableControlAction(0, 59) -- leaning left/right
        DisableControlAction(0, 60) -- leaning up/down
        --if not searchedVehs[vehicle] then
        if (latestveh ~= vehicle and not hasKey(plate)) or not hasKey(plate) then
            TriggerEvent("keys:shutoffengine")
        end
        if not searchedVehs[vehicle] and not hasKey(plate) then
            if whatthefuckisthisdoing > 0 then

                if hassearched[plate] == false or hassearched[plate] == nil then 
                    DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[Z] Ara / [H] Düz Kontak")
                   --DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[~g~H~w~] Düz Kontak [~g~Z~w~] Ara") --[~g~G~w~] Maymuncukla")
                elseif hassearched[plate] == true then 
                    DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[H] Düz kontak" )
                    ---DrawText3Ds(vehiclePos.x, vehiclePos.y, vehiclePos.z+0.20, "[~g~H~w~] Düz Kontak") --[~g~G~w~] Maymuncukla")
                end

                if IsControlJustPressed(0, 304) and not duzkontaklandi[plate] == true then
                    Citizen.Wait(400)

                    searchedVehs[vehicle] = true
                    TriggerEvent("disc-hotwire:hotwire")
                end

                if IsControlJustPressed(0, 20) and not hassearched[plate] == true then 
                    Citizen.Wait(400)
                    exports["t0sic_loadingbar"]:StartDelayedFunction("Araç aranıyor...", 1400, function()
                        searchvehicle()
                    end)
                    searchedVehs[vehicle] = true
                    hassearched[plate] = true 
                end
            end
        end
        latestveh = vehicle

    end

end



domsgnow = 0
Citizen.CreateThread( function()
    local playerPed = PlayerPedId()
    local isleniyor = false
    while true do
        Citizen.Wait(1)
        local doingsomething = false
        playerPed = PlayerPedId()
        if GetVehiclePedIsTryingToEnter(playerPed) ~= nil and GetVehiclePedIsTryingToEnter(playerPed) ~= 0 then
            local curveh = GetVehiclePedIsTryingToEnter(playerPed)
            local plate = GetVehicleNumberPlateText(curveh)

           TrackVehicle(plate,curveh)
          doingsomething = true
          local plate = GetVehicleNumberPlateText(curveh)
          if trackedVehicles[plate].canTurnOver == false then

                if not hasKey(plate) then

                    local pedDriver = GetPedInVehicleSeat(curveh, -1)
                    if pedDriver ~= 0 and (not IsPedAPlayer(pedDriver) or IsEntityDead(pedDriver)) then


                        if IsEntityDead(pedDriver) then

                            TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
                            if not isleniyor then
                                isleniyor = true
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "hotwire_search",
                                    duration = 3000,
                                    label = 'Anahtar Alınıyor...',
                                    useWhileDead = false,
                                    canCancel = false,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = false,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                }, function(status)
                                    if not status then
                                        isleniyor = false
                                        trackedVehicles[plate].canTurnOver = true
                                        isActive = false
                                        searchedVehs[curveh] = false
                                        Citizen.Wait(1000)
                                        whatthefuckisthisdoing = 0
                                        fuckingRETARDED = false    
                                        Citizen.Wait(1000)
                                        TriggerEvent("keys:addNew", curveh, plt)
                                        if trackedVehicles[plate].canTurnOver then
                                            trackedVehicles[plate].state = 1
                                        end
                                    end
                                end)
                            end
                        else

                            if GetEntityModel(curveh) ~= `taxi` then

                            if math.random(100) > 94 then

                                if not isleniyor then
                                    TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)

                                    isleniyor = true
                                    TriggerEvent("mythic_progbar:client:progress", {
                                        name = "hotwire_search2",
                                        duration = 3000,
                                        label = 'Anahtar alınıyor...',
                                        useWhileDead = false,
                                        canCancel = false,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = false,
                                            disableMouse = false,
                                            disableCombat = true,
                                        },
                                    }, function(status)
                                        if not status then
                                            isleniyor = false
                                            trackedVehicles[plate].canTurnOver = true
                                            isActive = false
                                            searchedVehs[curveh] = false
                                            Citizen.Wait(1000)
                                            whatthefuckisthisdoing = 0
                                            fuckingRETARDED = false    
                                            Citizen.Wait(1000)
                                            TriggerEvent("keys:addNew", curveh, plt)
                                            if trackedVehicles[plate].canTurnOver then
                                                trackedVehicles[plate].state = 1
                                            end
            
                                        end
                                    end)
                                end
                                

                            else
                                exports["mythic_notify"]:DoHudText("error", "Sürücü panik yaptı ve kapıyı kilitleyip kaçıyor!", 5000)
                                SetVehicleDoorsLocked(curveh, 2)
                                print("angry")
                                Citizen.Wait(1000)
                                TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
                                TaskReactAndFleePed(pedDriver, playerPed)
                                SetPedKeepTask(pedDriver, true)
                                ClearPedTasksImmediately(playerPed)
                                disableF = true
                                Citizen.Wait(2000)
                                disableF = false
                            end
                            
                            else
                            TriggerEvent("startAITaxi",true)
                            
                            
                            SetPedIntoVehicle(playerPed, curveh, 2)
                            SetPedIntoVehicle(playerPed, curveh, 1)

                            end
                        end
                    end
                end
            end
        end

        if IsPedJacking(playerPed) then
          doingsomething = true
            local veh = GetVehiclePedIsUsing(playerPed)
            local plate = GetVehicleNumberPlateText(veh)
            local stayhere = true

           while stayhere do

                local inCar = IsPedInAnyVehicle(playerPed, false)
                if not inCar then
                    stayhere = false
                end

                if IsVehicleEngineOn(veh) and not hasKey(plate) then
                    TriggerEvent("keys:shutoffengine")
                    stayhere = false
                end
                Citizen.Wait(1)
            end
        end   

        if domsgnow > 0 then
          domsgnow = domsgnow - 1
        end
        if not doingsomething then
          Wait(100)
        end
    end
end)



RegisterNetEvent('animation:repaircar')
AddEventHandler('animation:repaircar', function(secounts)

    inanimation = true

    ClearPedTasksImmediately(IPed)

    if not handCuffed then

        local lPed = PlayerPedId()



        RequestAnimDict("mini@repair")

        while not HasAnimDictLoaded("mini@repair") do

            Citizen.Wait(50)

        end

        

        if IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then

            ClearPedSecondaryTask(lPed)

            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)

        else

            ClearPedTasksImmediately(IPed)

            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)

            seccount = secounts

            while seccount > 0 do

                Citizen.Wait(1000)

                seccount = seccount - 1

            end



            ClearPedSecondaryTask(lPed)

        end   

    else

        ClearPedSecondaryTask(lPed)

    end

    inanimation = false

end)



function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


RegisterNetEvent('animation:lockpickinvtestoutside')
AddEventHandler('animation:lockpickinvtestoutside', function()

    local Ped = PlayerPedId()

    RequestAnimDict("veh@break_in@0h@p_m_one@")

    while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do

        Citizen.Wait(50)

    end

    while kilitac do


      TaskPlayAnim(Ped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)

      Citizen.Wait(2000)

      ClearPedTasks(Ped)

      TaskPlayAnim(Ped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)

      Citizen.Wait(2000)

      ClearPedTasks(Ped)

      TaskPlayAnim(Ped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)

      Citizen.Wait(2000)

      ClearPedTasks(Ped)

      TaskPlayAnim(Ped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)

      Citizen.Wait(2000)

    end

    ClearPedTasks(Ped)

end)


RegisterNetEvent('x-hotwire:duzKontakSes')
AddEventHandler('x-hotwire:duzKontakSes', function()
    while duzKontakSes do
      Citizen.Wait(3000)
    end
end)

function TrackVehicle(plate, vehicle) 
    if trackedVehicles[plate] == nil then
        if vehicle == nil then
            local coordA = GetEntityCoords(PlayerPedId(), 1)
            local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
            vehicle = getVehicleInDirection(coordA, coordB)
        end
        trackedVehicles[plate] = {}
        trackedVehicles[plate].vehicle = vehicle
        trackedVehicles[plate].canTurnOver = false
    end
end

function VehicleInFront()
    local player = PlayerPedId()
    local pos = GetEntityCoords(player)
    local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, 2.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, player, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
    return result
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
      RequestAnimDict(dict)
      Citizen.Wait(1)
    end
end

function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, player)
    end
    return players
end

--Disable All Cars Not tracked or Turned over

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(10)

        for k, v in pairs(trackedVehicles) do

            if not v.canTurnOver or v.state == 0 then

                SetVehicleEngineOn(v.vehicle, false, false)

            elseif v.state == 1 then

                SetVehicleEngineOn(v.vehicle, true, false)

                v.state = -1

            end

        end

    end

end)



--Turnover key

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10) 
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed then
                if IsControlJustReleased(1, 182) then
                    local vehicle = GetVehiclePedIsIn(playerPed)
                    local isTurned = GetIsVehicleEngineRunning(vehicle)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    local yatzzzPlate = GetVehicleNumberPlateText(vehicle)
                    if trackedVehicles[plate] == nil then
                        TrackVehicle(plate, vehicle)
                    end
                    if isTurned then
                        trackedVehicles[plate].state = 0
                        exports["mythic_notify"]:DoHudText("inform", "Motor durduruldu.")
                    elseif trackedVehicles[plate].canTurnOver then
                        trackedVehicles[plate].state = 1
                        exports["mythic_notify"]:DoHudText("inform", "Motor çalıştırıldı.")
                    elseif trackedVehicles[plate] ~= nil then
                        --for i = 1, #Plakalar, 1 do
                            if hasKey(yatzzzPlate) then
                                --print("115")
                                trackedVehicles[plate].canTurnOver = true
                                trackedVehicles[plate].state = 1
                            end
                        --end
                    end
                end
            end
        end
    end
end)