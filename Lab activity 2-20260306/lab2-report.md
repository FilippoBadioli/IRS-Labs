# LAB ACTIVITY 2 REPORT  
filippo.badioli@studio.unibo.it

# PARAMETERS

The controller uses several parameters to regulate the behaviour of the robot:

BASE_VELOCITY ==> Baseline velocity of the robot wheels. 
LEFT_SENSOR ==> ID of the light sensor on the left side of the robot.
RIGHT_SENSOR ==> ID of the light sensor on the right side of the robot.
FRONT_SENSOR ==> ID of the light sensor on the front of the robot.
K ==> Velocity gain to modify the trajectory based on the light sensors.
K2 ==> Velocity gain to modify the trajectory based on proximity sensors.
PROXIMITY_THRESHOLD ==> Threshold used to determine whether a proximity sensor is detecting a nearby obstacle.
STOP_THRESHOLD ==> Threshold used to determine whether the robot is close enough to the light source.
LIGHT_NOISE_THRESHOLD ==> Threshold used to distinguish real light readings from sensor noise.
MAX_SPEED ==> Maximum allowed speed.

# BEHAVIOUR

The robot is able to detect a light source in the environment, approach it and stop when it reaches a sufficiently close position.

The behaviour is designed using a priority-based decision structure. In particular, the robot gives higher priority to **obstacle avoidance** in order to prevent collisions. When an obstacle is detected near the robot, the controller modifies the wheel velocities to steer away from it.

If no obstacle is detected, the robot attempts to **follow the light source**. The direction of the light is estimated by comparing the readings of the left and right light sensors. The robot then adjusts its wheel velocities in order to rotate toward the direction of higher light intensity.

When the robot is very close to the light source, detected through the front light sensor, the robot **stops completely**.

If the robot cannot detect any meaningful light signal, it performs a **random exploration behaviour** in order to search for the light source within the environment.

# IMPLEMENTATION

The controller is implemented using a finite state machine with a perception -> decision -> action architecture.

The step function will firstly check all relevant sensors, and store their values in a table. This table is processed by a decision function, that returns a parameter defined in an enum.
This parameter will cause a robot to perform a determined action.

The decision function follows a priority hierarchy, prioritizing stopping condition, then obstacole avoidance, then following light and lastly random walking. 

# TESTS EVALUATED AND RESULTS
 
The behaviour was tested using different obstacle configurations, varying the type of obstacle (boxes and cylinders), their size, and their number.

The convergence toward the goal is often slow, with the robot occasionally moving in loops, especially when narrow passages are present or when obstacles form nearly closed areas. In most cases, however, the robot eventually succeeds in reaching the light source, although it may require a significant amount of time.

The behaviour was also tested with more than one robot in the environment. No particular issues were observed, confirming that the behaviour scales correctly when multiple robots are present.

Possible improvements could be explored in two different directions:

- Strengthening the velocity component influenced by the light source, which could reduce the tendency of the robot to move in loops.
- Improving the obstacle avoidance behaviour by using four grouped proximity areas (front-left, back-left, front-right, back-right). Currently, the robot tends to perform turns that are too wide when avoiding obstacles, having a more precise obstacle location could help overcome this issue.