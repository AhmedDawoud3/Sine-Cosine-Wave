--[[
        Sine-Cosine Wave
    Auther: Ahmed Dawoud
    adawoud1000@hotmail.com

    Animation Shows Sine And Cosine waves and the relation
    to the unit vector.
]]

local Timer = require "knife.timer"
local Easing = require 'easing'
local suit = require 'suit'

function love.load()
    -- Load Suit and set its theme (GUI Buttons).
    Suit = suit.new()
    Suit.theme.color = {
        normal = {
            bg = {193 / 255, 193 / 255, 193 / 255},
            fg = {40 / 255, 44 / 255, 52 / 255}
        },
        hovered = {
            bg = {0, 96 / 255, 255},
            fg = {1, 1, 1}
        },
        active = {
            bg = {224 / 255, 90 / 255, 84 / 255},
            fg = {1, 1, 1}
        }
    }

    -- Load Fonts.
    fonts = {love.graphics.newFont("fonts/MontserratBold.ttf", 50),
             love.graphics.newFont("fonts/MontserratExtralight.ttf", 40),
             love.graphics.newFont("fonts/MontserratExtralightItalic.ttf", 50),
             love.graphics.newFont("fonts/MontserratItalic.ttf", 20),
             love.graphics.newFont("fonts/MontserratSemibold.ttf", 30)}
    love.graphics.setFont(fonts[2])

    -- Set Window properties.
    love.window.setMode(800, 800)
    love.window.setTitle("Sine-Cosine Wave")

    -- Set The default point size to 5px (For the points indicating the position of the vector).
    love.graphics.setPointSize(5)
    -- Set The initial angle to π/4.
    angle = math.atan2(-1, 1)
    if angle < 0 then
        angle = angle + math.pi * 2
    end

    -- Set The initial speed to One.
    speed = 1
    -- The X, Y for the Vector.
    y = 0
    x = 0
    --  The Radius of the Circle.
    r = 200
    -- Start motion after the drawing is completed.
    finishedTheInitialDrawing = false
    -- Set angle of the arc and the length of the vector in a table to tween them.
    vars = {
        angleArc = 0,
        len = 0
    }
    -- Indicates whether the Sine and Cosine follows the victor or the axis.
    WithVector = true

    -- a table containing the values of the points of Sine.
    sin = {}
    -- a table containing the values of the points of cosine.
    cos = {}
    -- Boolean indicating whether to draw sine or cosine or both.
    sine = true
    cosine = true
    -- When Starting, tweeen the arc to make a circle.
    Timer.tween(4, {
        [vars] = {
            angleArc = math.pi * 2
        }
    }):ease(Easing.outCirc):finish(function()
        -- When The arc is finished, tween the "len" variable to make the unit vector.
        Timer.tween(2, {
            [vars] = {
                len = 200
            }
        }):ease(Easing.outElastic):finish(function()
            finishedTheInitialDrawing = true
        end)
    end)
end

