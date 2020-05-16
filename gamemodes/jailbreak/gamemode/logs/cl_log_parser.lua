local logColor = {
    Pickup = Color(0, 150, 255),
    Kill = Color(255, 25, 255),
    Death = Color(255, 20, 20),
    Drop = Color(255, 255, 255)
}


function JB:ParseLog(log)

end

function JB:GetLogColor(logType)
    return logColor[logType]
end