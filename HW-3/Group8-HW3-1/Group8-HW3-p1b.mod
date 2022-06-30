#Group8 - Rumainum & Vance
#HW 3
#AMPL model file for Problem 3-1 part b
#Boomer Sooner Air Services (BSAS)

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#parameters and sets-----------------------------------------------
set AIRPORT; # set of airports

# parameter variables:
# fuelBurn  		 - amount of fuel when traveling into that airport 
# fuelPrice 	   	 - price of fuel at that airport
# rampFee 	   		 - ramp fee of that airport
# minGallonPurchased - minimum amount of fuel (in gallons) purchased to waive ramp fee
# minLandingFuel	 - minimum amount of fuel needed
# passengers 		 - number of passengers
# tankCapacity		 - fuel tank capacity (in pounds)
# maxRampWeight		 - maximum ramp weight (in pounds)
# maxLandingWeight	 - maximum landing weight (in pounds)
# BOW				 - weight of Basic Operating Weight (BOW) (in pounds)
# fuelTankCap		 - maximum Fuel Tank Capacity (in pounds)
# avePassWeight		 - average weight per person with lagguge (in pounds)
# fuelWeightInLbs	 - gallon to pound conversion rate for jet fuel

param fuelBurn {AIRPORT} 				>= 0;
param fuelPrice {AIRPORT} 				>= 0;
param rampFee {AIRPORT} 				>= 0;
param minPurchasedToWaiveFee {AIRPORT}  >= 0;
param minLandingFuel {AIRPORT} 			>= 0;
param passengers {AIRPORT} 				>= 0;

param tankCapacity 	    >= 0;
param maxRampWeight     >= 0; 
param maxLandingWeight  >= 0; 
param BOW 				>= 0;
param fuelTankCap    	>= 0;
param avePassWeight   	>= 0;
param fuelWeightInLbs 	>= 0;

#decision variables-------------------------------------------------------------
var fuelPurchaseQty  {a in AIRPORT} >= 0;   #fuel purchased (in gallon)
var fuelInventory	 {a in AIRPORT} >= 0;   #fuel invetory (in pounds)

#0 - waived fee , 1 - fee charged
var rampFeeIndicator {a in AIRPORT} binary; #ramp fee indicator
# constant for the Disjunctive constraints
param M = 10000;

#whether or not fuel is purchased at that airport
var fuelBuyIndicator {a in AIRPORT} binary; #added for part b

#objective: minimum cost fuel plan-----------------------------------------
minimize totalFuelPlanCost: sum {a in AIRPORT} fuelPurchaseQty[a] * fuelPrice [a] + sum {a in AIRPORT} rampFee[a] * rampFeeIndicator[a];

#constraints:-------------------------------------------------------------------
# Initial inventory at KCID - start 
subject to KCID1inventory: fuelInventory['KCID1'] = 0;
# Initial purchase - need to start with 7000 lbs of fuel
subject to fuelPurchaseAtKCID1: fuelPurchaseQty['KCID1'] >= 7000/fuelWeightInLbs; 

# fuel flows contraints 
#separte fuel flow to each leg instead
subject to fuelKCID2KACK: fuelInventory['KCID1'] + fuelPurchaseQty['KCID1']*fuelWeightInLbs >= fuelBurn['KACK'] + fuelInventory['KACK'];
subject to fuelKACK2KMMU: fuelInventory['KACK']  + fuelPurchaseQty['KACK']*fuelWeightInLbs  >= fuelBurn['KMMU'] + fuelInventory['KMMU'];
subject to fuelKMMU2KBNA: fuelInventory['KMMU']  + fuelPurchaseQty['KMMU']*fuelWeightInLbs  >= fuelBurn['KBNA'] + fuelInventory['KBNA'];
subject to fuelKBNA2KTUL: fuelInventory['KBNA']  + fuelPurchaseQty['KBNA']*fuelWeightInLbs  >= fuelBurn['KTUL'] + fuelInventory['KTUL'];
subject to fuelKTUL2KCID: fuelInventory['KTUL']  + fuelPurchaseQty['KTUL']*fuelWeightInLbs  >= fuelBurn['KCID2'] + fuelInventory['KCID2'];

