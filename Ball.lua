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
    Set the ball's new direction. If a player scored, the ball's launch
    direction will be towards him on the next serve, otherwise it will be random.
]]
function Ball:SetDirection(lastScoringPlayer)
    -- Set the horizontal direction
    if lastScoringPlayer == "left" then
        self.dirX = -self.launchSpeed
    elseif lastScoringPlayer == "right" then
        self.dirX = self.launchSpeed
    else
        -- Random direction
        if love.math.random(0, 1) == 1 then
            self.dirX = -self.launchSpeed
        else
            self.dirX = self.launchSpeed
        end
    end
    -- Set the vertical direction
    self.dirY = love.math.random(-self.launchSpeed, self.launchSpeed) / 2
end

--[[
    Reset the ball to the middle of the screen.
]]
function Ball:ResetPos(startPos)
    self.posX = startPos.x
    self.posY = startPos.y
end