function love.update(dt)
    -- If the lenght of the sin table is above 1500, remove the first 2 elements from the table
    if #sin > 1500 then
        table.remove(sin, 1)
        table.remove(sin, 1)
    end
    -- If the lenght of the cos table is above 1500, remove the first 2 elements from the table
    if #cos > 1500 then
        table.remove(cos, 1)
        table.remove(cos, 1)
    end

    -- Update timer (for the Tweens).
    Timer.update(dt)

    -- Start moving the vector when the inital drawing is finished.
    if finishedTheInitialDrawing then
        -- set the new X, y for the vector as the angle variable.
        x = math.cos(angle - 0.01) * r
        y = math.sin(angle - 0.01) * r
        -- Change the angle acording to the speed.
        angle = angle - 0.01 * speed
        if angle < 0 then
            angle = angle + math.pi * 2
        end

        -- Insert ther sine, cosine values.
        -- with Sine, X is always 0.
        table.insert(sin, 0)
        table.insert(sin, y)
        -- with Cosine, Y is always 0.
        table.insert(cos, x)
        table.insert(cos, 0)
    end
    -- Loop over the sine values and change the X by "1" each frome to move it away from the vector.
    for i, v in ipairs(sin) do
        if i % 2 ~= 0 then
            sin[i] = v + 1
        end
    end
    -- Loop over the cosine values and change the Y by "1" each frome to move it away from the vector.
    for i, v in ipairs(cos) do
        if i % 2 == 0 then
            cos[i] = v + 1
        end
    end

    --[[
        Drawing GUI Buttons.
    ]]
    if Suit:Button('Sine', {
        font = fonts[5]
    }, 20, 700, 140, 50).hit then
        sine = true
        cosine = not sine
    end
    if Suit:Button('Cosine', {
        font = fonts[5]
    }, 20, 630, 140, 50).hit then
        sine = false
        cosine = not sine
    end
    if Suit:Button('Both', {
        font = fonts[5]
    }, 20, 560, 140, 50).hit then
        sine = true
        cosine = sine
    end

    if Suit:Button('Normal', {
        font = fonts[5]
    }, 640, 700, 140, 50).hit then
        speed = 1
    end
    if Suit:Button('Faster', {
        font = fonts[5]
    }, 640, 630, 140, 50).hit then
        if speed > 1 then
            speed = speed + 1
        else
            speed = speed * 2
        end
    end
    if Suit:Button('Slower', {
        font = fonts[5]
    }, 640, 560, 140, 50).hit then
        if speed > 1 then
            speed = speed - 1
        elseif speed > 0.125 then
            speed = speed / 2
        end
    end

    if Suit:Button('With The Axe', {
        font = fonts[5]
    }, 520, 20, 270, 50).hit then
        WithVector = false
    end
    if Suit:Button('With The Vector', {
        font = fonts[5]
    }, 520, 80, 270, 50).hit then
        WithVector = true
    end

end

function love.draw()
    love.graphics.clear(40 / 255, 48 / 255, 51 / 255)

    -- Translate the center to 400, 400.
    love.graphics.translate(400, 400)

    --[[
        The Arc.
    ]]
    love.graphics.setColor(255, 255, 255)
    love.graphics.arc("line", 0, 0, 200, 0, vars.angleArc)
    -- draw a line to hide the Arc's end.
    love.graphics.setColor(40 / 255, 48 / 255, 51 / 255, 1)
    love.graphics.setLineWidth(5)
    love.graphics.line(0, 0, math.cos(vars.angleArc) * 200, math.sin(vars.angleArc) * 200)
    love.graphics.setLineWidth(3)

    --[[
        The X, Y axis.
    ]]
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(-400, 0, 400, 0)
    love.graphics.line(0, -400, 0, 400)

    --[[
        Sine and Cosine Waves.
    ]]
    -- Check if sine is activated to draw it.
    if #sin >= 4 and sine then
        love.graphics.setColor(0, 96 / 255, 255)
        if WithVector then
            love.graphics.push()
            love.graphics.translate(math.cos(angle - 0.01) * r, 0)
            love.graphics.line(sin)
            love.graphics.pop()
        else
            love.graphics.line(sin)
        end
    end

    -- Check if cosine is activated to draw it.
    if #cos >= 4 and cosine then
        love.graphics.setColor(224 / 255, 90 / 255, 84 / 255)
        if WithVector then
            love.graphics.push()
            love.graphics.translate(0, math.sin(angle - 0.01) * r)
            love.graphics.line(cos)
            love.graphics.pop()
        else
            love.graphics.line(cos)
        end
    end

    --[[
        The Vector.
    ]]
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.arrow(0, 0, math.cos(angle) * vars.len, math.sin(angle) * vars.len, 20, .4)

    --[[
        Draw info to the screen
    ]]
    love.graphics.print(
        "Speed= " .. speed .. "\nSine    = " .. Round(math.sin(math.pi * 2 - angle), 3) .. "\nCosine= " ..
            Round(math.cos(math.pi * 2 - angle), 3) .. "\nAngle: " .. Round(360 - angle * 180 / 3.14159265359) .. "°",
        -390, -390)

    -- Credit :)
    love.graphics.print("Ahmed Dawoud", fonts[4], -400, -25)

    --[[
        The point at the end of the vector.
    ]]
    love.graphics.setColor(19 / 255, 158 / 255, 91 / 255)
    love.graphics.circle("fill", math.cos(angle) * vars.len, math.sin(angle) * vars.len, 4)
    love.graphics.translate(-400, -400)

    Suit:draw()
end

--[[
    A function to round numbers
]]
function Round(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function love.graphics.arrow(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.polygon('fill', x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle), x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
end

