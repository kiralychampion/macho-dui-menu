-- Macho DUI Menu Loader (Delete gombbal, nyílvezérlés)
local dui, visible = nil, false
local MENU_URL = "https://kiralychampion.github.io/macho-dui-menu/"

local function send(m)
    if dui then
        MachoSendDuiMessage(dui, json.encode(m))
    end
end

local function openMenu()
    if not dui then
        dui = MachoCreateDui(MENU_URL)
        if not dui then
            print("^1[MachoDUI] DUI létrehozás hiba^0")
            return
        end
        Citizen.Wait(200)
        send({
            type  = "init",
            title = "Phaze",
            index = 1,
            items = {
                "Main menu","Player","Server","Weapon","Combat",
                "Vehicle","Visual","Miscellaneous","Settings","Search"
            }
        })
    end
    MachoShowDui(dui)
    send({type="show"})
    send({type="focus"})
    visible = true
end

local function closeMenu()
    if not dui then return end
    send({type="hide"})
    MachoHideDui(dui)
    visible = false
end

CreateThread(function()
    while true do
        Wait(0)

        -- Toggle: DELETE (178)
        if IsControlJustPressed(0, 178) then
            if visible then closeMenu() else openMenu() end
        end

        if visible then
            -- Tiltsuk a játék inputját
            DisableControlAction(0, 172, true) -- Up
            DisableControlAction(0, 173, true) -- Down
            DisableControlAction(0, 174, true) -- Left
            DisableControlAction(0, 175, true) -- Right
            DisableControlAction(0, 176, true) -- Enter/Accept
            DisableControlAction(0, 177, true) -- Back/Cancel

            if IsDisabledControlJustPressed(0, 172) then send({type="move",  delta=-1}) end
            if IsDisabledControlJustPressed(0, 173) then send({type="move",  delta=1})  end
            if IsDisabledControlJustPressed(0, 174) then send({type="closeSub"}) end
            if IsDisabledControlJustPressed(0, 175) then send({type="openSub"})  end
            if IsDisabledControlJustPressed(0, 176) then send({type="confirm"})  end
            if IsDisabledControlJustPressed(0, 177) then send({type="closeSub"}) end
        end
    end
end)
