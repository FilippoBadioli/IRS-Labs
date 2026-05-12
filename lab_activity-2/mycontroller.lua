-- Put your global variables here

BASE_VELOCITY = 8
LEFT_SENSOR = 5
RIGHT_SENSOR = 20
FRONT_SENSOR = 1
K = 15 --Velocity gain modifier for light
K2 = 10 --Velocity gain modifier for obstacles
PROXIMITY_THRESHOLD = 0.05 --Threshold for considering an obstacle in the way
STOP_THRESHOLD = 0.45 --Light threshold sufficient for assuming to be on target
LIGHT_NOISE_THRESHOLD = 0.01  --Threshold under which it is considered to not sense any light source
MAX_SPEED = 15

--ENUM for possible decisions
DECISION = {
    STOP = "stop",
    AVOID_OBSTACLE = "avoid_obstacle",
    FOLLOW_LIGHT = "follow_light",
    RANDOM_WALK = "random_walk"
}

function init()
end

function step()
    local sensors = checkSensors()
    local decision = takeDecision(sensors)

    local left_v, right_v = controlStep(decision, sensors)
    left_v = math.min(MAX_SPEED, left_v)
    right_v = math.min(MAX_SPEED, right_v)
    robot.wheels.set_velocity(left_v, right_v)
end

function reset()
	local left_v = BASE_VELOCITY
	local right_v = BASE_VELOCITY
	robot.wheels.set_velocity(left_v,right_v)
end

function destroy()
end

function checkSensors()
    --LIGHT SENSORS
    local left_light = robot.light[LEFT_SENSOR].value
    local right_light = robot.light[RIGHT_SENSOR].value
    local front_light = robot.light[FRONT_SENSOR].value

    --OBSTACLE DETECTION
    local obstacleDetected = false
    for i=1,#robot.proximity do
        if robot.proximity[i].value >= PROXIMITY_THRESHOLD then
            obstacleDetected = true
        end
    end

    --OBSTACLE LOCATION
    local left_sum = 0
    local right_sum = 0
    local half = math.floor(#robot.proximity/2)
    for i=1,#robot.proximity do
        local value = robot.proximity[i].value
        if value >= PROXIMITY_THRESHOLD then
            obstacleDetected = true
        end
        if i <= half then
            left_sum = left_sum + value
        else
            right_sum = right_sum + value
        end
    end

    -- CREATE SENSOR TABLE
    local sensors = {
        light = {
            left = left_light,
            right = right_light,
            front = front_light
        },
        obstacleDetected = obstacleDetected,
        proximity = {
            left_sum = left_sum,
            right_sum = right_sum
        }
    }
    return sensors
end

function takeDecision(sensors)
    if sensors.light.front >= STOP_THRESHOLD then
        return DECISION.STOP
    elseif sensors.obstacleDetected then
        return DECISION.AVOID_OBSTACLE
    elseif sensors.light.left >= LIGHT_NOISE_THRESHOLD or sensors.light.right >= LIGHT_NOISE_THRESHOLD then
        return DECISION.FOLLOW_LIGHT
    else
        return DECISION.RANDOM_WALK
    end
end

function controlStep(decision, sensors)
    if decision == DECISION.STOP then
        return 0,0

    elseif decision == DECISION.AVOID_OBSTACLE then
        return avoidObstacle(sensors.proximity)

    elseif decision == DECISION.FOLLOW_LIGHT then
        return followLightWithAvoidance(sensors.light, sensors.proximity)

    elseif decision == DECISION.RANDOM_WALK then
        return randomWalk()

    end
end

function followLight(light)
    local light_diff = light.right - light.left
    local left =  K * light_diff
    local right = -K * light_diff

    return left, right
end

function avoidObstacle(sensors)
    local left_velocity = math.max(0, BASE_VELOCITY - K2 * sensors.right_sum)
    local right_velocity = math.max(0, BASE_VELOCITY - K2 * sensors.left_sum)   
    return left_velocity, right_velocity
end


function randomWalk()
    local v = BASE_VELOCITY
    local turn = robot.random.uniform(-5,5)
    return v + turn, v - turn
end

function followLightWithAvoidance(light, proximity)

    --Light contributions for velocity
    local light_left, light_right = followLight(light)

    --Modifier for proximity, if the obstacle is near it gets priority
    local proximity_strength = proximity.left_sum + proximity.right_sum

    --Obstacle controbution for velocity
    local avoid_left = -K2 * proximity.right_sum * (1 + proximity_strength)
    local avoid_right = -K2 * proximity.left_sum * (1 + proximity_strength)

    --Total velocity
    local left_velocity = BASE_VELOCITY + light_left + avoid_left
    local right_velocity = BASE_VELOCITY + light_right + avoid_right

    left_velocity = math.max(0, left_velocity)
    right_velocity = math.max(0, right_velocity)
    return left_velocity, right_velocity
end
