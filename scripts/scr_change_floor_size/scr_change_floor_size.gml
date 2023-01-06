/// @function scr_change_floor_size(current_map_list, horizontal_pieces, vertical_pieces)
/// @description Change the dimensions of all floorw
/// @param {real} current_map_list the list that holds the grids - all will be updated
/// @param {real} horizontal_pieces
/// @param {real} vertical_pieces

function scr_change_floor_size(map_list, horizontal_pieces, vertical_pieces){
	
	/*
		If the width of the grids are </> horizontal_pieces, 
		either resize the grid and add cells or 
		delete cells and then resize the grid.
		Same for vertical
	*/
	
	var floor_grid = map_list[| 0];
	
	//Get the w/h of the floor grid and the WANTED width/height based on hor/ver pieces
	var w = ds_grid_width(floor_grid);
	var h = ds_grid_height(floor_grid);
	var new_width = horizontal_pieces * BASE_TILES_PER_PIECE;
	var new_height = vertical_pieces * BASE_TILES_PER_PIECE;
		
	//Check to see that we actually want to change the map
	//If the map is already 10x10 and we try to decrease it
	//then nothing should happen as 10x10 is the smallest allowed
	if (horizontal_pieces != (w / BASE_TILES_PER_PIECE) || 
	    vertical_pieces != (h / BASE_TILES_PER_PIECE) ){
			
		//If we're trying to INCREASE the size of the map
		if (horizontal_pieces > (w / BASE_TILES_PER_PIECE) || 
		    vertical_pieces > (h / BASE_TILES_PER_PIECE) ){
			
			#region ADDING CELLS TO FLOOR_GRID
			
			//Sort out where to start the xx/yy from
			if ( horizontal_pieces > (w / BASE_TILES_PER_PIECE) ) 
				var xx_start = w; else xx_start = 0;
			if ( vertical_pieces > (h / BASE_TILES_PER_PIECE) ) 
				var yy_start = h; else yy_start = 0;
			
			//Set the end xx/yy
			var xx_end = new_width;
			var yy_end = new_height;
			
			//For as many floors as are in the map, resize them and
			//add new lists with default data for every cell
			for (var levels = 0; levels < ds_list_size(map_list); levels ++){
		
				var floor_grid = map_list[| levels];
				ds_grid_resize(floor_grid, new_width, new_height);
				
				if (levels == 0) var index = 1; else index = 0;
				
				for (var yy = yy_start; yy < yy_end; yy ++){
					for (var xx = xx_start; xx < xx_end; xx ++){
						var data_list = ds_list_create();
						
						data_list[| e_tile_parts.ground] = index;
						data_list[| e_tile_parts.wall_west] = 0;
						data_list[| e_tile_parts.wall_north] = 0;
						data_list[| e_tile_parts.deco] = 0;

						floor_grid[# xx, yy] = data_list;
					}
				}
				
			}
			
			#endregion
			
		}else{
			
			#region REMOVING CELLS FROM FLOOR_GRID
			
			//Delete first, then resize
			
			//Get the start xx/yy (end xx/yy is the existing w/h)
			if (horizontal_pieces < (w / BASE_TILES_PER_PIECE) ){
				xx_start = new_width;	
			}else xx_start = 0;
			
			if (vertical_pieces < (h / BASE_TILES_PER_PIECE) ){
				yy_start = new_height;	
			}else yy_start = 0;
			
			//For as many floors as there are in the map, 
			//Delete all the lists that we no longer need
			for (var levels = 0; levels < ds_list_size(map_list); levels ++){
		
				var floor_grid = map_list[| levels];
				
				for (var yy = yy_start; yy < h; yy ++){
					for (var xx = xx_start; xx < w; xx ++){
						var data_list = floor_grid[# xx, yy];
						ds_list_destroy(data_list);
					}
				}
				//We deleted all the unneeded lists and can now resize
				//the grid - deleting the lists stops memory leaks.
				ds_grid_resize(floor_grid, new_width, new_height);
			}
			
			#endregion
			
		}
			
	}
	
}