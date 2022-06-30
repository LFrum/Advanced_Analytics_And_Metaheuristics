#Group32 - Rumainum & Navarrete
#HW 1
#AMPL model file for Problem 1-5c
#Steel Mill

#Code up to constraints:
#From Figure 1-6a ampl book

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#parameters and sets-----------------------------------------------
set PROD; # products
set STAGE; # stages

param rate {PROD,STAGE} > 0; # tons per hour in each stage
param avail {STAGE} >= 0; # hours available/week in each stage
param profit {PROD}; 	  # profit per ton
param commit {PROD} >= 0; # lower limit on tons sold in week
param market {PROD} >= 0; # upper limit on tons sold in week
#added for part b
param max_weight >= 0;	  # the maximum total weight
#added for part d
param min_shares {PROD} >= 0; # minimum shares for each product

#------------------------Decision Variables------------------------
var Make {p in PROD} >= commit[p], <= market[p]; # tons produced

#------------------------Objective Function------------------------
maximize Total_Weight: sum {p in PROD} Make[p];
	# Objective: produce as many tons as possible

#------------------------Constraints------------------------
subject to Time {s in STAGE}:
	sum {p in PROD} (1/rate[p,s]) * Make[p] <= avail[s]; #original code

#------------------------Data-----------------------
data Group32-HW1-p5.dat;

#------------------------Commands------------------------
solve; 

#Print solution
printf "\n";
printf "Maximum total products being produced: %0.2f tons \n", Total_Weight;
printf "\n";
printf "Total weight of each product:";
for {p in PROD} {
	printf "\n %4.0d tons of %s", Make[p], p;
}

printf "\n Profit would be $%0.2f ", sum{p in PROD} profit[p] * Make[p];
printf "\n";
