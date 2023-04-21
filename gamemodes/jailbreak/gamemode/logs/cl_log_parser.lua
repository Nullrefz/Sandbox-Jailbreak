local logColor = {
    Pickup = Color(0, 150, 255),
    Kill = Color(255, 0, 0),
    Death = Color(150, 0, 255),
    Drop = Color(200, 0, 255),
    Damage = Color(255, 150, 0),
    Doors = Color(0, 200, 0),
    Disconnected = Color(200, 200, 200)
}

local playerStatusColor = {
    Neutral = Color (0,0,0),
    Rebelling = Color (255,255,0),
    Caught = Color (255,0,0),
    Warden = team.GetColor(TEAM_GUARDS),
}

function JB:ParseLog(log)

end

function JB:GetLogColor(logType)
    return logColor[logType]
end

function JB:GetStatusColor(status)
    return playerStatusColor[status]
end
