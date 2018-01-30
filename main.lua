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
    -- Set the display mode and properties of the game window.
    love.window.setMode(
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = false
        })
end

