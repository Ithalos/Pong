--[[
    File: main.lua
    Author: Sam Triest

    The main program.
]]

-- Dependencies
require "Entities/Paddle"
require "Entities/Ball"

-- Game window dimensions
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 900

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
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Set up some differently sized fonts
    smallFont = love.graphics.newFont(15)
    largeFont = love.graphics.newFont(30)
    scoreFont = love.graphics.newFont(50)

    -- Set the colour for drawing to white
    love.graphics.setColor(1, 1, 1, 1)

    --[[
        The gameState variable will hold the current state of the game,
        which is one of the following:

        main    -- The welcome screen
        ready   -- The ball is ready to be launched
        play    -- The ball is moving and the game is in progress
        done    -- A player has won, and the game can now be restarted
    ]]
    gameState = "main"

    -- Set the initial game mode
    gameMode = "solo"

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
    leftPlayer = Paddle:Create(leftStartPos.x, leftStartPos.y, "z", "s", true)
    secondaryPlayerSetup(gameMode)

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
        paddleHit = love.audio.newSource("Sounds/PaddleHit.wav", "static"),
        score = love.audio.newSource("Sounds/Score.wav", "static"),
        gameOver = love.audio.newSource("Sounds/GameOver.wav", "static")
    }

    -- Keep track of current keyboard layout (azerty/qwerty)
    keyMode = "azerty"
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

    -- Draw the players' scores on the screen
    drawScores()

    -- Render the paddles and ball on the screen every frame
    leftPlayer:Render()
    rightPlayer:Render()
    ball:Render()
end

--[[
    Polls for keyboard input.
]]
function love.keypressed(key)
    if gameState == "main" then
        if key == "return" then
            gameState = "ready"
            secondaryPlayerSetup(gameMode)
        elseif key == "down" then
            gameMode = "versus"
        elseif key == "up" then
            gameMode = "solo"
        end

        -- Toggle azerty/qwerty mode
        if key == "lctrl" then
            if keyMode == "azerty" then
                keyMode = "qwerty"
                leftPlayer = Paddle:Create(leftStartPos.x, leftStartPos.y, "w", "s", true)
            else
                keyMode = "azerty"
                leftPlayer = Paddle:Create(leftStartPos.x, leftStartPos.y, "z", "s", true)
            end
        end
    end

    if gameState == "ready" then
        if key == "space" then
            -- Serve towards the player who scored last
            ball:SetDirection(lastScoringPlayer)
            gameState = "play"
        end
    end

    -- Restart the game
    if gameState == "done" then
        if key == "return" then
            newGameSetup()
            gameState = "main"
        end
    end

    -- Quit the game
    if key == "escape" then
        love.event.quit()
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
            ball.dirX = -ball.dirX * 1.05
            ball.posX = leftPlayer.posX + leftPlayer.sizeX
            calculateBallAngle(leftPlayer)
            love.audio.play(sounds["paddleHit"])
        elseif ball:Collide(rightPlayer) then
            ball.dirX = -ball.dirX * 1.05
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

    if gameMode == "solo" then
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.printf("Solo", 0, WINDOW_HEIGHT / 10 * 6, WINDOW_WIDTH, "center")
    love.graphics.setColor(1, 1, 1, 1)

    if gameMode == "versus" then
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.printf("Versus", 0, WINDOW_HEIGHT / 10 * 7, WINDOW_WIDTH, "center")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(smallFont)
    love.graphics.printf("Press enter to start...", 0, WINDOW_HEIGHT / 10 * 9,
                         WINDOW_WIDTH, "center")

    love.graphics.printf("Left control: toggle azerty/qwerty", 50, 700, WINDOW_WIDTH, "left")
    love.graphics.printf("Left Player Keys:", 50, 730, WINDOW_WIDTH, "left")
    if keyMode == "azerty" then
        love.graphics.printf("Z S", 50, 760, WINDOW_WIDTH, "left")
    else
        love.graphics.printf("W S", 50, 760, WINDOW_WIDTH, "left")
    end
    love.graphics.printf("Right Player Keys:", 50, 790, WINDOW_WIDTH, "left")
    love.graphics.printf("Arrow Keys", 50, 820, WINDOW_WIDTH, "left")
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
    ball:SetDirection()
    lastScoringPlayer = ""
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

--[[
    Set up the second paddle. Make it human controllable if the gameMode is set
    to "versus", otherwise make it AI controlled.
]]
function secondaryPlayerSetup(gameMode)
    --[[
        If this is the first time the right paddle is created, set it up at the initial
        starting location, otherwise set it to the old paddle's location.
    ]]
    if gameMode == "solo" then
        if rightPlayer == nil then
            rightPlayer = Paddle:Create(rightStartPos.x, rightStartPos.y, "up", "down", false)
        else
            rightPlayer = Paddle:Create(rightPlayer.posX, rightPlayer.posY, "up", "down", false)
        end
    --[[
        Set the new right paddle's position to the position of the old paddle.
        Make sure the gameMode is set to "solo" in love.load(),
        otherwise this will throw an error.
    ]]
    else
        rightPlayer = Paddle:Create(rightPlayer.posX, rightPlayer.posY, "up", "down", true)
    end
end

