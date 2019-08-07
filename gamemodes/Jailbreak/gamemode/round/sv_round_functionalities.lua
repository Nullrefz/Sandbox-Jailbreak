function JB:OpenCells(ply, ent)
    self:RemoveCloseButton()

    if not ent then
        for k, v in pairs(ents.GetAll()) do
            if JB:ValidateDoorButton(v) then
                ent = v
            end
        end
    end

    if not ent then return end
    ent:Fire("Press")
    ent:SetPos(Vector(0, 0, 0))

    timer.Simple(0.3, function()
        if ent:IsValid() then
            ent:Remove()
        end
    end)

    if not ply then
        local notification = {
            TEXT = "The cell doors are now opened"
        }

        self:SendNotification(notification)

        for k, v in pairs(player.GetAll()) do
            v:ChatPrint("The cell doors are now opened")
        end
    else
        local notification = {
            TEXT = ply:Name() .. " opened the cell doors",
        }

        self:SendNotification(notification)

        for k, v in pairs(player.GetAll()) do
            v:ChatPrint(ply:Name() .. " opened the cell doors")
        end
    end

    hook.Run("CellDoorsOpened")
end

function JB:ValidateDoorButton(ent)
    if ent:GetClass() == "func_button" and (ent:GetModel() == "*57" or ent:GetModel() == "*17" or ent:GetName() == "cellopen") then return true end

    return false
end

function JB:ResetMap(openDoors)
    game.CleanUpMap()

    if openDoors then
        self:OpenCells()
    end

    self:RemoveCloseButton()
end

hook.Add("PlayerUse", "DisableDoorAfterPress", function(ply, ent)
    if JB:ValidateDoorButton(ent) then
        JB:OpenCells(ply, ent)

        return false
    end

    return true
end)

hook.Add("EntityTakeDamage", "DisableDoorAfterButtonDamage", function(ent, dmginfo)
    if JB:ValidateDoorButton(ent) then
        JB:OpenCells(dmginfo:GetAttacker(), ent)
    end
end)

function JB:RemoveCloseButton()
    for k, v in pairs(ents.GetAll()) do
        if v:GetClass() == "func_button" and v:GetModel() == "*18" and v:GetName() == "cellclose" then
            v:Remove()
            break
        end
    end
end

hook.Add("PostCleanupMap", "SetCellDoorsClosed", function() end)