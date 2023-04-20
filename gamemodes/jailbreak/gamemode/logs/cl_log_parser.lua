local logColor = {
    Pickup = Color(0, 150, 255),
    Kill = Color(255, 0, 0),
    Death = Color(150, 0, 255),
    Drop = Color(200, 0, 255),
    Damage = Color(255, 150, 0),
    Doors = Color(0, 200, 0),
    Disconnect = Color(200, 200, 200)
}

local playerStatusColor = {
    PLAYER_NEUTRAL = Color (0,0,0),
    PLAYER_REBELLING = Color (0,0,0),
    PLAYER_CAUGHT = Color (0,0,0),
    PLAYER_WARDEN = Color (0,0,0),
}

function JB:ParseLog(log)

end

function JB:GetLogColor(logType)
    return logColor[logType]
end
