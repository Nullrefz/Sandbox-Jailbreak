function DrawBar(offset, width, height, skew, divisions, prog, color, mat)
    local wide = width / divisions
    local progress = prog * divisions

    for i = 1, divisions do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((i - 1) * wide - skew + offset, 0, (wide * fill) + skew / 2, height, skew, color, mat)
    end
end

function DrawBarInverse(offset, y, width, height, skew, divisions, prog, color, mat)
    local wide = width / divisions
    local progress = prog * divisions

    for i = 1, divisions do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((divisions - i) * wide - skew + offset + (1 - fill) * wide, y, (wide * fill) + skew / 2, height, skew, color, mat)
    end
end
function DrawProgressBar(offset, y, width, height, skew, divisions, color, mat)
    local wide = width / (divisions - 2)
    local progress =  divisions

    for i = 1, divisions do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((i - 1) * wide - skew + offset + (CurTime() * 10) % wide  - wide, y, (wide * fill) + skew / 2, height, skew, color, mat)    end
end