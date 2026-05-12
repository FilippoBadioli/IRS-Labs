# LAB ACTIVITY 5 REPORT  
filippo.badioli@studio.unibo.it  

# RESULTS DISCUSSION

After analyzing the code provided and implementing all the needed functions I ran the suggested tests. All the tests were run with a fairly low amount of runs, in a task where variability might be high due to arena configurations.

The first test was about evaluating different crossover values (0, 0.5, 1).
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

As we can see from the results a crossover value of 0 produces the worst last-generation-fitness, while crossover probabilities of 0.5 and 1 are more or less comparable, with 0.5 producing slightly better results.
If we look at the average fitness per-generation in crossover.png we have another confirmation of its poor results, but we can also see an important difference between 0.5 and 1, which is the smoother and faster convergence of the first, while the latter produces way more oscillations.


The second test's goal was to show the differences between generational replacement and elitism.
Elitism was implemented by sorting the population by the fitness value of each individual, then we pick the best **ELITE_SIZE** individuals and put them in the new generation, finally we fill the remaining **POP_SIZE** - **ELITE_SIZE** individuals with a selection algorithm.

Replacement:
        Mean    = 0.7633
        Median  = 0.7476
        Std     = 0.1341

Elitism:
        Mean    = 0.8252
        Median  = 0.7935
        Std     = 0.0733

By looking at those results, and at the graph in replacement.png we can see how elitism provides us better results, with an higher average fitness and a less oscillating behaviour.



The last test taken had the goal of comparing proportional selection and tournament selection. 

Proportional:
        Mean    = 0.8181
        Median  = 0.8213
        Std     = 0.0445

Tournament:
        Mean    = 0.8218
        Median  = 0.8607
        Std     = 0.1550

As we can see from those results and from the graph in selection.png the results of the two methods are very similar and comparable, with tournament showing a bit more variability between generations.


As said in the beginning all the tests were evaluated with a limited number of runs, and fairly low values for generations, population size and so on, in an highly variable environment.
Therefore all the results are not objectively true, and might provide slightly different answers if ran again.

Overall, the experiments suggest that introducing crossover and elitism improves both convergence speed and final fitness quality. Selection methods instead appear to have a smaller impact on the final results under the tested conditions. However, due to the limited number of runs and the stochastic nature of the environment, further experimentation would be needed to draw stronger conclusions.


