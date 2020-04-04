function SecondsToMinutes(number)
    local minutes = math.floor(number / 60)
    local seconds = math.floor(number) % 60

    return minutes .. ":" .. (seconds < 10 and "0" .. seconds or seconds)
end

function SecondsInTime(time)
    return math.floor(time) % 60
end

function MinutesInTime(time)
    return math.floor(time / 60)
end