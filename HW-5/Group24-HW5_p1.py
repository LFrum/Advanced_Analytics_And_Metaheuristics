#basic hill climbing search provided as base code for the DSA/ISE 5113 course
#author: Charles Nicholson
#date revised: 3/26/2021

#NOTE: YOU MAY CHANGE ALMOST ANYTHING YOU LIKE IN THIS CODE.  
#However, I would like all students to have the same problem instance, therefore please do not change anything relating to:
#   random number generator
#   number of items (should be 150)
#   random problem instance
#   weight limit of the knapsack

#------------------------------------------------------------------------------

#Student name:Group 24 - Rumainum
#Date: 14 April 2020


#need some python libraries
from random import Random   #need this for the random number generation -- do not change
import numpy as np
import math


#to setup a random number generator, we will specify a "seed" value
#need this for the random number generation -- do not change
seed = 51132021
myPRNG = Random(seed)

#to get a random number between 0 and 1, use this:             myPRNG.random()
#to get a random number between lwrBnd and upprBnd, use this:  myPRNG.uniform(lwrBnd,upprBnd)
#to get a random integer between lwrBnd and upprBnd, use this: myPRNG.randint(lwrBnd,upprBnd)

#number of elements in a solution
n = 150

#create an "instance" for the knapsack problem
value = []
for i in range(0,n):
    value.append(round(myPRNG.triangular(150,2000,500),1))
    
weights = []
for i in range(0,n):
    weights.append(round(myPRNG.triangular(8,300,95),1))
    
#define max weight for the knapsack
maxWeight = 2500

#change anything you like below this line ------------------------------------
#some of the provided functions are intetionally incomplete
#also, you may wish to restructure the approach entirely -- this is NOT the world's best Python code

#monitor the number of solutions evaluated
solutionsChecked = 0

#function to evaluate a solution x
def evaluate(x):
          
    a=np.array(x)
    b=np.array(value)
    c=np.array(weights)
    
    totalValue = np.dot(a,b)     #compute the value of the knapsack selection
    totalWeight = np.dot(a,c)    #compute the weight value of the knapsack selection
    
    #infeasible solutions
    if totalWeight > maxWeight:
        totalValue = 0 # make total value to be zero so it won't get picked as most valueable

    return [totalValue, totalWeight]   #returns a list of both total value and total weight       
       
#here is a simple function to create a neighborhood
#1-flip neighborhood of solution x         
def neighborhood(x):        
    nbrhood = []     
    
    for i in range(0,n):
        
        nbrhood.append(x[:])
        
        if nbrhood[i][i] == 1:
            nbrhood[i][i] = 0
        else:
            nbrhood[i][i] = 1
      
    return nbrhood
          
#create the initial solution
def initial_solution(restartsCounter):
    x = []   #i recommend creating the solution as a list
    
    #need logic here!
    #create temporary lists for weights and solutions(var x)
    tempWeights = []
    tempX = []

    for i in range(0,n):
        #creating new seed so solution will be picked at random           
        solutionSeed = myPRNG.randint(0,(restartsCounter+1)*10)
        solutionSeed *= restartsCounter*100
        tempSolution = Random(solutionSeed)
        #add weights
        tempWeights.append(weights[i])
        #random selections
        tempX.append(tempSolution.randint(0,1))

        #put temporary lists into array
        a=np.array(tempX)
        c=np.array(tempWeights)

        totalWeight = np.dot(a,c)    #compute the weight value of the knapsack selection
        
        #create random percentage to use as constraint of weight upper limit
        percentageOfMaxWeight = i*5/100

        #make sure percentage at most 100% 
        while percentageOfMaxWeight > 1:
            percentageOfMaxWeight = percentageOfMaxWeight/3

        #append the selection if total weight is less than x% of total weight
        if totalWeight < maxWeight*percentageOfMaxWeight:
            x.append(tempX[i])
        else:
            x.append(0)
    return x

#varaible to record the number of solutions evaluated
solutionsChecked = 0
#random restarts counter used for random restarts method
k = 100

x_curr = initial_solution(k)  #x_curr will hold the current solution 
x_best = x_curr[:]           #x_best will hold the best solution 
f_curr = evaluate(x_curr)    #f_curr will hold the evaluation of the current soluton 
f_best = f_curr[:]

