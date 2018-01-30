--[[
    File: Paddle.lua
    Author: Sam Triest

    The Paddle class allows for the creation of paddle objects,
    each of which represents a player in the game.
]]

Paddle =
{
    posX,
    posY,

    sizeX = 20,
    sizeY = 50,

    speed = 200,

    keyUp,
    keyDown
}

