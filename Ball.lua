--[[
    File: Ball.lua
    Author: Sam Triest

    The Ball class allows for the creation of the ball object
    that the players must deflect.
]]

Ball =
{
    posX,
    posY,

    sizeX,
    sizeY,

    dirX,
    dirY
}

--[[
    Instantiate a new ball object and assign it a position and size.
]]
function Ball:Create(posX, posY, sizeX, sizeY)
    newObject = {}
    setmetatable(newObject, self)
    self.__index = self
    newObject.posX = posX
    newObject.posY = posY
    newObject.sizeX = sizeX
    newObject.sizeY = sizeY
    return newObject
end

