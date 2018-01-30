--[[
    File: main.lua
    Author: Sam Triest

    The main program.
]]

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
end

