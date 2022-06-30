#Exam 1
#Lince Rumainum
#AMPL model file for Problem 2
#Post COVID Party Planning

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;
option cplex_options 'sensitivity';

#parameters and sets----------------------------------------------------------
# Type of ingredients
set INGREDIENTS;
# Products that will be produced from mixing the ingredients
# BevA  - Beverage A
# BevB  - Beverage B
# Waste - Toxic Waste By-Product
set PRODUCTS;

# Costs per liter to buy each ingredients (in dollar)
param cost {INGREDIENTS} >= 0;
# Cost per liter of disposal fee to dispose the toxic waste
param disposalFee >= 0;
# Money available to spend to buy the ingredients (in dollar)
param maxSpending >= 0;

#decision variables-------------------------------------------------------------
# the amount of ingredients to buy (in liters)
var x{i in INGREDIENTS} >= 0;
# the amount of products that can be produced from the mixed ingredients (in liters)
var y{p in PRODUCTS} >= 0;

#objective: maximize amount of Beverages to make---------------------------------
maximize totalBeverages: y['BevA'] + y['BevB'];

#constraints:-------------------------------------------------------------------
#amount of type 1 ingredient AT LEAST 45% of the mix
subject to MinAmountOfType1ingredient: x[1] >= 0.45 * sum {i in INGREDIENTS} x[i];
#amount of type 2 ingredient AT LEAST 10% of the mix
subject to MinAmountOfType2ingredient: x[2] >= 0.10 * sum {i in INGREDIENTS} x[i];
#amount of type 3 ingredient NO MORE THAN 30% of the mix 
subject to MaxAmountOfType3ingredient: x[3] <= 0.30 * sum {i in INGREDIENTS} x[i];

#amount of Beverage A produced is EXACTLY 40% of the mix
subject to BevAProduced: y['BevA'] = 0.40 * sum {i in INGREDIENTS} x[i];
#amount of Beverage B produced is EXACTLY 25% of the mix
subject to BevBProduced: y['BevB'] = 0.25 * sum {i in INGREDIENTS} x[i];
#amount of Toxic Waste by-product is EXACTLY 35% of the mix
subject to ToxicWasteProduced: y['Waste'] = 0.35 * sum {i in INGREDIENTS} x[i];

#budget
subject to budget: disposalFee * y['Waste'] + sum {i in INGREDIENTS} x[i]*cost[i] <= maxSpending;

#data-------------------------------------
data Lince_Rumainum_Exam1_p2.dat;

#commands---------------------------------
solve; # solve to maximize total amount of beverages 

#spaces
printf "\n\n";

# display the total amount of each ingredients 
printf "Total amount of each ingredients \n";
for {i in INGREDIENTS} {
	printf " Ingredient %s: %7.4f liters \n", i, x[i]; 
}
printf "\n"; #space
# display total amount of ingredients
printf "Total amount of ingredients: %0.4f liters \n",sum {i in INGREDIENTS} x[i];

printf "\n\n";#spaces
#display y;
printf "Total amount of each Beverage: \n";
for {p in PRODUCTS} {
	if p != 'Waste' then printf " %s: %6.4f liters \n", p, y[p]; 
}
printf "\n"; #space
# display total amount of beverages produced
printf "Total amount of consumable products   : %7.4f liters \n", y['BevA'] + y['BevB'];

# display total amount of toxic waste
printf "Total amount of Toxic Waste by-product: %7.4f liters \n", y['Waste']; 

printf "\n\n"; #spaces

# display total costs of ingredients and disposal fee
printf "Total cost of all ingredients: $%6.2f \n",sum {i in INGREDIENTS} x[i]*cost[i];
printf "Total cost of disposal fee   : $%6.2f \n",disposalFee * y['Waste'];

printf "\n\n"; #spaces

#---FOR PART C
#display the shadow price of the budget constraint and its range of feasibility
display budget, budget.up, budget.down;

