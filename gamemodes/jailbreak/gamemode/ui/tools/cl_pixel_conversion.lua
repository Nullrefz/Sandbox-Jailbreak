w = ScrW()
h = ScrH()

local widthRef = 1920
local hightRef = 1080

function toHRatio(pixel, ref)
    return pixel / widthRef * (ref and ref or w)
end

function toVRatio(pixel, ref)
    return pixel / hightRef * (ref and ref or h)
end