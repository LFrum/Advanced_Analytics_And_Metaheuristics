#Exam 1
#Lince Rumainum
#AMPL model file for Problem 4
#Work Crews

#reset ampl-------------------------------------------------------------------
reset;

#option solver cplex;

#---CODES FROM mcnfp.txt 
# AMPL model for the Minimum Cost Network Flow Problem
#
# By default, this model assumes that b[i] = 0, c[i,j] = 0,
# l[i,j] = 0 and u[i,j] = Infinity.
#
# Parameters not specified in the data file will get their default values.

#options----------------------------------------------------------------------
option solver cplex;

set NODES;                        # nodes in the network
set ARCS within {NODES, NODES};   # arcs in the network 

param b {NODES} default 0;        # supply/demand for node i
param c {ARCS}  default 0;        # cost of one of flow on arc(i,j)
param l {ARCS}  default 0;        # lower bound on flow on arc(i,j)
param u {ARCS}  default Infinity; # upper bound on flow on arc(i,j)

var x {ARCS};                     # flow on arc (i,j)
 
minimize cost: sum{(i,j) in ARCS} c[i,j] * x[i,j];  #objective: minimize arc flow cost

# Flow Out(i) - Flow In(i) = b(i)

subject to flow_balance {i in NODES}:
sum{j in NODES: (i,j) in ARCS} x[i,j] - sum{j in NODES: (j,i) in ARCS} x[j,i] = b[i];

subject to capacity {(i,j) in ARCS}: l[i,j] <= x[i,j] <= u[i,j];

#--- END CODES FROM mcnfp.txt 

#DATA -----------------------------------------------------
data Lince_Rumainum_Exam1_p4.dat;

#commands---------------------------------
solve; # solve the objective 

#display the minimum cost of doing all of the projects
printf "\n";
printf "The minimum cost is $%0.2f \n", cost*1000;
printf "\n";

#display the flow path of the network
printf "The flow path taken to minimize the cost: \n";
display x;
printf "\n";
printf "The above data mean, the flow path taken to  minimize the cost are: \n";
for {(i,j) in ARCS}{
	if x[i,j] > 0 then printf "%s -----> %s \n", i, j;
}

printf "\n\n"; #spaces

#display cost for the selected crews doing each projec
printf "The cost for the selected crews doing each project: \n";

for {(i,j) in ARCS}{
	if x[i,j] > 0 and j != "DUMMY" then printf "%s will work on %s for $%8.2f \n", i, j, c[i,j]*1000;
}
  


