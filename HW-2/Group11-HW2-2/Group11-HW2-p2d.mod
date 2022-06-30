#Group11 - Rumainum & Haddad
#HW 2
#AMPL model file for Problem 2-2d
#Titan Enterprising Case Study

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;
option cplex_options 'sensitivity';

#------------------------Set & Parameters------------------------
set PROJECT; # set of the project investments (including Banks)

param maxInvestment{PROJECT}  >= 0; #maximum amount of investment for each project 
param secondYearRate{PROJECT} >= 0; #the rate of return for each project in 2022
param thirdYearRate{PROJECT}  >= 0; #the rate of return for each project in 2023
param fourthYearRate{PROJECT} >= 0; #the rate of return for each project in 2024
param initalInvestment 		  >= 0; #the initial investment in 2021

#------------------------Decision Variables------------------------
var x{PROJECT} >=0; #total amount invested in each project

#------------------------Objective Function------------------------
#maximizing the total return in 2024
maximize totaReturn: sum {p in PROJECT} (fourthYearRate[p] * x[p]);
#maximize totaReturn: sum {p in PROJECT} (secondYearRate[p] * x[p])+
#	sum {p in PROJECT} (thirdYearRate[p] * x[p])+
#	sum {p in PROJECT} (fourthYearRate[p] * x[p]);

#------------------------Constraints------------------------
#The total of investment for available projects has to be equal to 1 million in 2021  
subject to FirstYearInvestment: x['BANK_2021'] + x['A'] + x['C'] + x['D'] + x['F'] + x['G'] = initalInvestment;

#the throw-off from 2021 needs to equal the amount of project B + the bank
subject to SecondYearInvestmentReturn: sum {p in PROJECT} (secondYearRate[p] * x[p]) = x['B'] + x['BANK_2022'] ;

#the throw-off from 2022 needs to equal the amount of project E + the bank
subject to ThirdYearInvestmentReturn:  sum {p in PROJECT} (thirdYearRate[p] * x[p]) = x['E'] + x['BANK_2023'];

#Maximum amount that can be invested in a project
subject to projectMaxInvestment {p in PROJECT}: x[p] <= maxInvestment[p];

#------------------------Data-----------------------
data Group11-HW2-p2d.dat;

#------------------------Commands------------------------
#solve the LP problem
solve;

#display investment of each project
printf "\n\n";
printf "-----Solution for the Total investment of each project-----";
printf "\n";
for {p in PROJECT} {
	printf "\n Investment amount for %9.9s: $%0.2f", p, x[p];
}

#display
printf "\n\n";
printf "Without the rate of return, \n";
printf "the total investment for all projects: $%0.2f", 
	sum {p in PROJECT} (x[p]);
printf "\n";

printf "\n";
printf "The total investment with the return rate at end of 2022: $%0.2f", 
	sum {p in PROJECT} (secondYearRate[p] * x[p]);
printf "\n\n";

printf "The total investment with the return rate at end of 2023: $%0.2f", 
	sum {p in PROJECT} (thirdYearRate[p] * x[p]);
printf "\n\n";

printf "The total investment with the return rate at end of 2024: $%0.2f", 
	sum {p in PROJECT} (fourthYearRate[p] * x[p]);
printf "\n\n";

printf "The total amount made from all the return rates at end of 2024: $%0.2f", 
	sum {p in PROJECT} (secondYearRate[p] * x[p])+
	sum {p in PROJECT} (thirdYearRate[p]  * x[p])+
	sum {p in PROJECT} (fourthYearRate[p] * x[p]);
printf "\n\n";

printf "Each project's investment, current rate of returns, shadow prices and reduce cost: \n";
display x, x.current, x.up, x.down, x.rc;
printf "\n\n";
