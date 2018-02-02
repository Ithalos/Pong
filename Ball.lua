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

--[[
    Move the ball's position by its direction, multiplied by delta time.
    This ensures its movement remains framerate independent. The speed of
    the ball can vary depending on its angle. It will move faster diagonally,
    as its movement is not normalized. This is intentional, to add some variation.
    Check for top and bottom collision as well. If the ball collides with the
    top or bottom edge, it will bounce with a small amount of random variation.
]]
function Ball:Move(dt)
    self.posX = self.posX + self.dirX * dt
    self.posY = self.posY + self.dirY * dt
    -- Top edge collision check
    if self.posY < 0 then
        self.posY = 0
        self.dirY = -self.dirY + love.math.random(-100, 100)
    -- Bottom edge collision check
    elseif self.posY > WINDOW_HEIGHT - self.sizeY then
        self.posY = WINDOW_HEIGHT - self.sizeY
        self.dirY = -self.dirY + love.math.random(-100, 100)
    end
end

--[[
    Check whether or not the ball has collided with the paddle.
]]
function Ball:Collide(paddle)
    if self.posX > paddle.posX + paddle.sizeX or
       self.posX + self.sizeX < paddle.posX then
        return false
    end
    if self.posY > paddle.posY + paddle.sizeY or
       self.posY + self.sizeY < paddle.posY then
        return false
    end

    return true
end

