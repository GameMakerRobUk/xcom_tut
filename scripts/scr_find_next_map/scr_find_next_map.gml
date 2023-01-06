function scr_find_next_map(map_number, biome, increment, list_of_grids){
	
	var counter = map_number + increment;
	var h = ds_list_size(global.all_biome_maps[| biome]);
	h = clamp(h, 1, 999); //make h a min value of 1 
	
	while counter != map_number{
		/*
			The idea here is to check clockwise/anti 
			clockwise to find the
			next entry that has map data. If there's 
			only one map, we should end up there
		*/
		
		//Is the counter out of bounds?
		if (counter < 0) counter = (h - 1);
		if (counter >= h) counter = 0;
		
		//We've come full circle
		if (counter == map_number) break;
		
		if (counter < ds_list_size(global.all_biome_maps[| biome]) ){
			scr_load_map(biome, counter, list_of_grids);
			break;
		}
		
		counter += increment;
	}
	
	//If counter ends up being the same as map_number, nothing should happen
	show_debug_message("scr_find_next_map is done | map_number: " + string(map_number) + " | counter: " + string(counter) );
	return(counter);
}