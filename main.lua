function love.load()
    WALKING0 = love.graphics.newImage("Resources/Walking/Walking0.png")
    WALKING1 = love.graphics.newImage("Resources/Walking/Walking1.png")
    WALKING2 = love.graphics.newImage("Resources/Walking/Walking2.png")
    WALKING3 = love.graphics.newImage("Resources/Walking/Walking3.png")
    WALKING4 = love.graphics.newImage("Resources/Walking/Walking4.png")
    WALKING5 = love.graphics.newImage("Resources/Walking/Walking5.png")
    WALKING6 = love.graphics.newImage("Resources/Walking/Walking6.png")
    WALKING7 = love.graphics.newImage("Resources/Walking/Walking7.png")
    WALKING8 = love.graphics.newImage("Resources/Walking/Walking8.png")
    WALKING9 = love.graphics.newImage("Resources/Walking/Walking9.png")
    WALKING_ANIMATION = {WALKING0, WALKING1, WALKING2, WALKING3, WALKING4, WALKING5, WALKING6, WALKING7, WALKING8, WALKING9}
    ACTUAL_FRAME = WALKING_ANIMATION[1]
    CURRENT_WALKING_ANIMATION = 1
    ANIMATION_TIME = 0
    ANIMATION_LENGTH = 2/60
end

-- function Walking_animation()
--     love.graphics.clear()
--     love.graphics.draw(WALKING0)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING1)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING2)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING3)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING4)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING5)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING6)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING7)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING8)
--     love.timer.sleep(0.5)
--     love.graphics.clear()
--     love.graphics.draw(WALKING9)
--     love.timer.sleep(0.5)
-- end

function love.update(dt)
    if dt < 1/60 then
        love.timer.sleep(1/60 - dt)
    end
    ANIMATION_TIME = ANIMATION_TIME + dt
    if ANIMATION_TIME >= ANIMATION_LENGTH then
        CURRENT_WALKING_ANIMATION = CURRENT_WALKING_ANIMATION + 1
        if CURRENT_WALKING_ANIMATION > #WALKING_ANIMATION then
            CURRENT_WALKING_ANIMATION = 1
        end
        ACTUAL_FRAME = WALKING_ANIMATION[CURRENT_WALKING_ANIMATION]
        ANIMATION_TIME = 0
        if ANIMATION_LENGTH == 2/60 then
            ANIMATION_LENGTH = 3/60
        else
            ANIMATION_LENGTH = 2/60
        end
    end
end

function love.draw()
    love.graphics.draw(ACTUAL_FRAME)
end