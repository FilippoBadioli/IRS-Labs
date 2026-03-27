local vector = require "vector"
local fields = require "fields"

BASE_VELOCITY = 10

local velocities = { left = BASE_VELOCITY, right = BASE_VELOCITY}

local vectors = { 
    light = { lenght = 0, angle = 0},
    obstacle = { lenght = 0, angle = 0}
}

function init()
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
    vectors.light = fields.light_field()
    vectors.obstacle = fields.obstacle_field()

    local sum = vector.vec2_polar_sum(vectors.light, vectors.obstacle)
    velocities = convert_to_linear(sum)
    return velocities
end

function convert_to_linear(angular)
    local left --TODO
    local right --TODO
    return left, right
end
