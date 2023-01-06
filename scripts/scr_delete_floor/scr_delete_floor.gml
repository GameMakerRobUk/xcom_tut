/// @function scr_delete_floor(map_list)
/// @description Delete the highest floor
/// @param map_list {real} the current_map_list

function scr_delete_floor(map_list){
	
	var last_pos = ds_list_size(map_list) - 1;
	var floor_grid = map_list[| last_pos];
	
	//delete all the lists in the floor grid then 
	for (var yy = 0; yy < ds_grid_height(floor_grid); yy ++){
		for (var xx = 0; xx < ds_grid_width(floor_grid); xx ++){
			var data_list = floor_grid[# xx, yy];
			ds_list_destroy(data_list);
		}
	}
	//destroy the grid then 
	ds_grid_destroy(floor_grid);
	//delete the grid pointer from current_map_list
	ds_list_delete(map_list, last_pos);
}