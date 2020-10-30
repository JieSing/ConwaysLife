{ ------Word (Simulate_densities) will run a given number of simulations for random_cell maps of densities 0 to 99-------- }
{ -------------------------and will write the lifetimes of the cell maps into a text file--------------------------------- }
variable density_textfile					{ Variable holds the textfile's file id }
1 constant Number_of_measurements				{ The number of measurements of the lifetime in the experiment }

: make_density_file ( -- )					{ Create the textfile }                            
  s" C:\Users\Harry\Documents\My documents\Third year\Laboratory work\Conway's life\Conway's life code\cell map statistics\Density_data.txt" r/w create-file drop  
  density_textfile ! ; 						{ The location that the textfile will be written in is above }             

: close_density_file ( -- ) density_textfile @ close-file drop ; 	{ closes the textfile }

: Iterate_simulation ( -- ) reset_game random_pattern			{ This word iterates the cell map until a stable state is reached }
begin 1 generation +! 0 alive_cell_num ! next_gen swap_array reset_temp_array  	{ Iterates a generation }
Measure_if_stable_state
stable_pattern @ 90 = until ;							{ The simulation ends when a stable state is reached }

{ Simulates random_pattern cell maps using densities 0 to 99, with Number_of_measurements measurements per density, and writes the }
{ lifetime of the cell map of each measurement into a textfile }
: Simulate_densities ( -- ) make_density_file 
 
s" Density" density_textfile @ write-file drop    				{ Write the headers for the textfile }
s"  " density_textfile @ write-file drop s" Lifetime" density_textfile @ write-line drop

100 1 do i . i density ! 					{ Iterate through densities 0 to 99 }
density @ (.) density_textfile @ write-file drop				{ Write the density into the textfile }
s"  " density_textfile @ write-file drop 	
Number_of_measurements 0 do Iterate_simulation							{ Take number_of_measurements for each density }
s" ," density_textfile @ write-file drop generation @ 90 - (.) density_textfile @ write-file drop	{ Take 90 away due to stable state calculation }
0 generation ! 0 stable_pattern ! loop s"  " density_textfile @ write-line drop loop close_density_file ;


{ Simulates random_pattern cell maps of a single given density, with Number_of_measurements measurements and writes it into a textfile }
: Measure_single_density ( -- ) make_density_file 

s" Iteration" density_textfile @ write-file drop    				{ Write the headers for the textfile }
s"  " density_textfile @ write-file drop s" Lifetime" density_textfile @ write-line drop

Number_of_measurements 0 do Iterate_simulation 
i (.) density_textfile @ write-file drop
s"  " density_textfile @ write-file drop generation @ 90 - (.) density_textfile @ write-line drop	{ Take 90 away due to stable state calculation }
0 generation ! 0 stable_pattern ! loop close_density_file ;