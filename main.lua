function love.load()
    require("resources")
    load_resources()
    CHARACTER_X = 10
    CHARACTER_Y = 320
    CHARACTER_STATE = "walking"
    WALKING_ANIMATION = {WALKING0, WALKING1, WALKING2, WALKING3, WALKING4, WALKING5, WALKING6, WALKING7, WALKING8, WALKING9}
    JUMPING_ANIMATION = {JUMPING0, JUMPING1, JUMPING2, JUMPING3, JUMPING4, JUMPING5, JUMPING6, JUMPING7, JUMPING8}
    ACTUAL_FRAME = WALKING_ANIMATION[1]
    CURRENT_WALKING_ANIMATION = 1
    CURRENT_JUMPING_ANIMATION = 1
    ANIMATION_TIME = 0
    ANIMATION_LENGTH_WALKING = 2/60
    ANIMATION_LENGTH_JUMPING = 4/60
    JUMPING_DELAY = 2/60
    DELAY_TIME = 0
    JUMPING_MINIMAL_TIME = 15/60
    JUMPING_TIME = 0
end

function love.update(dt)
    if dt < 1/60 then
        love.timer.sleep(1/60 - dt)
    end
    if CHARACTER_STATE == "jumping" then
        JUMPING_TIME = JUMPING_TIME + dt
    end
    if love.keyboard.isDown("up")then
        DELAY_TIME = DELAY_TIME + dt
        if DELAY_TIME >= JUMPING_DELAY then
            CHARACTER_STATE = "jumping"
            DELAY_TIME = 0
        end
    else
        if JUMPING_TIME >= JUMPING_MINIMAL_TIME then
            CHARACTER_STATE = "walking"
        end
    end
    ANIMATION_TIME = ANIMATION_TIME + dt
    if CHARACTER_STATE == "walking" then
        if ANIMATION_TIME >= ANIMATION_LENGTH_WALKING then
            CURRENT_WALKING_ANIMATION = CURRENT_WALKING_ANIMATION + 1
            if CURRENT_WALKING_ANIMATION > #WALKING_ANIMATION then
                CURRENT_WALKING_ANIMATION = 1
            end
            ACTUAL_FRAME = WALKING_ANIMATION[CURRENT_WALKING_ANIMATION]
            ANIMATION_TIME = 0
            if ANIMATION_LENGTH_WALKING == 2/60 then
                ANIMATION_LENGTH_WALKING = 3/60
            else
                ANIMATION_LENGTH_WALKING = 2/60
            end
        end
        CURRENT_JUMPING_ANIMATION = 1
        ANIMATION_LENGTH_JUMPING = 4/60
        JUMPING_TIME = 0
    elseif CHARACTER_STATE == "jumping" then
        if ANIMATION_TIME >= ANIMATION_LENGTH_JUMPING then
            CURRENT_JUMPING_ANIMATION = CURRENT_JUMPING_ANIMATION + 1
            if CURRENT_JUMPING_ANIMATION > #JUMPING_ANIMATION then
                CURRENT_JUMPING_ANIMATION = 2
            end
            ACTUAL_FRAME = JUMPING_ANIMATION[CURRENT_JUMPING_ANIMATION]
            ANIMATION_TIME = 0
            if ANIMATION_LENGTH_JUMPING == 4/60 or ANIMATION_LENGTH_JUMPING == 2/60 then
                ANIMATION_LENGTH_JUMPING = 3/60
            else
                ANIMATION_LENGTH_JUMPING = 2/60
            end
        end
    end
end

function love.draw()
    love.graphics.draw(ACTUAL_FRAME,CHARACTER_X,CHARACTER_Y)
end