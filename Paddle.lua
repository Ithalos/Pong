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
    if love.keyboard.isDown(self.keyUp) then
        self.posY = self.posY - self.speed * dt
        -- Top edge collision check
        if self.posY < 0 then
            self.posY = 0
        end
    elseif love.keyboard.isDown(self.keyDown) then
        self.posY = self.posY + self.speed * dt
        -- Bottom edge collision check
        if self.posY > WINDOW_HEIGHT - self.sizeY then
            self.posY = WINDOW_HEIGHT - self.sizeY
        end
    end
end

