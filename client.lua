--Original script by pichotM : https://github.com/PichotM/sirencontrols-js
--Translated from js to lua (and optimised) by Sabiaryl

local DecorSilent = '_IS_SIREN_SILENT'
local DecorBlip = '_IS_SIREN_BLIP'
SirenKey = "G"


function IsSirenMuted(vehicle)
    return DecorGetBool(vehicle, DecorSilent)
end

function IsBlipSirenMuted(vehicle)
    return DecorGetBool(vehicle, DecorBlip)
end

DecorRegister(DecorBlip, 2)
DecorRegister(DecorSilent, 2)

function checkForSilentSirens() 
    for i=1, 1024, 1 do
        if NetworkIsPlayerActive(i) then
            local playerVeh = GetVehiclePedIsUsing(GetPlayerPed(i))
            if IsVehicleSirenOn(playerVeh) then
                DisableVehicleImpactExplosionActivation(playerVeh, IsSirenMuted(playerVeh))
                if IsBlipSirenMuted(playerVeh) then 
                    BlipSiren(playerVeh) end
            elseif DecorGetBool(playerVeh, "Invisible") then
                if not IsEntityVisible(playerVeh) then SetEntityVisible(playerVeh, true, true) end
                SetEntityAlpha(playerVeh, 0)
            end
        end
    end
end


Citizen.CreateThread(function()
    while true do 
        checkForSilentSirens()
        Citizen.Wait(2000)
    end
end)

RegisterCommand('siren', function()
    print('siren')
    local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local boolSilent = not IsSirenMuted(playerVeh)
    DecorSetBool(playerVeh, DecorSilent, boolSilent)
    DisableVehicleImpactExplosionActivation(playerVeh, boolSilent)

end, false)
RegisterKeyMapping('siren', 'Menu Sirene', 'keyboard', SirenKey)