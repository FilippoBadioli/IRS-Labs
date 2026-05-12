---@diagnostic disable: lowercase-global
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

local proximity_state = {
    SAFE = "safe",
    ALERT = "alert",
    DANGER = "danger"
}

local light_state = {
    NO_LIGHT = "no_light",
    LIGHT = "light"
}

local spot_state = {
    ON_SPOT = "on_spot",
    NOT_ON_SPOT = "not_on_spot"
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


-- Sensors checking functions
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

function checkGround()
    local ground = {}
    for i=1,#robot.motor_ground do
        ground[i] = robot.motor_ground[i].value
    end
    return ground
end


-- FSM functions
function dangerState(proximity)
    local danger_level = math.max(proximity.left_sum, proximity.right_sum)
    if danger_level == 0 then 
        return proximity_state.SAFE
    elseif danger_level <= ALERT_THRESHOLD then
        return proximity_state.ALERT
    else
        return proximity_state.DANGER
    end
end

function lightState(light)
    if light.left <= LIGHT_THRESHOLD and light.right <= LIGHT_THRESHOLD then
        return light_state.NO_LIGHT
    end
    return light_state.LIGHT
end

function spotState(ground)
    for i=1,#ground do
        if ground[i] <= BLACK_THRESHOLD then
            return spot_state.ON_SPOT
        end
    end
    return spot_state.NOT_ON_SPOT
end


-- Behaviour functions
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
    local is_light = lightState(light)

    if is_light == light_state.NO_LIGHT then
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

    if danger == proximity_state.SAFE then
        return  {left = cmd.left, right = cmd.right}
    elseif danger == proximity_state.ALERT then
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
    ground = checkGround()
    isSpot = spotState(ground)
    if isSpot == spot_state.ON_SPOT then
        return {left = 0, right = 0}
    else
        return cmd
    end 
end


-- Scaling velocity function
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








