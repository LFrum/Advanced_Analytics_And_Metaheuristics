#Rumainum
#Final

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#parameters and sets-----------------------------------------------
set J; # set of segments

# parameter variables:
# u - the maximum number of officers that can be assigned at that segment  
# s - the expected number of speeders per officer at that segment
param s {J} >= 0;
param u {J} >= 0;
param c {J} >= 0;

param maxAvailOfficer >= 0;
param maxCaptainTime >= 0;

#decision variables-------------------------------------------------------------
var y {j in J} >= 0 integer; #total number of officers assigned at the segment


#objective: -----------------------------------------
maximize totalSpeeders: sum {j in J} y [j] * s[j];

#constraints:-------------------------------------------------------------------
# maximum number of officer that can be assigned at each segment
subject to maxAssignedOfficer{j in J}:  y [j] <= u[j];

#total number of officers available to be assigned at all segment
subject to maxTotalOfficer: sum {j in J} y [j] <= maxAvailOfficer;

#data-------------------------------------
data final-p1.dat;

#commands---------------------------------
solve;

#Print out solution
#spaces
printf "\n\n";
# display how many officers and the total speeders per segment
for {j in J} {
	printf "At %s: \n", j;
	printf "Total number of officer assigned: %2.0f \n", y[j];
	printf "Total number of speeders caught : %2.0f \n", y[j]*s[j];		
	printf "\n";
}	
printf "\n";

# display total officers assigned and the total speeders for all segments
printf "total number officers for all segments: %3.0f \n", sum {j in J} y [j];
printf "total number speeders for all segments: %3.0f \n", totalSpeeders;

#spaces
printf "\n\n";
