INTERPOLATION = {
    Linear = 1,
    SmoothStep = 2,
    SmootherStep = 3,
    SinLerp = 4,
    CosLerp = 5,
    Exponential = 6
}

local function GetInterpolationValue(t, interpolation)
    if interpolation == INTERPOLATION.SinLerp then
        return math.sin(t * math.pi * 0.5)
    elseif interpolation == INTERPOLATION.CosLerp then
        return 1 - math.cos(t * math.pi * 0.5)
    elseif interpolation == INTERPOLATION.Exponential then
        return t * t
    elseif interpolation == INTERPOLATION.SmoothStep then
        return t * t * (3 - 2 * t)
    elseif interpolation == INTERPOLATION.SmootherStep then
        return t * t * t * (t * (6 * t - 15) + 10)
    else
        return t
    end
end

function LerpFloat(pointA, pointB, time, callback, typeOfInterpolation, onComplete)
    local endTime = CurTime() + time

    hook.Add("Think", "DoALerp", function()
        local percentage = math.Clamp(1 - (endTime - CurTime()) / time, 0, 1)

        if percentage < 1 then
            callback(Lerp(GetInterpolationValue(percentage, typeOfInterpolation), pointA, pointB))
        else
            callback(Lerp(1, pointA, pointB))

            if onComplete then
                onComplete()
            end

            hook.Remove("Think", "DoALerp")
        end
    end)
end