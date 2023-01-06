function scr_delete_map(current_biome, list_of_grids, pos){
	ds_list_delete(global.all_biome_maps[| current_biome], pos);
	
	array_delete(global.map_types[current_biome], pos, 1);  //<== NEW EPISODE 11
	
	show_message("Map deleted");
	//Is there another saved map to display?
	pos = ds_list_size(global.all_biome_maps[| current_biome]);
	if (pos > 0){
		pos --;
		scr_load_map(current_biome, pos, list_of_grids);
	}else{
		//no - make a fresh map
		scr_new_map(current_biome, list_of_grids);
	}
	
	return(pos);
}