#simulated annealing variables
#initial temperature
#T0 = 1000
#T0 = 800
T0 = 750

#cooling schedule
#1-cauchy schedule , 2-boltzmann schedule, #3-using alpha
#coolingSch = 1
#coolingSch = 2
coolingSch = 3

#current temperature
tk = T0
#iterations for each temperature/initial Mk (variations inside the loop)
#Mk = 30 #initial for variation-1
#Mk = 50 #initial for variation-2
#Mk = 135
Mk = 120

#k for simulated annealing's # of temperature
kSA = 0
#max_kSA = 100
#max_kSA = 75
max_kSA = 50

#simulated annealing stoping criteria 
while kSA < max_kSA and tk > 0.15*T0:
#while tk > 0.15*T0: #temperature is cooling to 15% of initial temperature  
#while kSA < max_kSA: #maximum number of temperature is reached
    #reset m-iteration counter
    m = 0

    while m < Mk: #iterate for same temperature
        newSeed = Random((m + T0 + int(tk)) * 100)
        Neighborhood = neighborhood(x_curr)   #create a list of all neighbors in the neighborhood of x_curr
        #pick random solution from the neighborhood        
        s = newSeed.choice(Neighborhood)

        #increment solution checked counter
        solutionsChecked = solutionsChecked + 1

        if evaluate(s)[0] > f_best[0]: 
            x_best = s[:]                 #find the best member and keep track of that solution
            f_best = evaluate(s)[:]       #and store its evaluation
            #update current            
            x_curr = x_best[:]         
            f_curr = f_best[:]         
        else:
            if evaluate(s)[0] > 0: #feasible solution
                #delta = evaluate(s)[0] - f_best[0]
                delta = f_best[0] - evaluate(s)[0]
                #epsilonSeed = (m + T) * 100
                epsilon = newSeed.uniform(0,1)
                prob = math.exp(-delta/tk)
                #print("delta: ",delta,"prob: ", prob, "epsilon: ",epsilon)

                #use the solution if condition is true
                if epsilon <= math.exp(-delta/tk):
                    x_best = s[:]                 #find the best member and keep track of that solution
                    f_best = evaluate(s)[:]       #and store its evaluation
                    #update current               
                    x_curr = x_best[:]        
                    f_curr = f_best[:]
                #else:
                    #print ("no new best solution")

        #increment m
        m = m + 1
    
    #increment kSA
    kSA = kSA + 1

    #update tk
    if coolingSch == 1: #1-cauchy schedule 
        tk = T0/(1+kSA)
    elif coolingSch == 2: #2-boltzmann schedule 
        tk = T0/math.log(1+kSA)
    else: #using alpha
        #alpha should be between 0.8 and 0.99
        #cooling is slower closer to 0.99
        alpha = 0.91
        tk = alpha * tk
    '''
    #update Mk - variation-1 Mk
    #cooler temperature has greater Mk value
    if tk > 0.90*T0: 
        Mk = 30
    elif tk > 0.75*T0:
        Mk = 60
    elif tk > 0.50*T0:
        Mk = 105
    elif tk > 0.25*T0:
        Mk = 120
    elif tk > 0.05*T0:
        Mk = 135
    else:
        Mk = 0
    #print("MK:",Mk, "tk:",tk)
    '''

    '''
    #update Mk - variation-2 Mk
    #cooler temperature has greater Mk value
    if tk > 0.90*T0: 
        Mk = 50
    elif tk > 0.75*T0:
        Mk = 100
    elif tk > 0.50*T0:
        Mk = 200
    elif tk > 0.25*T0:
        Mk = 400
    elif tk > 0.05*T0:
        Mk = 800
    else:
        Mk = 0
    '''

#print solutions
print ("\n--------SOLUTIONS PROBLEM 1--------")
if coolingSch == 1:
    print("Using Cauchy scheduling")  
elif coolingSch == 2:
    print("Using Boltzman scheduling")  
elif coolingSch == 3:
    print("Using Alpha scheduling")  
print ("Initial Temperature: ", T0)
print ("Number of temperature checked: ", kSA)
print ("Final number of solutions checked: ", solutionsChecked)
print ("Best value found: {:0.2f}".format(f_best[0]))
print ("Weight is: {:0.2f}".format(f_best[1]))
print ("Total number of items selected: ", np.sum(x_best))
print ("Best solution: ", x_best)
