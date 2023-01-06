function scr_external_load(){
	show_debug_message("scr_external_load running");

	//Load all of the biome strings that were saved back into the lists
	for (var biome = 0; biome < ds_list_size(global.all_biome_maps); biome ++){
		var biome_list = global.all_biome_maps[| biome];
		
		//Open the file - does it exist?
		var fname = "biome_" + string(biome) + ".txt";
		if file_exists(fname){
			show_debug_message(fname + " exists!");
			
			//Conver the saved string back into a biome list
			var file = file_text_open_read(working_directory + fname);
			var biome_string = file_text_read_string(file);
			ds_list_read(biome_list, biome_string);
			file_text_close(file);
		}
	}
	
	#region LOAD MAP_TYPES FILE			<=== NEW EPISODE 11
	
	//This won't exist at first so we'll check to see if it exists, and
	//if not, create it and give the maps a default map entry
	
	var fname = "map_types.txt";
	if file_exists(fname){
		var file = file_text_open_read(working_directory + fname);
		var str = file_text_read_string(file);
		global.map_types = json_parse(str);
		
		file_text_close(file);	//<=== IMPORTANT EPISODE 11!!
	}else{
		//Make a 2D array, with as many entries as there are maps in each biome
		//and set the entries as not_assigned
		for (var biome = 0; biome < e_biomes.last; biome ++){
			var biome_list = global.all_biome_maps[| biome];
			
			for (var map = 0; map < ds_list_size(biome_list); map ++){
				global.map_types[biome][map] = e_map_type.not_assigned;	
				
				show_debug_message("global.map_types[" + string(biome) + "][" + string(map) + "]: " + string(global.map_types[biome][map]) );
			}
		}
	}
	#endregion
}