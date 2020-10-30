# ConwaysLife
Conway's life built with Forth 

Known-pattern-cell-maps folder contains pre-generated cell maps that can be used in Conways_life_mechanics as current_array. 

This folder should include:
-Glider ( 10 x 10 )
-Toad (10 x 10)
-Gosper_gun ( 50 x 50 )
-Gosper_gun_with_eater ( 50 x 50 )
-Light_spaceship ( 10 x 10 )
-Pentadecathlon ( 25 x 25 )

Ensure that these text files of pre-generated cell maps are moved to the same directory as 'Conways_life_mechanics.txt' before 'known_pattern' is called. Also ensure that the directory called on line 81 is the text file you want. If the constants height and width do not match the height and width of the known cell map, the word 'known_pattern' will not work. 


Method:
1. In 'Conways_life_mechanics.txt', on line 81, change the name of text file to the desired file's name.

2. Change constants width and height to match the known_pattern ( width x height - shown above ).

3. run word "Known_pattern". Array will now be written into current_array.


You can write current_array into a text file using the word "Make_array_file". This can be used to generate known_pattern cell maps.





