/// @function scr_add_new_floor(map_list, current_level)
/// @description Add a new floor to the map_list
/// @param {real} map_list the list that holds the grids (floors)
/// @param {real} current_level the current level/floor of the grid

function scr_add_new_floor(map_list, current_level){
	
	show_debug_message("ADDING NEW FLOOR - current_level: " + 
	                    string(current_level));
	
	var hcells = (horizontal_pieces * BASE_TILES_PER_PIECE);			
	var vcells = (vertical_pieces * BASE_TILES_PER_PIECE);

	//Create the grid for the ground floor (first floor if you're USA)
	var floor_grid = ds_grid_create(hcells, vcells);
	
	if (current_level == 0) var index = 1; else index = 0;

	for (var yy = 0; yy < vcells; yy ++){
		for (var xx = 0; xx < hcells; xx ++){
			var data_list = ds_list_create();

			data_list[| e_tile_parts.ground] = index;
			data_list[| e_tile_parts.wall_west] = 0;
			data_list[| e_tile_parts.wall_north] = 0;
			data_list[| e_tile_parts.deco] = 0;
			
			floor_grid[# xx, yy] = data_list;
		}
	}

	ds_list_add(map_list, floor_grid);
	show_debug_message("map_list_size: " + string(ds_list_size(map_list)));
	show_debug_message("current_level: " + string(ds_list_size(current_level)));
	//return (map_list);
}