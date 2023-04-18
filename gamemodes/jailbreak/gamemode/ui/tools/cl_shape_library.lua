local CurTime = CurTime
local table = table
local surface = surface
local math = math
local Color = Color
local IsValid = IsValid
module("draw")

-- function for creating circles xD
local function MakeCircle(tbl, x, y, radius, seg, angle, shift)
    if not seg then
        seg = 32
    end

    if not angle then
        angle = 360
    end

    if not shift then
        shift = 0
    end

    for i = 0, seg do
        local a = math.rad((i / seg) * -angle + shift)

        table.insert(tbl, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        })
    end
end

-- function for creating an arc xD
function MakeArc(tbl, x, y, radius, seg, angle, shift)
    if not seg then
        seg = 32
    end

    if not angle then
        angle = 360
    end

    if not shift then
        shift = 0
    end

    for i = 0, seg do
        local a = math.rad((i / seg) * -angle + shift)

        table.insert(tbl, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        })
    end
end

function ChamferedBox(...)
    local rBox = {}
    local x, y, width, height, radius, color, material, seg = ... -- x and y are the center of the box.

    if not seg then
        seg = 64
    end

    local shortEdge = 0

    if width >= height then
        shortEdge = height
    else
        shortEdge = width
    end

    if radius >= (shortEdge / 2) then
        radius = shortEdge / 2
    end

    MakeCircle(rBox, x - width / 2 + radius, y - height / 2 + radius, radius, seg / 4, 90, 270)
    MakeCircle(rBox, x + width / 2 - radius, y - height / 2 + radius, radius, seg / 4, 90, 180)
    MakeCircle(rBox, x + width / 2 - radius, y + height / 2 - radius, radius, seg / 4, 90, 90)
    MakeCircle(rBox, x - width / 2 + radius, y + height / 2 - radius, radius, seg / 4, 90, 0)
    surface.SetDrawColor(color)

    if material then
        surface.SetMaterial(material)
    else
        NoTexture()
    end

    surface.DrawPoly(rBox)
    NoTexture()
end

function ChamferedBoxOutlined(x, y, width, height, radius, outline, color, outlineColor, material, seg)
    ChamferedBox(x, y, width, height, radius, outlineColor, material, seg)
    ChamferedBox(x, y, width - outline * 4, height - outline * 4, radius - outline * 4, color, material, seg)
end

function DrawOutline(posX, posY, width, height, radius, outline, color)
    local x = posX - width / 2
    local y = posY - height / 2
    local angle = 180

    for i = 0, 1 do
        for j = 0, 1 do
            DrawArc(x + radius + ((width - radius * 2) * j), y + radius + ((height - radius * 2) * i), radius, radius - outline, 90, angle + (i * 180), color)
            Drawrect((x + radius) * (1 - i) + ((x + (width - outline) * j) * i), (y + (height - outline) * j) * (1 - i) + (y + radius) * i, (width - radius * 2) * (1 - i) + outline * i, outline * (1 - i) + ((height - radius * 2) * i), color)
            angle = angle - 90 + (i * 180)
        end

        angle = 90
    end
end

function CapsuleBoxOutline(x, y, width, height, angle, rot, anchor, color, material, outline, outlineColor)
    CapsuleBox(x, y, width, height, angle, rot, anchor, outlineColor, material)
    x = x + outline / 2
    width = width - outline
    y = y + outline
    height = height - outline
    CapsuleBox(x, y, width, height, angle, rot, anchor, color, material)
end

function CapsuleBox(x, y, width, height, angle, rot, anchor, color, material)
    local circle = {}
    local radius = 0
    local type = 2
    local segment = math.ceil(32)
    y = y + height

    if anchor == nil then
        anchor = 0
    end

    if width == 0 then
        radius = height
    else
        radius = height / 2
    end

    if color == nil then
        color = Color(255, 255, 255, 200)
    end

    if angle == nil then
        angle = 360
    end

    if rot == nil then
        rot = 0
    end

    local r = math.rad(rot - 180)
    local pi2 = math.pi / 2
    width = width - radius * 2

    for i = 0, segment do
        local rad = math.rad((i / segment) * -angle / type)
        local r = math.rad(-rot)

        table.insert(circle, {
            x = x + math.sin(rad + r + pi2) * radius + (anchor - radius) * math.sin(r),
            y = y + math.cos(rad + r + pi2) * radius + (anchor - radius) * math.cos(r),
            u = math.sin(rad) / 2 + 0.5,
            v = math.cos(rad) / 2 + 0.5
        })
    end

    for i = 0, segment do
        local rad = math.rad((i / segment) * -angle / type)

        table.insert(circle, {
            x = x + math.sin(rad - r + pi2) * radius + (width - anchor + radius) * math.sin(-r),
            y = y + math.cos(rad - r + pi2) * radius + (width - anchor + radius) * math.cos(-r)
        })
    end

    if IsValid(material) then
        surface.SetMaterial(material)
    end

    surface.SetDrawColor(color)
    surface.DrawPoly(circle)
    NoTexture()
end

