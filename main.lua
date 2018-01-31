--[[
    File: main.lua
    Author: Sam Triest

    The main program.
]]

-- Dependencies
require "Paddle"
require "Ball"

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
end

--[[
    Draw on the screen every frame.
]]
function love.draw()
    if gameState == "main" then
        drawMain()
    end

    -- Render the paddles and ball on the screen every frame
    leftPlayer:Render()
    rightPlayer:Render()
    ball:Render()
end

--[[
    This function gets called every frame.
]]
function love.update(dt)
    -- Move the paddles when there is player input
    leftPlayer:Move(dt)
    rightPlayer:Move(dt)
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

