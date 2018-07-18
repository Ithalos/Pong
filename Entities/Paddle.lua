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
    sizeY = 60,

    speed = 200,
    aiSpeed = 85,

    keyUp,
    keyDown,

    isPlayer
}

--[[
    Instantiate a new paddle object, assign it a position, and
    set which keys will move the paddle up and down.
    Its size and speed are inherited automatically.
]]
function Paddle:Create(posX, posY, keyUp, keyDown, isPlayer)
    newObject = {}
    setmetatable(newObject, self)
    self.__index = self
    newObject.posX = posX
    newObject.posY = posY
    newObject.keyUp = keyUp
    newObject.keyDown = keyDown
    newObject.isPlayer = isPlayer
    return newObject
end

--[[
    Draw the paddle that calls this method to the screen.
    This method should be called in love.draw().
]]
function Paddle:Render()
    love.graphics.rectangle("fill", self.posX, self.posY, self.sizeX, self.sizeY)
end

--[[
    Move the paddle by its speed when there is player input, multiplied by
    delta time, to ensure movement remains framerate independent.
    Stop the paddle from moving past the edges of the screen.
    This function should be called in love.update(dt).
]]
function Paddle:Move(dt)
    if self.isPlayer then
        if love.keyboard.isDown(self.keyUp) then
            self.posY = self.posY - self.speed * dt
        elseif love.keyboard.isDown(self.keyDown) then
            self.posY = self.posY + self.speed * dt
        end
    else
        -- Move AI paddle
        local offset = ball.posY - self.posY - self.sizeY / 2
        -- Clamp the offset, to smooth out AI movement
        if offset > 2 then
            offset = 2
        elseif offset < -2 then
            offset = -2
        end
        self.posY = self.posY + offset * self.aiSpeed * dt
    end
    -- Top edge collision check
    if self.posY < 0 then
        self.posY = 0
    end
    -- Bottom edge collision check
    if self.posY > WINDOW_HEIGHT - self.sizeY then
        self.posY = WINDOW_HEIGHT - self.sizeY
    end
end

