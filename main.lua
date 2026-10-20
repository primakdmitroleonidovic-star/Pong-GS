if p1.score >= WIN or p2.score >= WIN then
        state = "done"
    else
        state = "serve"
    end
end

local function hit(p, direction)
    return ball.x + BR > p.x and ball.x - BR < p.x + PW
        and ball.y + BR > p.y and ball.y - BR < p.y + PH
        and ball.vx * direction < 0
end

function love.load()
    -- Keep the original small, minimal look.
    love.graphics.setDefaultFilter("nearest", "nearest")
    fontHello = love.graphics.newFont(11)
    fontScore = love.graphics.newFont(20)
    fontInfo = love.graphics.newFont(10)

    sounds.wall = makeSound(360, 0.045)
    sounds.paddle = makeSound(520, 0.055)
    sounds.score = makeSound(180, 0.12)

    newGame()
end

function love.update(dt)
    if state ~= "play" then return end

    if love.keyboard.isDown("w") then
        p1.y = p1.y - paddleSpeed * dt
    end
    if love.keyboard.isDown("s") then
        p1.y = p1.y + paddleSpeed * dt
    end
    if love.keyboard.isDown("up") then
        p2.y = p2.y - paddleSpeed * dt
    end
    if love.keyboard.isDown("down") then
        p2.y = p2.y + paddleSpeed * dt
    end

    p1.y = clamp(p1.y, 0, H - PH)
    p2.y = clamp(p2.y, 0, H - PH)

    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    if ball.y - BR <= 0 then
        ball.y = BR
        ball.vy = math.abs(ball.vy)
        beep("wall")
    elseif ball.y + BR >= H then
        ball.y = H - BR
        ball.vy = -math.abs(ball.vy)
        beep("wall")
    end

    if hit(p1, 1) then
        ball.x = p1.x + PW + BR
        ball.vx = math.abs(ball.vx) * 1.04
        ball.vy = ball.vy + ((ball.y - (p1.y + PH / 2)) / (PH / 2)) * 65
        beep("paddle")
    elseif hit(p2, -1) then
        ball.x = p2.x - BR
        ball.vx = -math.abs(ball.vx) * 1.04
        ball.vy = ball.vy + ((ball.y - (p2.y + PH / 2)) / (PH / 2)) * 65
        beep("paddle")
    end

    ball.vy = clamp(ball.vy, -280, 280)

    if ball.x + BR < 0 then
        scorePoint(2)
    elseif ball.x - BR > W then
        scorePoint(1)
    end
end

function love.keypressed(key)
    if key == "return" or key == "kpenter" then
        enterGame()
    elseif key == "space" or key == "escape" then
        pauseGame()
    elseif key == "r" then
        newGame()
    elseif key == "m" then
        soundOn = not soundOn
    end
end

function love.draw()
    -- Plain charcoal background, matching the reference image.
    love.graphics.clear(0.145, 0.169, 0.180, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fontHello)
    local title = "Hello Pong!"
    love.graphics.printf(title, 0, 9, W, "center")

    -- Small, simple white paddles and ball.
    love.graphics.rectangle("fill", p1.x, p1.y, PW, PH)
    love.graphics.rectangle("fill", p2.x, p2.y, PW, PH)
    love.graphics.rectangle("fill", math.floor(ball.x - BR), math.floor(ball.y - BR), BR * 2, BR * 2)

    -- The score appears only after the first point.
    if p1.score > 0 or p2.score > 0 then
        love.graphics.setFont(fontInfo)
        love.graphics.printf(tostring(p1.score) .. "   :   " .. tostring(p2.score),
            0, 28, W, "center")
    end

    if state == "start" then
        love.graphics.setFont(fontInfo)
        love.graphics.printf("PRESS ENTER TO START", 0, H - 22, W, "center")
    elseif state == "serve" then
        love.graphics.setFont(fontInfo)
        love.graphics.printf("PRESS ENTER TO SERVE", 0, H - 22, W, "center")
    elseif state == "paused" then
        love.graphics.setFont(fontInfo)
        love.graphics.printf("PAUSED  -  PRESS ENTER", 0, H - 22, W, "center")
    elseif state == "done" then
        love.graphics.setFont(fontInfo)
        local result = p1.score >= WIN and "PLAYER 1 WINS!  PRESS ENTER" or "PLAYER 2 WINS!  PRESS ENTER"
        love.graphics.printf(result, 0, H - 22, W, "center")
    end



