
{ ----------------------------------Phase Transition----------------------------------------- }


{ ----select random cells from the current array and retain its value in the next cycle----- }

: random_s ( -- ) 3 0 do height rnd dup width rnd dup 		{ change the value after random_s to vary synchronicity S, with max. value = length }
  rot rot Array_@ 2 mod 1 = if 
  add_alive_cell 					{ if it is alive in current array, make the cell alive in the next array }
  then i drop loop ;

variable phase-file-id    				{ creates variable to hold file id }

: make_phasefile ( -- )					{ Creates a text file }
  s" C:\Users\Jie Sing\Desktop\D3 EXPT\phase1.txt"  r/w create-file drop  
  phase-file-id ! 
;

: close_file ( -- ) phase-file-id @ close-file drop ; 		{ closes the file }

: write_phase_file ( -- ) generation @ (.) phase-file-id @ write-file drop			{ Writes in the generation }
  s"  " phase-file-id @ write-file drop
  alive_cell_num @ previous_alive_cell_num @ - (.) phase-file-id @ write-line drop ;            { Writes in the activity }


: gen_phase ( -- )						{ generates the phase change and writes it to a file }
  make_phasefile 

  s" Generation" phase-file-id @ write-file drop		{ Create headers for the text file }			
  s"  " phase-file-id @ write-file drop
  s" Activity" phase-file-id @ write-line drop
   
  begin 1 generation +! next_gen random_s swap_array reset_temp_array   { Iterates through generations with synchronicity S }
  write_phase_file
  Measure_if_stable_state
  
  stable_pattern @ 90 = until clearstack close_file ;			{ Begin loop stops iterating when stable state is reached }
;		