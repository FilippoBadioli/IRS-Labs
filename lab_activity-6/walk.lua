local vector = require "vector"

local walk = {}

local count = 0
local L = 0

local left_v = 0
local right_v = 0

local MAX_VELOCITY = 10

function walk.compute_velocities(axis)
    L = axis

    if count >= 5 then
        left_v = robot.random.uniform(0, 10)
        right_v = robot.random.uniform(0, 10)

        count = 0
    end

    local left_obst, right_obst = oa(robot.proximity)

    count = count + 1

    return limit_velocity(left_v + left_obst),
           limit_velocity(right_v + right_obst)
end

function oa(sensors)

    local field = {
        length = 0,
        angle = 0
    }

    local sensor_vector = {
        length = 0,
        angle = 0
    }

    for i = 1, #sensors do
        sensor_vector.length = sensors[i].value
        sensor_vector.angle = sensors[i].angle + math.pi

        field = vector.vec2_polar_sum(field, sensor_vector)
    end

    return convert_to_linear(field)
end

function convert_to_linear(angular)

    local v = angular.length * math.cos(angular.angle)
    local omega = angular.length * math.sin(angular.angle)

    local left = v - (L / 2) * omega
    local right = v + (L / 2) * omega

    return left, right
end

function limit_velocity(v)

    if v > MAX_VELOCITY then
        return MAX_VELOCITY
    elseif v < -MAX_VELOCITY then
        return -MAX_VELOCITY
    else
        return v
    end
end

return walk