#Group32 - Rumainum & Navarrete
#HW 1
#AMPL model file for Problem 1-5d
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
param profit {PROD}; # profit per ton
param commit {PROD} >= 0; # lower limit on tons sold in week
param market {PROD} >= 0; # upper limit on tons sold in week
#added for part b
param max_weight >= 0;	  # the maximum total weight
#added for part d
param min_shares {PROD} >= 0; # minimum shares for each product

#decision variables----------------------------------------------
#var Make {p in PROD} >= commit[p], <= market[p]; # tons produced
var Make {p in PROD} <= market[p]; # tons produced

#objective------------------------------------------------------
maximize Total_Profit: sum {p in PROD} profit[p] * Make[p];
	# Objective: total profits from all products

#constraints:---------------------------------------------------
subject to Time {s in STAGE}:
	sum {p in PROD} (1/rate[p,s]) * Make[p] <= avail[s];
		# In each stage: total of hours used by all
		# products may not exceed hours available

#constraint for all minimum share associated with product
subject to Minimum_Commit {p in PROD}: 
	 min_shares [p] * sum {b in PROD} Make [b]  <= Make[p];

#data-------------------------------------
data Group32-HW1-p5.dat

#commands---------------------------------

# display total profit
solve; # solve the maximize total profit

printf "\n";
# display optimal solution for all minimum share associated with product 
for {p in PROD} {
	printf "The minimum shares of %s: %0.4f \n", p, min_shares[p];
}
# display amount of product in tons
for {p in PROD} {
	printf "The amount of %s made   : %0.2f ton(s)\n", p, Make[p];
}
printf "\n";