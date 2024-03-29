{ ---------------------Conway's life ------------------------------- }
{ -------------------By Harry and Jie Sing-------------------------- }
{ ------------------requires rnd file------------------------------- }


{ ---------------- Define constants and variables------------------- }

{ ----These constants can be changed to vary the width and height of the cell map }
10 constant height 				{ Changing height and width will change the cell map's dimensions }
10 constant width
variable length
height width * length !				 { Length is the total amount of numbers }

{ ----This controls the density of the cell map when using random_fill }
variable density 50 density !

{ ----These variables and words are used to stop the simulation when a stable state is reached }
variable stable_pattern 0 stable_pattern ! 	{ Determines how many generations the pattern is stable }
variable alive_cell_num 0 alive_cell_num ! 	{ Counts the number of alive cells in a generation }
variable previous_alive_cell_num 0 previous_alive_cell_num ! 	{ Counts the number of alive cells in the previous generation }

: reset_game ( -- ) 0 stable_pattern ! ; 	{ Must set stable_pattern to zero to allow the simulation ran more than once }

create recent_alive_cell_num 30 chars allot 	{ Creates an array of the number of alive cells in the 30 most recent generations }
recent_alive_cell_num 30 0 fill

{ These variables and words calculate the maximum and minimum number of alive cells in 30 most recent generations }
{ If the maximum and miniumum values for the 30 most recent generations are constant for 90 generations then the simulation is stable }
variable minimum_element 0 minimum_element ! 	{ The following 4 words hold the maximum and minimum values of the array recent_alive_cell_num }		
variable previous_minimum_element 0 previous_minimum_element !
variable maximum_element 0 maximum_element !
variable previous_maximum_element 0 previous_maximum_element !

variable array_iteration 0 array_iteration ! 	{ This variable is required to give array recent_alive_cell_num has the 30 most recent generations }

{ These words give the maximum and miniumum values of a 30 element array }
: Find_min ( -- n ) recent_alive_cell_num c@ 30 1 do i recent_alive_cell_num + c@ min loop minimum_element ! ;
: Find_max ( -- n )recent_alive_cell_num c@ 30 1 do i recent_alive_cell_num + c@ max loop maximum_element ! ;


{ --These variables measure statistics of the Conway's life somulation }
variable generation 0 generation ! 		{ Used to count the number of generations in a simulation }	
: run_time ( -- n ) counter swap - ; 		{ Adds the run time of a word to the stack (must be used with counter)}


{ --This variable is used to control whether the edges are wrapped or are closed }
variable wrapped_edges 1 wrapped_edges ! { Edges are initially wrapped (1) instead of closed (0) }


{ ------------Create arrays to hold the cell map----------------------- }
create current_array length chars allot 	{ 2 arrays are used to hold the cell map - current_array and temp_array }
create temp_array length chars allot		{ The size of these arrays is equal to height * width }

{ Set the elements in both arrays to 0 }
: reset_array ( -- ) current_array length 0 fill ; 
: reset_temp_array ( -- ) temp_array length 0 fill ;
reset_array
reset_temp_array 


{ ---------------Function to clear the stack----------------------- }
: clearstack ( -- ) depth 0 = invert if depth 0 do i drop drop loop then ;


{ ----------Words to change and read the array elements------------ }
{ Words for current_arrray }
: Array_@ ( n1 n2 -- n3 ) width * + current_array + c@ ; 				{ Lets you read element x y of current_array }
: Array_! ( n1 n2 n3 -- ) width * + current_array + c! ; 				{ Changes the value of element x y in current_array to n1 }
: show_current_array ( -- ) cr width 0 do height 0 do i j Array_@ 5 u.r loop cr loop ; 	{ prints the contents of current_array }

{ Words for temp_array }
: Array_temp_@ ( n1 n2 -- n3 ) width * + temp_array + c@ ; 				{ Lets you read element x y of temp_array }
: Array_temp_! ( n1 n2 n3 -- ) width * + temp_array + c! ; 				{ Changes the value of element x y to n1 }
: Array_temp_add ( n1 n2 n3 -- ) over over Array_temp_@ 3 pick + rot rot Array_temp_! drop ; { Adds n1 to element x y }
: show_temp_array ( -- ) cr width 0 do height 0 do i j Array_temp_@ 5 u.r loop cr loop ; { prints the contents of temp_array }


{ --------Read a cell map pattern from a textfile------------------ }
{ Read the contents of the textfile and put it on the stack }
: read_textfile ( -- n n1 n2 ... )
  s" ./Light_spaceship.txt" 			{ Give the text file location. Change the textfile name to change the known_pattern.}
  ['] included depth 1- >r execute depth r> - 2 + ; 	{ Write contents onto the stack }

{ Write the stack into the array }
: Write_into_array ( n n1 n2 ... -- )
length @ <> abort" Unexpected amount of numbers" 	{ Reject if more numbers than elements in the array }
length @ 0 do length @ 1 - i - current_array + c! loop ; { Write the stack into current_array }

{ Reads a known pattern from a text file into an array }
: Known_pattern ( -- ) clearstack read_textfile write_into_array ;


{ ------------------------Closes the edges of the cell map to stop cells from wrapping around--------------------------- }
: Close_boundaries ( -- ) 0 wrapped_edges ! ;   	{ Makes the edges of cell map closed }
: wrap_boundaries ( -- ) 1 wrapped_edges ! ;            { Makes the edges of the cell map wrapped to make a torodial surface }


{ -----------------Changes the values on the cell map temp_array caused by adding an alive cell-------------------------- }

{ Iterate over all elements surronding the alive cell }
{ The elements added are wrapped around the array to create a torodial surface }
: centre ( n1 n2 -- n1 n2 ) over over 1 rot rot Array_temp_add ;

: bottom ( n1 n2 -- n1 n2 ) over over dup height 1 - = if drop -1 then
1 + 2 rot rot Array_temp_add ;

: bottom_right ( n1 n2 -- n1 n2 ) over over dup height 1 - = if drop -1 then
swap dup width 1 - = if drop -1 then swap
swap 1 + swap 1 + 2 rot rot Array_temp_add ;

: right ( n1 n2 -- n1 n2 ) over over swap dup width 1 - = if drop -1 then swap
swap 1 + swap 2 rot rot Array_temp_add ;

: top_right ( n1 n2 -- n1 n2 ) over over dup 0 = if drop height then
swap dup width 1 - = if drop -1 then swap
swap 1 + swap 1 - 2 rot rot Array_temp_add ;

: top ( n1 n2 -- n1 n2 ) over over dup 0 = if drop height then
1 - 2 rot rot Array_temp_add ;

: top_left ( n1 n2 -- n1 n2 ) over over dup 0 = if drop height then
swap dup 0 = if drop width then swap
swap 1 - swap 1 - 2 rot rot Array_temp_add ;

: left ( n1 n2 -- n1 n2 ) over over swap dup 0 = if drop width then swap
swap 1 - swap 2 rot rot Array_temp_add ;

: bottom_left ( n1 n2 -- n1 n2 ) dup height 1 - = if drop -1 then
swap dup 0 = if drop width then swap
swap 1 - swap 1 + 2 rot rot Array_temp_add ;

{ If the boundaries are closed, the elements are not wrapped around the cell map }
: closed_boundary_add_alive_cell ( n1 n2 -- )
dup height 1 - = invert if 			{ Checks if the element is not at the bottom boundary }
over over 1 + 2 rot rot Array_temp_add          { Increases value of the cell on the bottom }

swap dup width 1 - = invert if			{ Checks if the elements is not at the right boundary }
swap over over 
swap 1 + swap 1 + 2 rot rot Array_temp_add	{ Increases value of the cell on the bottom-right }
else swap then

swap dup 0 = invert if				{ Checks if the elements is not at the left boundary }
swap over over  
swap 1 - swap 1 + 2 rot rot Array_temp_add	{ Increases value of the cell on the bottom-left }
else swap then
then

dup 0 = invert if 				{ Checks if the element is not at the top boundary }
over over 1 - 2 rot rot Array_temp_add 		{ Increases value of the cell on the top }

swap dup width 1 - = invert if 			{ Checks if the elements is not at the right boundary }
swap over over
swap 1 + swap 1 - 2 rot rot Array_temp_add	{ Increases value of the cell on the top-right }
else swap then

swap dup 0 = invert if 				{ Checks if the elements is not at the left boundary }
swap over over
swap 1 - swap 1 - 2 rot rot Array_temp_add	{ Increases value of the cell on the top-left }
else swap then
then

swap dup width 1 - = invert if 			{ Checks if the elements is not at the right boundary }
swap over over
swap 1 + swap 2 rot rot Array_temp_add 		{ Increases value of the cell on the right }
else swap then

swap dup 0 = invert if 				{ Checks if the elements is not at the left boundary }
1 - swap 2 rot rot Array_temp_add		{ Increases value of the cell on the left }
else drop drop then ;

{ Increase the values of cell and its adjacent cells to represent an alive cell }
: Add_alive_cell ( n1 n2 -- ) centre wrapped_edges @ 1 = if bottom bottom_right right top_right top top_left left bottom_left
else closed_boundary_add_alive_cell then 1 alive_cell_num +! ;


{ ---------------------Finds the next generation of current_array and writes it into temp_array---------------------- } 
 : next_gen ( -- ) width 0 do height 0 do 
 i j Array_@ 
 4 > if i j Array_@ 8 < if i j Add_alive_cell then then 	{ Cells with values 5,6,7 will survive in the next_genetation }
 loop loop ; 


{ --------Swaps the values of current_array with the values of temp_array------- }
: swap_array ( -- ) width 0 do height 0 do i j Array_temp_@ i j Array_! loop loop ;


{ -------Generates a random pattern on the cell map ( requires rnd )-------------- }
: random_pattern ( -- ) density @ 100 >= if abort" Density must be between 0-99 "  { Checks the density is between the range 0-99 }
else density @ 0 < if abort" Density must be between 0-99 " then then
reset_temp_array width 0 do height 0 do 
100 rnd density @ 1 - <= if i j Add_alive_cell then loop loop 	{ adds an alive cell to the temp_array when less than or equal to the given density }
swap_array reset_temp_array ; 					{ swaps the arrays around }


{ ---------------------Saves the contents of current_array into a text file------------------------ }
{ ----Ensure the array you want to save is current_arrary not temp_arrary (Else use swap_array)---- }
variable matrix-file-id                              { Create Variable to hold file id handle }

: make_matrixfile ( -- )                             { Create a test file to read / write to  }
  s" C:\Users\Harry\Documents\My documents\Third year\Laboratory work\Conway's life\Conway's life code\known pattern files\Current_cell_map.txt" r/w create-file drop  { Create the file                        } 
  matrix-file-id ! ;                                 { Store file handle for later use       }

: write_up_array ( -- ) width 0 do height 0 do i j Array_@ (.) matrix-file-id @ write-file drop s"  " matrix-file-id @ write-file drop
 loop s"  " matrix-file-id @ write-line drop loop ;

: close_matrixfile ( -- ) matrix-file-id @ close-file drop ;  { Close the textfile  }

{ This function writes up the contents of current_array into a text file - useful for creating known_pattern cell maps }
: Make_array_file ( -- ) make_matrixfile write_up_array close_matrixfile ;


{ -----Words to write simulation statistics into a text file for later analysis--- }
variable file-id 		{ Create a variable to hold the file-id }

: make_textfile ( -- )		{ Create the textfile }                            
  s" C:\Users\Harry\Documents\My documents\Third year\Laboratory work\Conway's life\Conway's life code\cell map statistics\Loop_statistics.txt" r/w create-file drop  
  file-id ! ; 			{ The location that the textfile will be written in is above }                          

: close_textfile ( -- ) file-id @ close-file drop ; { close the textfile }


{ --------Determines if the simulation is in a stable state--------------------- }
{ The code measures if the number of alive cells has had the same maximum and minimum in the last 30 generations for 3 consecutive times }
: Measure_if_stable_state ( -- )
alive_cell_num @ array_iteration @ recent_alive_cell_num + c!			{ Writes the number of alive cells into the array }
find_min minimum_element @ previous_minimum_element @ = if			{ Calculates if the minimum of the array is the same as the last generation }
find_max maximum_element @ previous_maximum_element @ = if			{ Calculates if the maximum of the array is the same as the last generation }
1 stable_pattern +! else 0 stable_pattern ! then else 0 stable_pattern ! then   { If its true then it increases the value of stable_pattern }

array_iteration @ 29 = if 0 array_iteration ! 					{ Wraps the array to ensure it keeps the 30 most recent generations }
else 1 array_iteration +! then

minimum_element @ previous_minimum_element !					{ Set the previous minimum to the current miniumum }
maximum_element @ previous_maximum_element !					{ Set the previous maximum to the current miniumum }
alive_cell_num @ previous_alive_cell_num ! ;					{ Set the previous number of alive cells to the current number }


{ -----Word (simulate_no_visuals) will run a simulation, without visuals, and write its statistics into a textfile---- }
{ ------------------------------Before using please run known_pattern or random_pattern------------------------------- }
{ Write the generation statistics into the test file }
: write_file ( -- ) generation @ (.) file-id @ write-file drop				{ Writes in the generation }
s"  " file-id @ write-file drop alive_cell_num @ (.) file-id @ write-file drop		{ Writes in the number of alive cells }
s"  " file-id @ write-file drop (.) file-id @ write-file drop				{ Writes in the run time of the simulation }
s"  " file-id @ write-file drop alive_cell_num @ previous_alive_cell_num @ -
 (.) file-id @ write-line drop ; 							{ Writes in the activity of the generation }

{ Run the simulation and write statistics into a textfile }
: simulate_no_visuals ( -- ) reset_game 0 generation ! make_textfile 			{ Creates the textfile }

s" Generation" file-id @ write-file drop    						{ Write the headers for the textfile }
s"  " file-id @ write-file drop s" Alive_cells" file-id @ write-file drop
s"  " file-id @ write-file drop s" Run-time" file-id @ write-file drop
s"  " file-id @ write-file drop s" Activity" file-id @ write-line drop

0                                                                                       { Zero is used to set the initial time to 0 }
begin 1 generation +! 0 alive_cell_num ! counter next_gen swap_array reset_temp_array run_time + dup write_file  { Iterates a generation }
Measure_if_stable_state					
stable_pattern @ 90 = until clearstack close_textfile ; 		{ If the number of alive cells doesn't change for 90 (3x30) }
                                                                        { iterations, the simulation ends }
