#Group8 - Rumainum & Vance
#HW 3
#AMPL model file for Problem 3-3
#ED On-Call

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#parameters and sets----------------------------------------------------------
set DOCTOR;    #set of doctors
set PROCEDURE; #set of procedures	

# parameter variable:
# cost of procedure depending on the doctor.
#	Since the goal is to minimize cost, the doctor with
#	default price will not be chosen to do the procedure. 
param procedureCost{PROCEDURE, DOCTOR} 	default 1000000; 

#decision variables-------------------------------------------------------------
#whether or not the doctor is choosen for the procedure
var x{PROCEDURE, DOCTOR} binary;

#objective: minimize total cost-----------------------------------------
minimize totalProcedureCost:  sum {p in PROCEDURE, d in DOCTOR} (x[p,d] * procedureCost[p,d]);

#constraints:-------------------------------------------------------------------
#each procedure is covered by a doctor
subject to CoveredProcedure{p in PROCEDURE}: sum{d in DOCTOR} (x[p,d] * procedureCost[p,d]) >= 1;

#data-------------------------------------
data Group8-HW3-p3.dat

#commands---------------------------------
solve; # solve the minimize totalProcedureCost

#spaces
printf "\n\n";

# display which doctor is chosen for the procedure at what cost
for {p in PROCEDURE} {
	for {d in DOCTOR} {
		if x[p,d] * procedureCost[p,d] > 0 then
			printf "For the procedure %s, we will need %s. The cost: $%0.2f \n", p, d, x[p,d] * procedureCost[p,d];		
	}
}
printf "\n"; #space

# display the total cost of covering all procedures
printf "The minimum of total procedure cost: $%0.2f \n", totalProcedureCost;

#spaces
printf "\n\n";