/// @function scr_build_battlescape(map_xx, map_yy, temp_list_of_grids, temp_floor_grid, h_pieces, v_pieces);
/// @param {real} map_xx The horizontal cell to start from
/// @param {real} map_yy The vertical cell to start from
/// @param {real} temp_list_of_grids The list of floor_grid strings
/// @param {real} temp_floor_grid The grid of list strings
/// @param {real} h_pieces How many horizontal pieces in the map
/// @param {real} v_pieces How many vertical pieces in the map

function scr_build_battlescape(map_xx, map_yy, temp_list_of_grids, temp_floor_grid, h_pieces, v_pieces){
	//Calculate the start_xx/start_yy/end_xx/end_yy for the battlescape
	var start_xx = map_xx * BASE_TILES_PER_PIECE;
	var end_xx = start_xx + (h_pieces * BASE_TILES_PER_PIECE);
	var start_yy = map_yy * BASE_TILES_PER_PIECE;
	var end_yy = start_yy + (v_pieces * BASE_TILES_PER_PIECE);
			
	for (var i = 0; i < ds_list_size(temp_list_of_grids); i ++){
		var floor_grid_str = temp_list_of_grids[| i];
				
		if (i >= ds_list_size(battlescape) ){
			var floor_grid = ds_grid_create(w, h);
			ds_grid_clear(floor_grid, -1);     
			ds_list_add(battlescape, floor_grid);
		}else floor_grid = battlescape[| i];
				
		ds_grid_read(temp_floor_grid, floor_grid_str);
		var yy_count = 0;
				
		for (var yy = start_yy; yy < end_yy; yy ++){
			var xx_count = 0;
			for (var xx = start_xx; xx < end_xx; xx ++){
				//Get the list string
				var list_str = temp_floor_grid[# xx_count, yy_count];
						
				//Make a list
				var list = ds_list_create();

				//Convert the string into that list
				ds_list_read(list, list_str);
				//Save that list to the appropriate cell
				floor_grid[# xx, yy] = list;
						
				xx_count ++;
			}	
			yy_count ++;
		}
	}
			
	//Update map_xx
	map_xx += (h_pieces - 1);
	
	return(map_xx);
}