function DrawArc(x, y, radius1, radius2, rot, angle, color, material)
    local arc = {}
    local iteration = 1

    if color == nil then
        color = Color(0, 0, 0, 220)
    end

    local t = 0

    for i = 0, rot - iteration, iteration do
        rad = math.rad(i + angle)
        local rad2 = math.rad(i + iteration + angle)
        local temp = {}
        t = i

        table.insert(temp, {
            x = x + math.sin(rad) * radius2,
            y = y + math.cos(rad) * radius2,
            u = math.sin(rad) * radius2,
            v = math.cos(rad) * radius2
        })

        table.insert(temp, {
            x = x + math.sin(rad2) * radius2,
            y = y + math.cos(rad2) * radius2,
            u = math.sin(rad2) / 2 + 0.5,
            v = math.cos(rad2) / 2 + 0.5
        })

        table.insert(temp, {
            x = x + math.sin(rad2) * radius1,
            y = y + math.cos(rad2) * radius1,
            u = math.sin(rad2) / 2 + 0.5,
            v = math.cos(rad2) / 2 + 0.5
        })

        table.insert(temp, {
            x = x + math.sin(rad) * radius1,
            y = y + math.cos(rad) * radius1,
            u = math.sin(rad) / 2 + 0.5,
            v = math.cos(rad) / 2 + 0.5
        })

        table.insert(arc, temp)
    end

    if rot ~= 0 then
        local temp2 = {}
        local radbase = math.rad(rot + angle)
        local radbase2 = math.rad(t + iteration + angle)

        table.insert(temp2, {
            x = x + math.sin(radbase) * radius2,
            y = y + math.cos(radbase) * radius2,
            u = math.sin(radbase) / 2 + 0.5,
            v = math.cos(radbase) / 2 + 0.5
        })

        table.insert(temp2, {
            x = x + math.sin(radbase2) * radius2,
            y = y + math.cos(radbase2) * radius2,
            u = math.sin(radbase2) / 2 + 0.5,
            v = math.cos(radbase2) / 2 + 0.5
        })

        table.insert(temp2, {
            x = x + math.sin(radbase2) * radius1,
            y = y + math.cos(radbase2) * radius1,
            u = math.sin(radbase2) / 2 + 0.5,
            v = math.cos(radbase2) / 2 + 0.5
        })

        table.insert(temp2, {
            x = x + math.sin(radbase) * radius1,
            y = y + math.cos(radbase) * radius1,
            u = math.sin(radbase) / 2 + 0.5,
            v = math.cos(radbase) / 2 + 0.5
        })

        table.insert(arc, temp2)
    end

    for i = 0, table.Count(arc) - 1 do
        if material then
            surface.SetMaterial(material)
        end

        surface.SetDrawColor(color)
        surface.DrawPoly(arc[i + 1])
    end
end

function DrawRect(x, y, width, height, color, material)
    NoTexture()
    local coord = {}

    table.insert(coord, {
        x = x,
        y = y,
        u = 0,
        v = 0
    })

    table.insert(coord, {
        x = x + width,
        y = y,
        u = 1,
        v = 0
    })

    table.insert(coord, {
        x = x + width,
        y = y + height,
        u = 1,
        v = 1
    })

    table.insert(coord, {
        x = x,
        y = y + height,
        u = 0,
        v = 1
    })

    if material then
        surface.SetMaterial(material)
    end

    if color then
        surface.SetDrawColor(color)
    else
        color = Color(0, 0, 0, 100)
    end

    surface.DrawPoly(coord)
    NoTexture()
end

function DrawSkewedRect(x, y, width, height, skew, color, material)
    NoTexture()
    local coord = {}

    table.insert(coord, {
        x = x + skew,
        y = y,
        u = 0,
        v = 0
    })

    table.insert(coord, {
        x = x + width,
        y = y,
        u = 1,
        v = 0
    })

    table.insert(coord, {
        x = x + width - skew,
        y = y + height,
        u = 1,
        v = 1
    })

    table.insert(coord, {
        x = x,
        y = y + height,
        u = 0,
        v = 1
    })

    if material then
        surface.SetMaterial(material)
    end

    if color then
        surface.SetDrawColor(color)
    else
        color = Color(0, 0, 0, 100)
    end

    surface.DrawPoly(coord)
    NoTexture()
end

local function MakeSkewedCircle(tbl, x, y, radius, seg, angle, shift, skew)
    if not seg then
        seg = 32
    end

    if not angle then
        angle = 360
    end

    if not shift then
        shift = 0
    end

    for i = 0, seg do
        local a = math.rad((i / seg) * -angle + shift)

        table.insert(tbl, {
            x = x + math.sin(a) * radius + math.cos(a) * skew,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        })
    end
end

function SkweredChamferedBox(...)
    local rBox = {}
    local x, y, width, height, radius, skew, color, material, seg = ... -- x and y are the center of the box.

    if not seg then
        seg = 64
    end

    x = math.Round(x)
    y = math.Round(y)
    width = math.Round(width)
    height = math.Round(height)
    radius = math.Round(radius)
    local shortEdge = 0

    if width >= height then
        shortEdge = height
    else
        shortEdge = width
    end

    if radius >= (shortEdge / 2) then
        radius = shortEdge / 2
    end

    MakeSkewedCircle(rBox, x  + radius + skew * 2, y - height / 2 + radius, radius, seg / 4, 90, 270, -radius)
    MakeSkewedCircle(rBox, x + width - radius , y - height / 2 + radius, radius, seg / 4, 90, 180, radius)
    MakeSkewedCircle(rBox, x + width - radius - skew * 2, y + height / 2 - radius, radius, seg / 4, 90, 90, -radius)
    MakeSkewedCircle(rBox, x + radius, y + height / 2 - radius, radius, seg / 4, 90, 0, radius )
    surface.SetDrawColor(color)

    if material then
        surface.SetMaterial(material)
    else
        NoTexture()
    end

    surface.DrawPoly(rBox)
    NoTexture()
end