-- Pong для LÖVE2D

local W, H = 1280, 720

local pw, ph = 18, 130
local speed = 520
local ballSpeed = 520
local radius = 10

local left, right, ball
local p1, p2 = 0, 0

local running = false
local paused = false
local gameOver = false

local fontBig, fontSmall, fontControls
local sounds = {}

--------------------------------------------------
-- SOUND
--------------------------------------------------

local function makeSound(freq, duration)
    local rate = 44100
    local n = math.floor(rate * duration)

    local data = love.sound.newSoundData(n, rate, 16, 1)

    for i = 0, n - 1 do
        local t = i / rate
        local fade = 1 - i / n

        data:setSample(
            i,
            math.sin(2 * math.pi * freq * t) * 0.18 * fade
        )
    end

    return love.audio.newSource(data, "static")
end

local function sound(name)
    if sounds[name] then
        sounds[name]:stop()
        sounds[name]:play()
    end
end

--------------------------------------------------
-- BALL
--------------------------------------------------

local function resetBall(dir)
    ball.x = W / 2
    ball.y = H / 2

    ball.vx = ballSpeed * dir
    ball.vy = (love.math.random() - 0.5) * ballSpeed * 1.2
end

--------------------------------------------------
-- RESET GAME
--------------------------------------------------

local function resetGame()
    p1 = 0
    p2 = 0

    left = {
        x = 40,
        y = H / 2 - ph / 2
    }

    right = {
        x = W - 40 - pw,
        y = H / 2 - ph / 2
    }

    ball = {
        x = W / 2,
        y = H / 2
    }

    resetBall(love.math.random() < 0.5 and 1 or -1)

    running = false
    paused = false
    gameOver = false
end

--------------------------------------------------
-- COLLISION
--------------------------------------------------

local function hit(p)
    return ball.x - radius < p.x + pw
       and ball.x + radius > p.x
       and ball.y - radius < p.y + ph
       and ball.y + radius > p.y
end

--------------------------------------------------
-- LOAD
--------------------------------------------------

function love.load()

    love.window.setMode(W, H, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    love.window.setTitle("Pong")

    love.graphics.setBackgroundColor(
        0.067,
        0.067,
        0.067
    )

    -- Default LÖVE font.
    -- Only English text is used, so there will be no boxes.
    fontBig = love.graphics.newFont(52)
    fontSmall = love.graphics.newFont(20)
    fontControls = love.graphics.newFont(18)

    sounds.bounce = makeSound(520, 0.06)
    sounds.paddle = makeSound(700, 0.06)
    sounds.score = makeSound(260, 0.12)
    sounds.start = makeSound(880, 0.08)

    resetGame()
end

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function love.update(dt)

    if not running or paused or gameOver then
        return
    end

    -- Player 1: W / S
    if love.keyboard.isDown("w") then
        left.y = left.y - speed * dt
    end

    if love.keyboard.isDown("s") then
        left.y = left.y + speed * dt
    end

    -- Player 2: Arrow Up / Arrow Down
    if love.keyboard.isDown("up") then
        right.y = right.y - speed * dt
    end

    if love.keyboard.isDown("down") then
        right.y = right.y + speed * dt
    end

    -- Keep paddles inside the screen
    left.y = math.max(
        0,
        math.min(H - ph, left.y)
    )

    right.y = math.max(
        0,
        math.min(H - ph, right.y)
    )

    -- Move ball
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    --------------------------------------------------
    -- TOP / BOTTOM
    --------------------------------------------------

    if ball.y - radius <= 0 then

        ball.y = radius
        ball.vy = math.abs(ball.vy)

        sound("bounce")

    elseif ball.y + radius >= H then

        ball.y = H - radius
        ball.vy = -math.abs(ball.vy)

        sound("bounce")
    end

    --------------------------------------------------
    -- LEFT PADDLE
    --------------------------------------------------

    if ball.vx < 0 and hit(left) then

        ball.x = left.x + pw + radius

        ball.vx = math.abs(ball.vx) * 1.04

        ball.vy =
            ((ball.y - (left.y + ph / 2)) / (ph / 2))
            * ballSpeed

        sound("paddle")
    end

    --------------------------------------------------
    -- RIGHT PADDLE
    --------------------------------------------------

    if ball.vx > 0 and hit(right) then

        ball.x = right.x - radius

        ball.vx = -math.abs(ball.vx) * 1.04

        ball.vy =
            ((ball.y - (right.y + ph / 2)) / (ph / 2))
            * ballSpeed

        sound("paddle")
    end

    --------------------------------------------------
    -- SCORE
    --------------------------------------------------

    if ball.x < -radius then

        p2 = p2 + 1

        sound("score")

        resetBall(1)

    elseif ball.x > W + radius then

        p1 = p1 + 1

        sound("score")

        resetBall(-1)
    end

    --------------------------------------------------
    -- WIN
    --------------------------------------------------

    if p1 >= 10 or p2 >= 10 then

        running = false
        gameOver = true

    end
end

--------------------------------------------------
-- KEYBOARD
--------------------------------------------------

function love.keypressed(key)

    -- SPACE = START / PAUSE
    if key == "space" then

        if not gameOver then

            if not running then

                running = true
                paused = false

            else

                paused = not paused

            end

            sound("start")
        end

    -- R = RESTART
    elseif key == "r" then

        resetGame()

    -- ESC = EXIT
    elseif key == "escape" then

        love.event.quit()
    end
end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function love.draw()

    --------------------------------------------------
    -- SCORE
    --------------------------------------------------

    love.graphics.setFont(fontBig)

    love.graphics.printf(
        tostring(p1),
        0,
        35,
        W / 2 - 40,
        "right"
    )

    love.graphics.printf(
        tostring(p2),
        W / 2 + 40,
        35,
        W / 2 - 40,
        "left"
    )

    --------------------------------------------------
    -- CENTER LINE
    --------------------------------------------------

    love.graphics.setLineWidth(3)

    for y = 0, H, 30 do

        love.graphics.line(
            W / 2,
            y,
            W / 2,
            y + 15
        )
    end

    --------------------------------------------------
    -- PADDLES
    --------------------------------------------------

    love.graphics.rectangle(
        "fill",
        left.x,
        left.y,
        pw,
        ph
    )

    love.graphics.rectangle(
        "fill",
        right.x,
        right.y,
        pw,
        ph
    )

    --------------------------------------------------
    -- BALL
    --------------------------------------------------

    love.graphics.circle(
        "fill",
        ball.x,
        ball.y,
        radius
    )

    --------------------------------------------------
    -- MAIN MESSAGE
    --------------------------------------------------

    love.graphics.setFont(fontSmall)

    local msg

    if gameOver then

        if p1 >= 10 then
            msg = "PLAYER 1 WINS! Press R to restart"
        else
            msg = "PLAYER 2 WINS! Press R to restart"
        end

    elseif not running then

        msg = "Press SPACE to start"

    elseif paused then

        msg = "PAUSED - Press SPACE"

    else

        msg = "SPACE - Pause"
    end

    love.graphics.printf(
        msg,
        0,
        H - 105,
        W,
        "center"
    )

    --------------------------------------------------
    -- CONTROLS
    --------------------------------------------------

    love.graphics.setFont(fontControls)

    love.graphics.printf(
        "PLAYER 1: W / S    |    PLAYER 2: UP / DOWN",
        0,
        H - 65,
        W,
        "center"
    )

    love.graphics.printf(
        "SPACE - Start / Pause    |    R - Restart",
        0,
        H - 38,
        W,
        "center"
    )
end
