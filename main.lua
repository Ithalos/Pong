--[[
    File: main.lua
    Author: Sam Triest

    The main program.
]]

-- Dependencies
require "Paddle"
require "Ball"

-- Game window dimensions
WINDOW_WIDTH = 720
WINDOW_HEIGHT = 480

--[[
    Initial program setup.
]]
function love.load()
    -- Set the display mode and properties of the game window
    love.window.setMode(
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = false
        })

    -- Set the window title
    love.window.setTitle("Pong")

    -- Set a grey background colour
    love.graphics.setBackgroundColor(25, 25, 25)

    -- Set up some differently sized fonts
    smallFont = love.graphics.newFont(15)
    largeFont = love.graphics.newFont(30)
    scoreFont = love.graphics.newFont(50)

    -- Set the colour for drawing to white
    love.graphics.setColor(255, 255, 255, 255)

    --[[
        The gameState variable will hold the current state of the game,
        which is one of the following:

        main    -- The welcome screen
        ready   -- The ball is ready to be launched
        play    -- The ball is moving and the game is in progress
        done    -- A player has won, and the game can now be restarted
    ]]
    gameState = "main"

    -- Set the original paddle starting positions
    leftStartPos =
    {
        x = Paddle.sizeX,
        y = Paddle.sizeY
    }
    rightStartPos =
    {
        x = WINDOW_WIDTH - Paddle.sizeX * 2,
        y = WINDOW_HEIGHT - Paddle.sizeY * 2
    }

    -- Create the paddles that will represent the players
    leftPlayer = Paddle:Create(leftStartPos.x, leftStartPos.y, "z", "s")
    rightPlayer = Paddle:Create(rightStartPos.x, rightStartPos.y, "up", "down")

    -- Keep track of the players' scores
    leftPlayerScore = 0
    rightPlayerScore = 0

    -- Keep track of which player scored last, if any
    lastScoringPlayer = ""

    -- Set the original ball starting position to the middle of the screen
    ballStartPos =
    {
        x = (WINDOW_WIDTH / 2) - (Ball.sizeX / 2),
        y = (WINDOW_HEIGHT / 2) - (Ball.sizeY / 2)
    }

    -- Create the ball that the players must deflect
    ball = Ball:Create(ballStartPos.x, ballStartPos.y)

    -- Give the ball a random starting direction
    ball:SetDirection()

    -- Set master volume and load sounds into memory
    love.audio.setVolume(0.20)
    sounds =
    {
        paddleHit = love.audio.newSource("sounds/PaddleHit.wav", "static"),
        score = love.audio.newSource("sounds/Score.wav", "static"),
        gameOver = love.audio.newSource("sounds/GameOver.wav", "static")
    }
end

--[[
    Draw on the screen every frame.
]]
function love.draw()
    if gameState == "main" then
        drawMain()
    elseif gameState == "ready" then
        drawReady()
    elseif gameState == "done" then
        drawDone(lastScoringPlayer)
    end

    -- Render the paddles and ball on the screen every frame
    leftPlayer:Render()
    rightPlayer:Render()
    ball:Render()

    -- Draw the players' scores on the screen
    drawScores()
end

--[[
    Polls for keyboard input.
]]
function love.keypressed(key)
    if gameState == "main" then
        if key == "return" then
            gameState = "ready"
        end
    end

    if gameState == "ready" then
        if key == "space" then
            -- Serve towards the player who scored last
            ball:SetDirection(lastScoringPlayer)
            gameState = "play"
        end
    end

    if gameState == "done" then
        if key == "return" then
            newGameSetup()
            gameState = "main"
        end
    end
end

--[[
    This function gets called every frame.
]]
function love.update(dt)
    -- Move the paddles when there is player input
    leftPlayer:Move(dt)
    rightPlayer:Move(dt)

    if gameState == "play" then
        ball:Move(dt)

        -- Check left edge collision
        if ball.posX < 0 then
            playerScored("right")
        -- Check right edge collision
        elseif ball.posX > WINDOW_WIDTH - ball.sizeX then
            playerScored("left")
        end

        -- Check paddle collision with ball
        if ball:Collide(leftPlayer) then
            ball.dirX = -ball.dirX
            ball.posX = leftPlayer.posX + leftPlayer.sizeX
            calculateBallAngle(leftPlayer)
            love.audio.play(sounds["paddleHit"])
        elseif ball:Collide(rightPlayer) then
            ball.dirX = -ball.dirX
            ball.posX = rightPlayer.posX - ball.sizeX
            calculateBallAngle(rightPlayer)
            love.audio.play(sounds["paddleHit"])
        end
    end
