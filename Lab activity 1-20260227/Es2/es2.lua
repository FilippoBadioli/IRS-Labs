-- Put your global variables here

BASE_VELOCITY = 5
MAX_VELOCITY = 15


--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	if checkPath() then
		left_v = robot.random.uniform(0, MAX_VELOCITY)
		right_v = robot.random.uniform(0, MAX_VELOCITY)
		robot.wheels.set_velocity(left_v, right_v)
	else
		left_v = -BASE_VELOCITY
		right_v = BASE_VELOCITY
		robot.wheels.set_velocity(left_v, right_v)
	end
end



--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	if checkPath() then
		left_v = robot.random.uniform(0, MAX_VELOCITY)
		right_v = robot.random.uniform(0, MAX_VELOCITY)
		robot.wheels.set_velocity(left_v, right_v)
	else
		left_v = -BASE_VELOCITY
		right_v = BASE_VELOCITY
		robot.wheels.set_velocity(left_v, right_v)
	end
end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
	robot.leds.set_all_colors("black")
end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end

function checkPath()
	free_path = true
	for i = 1, #robot.proximity do
		log("Distance from sensor " .. i .. " = " .. robot.proximity[i].value)
		if i > 3 and i < 22 then
		elseif robot.proximity[i].value >= 0.1 then
			free_path = false
		end
	end
	return free_path
end
