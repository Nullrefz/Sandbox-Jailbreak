function DrawBar(x, width, height, skew, divisions, prog, color, mat)
    local wide = width / divisions
    local progress = prog * divisions

    for i = 1, divisions do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((i - 1) * wide - skew + x, 0, (wide * fill) + skew / 2, height, skew, color, mat)
    end
end

function DrawBarInverse(x, y, width, height, skew, divisions, prog, color, mat)
    local wide = width / divisions
    local progress = prog * divisions

    for i = 1, divisions do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((divisions - i) * wide - skew + x + (1 - fill) * wide, y, (wide * fill) + skew / 2, height, skew, color, mat)
    end
end

function DrawProgressBar(x, y, width, height, skew, divisions, color, mat)
    local wide = width / (divisions - 2)
    local progress = divisions

    for i = 1, divisions do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((i - 1) * wide - skew + x + (CurTime() * 10) % wide - wide, y, (wide * fill) + skew / 2, height, skew, color, mat)
    end
end

function DrawCenterBar(x, y, width, height, skew, divisions, prog, color, mat)
    local wide = width / divisions
    local progress = prog * divisions

    for i = 1, divisions do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((i - 1) * wide - skew + x, y, (wide * fill) + skew / 2, height, skew, color, mat)
    end
end
