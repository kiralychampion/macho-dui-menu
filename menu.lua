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

        -- Toggle DELETE (178)
        if IsControlJustPressed(0, 178) then
            if visible then closeMenu() else openMenu() end
        end

        if visible then
            -- Figyeljük a nyilakat és az entert (nincs disable!)
            if IsControlJustPressed(0, 172) then send({type="move",  delta=-1}) end -- ↑
            if IsControlJustPressed(0, 173) then send({type="move",  delta=1})  end -- ↓
            if IsControlJustPressed(0, 174) then send({type="closeSub"}) end        -- ←
            if IsControlJustPressed(0, 175) then send({type="openSub"})  end        -- →
            if IsControlJustPressed(0, 176) then send({type="confirm"})  end        -- Enter
            if IsControlJustPressed(0, 177) then send({type="closeSub"}) end        -- Back
        end
    end
end)