# minimum fuel inventory
subject to minFuelInventory{a in AIRPORT}: fuelInventory[a] >= minLandingFuel[a];

# maximum Ramp Weight
subject to rampWeight {a in AIRPORT}: passengers[a]*avePassWeight + BOW + fuelInventory[a] + fuelPurchaseQty[a]*fuelWeightInLbs <= maxRampWeight;
# maximum Landing Weight
subject to landingWeight {a in AIRPORT}: passengers[a]*avePassWeight + BOW + fuelInventory[a] <= maxLandingWeight;
# maximum tank capacity
subject to fuelTankCapacity{a in AIRPORT}: fuelInventory[a] + fuelPurchaseQty[a]*fuelWeightInLbs <= fuelTankCap;

#the Disjunctive constraints for the ramp fee
subject to waivedRampFee{a in AIRPORT}  : minPurchasedToWaiveFee[a] - fuelPurchaseQty[a] <= minPurchasedToWaiveFee[a]*rampFeeIndicator[a];
subject to chargingRampFee{a in AIRPORT}: fuelPurchaseQty[a] >= minPurchasedToWaiveFee[a]*(1-rampFeeIndicator[a]); 

#---- ADDED CONSTRAINT FOR PART B ----
#no fuel purchased at KTUL2 
subject to FuelAtKCID2: fuelPurchaseQty['KCID2'] = 0;
#must buy at least 200 gallons
#not working
#subject to minFuelIfPurchased{a in AIRPORT} :fuelPurchaseQty[a]*fuelBuyIndicator[a] >= 200;
#seperate to each airport
subject to minFuelBuyAtKCID1:fuelPurchaseQty['KCID1']*fuelBuyIndicator['KCID1'] >= 200;
subject to minFuelBuyAtKACK:fuelPurchaseQty['KACK']*fuelBuyIndicator['KACK'] >= 200;
subject to minFuelBuyAtKMMU:fuelPurchaseQty['KMMU']*fuelBuyIndicator['KMMU'] >= 200;
subject to minFuelBuyAtKBNA:fuelPurchaseQty['KBNA']*fuelBuyIndicator['KBNA'] >= 200;
subject to minFuelBuyAtKTUL:fuelPurchaseQty['KTUL']*fuelBuyIndicator['KTUL'] >= 200;
#--- END OF PART B----

#data-------------------------------------
data Group8-HW3-p1.dat

#commands---------------------------------
solve; # solve the minimum cost fuel plan

#spaces
printf "\n\n";

# display how much fuel purchased and its cost and ramp fee (if applicable) 
for {a in AIRPORT} {
	printf "At %s airport: \n", a;	
	if fuelInventory[a] > 0 then
		printf "Fuel inventory: %0.2f pounds (%0.2f gallon) \n", 
			fuelInventory[a], fuelInventory[a]/fuelWeightInLbs; 
	if fuelPurchaseQty[a] > 0 then
		printf "Purchasing fuel %0.2f pounds (%0.2f gallon) cost: $%0.2f \n",
			fuelPurchaseQty[a] * fuelWeightInLbs, fuelPurchaseQty[a], 
			fuelPurchaseQty[a] * fuelPrice [a];
	if rampFeeIndicator[a] > 0 then
		printf "Fuel purchased < %3.0f gallons. Ramp fee charged: $%0.2f \n",minPurchasedToWaiveFee[a], rampFee[a]; 
	#if rampFeeIndicator[a] > 0 then
	#	printf "Ramp fee charged: $%0.2f \n", rampFee[a]; 
	printf "\n"; #space	
}
printf "\n"; #space

# display the total cost of covering all procedures
printf "The minimum of fuel plan cost: $%0.2f \n", totalFuelPlanCost;

#spaces
printf "\n\n";
