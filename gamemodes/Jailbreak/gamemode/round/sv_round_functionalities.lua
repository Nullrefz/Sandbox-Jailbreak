function JB:OpenCells()
end

hook.Add("Think", "TraceEntity", function()
    local button = player.GetAll()[1]:GetEyeTrace().Entity

    if player.GetAll()[1]:GetEyeTrace().Entity:GetClass() == "func_button" and button:GetModel() == "*57" then
        button:Fire("Press")
       -- button:Remove()
    end
end)