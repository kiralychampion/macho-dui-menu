local dui = nil
local visible = false

-- IDE tedd a HTTPS URL-t, ahova feltöltötted az index.html-t
local MENU_URL = "https://<felhasznalo>.github.io/macho-dui-menu/"

RegisterCommand("macho_menu", function()
    if not dui then
        dui = MachoCreateDui(MENU_URL)
        if not dui then print("^1[DUI] Létrehozás hiba.^0"); return end
        Citizen.Wait(200)
    end

    visible = not visible
    if visible then
        MachoShowDui(dui)
        MachoSendDuiMessage(dui, json.encode({
            type = "init",
            title = "Macho DUI Menü",
            items = { "Inventory", "Loadout", "Settings" }
        }))
    else
        MachoHideDui(dui)
    end
end, false)

RegisterKeyMapping("macho_menu", "Macho DUI Menü váltás", "keyboard", "F2")

RegisterCommand("macho_title", function(_, args)
    if not (dui and visible) then return end
    local newTitle = table.concat(args, " ")
    MachoSendDuiMessage(dui, json.encode({ type = "setTitle", title = newTitle }))
end, false)

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() and dui then
        MachoDestroyDui(dui)
        dui = nil
    end
end)
