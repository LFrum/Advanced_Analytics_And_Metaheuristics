#Group32 - Rumainum & Navarrete
#HW 1
#AMPL model file for Problem 1-3 Part a
#Portfolio Selection 

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#parameters and sets----------------------------------------------------------
set BOND; #set of bonds names

# parameter variables:
# gov  				   - true if bond type is government/agency 
# yieldToMaturity 	   - yield to maturity
# afterTaxYield 	   - after-tax yield
# qualityCoeff 		   - bank's quality coefficient
# yearsToMaturityCoeff - years to maturity's coefficient

param yieldToMaturity{BOND} 	>= 0; # yield to maturity of bond i in BOND
param afterTaxYield{BOND}    	>= 0; # after-tax yield of bond i in BOND
param qualityCoeff{BOND}; 	      	  # bank's quality coefficient  of bond i in BOND
param yearsToMaturityCoeff{BOND};     # year to maturity coefficient of bond i in BOND
param isGov{BOND}				>= 0; # indicator if bond type is government/agency
param maxInvestment 			>= 0; # maximum invesment (in millions)
param minGovAg					>= 0; # minimum Government & Agency bonds (in millions)
#added for part b
param loanAfterTaxRate			<= 0; # the after-tax rate for the loan

#decision variables-------------------------------------------------------------
var investment{BOND} >= 0; #investment amount of each bond i in BOND

#objective: maximize after-tax earnings-----------------------------------------
maximize totalEarnings: sum {i in BOND} (afterTaxYield[i]*investment[i]); #in million(s)

#constraints:-------------------------------------------------------------------
#Total invesment up to $10 million
subject to Total_Investment: sum{i in BOND} investment[i] <= maxInvestment;

#Bond types: Government and agency, have total investomet of at least $4 million
subject to Total_GovAgency: sum{i in BOND} (investment[i]*isGov[i]) >= minGovAg;

#The average quality of the portfolio cannot exceed 1.4 on the bank’s quality scale
#It's set to <= 0 since the coefficient of bank's quality scale is already calculated
subject to AverageQualityOfBanksQualityScale : sum{i in BOND} qualityCoeff[i] * investment[i] <= 0;

#The average years to maturity of the portfolio must not exceed 5 years
#It's set to <= 0 since the coefficient of years to maturity is already calculated
subject to AverageYearsToMaturityCoeff : sum{i in BOND} yearsToMaturityCoeff[i] * investment[i] <= 0;

#data-------------------------------------
data Group32-HW1-p3.dat

#commands---------------------------------
solve; # solve the maximize totalEarnings

printf "\n";
# display optimal solution for all investments
for {b in BOND} {
	printf "The amount of investment for Bond %s: %0.4f million \n", b, investment[b];
}
printf "\n";
