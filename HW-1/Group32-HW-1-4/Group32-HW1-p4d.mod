#Group32 - Rumainum & Navarrete
#HW 1
#AMPL model file for Problem 1-4d
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
var tv_minutes >= 0; 	# Number of TV minutes to buy
var mag_pages  >= 0; 	# Number of magazine pages to buy
var radio_minutes >= 0; # Number of radio minutes to buy

#------------------------Objective Function------------------------
maximize Audience: tv_reach * tv_minutes + mag_reach * mag_pages + radio_reach * radio_minutes;

#------------------------Constraints------------------------
# Spending advertisement within the budget
subject to Ad_Budget : tv_minutes * tv_cpm + mag_pages * mag_cpp + radio_minutes * radio_cpm <= budget;
# Minimum number of TV minutes
subject to Min_TV_Minutes : tv_minutes >= 10;
# Total creative talent that will be working on the advertising 
subject to Total_Person_Working : tv_minutes * tv_person_weeks + mag_pages * mag_person_weeks + radio_minutes * radio_person_weeks <= person_weeks_available;
# Minimum pages to do advertising on the magazine
subject to Min_Magazine_Page : mag_pages >= 2;
# Maximum minutes to do advertising on the radio minutes
subject to Max_Radio_Minutes : radio_minutes <= 120;

#------------------------Data-----------------------
data Group32-HW1-p4.dat;

#------------------------Commands------------------------
solve; #solve the LP problem

#Print solutions
printf "-----Solution Question 4d: adding magazine and radio constraints----- \n";

printf "\n";
printf "Potential customers reached: %d million. \n", Audience/1000000;

printf "\n";
printf "This is achieved by advertising in: \n";
printf " %d TV minutes\n", tv_minutes;
printf " %d magazine pages\n", mag_pages;
printf " %d radio minutes\n", radio_minutes;

printf "\n";
printf "Cost by advertising in: \n";
printf " TV      : %0.2f million \n", tv_minutes * tv_cpm /1000000;
printf " Magazine: %0.2f million \n", mag_pages * mag_cpp /1000000;
printf " Radio   : %0.2f million \n", radio_minutes * radio_cpm /1000000;
