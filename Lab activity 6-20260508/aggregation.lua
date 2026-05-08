---@diagnostic disable: lowercase-global
local walk = require "walk"
local walking = true
local left, right
W = 0.1
S = 0.01
P_MAX_S = 0.99
P_MIN_W = 0.005
ALFA = 0.1
BETA = 0.05
MAXRANGE = 30
BLACK_THRESHOLD = 0.9

function init()
    L = robot.wheels.axis_length
    left, right = walk.compute_velocities(robot.wheels.axis_length)
    robot.wheels.set_velocity(left, right)
end

function step()
    stopped_nearby = CountRAB()
    if on_spot() then
        D_S = 0.2
        D_W = 0
    else    
        D_S = 0
        D_W = 0.4
    end
    if walking then
        robot.range_and_bearing.set_data(1,0)
        robot.leds.set_all_colors("green")
        left, right = walk.compute_velocities(robot.wheels.axis_length)
        local t = robot.random.uniform()
        local p = math.min(P_MAX_S, S+ALFA*stopped_nearby^1.5+D_S)
        if t <= p then
            walking = false
        end
    else
        robot.range_and_bearing.set_data(1,1)
        robot.leds.set_all_colors("red")
        left, right = 0, 0
        local t = robot.random.uniform()
        local p = math.min(P_MIN_W, W+BETA*stopped_nearby^1.5+D_W)
        if t <= p then
            walking = true
        end
    end
    robot.wheels.set_velocity(left, right)
end

function destroy()
end

function reset()
end

function CountRAB()
    number_robot_sensed = 0
    for i = 1, #robot.range_and_bearing do
        -- for each robot seen, check if it is close enough.
        if robot.range_and_bearing[i].range < MAXRANGE and
        robot.range_and_bearing[i].data[1]==1 then
        number_robot_sensed = number_robot_sensed + 1
        end
    end
    return number_robot_sensed
end

function on_spot()
    local ground = {}
    for i=1,#robot.motor_ground do
        ground[i] = robot.motor_ground[i].value
    end
    for i=1,#ground do
        if ground[i] <= BLACK_THRESHOLD then
            return true
        end
    end
    return false
end