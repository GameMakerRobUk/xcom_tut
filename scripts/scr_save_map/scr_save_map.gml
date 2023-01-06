// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_save_map(current_biome, current_map_number, list_of_grids){
	
	//Setup some temporary data structures
	var temp_list_of_grids = ds_list_create();
	var temp_grid = ds_grid_create(1, 1);
	
	var w = ds_grid_width(list_of_grids[| 0]);
	var h = ds_grid_height(list_of_grids[| 0]);
	
	show_debug_message("w: " + string(w) );
	show_debug_message("h: " + string(h) );
	
	ds_grid_resize(temp_grid, w, h);
	/*
		For as many grids as we have in this map's list, convert
		the lists from each cell into strings, save those strings
		to the corresponding cell in the temp_grid, and when all
		cells are done, convert the temp grid into a string and
		save THAT string into the temporary list
	*/
	for (var i = 0; i < ds_list_size(list_of_grids); i ++){
		//Get the floor grid
		var floor_grid = list_of_grids[| i];
		
		show_debug_message("floor_grid w: " + string(ds_grid_width(floor_grid)) );
		show_debug_message("floor_grid h: " + string(ds_grid_height(floor_grid)) );
		
		//Convert all lists in this grid into strings
		for (var yy = 0; yy < h; yy ++){
			for (var xx = 0; xx < w; xx ++){
				var data_list = floor_grid[# xx, yy];
				show_debug_message("data_list: " + string(data_list) );
				var data_str = ds_list_write(data_list);
				//save those strings into the temp grid
				temp_grid[# xx, yy] = data_str;
			}
		}
		//The lists still exist as before
		
		//Convert temp_grid into a string (so now all those list strings
		//are held in one BIG string)
		var floor_grid_str = ds_grid_write(temp_grid);
		//Add that one big string to the temporary list 
		ds_list_add(temp_list_of_grids, floor_grid_str);
	}
	
	//convert the temp list into an EVEN BIGGER string
	var list_of_grids_str = ds_list_write(temp_list_of_grids);
	
	global.all_biome_maps[| current_biome][| current_map_number] 
		= list_of_grids_str;
	show_debug_message("displaying map string");
	show_debug_message(global.all_biome_maps[| current_biome][| current_map_number]);

	show_message("Map saved!");
}