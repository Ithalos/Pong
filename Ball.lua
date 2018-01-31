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

    sizeX = 8,
    sizeY = 8,

    launchSpeed = 200,

    dirX,
    dirY
}

--[[
    Instantiate a new ball object and assign it a position and size.
]]
function Ball:Create(posX, posY)
    newObject = {}
    setmetatable(newObject, self)
    self.__index = self
    newObject.posX = posX
    newObject.posY = posY
    return newObject
end

--[[
    Draw the ball that calls this method to the screen.
    This method should be called in love.draw().
]]
function Ball:Render()
    love.graphics.rectangle("fill", self.posX, self.posY, self.sizeX, self.sizeY)
end

--[[
    Reset the ball to the middle of the screen.
]]
function Ball:ResetPos(startPos)
    self.posX = startPos.x
    self.posY = startPos.y
end

