#Group8 - Rumainum & Vance
#HW 3
#AMPL model file for Problem 3-4
#Galaxy Industries Revisited

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#decision variables-------------------------------------------------------------
#SR - Space Ray
#Z  - Zapper
#d  - delta 
#1..n - component number
#i.e.: dSR1 - delta of piecewise component 1 of var SR

#Since there is a limit of 7,000 lbs of special plastic per week 
#Space Ray's upper bound is 3,500 since it needs 2lbs of plastic
#Zapper's    upper bound is 7,000 since it needs 1lbs of plastic
var SR >=0, <=3500, integer; #number of Space Rays
var  Z >=0, <=7000, integer; #number of Zappers

var dSR1 >=0;  # piecewise component 1 of var SR
var dSR2 >=0;  # piecewise component 2 of var SR
var dSR3 >=0;  # piecewise component 3 of var SR
var dSR4 >=0;  # piecewise component 4 of var SR

var ySR1 binary; #to model piecewise cost for var SR
var ySR2 binary; #to model piecewise cost for var SR
var ySR3 binary; #to model piecewise cost for var SR

var dZ1 >=0;  # piecewise component 1 of var Z
var dZ2 >=0;  # piecewise component 2 of var Z
var dZ3 >=0;  # piecewise component 3 of var Z

#Variables for Disjunctive constraints (Either/Or)
#indicator if the total units is under or over 3,000 units
var zIndicator binary;
#constant for the Disjunctive constraints
param M := 4000;

#objective: maximize the company's profit per week-----------------------------------------
# revenue minus cost
maximize totalProfit: (8*SR + 5*Z) - (3.75*dSR1 + 3.25*dSR2 + 2.80*dSR3 + 1.90*dSR4 + 1.95*dZ1 + 2.15*dZ2 + 2.95*dZ3);

#constraints:-------------------------------------------------------------------
#---Space Rays
#connect SR with all its delta components;
subject to totalSR: SR = dSR1 + dSR2 + dSR3 + dSR4;

#ensure that the piece wise costs are used correctly,
#i.e., you have to use all of d1 before you use d2,...

# SR upper bound is 3,500 units
# 0 to 500 units
subject to piece1a: 500*ySR1 <= dSR1;
subject to piece1b: dSR1 <= 500;
# next 500 units
subject to piece2a: 500*ySR2 <= dSR2;
subject to piece2b: dSR2 <= 500*ySR1;
# next 1,000 units
subject to piece3a: 1000*ySR3 <= dSR3;
subject to piece3b: dSR3 <= 1000*ySR2;
# the rest of the units, which is 1,500 units
subject to piece4: dSR4 <= 1500*ySR3;

#--ZAPPERS
# connect Z with all its delta components
subject to totalZ: Z = dZ1 + dZ2 + dZ3;

# the price for Zappers are increasing for every delta components
# Z upper bound is 7,000 units
subject to z1Bounds: dZ1 <= 1500;
subject to z2Bounds: dZ2 <=  500;
subject to z3Bounds: dZ3 <= 5000;

# up to 7,000 pounds of special plastic per week
subject to plastic: 2*SR + Z <=  7000;
# up to 250 hours (15,000 minutes) of production time per week
subject to labor: 3*SR + 4*Z <= 15000;

# Using disjunctive constraint
# if total units is more than 3,000 units, at least 45% are Zappers
subject to lessThan3000: SR + Z <= 3000 + M*zIndicator;
subject to greaterThan3000: 0.45 *(SR + Z) <= Z + M*(1-zIndicator);

#commands---------------------------------
solve; # solve the maximize profit per week

#spaces
printf "\n\n";

#display Space Ray results
printf "The total of Space Ray guns made: %d units \n", SR;
printf "The total of Space Ray guns made for the cost of $3.75: %4.0d units \n", dSR1;
printf "The total of Space Ray guns made for the cost of $3.25: %4.0d units \n", dSR2;
printf "The total of Space Ray guns made for the cost of $2.80: %4.0d units \n", dSR3;
printf "The total of Space Ray guns made for the cost of $1.90: %4.0d units \n", dSR4;

printf "The total cost of of the Space Ray guns: $%0.2f \n", 3.75*dSR1 + 3.25*dSR2 + 2.80*dSR3 + 1.90*dSR4;
printf "The total revenue of of the Space Ray guns: $%0.2f \n", 8*SR;

#space
printf "\n";
#display Zappers results
printf "The total of Zappers guns made: %d units \n", Z;
printf "The total of Zappers guns made for the cost of $1.95: %4.0d units \n", dZ1;
printf "The total of Zappers guns made for the cost of $2.15: %4.0d units \n", dZ2;
printf "The total of Zappers guns made for the cost of $2.95: %4.0d units \n", dZ3;

printf "The total cost of of the Zappers guns: $%0.2f \n", 1.95*dZ1 + 2.15*dZ2 + 2.95*dZ3;
printf "The total revenue of of the Zappers guns: $%0.2f \n", 5*Z;

#space
printf "\n";
#display Total results
#display total weight of special plastic used to produced all units
printf "The total weight of special plastic used: %d pounds out of 7000 pounds \n", 2*SR + Z;
#display total labor time (in minutes) to used to produced all units
printf "The total labor time used: %5.0d out of 15000 minutes \n", (3*SR + 4*Z);
#display total units produced 
printf "The total units made: %d units \n", SR + Z;
#display the percentage of Zapper out of total units
printf "The total percentage of Zapper guns made: %0.2f%", Z/(SR+Z)*100;
printf "\n"; #space
# display the total profit 
printf "The maximum total profit: $%0.2f \n", totalProfit;

#spaces
printf "\n\n";