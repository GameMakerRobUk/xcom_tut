if (show_designations == false){

	//Find the correct grid for this floor level
	//current_map_list = global.all_maps[# current_tile_set, current_map_number];
	var floor_grid = current_map_list[| current_level];

	var hcells = ds_grid_width(floor_grid);
	var vcells = ds_grid_height(floor_grid);

	#region WORK OUT GRIDX/GRIDY

	if (isoON == false){
		if (!keyboard_check(ord("Z"))) gridX = floor(mouse_x / GRID_SIZE);
		if (!keyboard_check(ord("X"))) gridY = floor(mouse_y / GRID_SIZE);
	}else{

		if (!keyboard_check(ord("Z"))) gridX = floor((mouse_x / tile_width) + (mouse_y / tile_height));
		if (!keyboard_check(ord("X"))) gridY = floor((mouse_y / tile_height) - (mouse_x / tile_width));	

	}
	gridX = clamp(gridX, 0, hcells - 1);
	gridY = clamp(gridY, 0, vcells - 1);

	#endregion

	#region Change current tile to 'current_tile_to_place'

	if(mouse_check_button(mb_left)){
		//var ds_terrain_data = a_floor_levels[current_level];
		if (!keyboard_check(vk_shift) ){
			var data_list = floor_grid[# gridX, gridY]
			data_list[| tile_part_to_place] = current_tile_to_place;
		}else{
			#region MAKE ALL TILES EQUAL THE CURRENT TILE
		
			for (var yy = 0; yy < vcells; yy ++){
				for (var xx = 0; xx < hcells; xx ++){
					var data_list = floor_grid[# xx, yy];
					data_list[| tile_part_to_place] = current_tile_to_place;
				}
			}
		
			#endregion
		}
	}

	#endregion

	#region Remove Walls / Deco

	if (mouse_check_button(mb_right) ){
		//var ds_terrain_data = a_floor_levels[current_level];
		var data_list = floor_grid[# gridX, gridY];
	
		//Remove wall/deco or change ground to first image
		if (tile_part_to_place != e_tile_parts.ground || current_level > 0) data_list[| tile_part_to_place] = 0;
		else{
			//We always want a floor on the floor...
			if (current_level == 0 && tile_part_to_place == e_tile_parts.ground) data_list[| tile_part_to_place] = 1;
		}
	}

	#endregion

	#region Change / Increase level

	if (keyboard_check_pressed(vk_up) ){
	
			if (current_level + 1) < ds_list_size(current_map_list){
				current_level ++;	
			}else{
				if (!keyboard_check(vk_shift) )	current_level = 0;
				else{
					//ADD NEW FLOOR	
					if (ds_list_size(current_map_list) < MAX_LEVELS){
						current_level ++;
						scr_add_new_floor(current_tile_set, current_map_list, current_level);
					}
				}
			}
	}

	if (keyboard_check_pressed(vk_down) ){
	
		if (!keyboard_check(vk_shift) ){
			if (current_level - 1) >= 0 current_level --;
			else current_level = ds_list_size(current_map_list) - 1;
		}else{
			if (current_level > 0){
				//DELETE HIGHEST FLOOR
				scr_delete_floor(current_map_list);
				current_level --;
			}
		}
	}

	#endregion

	#region Change 'current_tile_to_place' / tile_part_to_place

	if keyboard_check_pressed(vk_right){
		if (!keyboard_check(vk_shift) ){
			//Change tile
		
			if (current_tile_to_place + 1) < sprite_get_number(global.a_tile_sets[tile_part_to_place][current_tile_set]) current_tile_to_place ++;
			else current_tile_to_place = 0;
		}else{
			//Change Tile Part (Floor / West Wall / North Wall / Deco
			if (tile_part_to_place + 1) < e_tile_parts.last tile_part_to_place ++;
			else tile_part_to_place = 0;
			//Reset current tile to place
			current_tile_to_place = 0;
		}
	}

	if keyboard_check_pressed(vk_left){
		if (!keyboard_check(vk_shift) ){
			show_debug_message("PRESSED LEFT: current_tile_set: " + string(current_tile_set) + " | tile_part_to_place: " + string(tile_part_to_place) + 
			"| a_tile_sets[tile_part_to_place][current_tile_set]: " + string(global.a_tile_sets[tile_part_to_place][current_tile_set]) );
			if (current_tile_to_place - 1) >= 0 current_tile_to_place --;
			else current_tile_to_place = sprite_get_number(global.a_tile_sets[tile_part_to_place][current_tile_set]) - 1;
		}else{
			//Change Tile Part (Floor / West Wall / North Wall / Deco
			if (tile_part_to_place - 1) >= 0 tile_part_to_place --;
			else tile_part_to_place = (e_tile_parts.last - 1);
			//Reset current tile to place
			current_tile_to_place = 0;
		}
	}

	#endregion

	//Toggle isoON - not used as there's no 2D equivalent to draw in
	//if (keyboard_check_pressed(vk_tab) && !keyboard_check(vk_shift) ) isoON = !isoON;

	#region CHANGE show_all_levels

	if (keyboard_check(vk_shift) && keyboard_check_pressed(vk_tab) ) show_all_levels = !show_all_levels;

	#endregion

	#region CHANGE BIOME (current_tile_set)

	if (keyboard_check(vk_shift) ){
		if (keyboard_check_pressed(ord("T")) ){
			if (current_tile_set + 1) < e_tile_sets.last current_tile_set ++;
			else current_tile_set = 0;
		}
		if (keyboard_check_pressed(ord("R")) ){
			if (current_tile_set - 1) >= 0 current_tile_set --;
			else current_tile_set = (e_tile_sets.last - 1);
		}
	
		if (keyboard_check_pressed(ord("T")) || keyboard_check_pressed(ord("R"))){
			//RESET EDITING VARIABLES
			current_map_number = 0;
			current_level = 0;
			tile_part_to_place = e_tile_parts.ground;
			current_tile_to_place = 0;
		
			show_debug_message("CHANGING BIOMES - global.all_maps[# current_tile_set, current_map_number]: " + string(global.all_maps[# current_tile_set, current_map_number]) );
		
			if (global.all_maps[# current_tile_set, current_map_number] == 0){
				show_debug_message("CREATING NEW MAP");
				var old_map_number = current_map_number;
				current_map_number = scr_find_next_map(current_map_number, current_tile_set, 1, current_map_list);
			
				if (current_map_number = old_map_number)
					scr_create_new_map(current_tile_set, current_map_list, current_map_number);	
			}else{
				show_debug_message("A map exists for this biome");
				scr_load_map(current_map_number, current_tile_set, current_map_list);	
			}
		}
	}

	#endregion

	#region SAVE/LOAD/NEW MAP/DELETE MAP

		#region SAVING
	
		if (keyboard_check_pressed(vk_f5) ) scr_save_map(current_map_number, current_tile_set, current_map_list);

		#endregion
	
		#region LOADING
	
		//Press "[" to load previous map or "]" to load next map
		if (keyboard_check_pressed(ord("O"))){
			show_debug_message("O pressed");
			current_level = 0;
			current_map_number = scr_find_next_map(current_map_number, current_tile_set, -1, current_map_list);
		}
	
		if (keyboard_check_pressed(ord("P"))){
			show_debug_message("P pressed");
			current_level = 0;
			current_map_number = scr_find_next_map(current_map_number, current_tile_set, 1, current_map_list);
		}
	
		#endregion
	
		#region NEW MAP
	
		if (keyboard_check_pressed(vk_enter) ){
			current_level = 0;
			current_map_number = scr_create_new_map(current_tile_set, current_map_list, current_map_number);	
		}
	
		#endregion
	
		#region DELETE MAP
	
		if (keyboard_check_pressed(vk_backspace) ){
			current_level = 0;
			current_map_number = scr_delete_map(current_map_number, current_tile_set, current_map_list);
		}
	
		#endregion

	#endregion

	if (keyboard_check(ord("W")) || keyboard_check(ord("S")) || keyboard_check(ord("A")) || keyboard_check(ord("D"))){
	
		#region Move Map Around

		if (!keyboard_check(vk_shift) ){
	
			if (keyboard_check(ord("W")) ) cy -= 8;
			if (keyboard_check(ord("S")) ) cy += 8;
			if (keyboard_check(ord("A")) ) cx -= 8;
			if (keyboard_check(ord("D")) ) cx += 8;

			camera_set_view_pos(view_camera[0], cx, cy);
		}

		#endregion
		
		#region CHANGE SIZE OF THE FLOORS

		if ( keyboard_check(vk_shift) ){
		
			//We only want to change EITHER horizontal or vertical at one time, not both (would
			//probably give a crash)
		
			if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("D")) ){
				horizontal_pieces += ( keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A")) );
				horizontal_pieces = clamp(horizontal_pieces, 1, 5);
			}else{
				if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("S")) ){
					vertical_pieces += ( keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W")) );
					vertical_pieces = clamp(vertical_pieces, 1, 5);
				}
			}
		
			scr_change_floor_size(current_map_list, horizontal_pieces, vertical_pieces, current_tile_set);
			
		}
	
		#endregion
	}


	#region TOGGLE SHOW HELP

	if (keyboard_check_pressed(vk_escape) ) show_help = !show_help;

	#endregion

}else{
	#region CHOOSE A DESIGNATION FOR THIS MAP
	
	if (keyboard_check_pressed(vk_enter)) show_designations = false;
	
	if (keyboard_check_pressed(vk_up)){
		var des = global.map_designations[# current_tile_set, current_map_number];
		if (des > 0) des --; else des = (e_designation.last - 1);
		global.map_designations[# current_tile_set, current_map_number] = des;
	}
	
	if (keyboard_check_pressed(vk_down)){
		var des = global.map_designations[# current_tile_set, current_map_number];
		if (des < e_designation.last - 1) des ++; else des = 0;
		global.map_designations[# current_tile_set, current_map_number] = des;
	}
	
	#endregion
}

if (keyboard_check_pressed(ord("H"))){
	if (!keyboard_check(vk_shift) ) show_designations = !show_designations;
	else debug_on = !debug_on;
}

if (ds_grid_width(global.map_designations) != ds_grid_width(global.all_maps) || ds_grid_height(global.map_designations) != ds_grid_height(global.all_maps) ){
	show_debug_message("Resizing global.map_designations");
	ds_grid_resize(global.map_designations, ds_grid_width(global.all_maps), ds_grid_height(global.all_maps) );	
}
	