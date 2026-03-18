BASE_VELOCITY = 10
ALERT_THRESHOLD = 0.3
ALERT_MULTIPLIER = 1.5
DANGER_MULTIPLIER = 3
LIGHT_MULTIPLIER = 4
LEFT_SENSOR = 5
RIGHT_SENSOR = 20
FRONT_SENSOR = 1
BLACK_THRESHOLD = 0.6
LIGHT_THRESHOLD = 0.05
MAX_VELOCITY = 15

local state = {
    SAFE = "safe",
    ALERT = "alert",
    DANGER = "danger"
}

function init()
    robot.wheels.set_velocity(BASE_VELOCITY, BASE_VELOCITY)
end

function step()
    local velocities = controller()
    robot.wheels.set_velocity(velocities.left, velocities.right)
end

function reset()
end

function destroy()
end

function controller()
    local cmd = walk()
    cmd = followLight(cmd)
    cmd = avoid(cmd)
    cmd = stop(cmd)

    --Scaling to not exceed MAX_VELOCITY
    cmd = limitVelocity(cmd)
    return cmd
end

function checkLight()
    local left_light = robot.light[LEFT_SENSOR].value
    local right_light = robot.light[RIGHT_SENSOR].value
    local front_light = robot.light[FRONT_SENSOR].value

    local light = {
            left = left_light,
            right = right_light,
            front = front_light
        }

    return light
end

function checkProximity()
    local left_sum = 0
    local right_sum = 0
    local half = math.floor(#robot.proximity/2)
    for i=1,#robot.proximity do
        local value = robot.proximity[i].value
        if i <= half then
            left_sum = left_sum + value
        else
            right_sum = right_sum + value
        end
    end

    local proximity = {
        left_sum = left_sum,
        right_sum = right_sum
    }

    return proximity
end

function checkBlackSpot()
    for i=1,#robot.motor_ground do
        if robot.motor_ground[i].value <= BLACK_THRESHOLD then
            return true
        end
    end
    return false
end

function dangerState(proximity)
    local danger_level = math.max(proximity.left_sum, proximity.right_sum)
    if danger_level == 0 then 
        return state.SAFE
    elseif danger_level <= ALERT_THRESHOLD then
        return state.ALERT
    else
        return state.DANGER
    end
end

function walk()
    local v = BASE_VELOCITY
    local turn = robot.random.uniform(-5,5)
    return {
        left = v + turn,
        right = v - turn
    }
end

function followLight(cmd)
    local light = checkLight()

    if light.left <= LIGHT_THRESHOLD and light.right <= LIGHT_THRESHOLD then
        log("No light detected")
        return cmd
    else 
        local light_diff = light.right - light.left
        local left =  BASE_VELOCITY+LIGHT_MULTIPLIER * light_diff
        local right = BASE_VELOCITY-LIGHT_MULTIPLIER * light_diff

        return {
            left = left,
            right = right
        }
    end
end

function avoid(cmd)
    local proximity = checkProximity()
    local danger = dangerState(proximity)

    if danger == state.SAFE then
        return  {left = cmd.left, right = cmd.right}
    elseif danger == state.ALERT then
        return {
            left = cmd.left-proximity.right_sum*ALERT_MULTIPLIER,
            right = cmd.right-proximity.left_sum*ALERT_MULTIPLIER
        }
    else
        return {
        left = cmd.left-proximity.right_sum*DANGER_MULTIPLIER,
        right = cmd.right-proximity.left_sum*DANGER_MULTIPLIER
        }
    end
end

function stop(cmd)
    if checkBlackSpot() then
        return {left = 0, right = 0}
    else
        return cmd
    end 
end

function limitVelocity(cmd)
    local max_val = math.max(math.abs(cmd.left), math.abs(cmd.right))

    if max_val > MAX_VELOCITY then
        local scale = MAX_VELOCITY / max_val
        return {
            left = cmd.left * scale,
            right = cmd.right * scale
        }
    else
        return cmd
    end
end








