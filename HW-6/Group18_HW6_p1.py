#the intial framework for a real-valued GA
#author: Charles Nicholson
#for ISE/DSA 5113

#need some python libraries
import copy
import math
from random import Random
import numpy as np

#to setup a random number generator, we will specify a "seed" value
seed = 5113
myPRNG = Random(seed)

lowerBound = -500  #bounds for Schwefel Function search space
upperBound = 500   #bounds for Schwefel Function search space

#you may change anything below this line that you wish too -----------------------------------------------------------------

#Student name(s): Lince Rumainum
#Date: 1 May 2020

dimensions = 2    #set dimensions for Schwefel Function search space (should either be 2 or 200 for HM #5)

populationSize = 50000 #size of GA population
Generations = 10   #number of GA generations

crossOverRate = 0.90  #currently not used in the implementation; neeeds to be used.
mutationRate = 0.15   #currently not used in the implementation; neeeds to be used.


#create an continuous valued chromosome 
def createChromosome(n, d, lBnd, uBnd):
    # n is the increment of population size (needed for seed to create randomness of the choromosome)  
    # d is the number of dimension
     
    #this code as-is expects chromosomes to be stored as a list, e.g., x = []
    x = [] #initialize x as an empty list

    #write code to generate chromosomes, most likely want this to be randomly generated
    #pick a point for each dimension
    for i in range(d):
        #create seed for random number
        seed = (i+n+d+populationSize)*100
        chromosome = Random (seed)
        #pick a random point between lower and upper bound
        x.append(chromosome.uniform(lBnd,uBnd))

    return x

#create initial population
def initializePopulation(): #n is size of population; d is dimensions of chromosome
    population = []
    populationFitness = []
    
    for i in range(populationSize):
        population.append(createChromosome(i, dimensions,lowerBound, upperBound))
        populationFitness.append(evaluate(population[i]))
        
    tempZip = zip(population, populationFitness)
    popVals = sorted(tempZip, key=lambda tempZip: tempZip[1])
    
    #the return object is a sorted list of tuples: 
    #the first element of the tuple is the chromosome; the second element is the fitness value
    #for example:  popVals[0] is represents the best individual in the population
    #popVals[0] for a 2D problem might be  ([-70.2, 426.1], 483.3)  -- chromosome is the list [-70.2, 426.1] and the fitness is 483.3
    
    return popVals    

#implement a linear crossover
# a+10 is the increment of population pair index (needed for seed to create random probability)  
def crossover(a, x1,x2):
    #new random seed for crossover
    crossoverSeed = (a+10+dimensions+populationSize)*100
    rndmCrossover = Random (crossoverSeed)

    #current crossover probability
    pRate = rndmCrossover.random()

    if pRate < crossOverRate:    #do crossover
        #print("crossover")
        d = len(x1) #dimensions of solution
        
        #choose crossover point 
        
        #we will choose the smaller of the two [0:crossOverPt] and [crossOverPt:d] to be unchanged
        #the other portion be linear combo of the parents
            
        crossOverPt = myPRNG.randint(1,d-1) #notice I choose the crossover point so that at least 1 element of parent is copied
        
        beta = myPRNG.random()  #random number between 0 and 1
            
        #note: using numpy allows us to treat the lists as vectors
        #here we create the linear combination of the soltuions
        new1 = list(np.array(x1) - beta*(np.array(x1)-np.array(x2))) 
        new2 = list(np.array(x2) + beta*(np.array(x1)-np.array(x2)))
        
        #the crossover is then performed between the original solutions "x1" and "x2" and the "new1" and "new2" solutions
        if crossOverPt<d/2:    
            offspring1 = x1[0:crossOverPt] + new1[crossOverPt:d]  #note the "+" operator concatenates lists
            offspring2 = x2[0:crossOverPt] + new2[crossOverPt:d]
        else:
            offspring1 = new1[0:crossOverPt] + x1[crossOverPt:d]
            offspring2 = new2[0:crossOverPt] + x2[crossOverPt:d]        
    else: # no crossover
        #print("no crossover")
        #keep the same x1 and x2
        offspring1 = x1
        offspring2 = x2
    return offspring1, offspring2  #two offspring are returned 

#function to evaluate the Schwefel Function for d dimensions
def evaluate(x):  
    val = 0
    d = len(x)
    for i in range(d):
        val = val + x[i]*math.sin(math.sqrt(abs(x[i])))
         
    val = 418.9829*d - val         
                    
    return val             
  

#function to provide the rank order of fitness values in a list
#not currently used in the algorithm, but provided in case you want to...
def rankOrder(anyList):
    
    rankOrdered = [0] * len(anyList)
    for i, x in enumerate(sorted(range(len(anyList)), key=lambda y: anyList[y])):  
        rankOrdered[x] = i     

    return rankOrdered

#performs tournament selection; k chromosomes are selected (with repeats allowed) and the best advances to the mating pool
#function returns the mating pool with size equal to the initial population
def tournamentSelection(pop,k):
    
    #randomly select k chromosomes; the best joins the mating pool
    matingPool = []
    
    while len(matingPool)<populationSize:
        
        ids = [myPRNG.randint(0,populationSize-1) for i in range(k)]
        competingIndividuals = [pop[i][1] for i in ids]
        bestID=ids[competingIndividuals.index(min(competingIndividuals))]
        matingPool.append(pop[bestID][0])

    return matingPool
    
