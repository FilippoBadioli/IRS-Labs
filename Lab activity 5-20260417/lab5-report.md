# LAB ACTIVITY 4 REPORT  
filippo.badioli@studio.unibo.it  

# RESULTS DISCUSSION

After analyzing the code provided and implementing all the needed functions I ran the suggested tests. All the tests were ran with a fairly low amount of runs, in a task where variability might be high due to arena configurations.

The first test was about trying different crossover values (0, 0.5, 1).
After collecting all the fitness values I took the fitness of the last generation of each run and summarized them in mean, median and standard deviation.

Crossover 0:
        Mean    = 0.5047
        Median  = 0.3833
        Std     = 0.2186

Crossover 0.5:
        Mean    = 0.8677
        Median  = 0.8584
        Std     = 0.0450

Crossover 1:
        Mean    = 0.7881
        Median  = 0.8017
        Std     = 0.0863

As we can see from the results a crossover value of 0 produces the worst last-generation-fitness, while 0.5 and 1 are more or less comparable, with 0.5 producing slightly better results.
If we look at the average fitness per-generation in crossover.png we have another confirmation of its poor results, but we can also see an important difference bwtween 0.5 and 1, which is the faster convergence and better monotony of the first, while the latter produces way more oscillations.


