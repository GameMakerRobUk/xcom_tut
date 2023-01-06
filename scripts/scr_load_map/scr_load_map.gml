function scr_load_map(current_biome, current_map_number, list_of_grids){
	/*
		Im just going to delete all the floors of the current map
		as it's easier, there's a script for it, and the size of
		my maps mean that the time it takes will be minimal (I think!)
	*/

	//Get the BIG BIG string for the map we want to load
	var list_of_grids_str = 
		global.all_biome_maps[| current_biome][| current_map_number];
	
	if (list_of_grids_str != undefined){
		//Delete all lists/grids from current map
		while ds_list_size(list_of_grids) > 0{
			scr_delete_floor(list_of_grids);
		}
	
		//Convert the string into usable data
		ds_list_read(list_of_grids, list_of_grids_str);
	
		//We now have a list of strings
		for (var i = 0; i < ds_list_size(list_of_grids); i ++){
			//Create a NEW grid
			var floor_grid = ds_grid_create(1,1);
			//Get the string for this floor from list_of_grids
			var floor_grid_str = list_of_grids[| i];
			//Convert that string into our new grid
			ds_grid_read(floor_grid, floor_grid_str);
			//We now have a grid of strings
			for (var yy = 0; yy < ds_grid_height(floor_grid); yy++){
				for (var xx = 0; xx < ds_grid_width(floor_grid); xx ++){
					//Make a new list
					var data_list = ds_list_create();
					//Get the list string from our new grid
					var data_list_str = floor_grid[# xx, yy];
					//Convert that list string into a list
					ds_list_read(data_list, data_list_str);
					//Save that list pointer to our new grid
					floor_grid[# xx, yy] = data_list;
				}
			}
			//Add our new grid to the level we're on
			list_of_grids[| i] = floor_grid;
		}
	
		//By now we should have all strings converted back
		//into grids/lists
		show_message("Map loaded!");
		
		#region BUGFIX for adding new floors to maps bigger than 1/1 hor/ver pieces  <=== NEW EPISODE 11
		
		horizontal_pieces = ds_grid_width(floor_grid) div BASE_TILES_PER_PIECE;
		vertical_pieces = ds_grid_height(floor_grid) div BASE_TILES_PER_PIECE;
		
		#endregion
	}
	else show_message("string is undefined, can't load map data");
}