end

--[[
    Draw the welcome screen. This function should be called in love.draw().
]]
function drawMain()
    love.graphics.setFont(largeFont)
    love.graphics.printf("Welcome to Pong!", 0, WINDOW_HEIGHT / 4 * 1,
                         WINDOW_WIDTH, "center")

    love.graphics.setFont(smallFont)
    love.graphics.printf("Press enter to start...", 0, WINDOW_HEIGHT / 4 * 3,
                         WINDOW_WIDTH, "center")
end

--[[
    Draw the ready screen. This function should be called in love.draw().
]]
function drawReady()
    love.graphics.setFont(largeFont)
    love.graphics.printf("Ready to serve!", 0, WINDOW_HEIGHT / 4 * 1,
                         WINDOW_WIDTH, "center")

    love.graphics.setFont(smallFont)
    love.graphics.printf("Press space to launch...", 0, WINDOW_HEIGHT / 4 * 3,
                         WINDOW_WIDTH, "center")
end

--[[
    Draw the game over screen, showing who won and who lost.
]]
function drawDone(winner)
    if winner == "left" then
        leftText = "You win!"
        rightText = "You lose!"
    else
        leftText = "You lose!"
        rightText = "You win!"
    end

    love.graphics.setFont(largeFont)
    love.graphics.printf(leftText, 0, WINDOW_HEIGHT / 2,
                         WINDOW_WIDTH / 8 * 3, "right")
    love.graphics.printf(rightText, WINDOW_WIDTH / 8 * 5, WINDOW_HEIGHT / 2,
                         WINDOW_WIDTH, "left")

    love.graphics.setFont(smallFont)
    love.graphics.printf("Press enter to restart...", 0, WINDOW_HEIGHT / 5 * 4,
                         WINDOW_WIDTH, "center")
end

--[[
    Draw the players' scores to the screen.
    This function should be called in love.draw()
]]
function drawScores()
    love.graphics.setFont(scoreFont)
    love.graphics.printf(leftPlayerScore, WINDOW_WIDTH / 6,
                         WINDOW_HEIGHT / 10, WINDOW_WIDTH / 2, "center")
    love.graphics.printf(rightPlayerScore, WINDOW_WIDTH / 2,
                         WINDOW_HEIGHT / 10, WINDOW_WIDTH / 6, "center")
end

--[[
    This function is called any time a player scores.
]]
function playerScored(player)
    love.audio.play(sounds["score"])
    lastScoringPlayer = player

    if player == "left" then
        leftPlayerScore = leftPlayerScore + 1
    elseif player == "right" then
        rightPlayerScore = rightPlayerScore + 1
    end

    if leftPlayerScore > 10 or rightPlayerScore > 10 then
        gameState = "done"
        love.audio.play(sounds["gameOver"])
    else
        ball:ResetPos(ballStartPos)
        gameState = "ready"
    end
end

--[[
    Reset the game state to allow a new game to begin.
]]
function newGameSetup()
    ball:ResetPos(ballStartPos)
    lastScoringPlayer = ""
    ball:SetDirection()
    leftPlayerScore = 0
    rightPlayerScore = 0
end

--[[
    When the ball collides with a paddle, check whether it hits the top or bottom
    half, then give it an additional, slightly randomised, push in that direction.
    If it hits in the middle of the paddle, do nothing.
]]
function calculateBallAngle(paddle)
    if ball.posY + ball.sizeY < paddle.posY + (paddle.sizeY / 2) then
        ball.dirY = ball.dirY + love.math.random(-10, -150)
    elseif ball.posY > paddle.posY + (paddle.sizeY / 2 )  then
        ball.dirY = ball.dirY + love.math.random(10, 150)
    end
end

