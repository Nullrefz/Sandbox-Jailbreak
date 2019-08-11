util.AddNetworkString("SendCustomLR")

net.Receive("SendLR", function(ln, ply)
    local lastRequest = net.ReadString()

    if lastRequest == "tic tac toe" then
        JB:SetTicTacToe()
    elseif lastRequest == "knife battle" then
        JB:SetKnifeBattle()
    elseif lastRequest == "calendar" then
        JB:OpenMenu(lastRequest)
    elseif lastRequest == "sniper battle" then
        JB:SetSniperBattle()
    elseif lastRequest == "custom" then
        JB:SetCustom()
    end
end)

function JB:SetTicTacToe()
end

function JB:SetKnifeBattle()
end

function JB:SetSniperBattle()
end

function JB:SetCustom()
end