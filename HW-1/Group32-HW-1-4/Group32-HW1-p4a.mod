#Group32 - Rumainum & Navarrete
#HW 1
#AMPL model file for Problem 1-4a
#Advertising

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#------------------------Parameters------------------------
param budget >= 0;	  # Advertising budget for new product
param tv_cpm >= 0;	  # Cost per minute for TV ads
param tv_reach >= 0;  # Potential customers for TV ads
param mag_cpp >= 0;	  # Cost per page for magazine ads
param mag_reach >= 0; # Potential customers for mag ads
#added for part b & c
param tv_person_weeks >= 0;  # Number of person-weeks to create a tv minute
param mag_person_weeks >= 0; # Number of person-weeks to create a magazine page
param person_weeks_available >= 0; # Max person-weeks available
#added for part c
param radio_cpm >= 0;   # Cost per minute for radio ads
param radio_reach >= 0; # Potential customers for radio ads
param radio_person_weeks >= 0; # Number of person-weeks to create a radio minute

#------------------------Decision Variables------------------------
var tv_minutes >= 0; # Number of TV minutes to buy
var mag_pages  >= 0; # Number of magazine pages to buy

#------------------------Objective Function------------------------
maximize Audience: tv_reach * tv_minutes + mag_reach * mag_pages;

#------------------------Constraints------------------------
# Spending advertisement within the budget
subject to Ad_Budget : tv_minutes * tv_cpm + mag_pages * mag_cpp <= budget;
# Minimum number of TV minutes
subject to Min_TV_Minutes : tv_minutes >= 10;

#------------------------Data-----------------------
data Group32-HW1-p4.dat;

#------------------------Commands------------------------
solve;

#Print solutions
printf "-----Solution Question 4a: maximize audience at $%0.2f million budget----- \n", budget/1000000;

printf "\n";
printf "Potential customers reached: %d million. \n", Audience/1000000;

printf "\n";
printf "This is achieved by advertising in: \n";
printf " %d TV minutes\n", tv_minutes;
printf " %d magazine pages\n", mag_pages;

printf "\n";
printf "Cost by advertising in: \n";
printf " TV      : %0.2f million \n", tv_minutes * tv_cpm /1000000;
printf " Magazine: %0.2f million \n", mag_pages * mag_cpp /1000000;
