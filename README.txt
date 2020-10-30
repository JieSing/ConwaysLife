# ConwaysLife
A Conway's Game of Life simulation built with Forth language by Harry Anthony and Jie Sing Yoo

The main branch should include the following files:
1. Conways_life_mechanics
  This code contains the mechanics for the Conway's life simulation. It can generate random cell maps and read cell map text files. It can use these cell maps to run a Conway's life simulation. The file can also write statistics of the simulations into text files.
  
2. Density_measurements
  This code is used to test Conway's Game of Life by altering the density of randomly generated text files. 
 
3. Glider.txt
  This text file is an example of a known cell map that can be called by Conways_life_mechanics with the function known_pattern. This text file has the pattern for a glider (10x10) which can be called in Conways_life_mechanics using the word 'known_pattern'.

4. Phase_transition
  This code can be used to vary the synchronicity S of the Conway's life simulation. 
  
5. Rnd
  This code is used to generate random numbers.
  
6. Visualisation
  This code is used to visualise the Conway's Game of Life simulation using Windows graphics commands.
  
7. Visualisation_bmp
  This code is used to visualise the Conway's Game of Life simulation using a bitmap image file.
  
How to use the code
-------------------

Firstly, the Rnd.f file should be executed. This is required to run the other files.

Next, the Conways_life_mechanics.f file should be executed. This will generate an cell map ( of size height x width ) full of zeros. To change the size of the cell map, change the value of the constants height and width before running the file.

To fill the cell map, there are two options:
-run "known_pattern"
  This will read a known cell map in the directory into current_array. You must ensure that the width and height of the text file match the constants width and height in Conways_life_mechanics. To change the cell map that is read, change the file name on line 81. There are several examples of cell maps in the branch.
-run "random_pattern"
  This will generate a random cell map. To change the density of the alive cells, change the value of the variable density (values must be between 0-99).
  
The cell map can then be executed in several ways:
1. run 'simulate_no_visuals'
    This will run the simulation without visuals until a stable state is reached and it will write the statistics of the run (generation,alive_cells,run_time,activity) into a text file.

2. Execute visualisation.f. Run 'go'.
   This will run the simulation and visualise it using windows. The visualisation will end when a stable state is detected.
   
3. Execute visualisation_bmp.f. Run 'go'.
   This will run the simulation and visualise it using a bitmap image file. This works best with large arrays.
   
4. Execute Density_measurements.f. Run 'simulate_densities'
   This creates random cell maps for densities 0 to 99 and iterates them a given number of times (controlled by Number_of_measurements). The results are written into a text file. This is used for measuing how the lifetime of cell maps varies with density.
   
5. Execute Density_measurements.f. Run 'measure_single_density'
   This will iterate a cell map of a given density (controlled by variable density) a given number of times controlled by Number_of_measurements). The results are written into a text file. This is used for measuing the mean lifetime of cell maps of a given density.
   
6. Execute Phase_transition.f. Run 'gen_phase'.
   This will run the simulation with a given synchronicity until the simulation reaches a stable state. The statistics of the simulation are then written into a text file.
   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Other functionality:
Conways_life_mechanics also contains the following features:
- Close_boundaries ( -- ) 
  This word will close the boundaries of the cell map. The cell map is initially set to have wrapped boundaries (torodial surface).
- Open_boundaries ( -- )
  This word will open the boundaries of the cell map. The cell map is initially set to have wrapped boundaries (torodial surface).
- Make_array_file ( -- )
  This word will save the current_array into a text file. This word is useful for creating known_pattern cell maps.
