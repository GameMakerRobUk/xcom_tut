function scr_new_map(current_biome, list_of_grids){
	
	//Delete all lists/grids from current map
	while ds_list_size(list_of_grids) > 0{
		scr_delete_floor(list_of_grids)	
	}
	//Create a basic first/ground floor
	scr_add_new_floor(list_of_grids, 0);
	
	//Add a new entry for map_type					                                       <=== NEW EPISODE 11
	var num = ds_list_size( global.all_biome_maps[| current_biome] ); //<=== NEW EPISODE 11
	global.map_types[current_biome][num] = e_map_type.not_assigned; //<=== NEW EPISODE 11
	
	show_message("New map created!");
	
	//Return the new current_map_number value
	return(ds_list_size(global.all_biome_maps[| current_biome]));
}