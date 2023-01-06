function scr_external_save(){
	show_debug_message("scr_external_save running");
	
	//Create a file for each biome and save the map strings to it
	for (var biome = 0; biome < ds_list_size(global.all_biome_maps); biome ++){
		var biome_list = global.all_biome_maps[| biome];
		
		//Open the file for this biome
		var fname = "biome_" + string(biome) + ".txt";
		var file = file_text_open_write(working_directory + fname);
	
		//Write the list of maps as a string to the file
		var biome_string = ds_list_write(biome_list);
		file_text_write_string(file, biome_string);
		
		//We're done!
		file_text_close(file);
	}
	
	#region Save map_types			
	
	var fname = "map_types.txt";

	var file = file_text_open_write(working_directory + fname);
	var str = json_stringify(global.map_types);
	file_text_write_string(file, str);
	
	file_text_close(file);
	#endregion
}