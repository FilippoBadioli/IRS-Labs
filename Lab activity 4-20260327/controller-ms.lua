local vector = require "vector"

BASE_VELOCITY = 10
MAX_VELOCITY = 15
W1 = 10
W2 = 30
W3 = 3
TICKS = 50

local velocities = { left = BASE_VELOCITY, right = BASE_VELOCITY}

local vectors = { 
    light = { length = 0, angle = 0},
    obstacle = { length = 0, angle = 0},
    random = { length = 0, angle = 0}
}

local random_vector = { length = 0, angle = 0}
local random_counter = 0

function init()
    L = robot.wheels.axis_length
    robot.wheels.set_velocity(velocities.left, velocities.right)
end

function step()
    velocities = controller()
    robot.wheels.set_velocity(velocities.left, velocities.right)
end

function reset()
end

function destroy()
end

function controller()
    vectors.light = compute_light_field(robot.light)
    vectors.obstacle = compute_obstacle_field(robot.proximity)
    vectors.random = compute_random_field()

    log("Light field -> length = " .. vectors.light.length .. " angle = ".. vectors.light.angle)
    log("Proximity field -> length = " .. vectors.obstacle.length .. " angle = ".. vectors.obstacle.angle)
    local sum = vector.vec2_polar_sum(vectors.light, vectors.obstacle)
    sum = vector.vec2_polar_sum(sum, vectors.random)
    velocities = convert_to_linear(sum)
    velocities = limitVelocity(velocities)
    log("left = " .. velocities.left .. " right = " .. velocities.right)
    return velocities
end

function convert_to_linear(angular)
    local v = angular.length * math.cos(angular.angle)
    local omega = angular.length * math.sin(angular.angle)

    local left = v - (L/2)*omega
    local right = v + (L/2)*omega
    return {left = left, right = right}
end

function compute_light_field(sensors)
    local field = { length = 0, angle = 0 }
    local sensor_vector = { length = 0, angle = 0}
    for i=1,#sensors do
        sensor_vector.length = sensors[i].value
        sensor_vector.angle = sensors[i].angle
        field = vector.vec2_polar_sum(field, sensor_vector)
    end
    field.length = field.length * W1
    return field
end

function compute_obstacle_field(sensors)
    local field = { length = 0, angle = 0 }
    local sensor_vector = { length = 0, angle = 0}
    for i=1,#sensors do
        sensor_vector.length = sensors[i].value
        sensor_vector.angle = sensors[i].angle + math.pi
        field = vector.vec2_polar_sum(field, sensor_vector)
    end
    field.length = field.length * W2
    return field
end

function compute_random_field()
    return { length = 5, angle = 0}
end

function limitVelocity(velocities)
    local max_val = math.max(math.abs(velocities.left), math.abs(velocities.right))

    if max_val > MAX_VELOCITY then
        local scale = MAX_VELOCITY / max_val
        return {
            left = velocities.left * scale,
            right = velocities.right * scale
        }
    else
        return velocities
    end
end
