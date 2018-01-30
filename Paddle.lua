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

--[[
    Instantiate a new paddle object, assign it a position, and
    set which keys will move the paddle up and down.
    Its size and speed are inherited automatically.
]]
function Paddle:Create(posX, posY, keyUp, keyDown)
    newObject = {}
    setmetatable(newObject, self)
    self.__index = self
    newObject.posX = posX
    newObject.posY = posY
    newObject.keyUp = keyUp
    newObject.keyDown = keyDown
    return newObject
end