#function to mutate solutions
# a+5 is the increment of population pair index (needed for seed to create random probability)  
def mutate(a, x):
    #new random seed for mutation
    mutationSeed = (a+10+dimensions+populationSize)*100
    rndmMutation = Random (mutationSeed)

    #current mutation probability
    pRate = rndmMutation.random()

    #do mutation
    if pRate < mutationRate:
        #10% of dimensions
        #for example: d = 10, mutate 1 random dimension, d = 1000, mutate 100 random dimension
        numOfMutation = math.floor(0.10 * dimensions)
        #print("mutation")

        for i in range(numOfMutation):
            #select random 
            selectionSeed = (i+seed+mutationSeed)*10
            mutationSelection = Random(selectionSeed)
            #pick index to do mutation
            indexToMutate = mutationSelection.randint(0, dimensions-1)

            #do mutation
            if x[indexToMutate] < -250: #shift between 0 to +750
                x[indexToMutate] += mutationSelection.uniform(0, 750)
            elif x[indexToMutate] < 0: #shift between 0 to +500
                x[indexToMutate] += mutationSelection.uniform(0, 500)
            elif x[indexToMutate] < 250: #shift between 0 to -500
                x[indexToMutate] -= mutationSelection.uniform(0, 500)
            else: #shift between 0 to -750
                x[indexToMutate] -= mutationSelection.uniform(0, 750)

    return x
        
def breeding(matingPool):
    #the parents will be the first two individuals, then next two, then next two and so on
    
    children = []
    childrenFitness = []
    for i in range(0,populationSize-1,2):
        child1,child2=crossover(i,matingPool[i],matingPool[i+1])
        
        child1=mutate(i,child1)
        child2=mutate(i,child2)
        
        children.append(child1)
        children.append(child2)
        
        childrenFitness.append(evaluate(child1))
        childrenFitness.append(evaluate(child2))
        
    tempZip = zip(children, childrenFitness)
    popVals = sorted(tempZip, key=lambda tempZip: tempZip[1])
        
    #the return object is a sorted list of tuples: 
    #the first element of the tuple is the chromosome; the second element is the fitness value
    #for example:  popVals[0] is represents the best individual in the population
    #popVals[0] for a 2D problem might be  ([-70.2, 426.1], 483.3)  -- chromosome is the list [-70.2, 426.1] and the fitness is 483.3
    
    return popVals


#insertion step
def insert(pop,kids):
    #for i in range (len(pop)):
        #print("pop", i, ": ", pop[i])
    
    #for i in range (len(pop)):
        #print("kids", i, ": ", kids[i])

    #replacing the previous generation completely...  probably a bad idea -- please implement some type of elitism
    tempKids = [] #initialize list of temporary kids list
    kids = [] #initialize list of kids list

    #combined list of population and kids
    combinedList = pop + kids
    #print("combinedList: ")
    #print(combinedList)

    '''
    #rank the combined lists
    rankOfCombinedList = rankOrder(combinedList)

    #pick the top number of population size
    for i in range (len(combinedList)):
        if rankOfCombinedList[i] < populationSize:
            #print("rankOfCombinedList: ",rankOfCombinedList[i])
            #print("kid: ", combinedList[i])
            tempKids.append(combinedList[i])
    '''
    #re-sort the combined list into temporary kids list
    tempKids = sorted(combinedList, key=lambda combinedList: combinedList[1])
    
    #pick the best solution
    for i in range(populationSize):
        kids.append(tempKids[i])

    #print("kids: ")
    #print(kids)
    #re-sort the top picked of the combination lists
    #kids = sorted(tempKids, key=lambda tempKids: tempKids[1])
    return kids
    
#perform a simple summary on the population: returns the best chromosome fitness, the average population fitness, and the variance of the population fitness
def summaryFitness(pop):
    a=np.array(list(zip(*pop))[1])
    return np.min(a), np.mean(a), np.var(a)

#the best solution should always be the first element... if I coded everything correctly...
def bestSolutionInPopulation(pop):
    print (pop[0])

#check the optimal value in the population
def bestOptimalValue(pop):
    print ("bestOptimalValueForCurrentGen:", pop[0][1])
          
#optional: you can output results to a file -- i've commented out all of the file out put for now

f = open('out.txt', 'w')  #---uncomment this line to create a file for saving output
    
#GA main code
Population = initializePopulation()

for j in range(Generations):
    mates=tournamentSelection(Population,3)
    Offspring = breeding(mates)
    Population = insert(Population, Offspring)
    #print(bestSolutionInPopulation(Population))
    #end of GA main code
    
    minVal,meanVal,varVal=summaryFitness(Population)  #check out the population at each generation
    print(summaryFitness(Population))                 #print to screen; turn this off for faster results
    #bestOptimalValue(Population)
    #print()
    
    f.write(str(minVal) + " " + str(meanVal) + " " + str(varVal) + "\n")  #---uncomment this line to write to  file
    
f.close()   #---uncomment this line to close the file for saving output

print (summaryFitness(Population))
bestSolutionInPopulation(Population)

