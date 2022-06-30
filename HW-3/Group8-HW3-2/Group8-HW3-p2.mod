#Group8 - Rumainum & Vance
#HW 3
#AMPL model file for Problem 3-2
#We Got Gas!
#reset ampl-------------------------------------------------------------------
reset;
option solver cplex;

###params
#L of gas to store
param A = 75000;
param B = 50000;
param C = 25000;
param D = 80000;
param E = 20000;

#individual costs
param T1_A = 1;
param T1_B = 2;
param T1_C = 3;
param T1_D = 1;
param T1_E = 1;
param T2_A = 2;
param T2_B = 3;
param T2_C = 4;
param T2_D = 1;
param T2_E = 1;
param T3_A = 2;
param T3_B = 3;
param T3_C = 1;
param T3_D = 2;
param T3_E = 1;
param T4_A = 1;
param T4_B = 3;
param T4_C = 2;
param T4_D = 2;
param T4_E = 1;
param T5_A = 4;
param T5_B = 1;
param T5_C = 1;
param T5_D = 3;
param T5_E = 1;
param T6_A = 4;
param T6_B = 4;
param T6_C = 4;
param T6_D = 4;
param T6_E = 1;
param T7_A = 5;
param T7_B = 5;
param T7_C = 5;
param T7_D = 5;
param T7_E = 5;
param T8_A = 3;
param T8_B = 2;
param T8_C = 1;
param T8_D = 2;
param T8_E = 5;

###vars
#tank capacity
var T1A;
var T1B;
var T1C >= 0;
var T1D >= 0;
var T1E >= 0;
var T2A >= 0;
var T2B >= 0;
var T2C >= 0;
var T2D >= 0;
var T2E >= 0;
var T3A >= 0;
var T3B >= 0;
var T3C >= 0;
var T3D >= 0;
var T3E >= 0;
var T4A >= 0;
var T4B >= 0;
var T4C >= 0;
var T4D >= 0;
var T4E >= 0;
var T5A >= 0;
var T5B >= 0;
var T5C >= 0;
var T5D >= 0;
var T5E >= 0;
var T6A >= 0;
var T6B >= 0;
var T6C >= 0;
var T6D >= 0;
var T6E >= 0;
var T7A >= 0;
var T7B >= 0;
var T7C >= 0;
var T7D >= 0;
var T7E >= 0;
var T8A >= 0;
var T8B >= 0;
var T8C >= 0;
var T8D >= 0;
var T8E >= 0;
#cost for each tank
var T1 = T1A*T1_A + T1B*T1_B + T1C*T1_C + T1D*T1_D + T1E*T1_E;
var T2 = T2A*T2_A + T2B*T2_B + T2C*T2_C + T2D*T2_D + T2E*T2_E;
var T3 = T3A*T3_A + T3B*T3_B + T3C*T3_C + T3D*T3_D + T3E*T3_E;
var T4 = T4A*T4_A + T4B*T4_B + T4C*T4_C + T4D*T4_D + T4E*T4_E;
var T5 = T5A*T5_A + T5B*T5_B + T5C*T5_C + T5D*T5_D + T5E*T5_E;
var T6 = T6A*T6_A + T6B*T6_B + T6C*T6_C + T6D*T6_D + T6E*T6_E;
var T7 = T7A*T7_A + T7B*T7_B + T7C*T7_C + T7D*T7_D + T7E*T7_E;
var T8 = T8A*T8_A + T8B*T8_B + T8C*T8_C + T8D*T8_D + T8E*T8_E;


###objective
minimize cost: T1 + T2 + T3 + T4 + T5 + T6 + T7 + T8;

###constraints
#storage space per tank
subject to T_1: T1 <= 25000;
subject to T_2: T2 <= 25000;
subject to T_3: T3 <= 30000;
subject to T_4: T4 <= 60000;
subject to T_5: T5 <= 80000;
subject to T_6: T6 <= 85000;
subject to T_7: T7 <= 100000;
subject to T_8: T8 <= 50000;

#amount of gas to be stored per gas type
subject to TA: T1A + T2A + T3A + T4A + T5A + T6A + T7A + T8A = 75000;
subject to TB: T1B + T2B + T3B + T4B + T5B + T6B + T7B + T8B = 50000;
subject to TC: T1C + T2C + T3C + T4C + T5C + T6C + T7C + T8C = 25000;
subject to TD: T1D + T2D + T3D + T4D + T5D + T6D + T7D + T8D = 80000;
subject to TE: T1E + T2E + T3E + T4E + T5E + T6E + T7E + T8E = 20000;



solve;
display T1, T2, T3, T4, T5, T6, T7, T8;
