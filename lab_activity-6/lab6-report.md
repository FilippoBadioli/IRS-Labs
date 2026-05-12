# LAB ACTIVITY 6 REPORT  
filippo.badioli@studio.unibo.it

# PARAMETERS

W ==> Base probability of a robot to start walking
S ==> Base probability of a robot to stop
P_MAX_S ==> Maximum probability for a robot top stop
P_MIN_W ==> Minimum probability for a robot to start walking
ALFA ==> Multiplier factor to stop based on nearby stopped robots
BETA ==> Multiplier factor to start walking based on nearby stopped robots
MAXRANGE ==> Maximum range for sensning nearby stopped robots
BLACK_THRESHOLD ==> Threshold used by ground motor to assess if a robot is on the black spot
D_S ==> Probability modifier to stop based on the black spot 
D_W ==> Probability modifier to start walking based on the black spot

# IMPLEMENTATION

For exercise 1 I created a walk function, that performs a random walk with collision avoidance (using potential fields).
In the init function the robot starts walking.
The architecture used in the step function is a FSM with only 2 states: walking and stopped.
Each time step is called, based on the current state of the robot, a random number is generated, and is then compared with the probability of walking/stopping, calculated with the following formulas:

**Ps = math.min(P_MAX_S, S+ALFA*N)**
**Pw = math.max(P_MIN_W, W-BETA*N)**

if the random number is equal or less of the probability the robot will change its state.

The number of nearby stopped robot is calculated using the function provided by the teacher.

For exercise 2 I added a function that checks if the robot is on a black spot. Based on the answer the controller adds a modifier to increase the probability of stopping while on it and to start walking when not on it, and decreasing those in the opposite scenarios.

Exercise 3 only required a tuning of the parameters, the main change was adding non linearity in the probability function for the number of stopped nearby robots factor, in order to easily destroy small clusters and strengthen big ones.

# BEHAVIOUR AND RESULTS

For all the exercises the convergence of the behaviour is relatively slow (usually 1500-2500 ticks) and the initial distribution of the robot has a big influence on the number and dimension of the clusters.

For the first exercise in most of the runs there were 2-3 small clusters and a bigger one, or 2 big ones and a smaller one. 
For exercise 2 most of the robots were aggregating around (usually not too much inside) the black spot.
For exercise 3 most of the time the behaviour consist of most of the robots aggregating around one of the two spots, while a smaller amount goes on the other one. In some runs with initial configurations where the robots started with 2 small clusters near the two spots it frequently converges to a solution with an equal split around the two spots.

In conclusion I think that a deeper analysis of the parameters is needed, also sperimenting with different types of non-linearity in the nearby stopped robots factor.
Other improvements could be using a distance-based aggregation, where we don't just count the number of nearby stopped robots but weight them based on the distance, or using a different walking behaviour, e.g instead of walking randomly the robot should go towards a direction already populated by other robots, emulating a pheromon-like behaviour.
 

 
