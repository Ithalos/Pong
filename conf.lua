-- Disable unnecessary modules to reduce memory usage
function love.conf(t)
    t.modules.joystick = false
    t.modules.physics  = false
    t.modules.touch    = false

    t.accelerometerjoystick = false
end

