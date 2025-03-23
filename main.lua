function love.load()
    math.randomseed(os.time())
    require("resources")
    load_resources()
    CHARACTER_X_START = 10
    CHARACTER_Y_START = 325
    CHARACTER_X = CHARACTER_X_START
    CHARACTER_Y = CHARACTER_Y_START
    CHARACTER_Y_MAX_VALUE = -150
    CHARACTER_STATE = "walking"
    WALKING_ANIMATION = {WALKING0, WALKING1, WALKING2, WALKING3, WALKING4, WALKING5, WALKING6, WALKING7, WALKING8, WALKING9}
    JUMPING_ANIMATION = {JUMPING0, JUMPING1, JUMPING2, JUMPING3, JUMPING4, JUMPING5, JUMPING6, JUMPING7, JUMPING8}
    MORPHING_ANIMATION = {MORPHING0, MORPHING1, MORPHING2, MORPHING3, MORPHING4, MORPHING5, MORPHING6, MORPHING7, MORPHING8, MORPHING9, MORPHING10, MORPHING11}
    CRATERIA_LAYOUT = {CRATERIA0, CRATERIA1, CRATERIA2, CRATERIA3}
    LEVELS = {CRATERIA_LAYOUT}
    LAYOUT_1 = LEVELS[1][math.random(1,4)]
    LAYOUT_2 = LEVELS[1][math.random(1,4)]
    LAYOUT_POSITION_1 = 0
    LAYOUT_POSITION_2 = LEVELS[1][1]:getWidth()
    LAYOUT_SPEED = 5
    ACTUAL_FRAME = WALKING_ANIMATION[1]
    CURRENT_WALKING_ANIMATION = 1
    CURRENT_JUMPING_ANIMATION = 1
    CURRENT_MORPHING_ANIMATION = 1
    ANIMATION_TIME = 0
    ANIMATION_LENGTH_WALKING = 2/60
    ANIMATION_LENGTH_JUMPING = 4/60
    ANIMATION_LENGTH_MORPHING = 3/60
    ANIMATION_LENGTH_CROUCHING = 1/60
    JUMPING_DELAY = 2/60
    MORPHING_DELAY = 1/60
    DELAY_TIME = 0
    JUMPING_MINIMAL_TIME = 15/60
    JUMPING_TIME = 0
    TIME_IN_MAX_Y_VALUE = 0
    TIME_FALLING = 0
    CAN_JUMP = true
end

function love.keypressed(key)
    if key == "r" then
        CHARACTER_Y = CHARACTER_Y_START
    end
end

