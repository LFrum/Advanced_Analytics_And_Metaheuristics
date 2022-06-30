#Exam 1
#Lince Rumainum
#AMPL model file for Problem 5
#Mix Tape

#reset ampl-------------------------------------------------------------------
reset;

#options----------------------------------------------------------------------
option solver cplex;

#parameters and sets----------------------------------------------------------
set SIDES; # Side of the mix tape
set SONGS; # Songs available to put on the mix tape

param length {SONGS} >= 0; # tape length for each song (in cm)

#decision variables-------------------------------------------------------------
# whether or not the song is chosen and for which side of the mix tape
var x{side in SIDES, song in SONGS} binary;

#objective: minimize the length of the mix tape 
#		by minimize the length of side A--------------------------------------
minimize totalLengthOfTape: sum {song in SONGS} x['A',song]*length[song];

#constraints:-------------------------------------------------------------------
# the total length of side A added to total length of side B HAVE TO BE EQUAL TO the total length of all songs available
subject to totalLength: sum {song in SONGS} x['A',song]*length[song] + sum {song in SONGS} x['B',song]*length[song] = sum {song in SONGS} length[song];
# the side A of the mix tape need to be GREATER THAN the total length of all songs available
subject to sideAsLength: sum {song in SONGS} x['A',song]*length[song] >= (1/2) * sum {song in SONGS} length[song];
# if the song is on side A then it can't be on side B
subject to pickAllSong{song in SONGS}: x['A',song] + x['B',song] <= 1;

#data-------------------------------------
data Lince_Rumainum_Exam1_p5.dat;

#commands---------------------------------
solve; # solve to minimize the total length of the tape

#spaces
printf "\n\n";

#Display the optimal objective solution
printf "The shortest total tape length for the mix tape: %d cm \n", totalLengthOfTape;

#spaces
printf "\n\n";

# display 
for {side in SIDES} {
	printf "Songs on Side %s: \n", side;
	for {song in SONGS} {
		#display the songs that chosen for this side of the tape and its length 
		if x[side, song] > 0 then printf "Song %2.0d with tape length: %2.0d cm \n", song, length[song];
	}
	printf "\n"; #space
	#Display the total length of each side of the tape
	printf "Total length for Side %s: %d cm \n", side, sum {song in SONGS} x[side,song]*length[song];
	printf "\n\n"; #spaces
}

