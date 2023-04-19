local logColor = {
    Pickup = Color(0, 150, 255),
    Kill = Color(255, 0, 0),
    Death = Color(150, 0, 255),
    Drop = Color(200, 0, 255),
    Damage = Color(255, 150, 0),
    Doors = Color(0, 0, 255),
    Disconnect = Color(200, 200, 200)
}

function JB:ParseLog(log)

end

function JB:GetLogColor(logType)
    return logColor[logType]
end