function love.update(dt)
    print(CHARACTER_Y, CHARACTER_STATE)
    if dt < 1/60 then
        love.timer.sleep(1/60 - dt)
    end
    if (CHARACTER_Y < CHARACTER_Y_START or CHARACTER_Y > CHARACTER_Y_START) and CHARACTER_STATE == "walking" then
        CHARACTER_Y = CHARACTER_Y_START
    end
    if CHARACTER_STATE == "jumping" then
        JUMPING_TIME = JUMPING_TIME + dt
    end
    if not CAN_JUMP and CHARACTER_Y <= CHARACTER_Y_START then
        TIME_FALLING = TIME_FALLING + dt
    end
    if love.keyboard.isDown("up") and CAN_JUMP then
        if CHARACTER_STATE == "morphing" then
            CHARACTER_STATE = "walking"
        else
            DELAY_TIME = DELAY_TIME + dt
            if DELAY_TIME >= JUMPING_DELAY then
                CHARACTER_STATE = "jumping"
                DELAY_TIME = 0
            end
            if CHARACTER_Y <= CHARACTER_Y_START and CHARACTER_Y >= 100 then
                CHARACTER_Y = CHARACTER_Y - 4
            elseif CHARACTER_Y <= 100 and CHARACTER_Y >= -20 then
                CHARACTER_Y = CHARACTER_Y - 3
            elseif CHARACTER_Y <= -20 and CHARACTER_Y >= -120 then
                CHARACTER_Y = CHARACTER_Y - 2
            elseif CHARACTER_Y <= -120 and CHARACTER_Y > CHARACTER_Y_MAX_VALUE then
                CHARACTER_Y = CHARACTER_Y - 1
            elseif CHARACTER_Y == CHARACTER_Y_MAX_VALUE then
                TIME_IN_MAX_Y_VALUE = TIME_IN_MAX_Y_VALUE + dt
            end
            if TIME_IN_MAX_Y_VALUE > 10/60 then
                CAN_JUMP = false
            end
        end
    else
        if JUMPING_TIME >= JUMPING_MINIMAL_TIME and CHARACTER_Y >= CHARACTER_Y_START then
            CHARACTER_STATE = "walking"
            CAN_JUMP = true
            TIME_IN_MAX_Y_VALUE = 0
            TIME_FALLING = 0
        elseif JUMPING_TIME >= JUMPING_MINIMAL_TIME and CHARACTER_Y <= CHARACTER_Y_START then
            CAN_JUMP = false
            if TIME_FALLING > 0 and TIME_FALLING <= 10/60 then
                CHARACTER_Y = CHARACTER_Y + 1
            elseif TIME_FALLING > 10/60 and TIME_FALLING <= 20/60 then
                CHARACTER_Y = CHARACTER_Y + 2
            elseif TIME_FALLING > 20/60 and TIME_FALLING <= 35/60 then
                CHARACTER_Y = CHARACTER_Y + 3
            else
                CHARACTER_Y = CHARACTER_Y + 4
            end
        end
    end
    if love.keyboard.isDown("down") then
        if CHARACTER_STATE == "walking" and DELAY_TIME >= MORPHING_DELAY then
            CHARACTER_STATE = "morphing"
            DELAY_TIME = 0
        elseif CHARACTER_STATE == "walking" then
            DELAY_TIME = DELAY_TIME + dt
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
        CURRENT_MORPHING_ANIMATION = 1
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
    elseif CHARACTER_STATE == "morphing" then
        ACTUAL_FRAME = MORPHING_ANIMATION[CURRENT_MORPHING_ANIMATION]
        if CURRENT_MORPHING_ANIMATION == 1 and ANIMATION_TIME >= ANIMATION_LENGTH_MORPHING then
            CURRENT_MORPHING_ANIMATION = 2
            ANIMATION_TIME = 0
        elseif CURRENT_MORPHING_ANIMATION == 2 and ANIMATION_TIME >= ANIMATION_LENGTH_CROUCHING then
            CURRENT_MORPHING_ANIMATION = 3
            ANIMATION_TIME = 0
        elseif CURRENT_MORPHING_ANIMATION == 3 or CURRENT_MORPHING_ANIMATION == 4 and ANIMATION_TIME >= ANIMATION_LENGTH_MORPHING then
            CURRENT_MORPHING_ANIMATION = CURRENT_MORPHING_ANIMATION + 1
            ANIMATION_TIME = 0
        elseif CURRENT_MORPHING_ANIMATION >= 5 and ANIMATION_TIME >= ANIMATION_LENGTH_MORPHING then
            CURRENT_MORPHING_ANIMATION = CURRENT_MORPHING_ANIMATION + 1
            ANIMATION_TIME = 0
            if CURRENT_MORPHING_ANIMATION > #MORPHING_ANIMATION then
                CURRENT_MORPHING_ANIMATION = 5
            end
        end
    end
    LAYOUT_POSITION_1 = (LAYOUT_POSITION_1 - LAYOUT_SPEED)
    if LAYOUT_POSITION_1 <= -LEVELS[1][1]:getWidth() then
        LAYOUT_POSITION_1 = LEVELS[1][1]:getWidth()
        LAYOUT_1 = LEVELS[1][math.random(1,4)]
    end
    LAYOUT_POSITION_2 = (LAYOUT_POSITION_2 - LAYOUT_SPEED)
    if LAYOUT_POSITION_2 <= -LEVELS[1][1]:getWidth() then
        LAYOUT_POSITION_2 = LEVELS[1][1]:getWidth()
        LAYOUT_2 = LEVELS[1][math.random(1,4)]
    end
end

function love.draw()
    love.graphics.draw(ACTUAL_FRAME,CHARACTER_X,CHARACTER_Y,0,0.75,0.75)
    love.graphics.draw(LAYOUT_1,LAYOUT_POSITION_1)
    love.graphics.draw(LAYOUT_2,LAYOUT_POSITION_2)
end