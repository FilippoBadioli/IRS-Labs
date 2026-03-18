-- Put your global variables here

BASE_VELOCITY = 10


--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	direction = checkLightDirection()
     if direction == 1 then
          left_v = BASE_VELOCITY
	     right_v = BASE_VELOCITY
     elseif direction == 2 then
          left_v = -BASE_VELOCITY
	     right_v = BASE_VELOCITY
     elseif direction == 3 then
          left_v = BASE_VELOCITY
	     right_v = -BASE_VELOCITY
     else 
          logerr("No Light detected")
     end
     robot.wheels.set_velocity(left_v, right_v)
end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
     direction = checkLightDirection()
     log("Direction = " .. direction)
     if direction == 1 then
          left_v = BASE_VELOCITY
	     right_v = BASE_VELOCITY
     elseif direction == 2 then
          left_v = -BASE_VELOCITY
	     right_v = BASE_VELOCITY
     elseif direction == 3 then
          left_v = BASE_VELOCITY
	     right_v = -BASE_VELOCITY
     else 
          logerr("No Light detected")
     end
     robot.wheels.set_velocity(left_v, right_v)
end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
	left_v = BASE_VELOCITY
	right_v = BASE_VELOCITY
	robot.wheels.set_velocity(left_v,right_v)
end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end

function checkLightDirection()
	direction = 0
     highest_value = 0
     highest_light = 0
	for i = 1, #robot.light do
		if robot.light[i].value > highest_value then
               highest_value = robot.light[i].value
               highest_light = i
          end
	end
     log("Highest light detected on sensor number " .. highest_light .. " with value = " .. highest_value)
     if highest_light < 3 or highest_light > 22 then
          return 1
     elseif highest_light < 13 then
          return 2
     else
          return 3
     end
end
