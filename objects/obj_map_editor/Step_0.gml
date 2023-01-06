if (!show_map_types){		//<=== NEW EPISODE 11

	var floor_grid = current_map_list[| current_level];

	#region WORK OUT GRIDX/GRIDY

	var hcells = ds_grid_width(floor_grid);
	var vcells = ds_grid_height(floor_grid);

	//Where in a 2D grid is the cursor (converting Iso to top down basically)
	if !keyboard_check( ord("Z") ) grid_x = floor( (mouse_x / tile_width) + (mouse_y / tile_height) );
	if !keyboard_check( ord("X") ) grid_y = floor( (mouse_y / tile_height) - (mouse_x / tile_width) );

	//Stop grid_x/y going out of bounds of the grid
	grid_x = clamp(grid_x, 0, hcells - 1);
	grid_y = clamp(grid_y, 0, vcells - 1);

	#endregion

	if (keyboard_check(ord("W")) || keyboard_check(ord("S")) || 
		keyboard_check(ord("A")) || keyboard_check(ord("D"))){
	
		if (!keyboard_check(vk_shift) ){		
	
			#region Move Camera Around
	
			if (keyboard_check(ord("W")) ) cy -= 8;
			if (keyboard_check(ord("S")) ) cy += 8;
			if (keyboard_check(ord("A")) ) cx -= 8;
			if (keyboard_check(ord("D")) ) cx += 8;

			camera_set_view_pos(view_camera[0], cx, cy);

			#endregion
	
		}else{								
	
			#region CHANGE SIZE OF THE FLOORS	

			//We only want to change EITHER horizontal or vertical at one time, not both (would
			//probably give a crash)
		
			if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("D")) ){
				horizontal_pieces += ( keyboard_check_pressed(ord("D")) 
				                     - keyboard_check_pressed(ord("A")) );
				horizontal_pieces = clamp(horizontal_pieces, 1, 5);
			}else{
				if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("S")) ){
					vertical_pieces += ( keyboard_check_pressed(ord("S")) 
					                   - keyboard_check_pressed(ord("W")) );
					vertical_pieces = clamp(vertical_pieces, 1, 5);
				}
			}
		
			scr_change_floor_size(current_map_list, horizontal_pieces, vertical_pieces);
	
			#endregion
		
		}									
	}

	#region Change tile_to_place

	var spr = global.biomes[tile_part_to_place][current_biome];
	var images_in_sprite = sprite_get_number(spr);

	if keyboard_check_pressed(vk_right){	
	
		if (!keyboard_check(vk_shift) ){			
			if (tile_to_place + 1) < images_in_sprite tile_to_place ++;
			else tile_to_place = 0;
		
			show_debug_message("tile_to_place: " + string(tile_to_place) );
		}else{												
			//Change Tile Part (Floor / West Wall / North Wall / Deco
			if (tile_part_to_place + 1) < e_tile_parts.last tile_part_to_place ++;
			else tile_part_to_place = 0;
		
			//Reset current tile to place
			tile_to_place = 0;
		}												
	}

	if keyboard_check_pressed(vk_left){
	
		if (!keyboard_check(vk_shift) ){				
			if (tile_to_place - 1) >= 0 tile_to_place --;
			else tile_to_place = images_in_sprite - 1;
		
			show_debug_message("tile_to_place: " + string(tile_to_place) );
		}else{											
			//Change Tile Part (Floor / West Wall / North Wall / Deco
			if (tile_part_to_place - 1) >= 0 tile_part_to_place --;
			else tile_part_to_place = (e_tile_parts.last - 1);
		
			//Reset current tile to place
			tile_to_place = 0;
		}												
	}

	#endregion

	#region Remove Tilepart			<=== NEW EPISODE 10

	if (mouse_check_button(mb_right) ){

		var data_list = floor_grid[# grid_x, grid_y];
	
		//Remove wall/deco or change ground to first image
		if (tile_part_to_place != e_tile_parts.ground || current_level > 0) data_list[| tile_part_to_place] = 0;
	}

	#endregion

	#region Change current tile to tile_to_place	

	if(mouse_check_button(mb_left) ){ 

		if (!keyboard_check(vk_shift) ){
			var data = floor_grid[# grid_x, grid_y];				
			data[| tile_part_to_place] = tile_to_place;			
		}else{
			#region MAKE ALL TILES EQUAL THE CURRENT TILE
		
			for (var yy = 0; yy < vcells; yy ++){
				for (var xx = 0; xx < hcells; xx ++){
					var data = floor_grid[# xx, yy];					
					data[| tile_part_to_place] = tile_to_place;		
				}
			}
		
			#endregion
		}
	}

	#endregion

	#region CHANGE BIOME (current_tile_set) 

	if (keyboard_check_pressed(ord("T")) ){
		if (current_biome + 1) < e_biomes.last current_biome ++;
		else current_biome = 0;
	}
	if (keyboard_check_pressed(ord("R")) ){
		if (current_biome - 1) >= 0 current_biome --;
		else current_biome = (e_biomes.last - 1);
	}

	if (keyboard_check_pressed(ord("T")) || keyboard_check_pressed(ord("R"))){
		//RESET EDITING VARIABLES
		tile_part_to_place = e_tile_parts.ground;
		tile_to_place = 0;
		current_map_number = 0; 
	
		#region Load first map or create new 
	
		var map_data = global.all_biome_maps[| current_biome];
		if (map_data[| 0] != undefined){
			scr_load_map(current_biome, current_map_number, 
			             current_map_list); 
		}else{
			scr_new_map(current_biome, current_map_list);
		}
	
		#endregion
	}
	
	#endregion

	#region Change / Increase level

	if (keyboard_check_pressed(vk_up) ){
	
		if (current_level + 1) < ds_list_size(current_map_list){
			current_level ++;	
		}else{
			if (!keyboard_check(vk_shift) )	current_level = 0;
			else{
				//ADD NEW FLOOR	(only if current_level is the top floor)
				if (ds_list_size(current_map_list) < MAX_LEVELS){
					current_level ++;
					scr_add_new_floor(current_map_list, current_level);
				}
			}
		}
	}

	if (keyboard_check_pressed(vk_down) ){
	
		if (!keyboard_check(vk_shift) ){
			if (current_level - 1) >= 0 current_level --;
			else current_level = ds_list_size(current_map_list) - 1;
		}else{
			//DELETE HIGHEST FLOOR
			if (current_level > 0){
				current_level --;
				scr_delete_floor(current_map_list);
			}
		}
	}

	#endregion

	#region CHANGE show_all_levels

	if keyboard_check_pressed(vk_tab) show_all_levels = !show_all_levels;

	#endregion

	#region SAVE/LOAD/NEW/DELETE MAPS	

	#region SAVE THE MAP		
	if (keyboard_check_pressed(vk_f5) ) 
		scr_save_map(current_biome, current_map_number, current_map_list);
	#endregion

	#region LOAD THE MAP			
		if (keyboard_check_pressed(ord("O"))){
			current_level = 0;
			current_map_number = 
				scr_find_next_map(current_map_number, current_biome, 
				                  -1, current_map_list);
		}
	
		if (keyboard_check_pressed(ord("P"))){
			current_level = 0;
			current_map_number = 
				scr_find_next_map(current_map_number, current_biome, 
				                  1, current_map_list);
		}
	#endregion

	#region NEW MAP				
	if (keyboard_check(vk_shift) && keyboard_check_pressed(vk_enter) ){
		current_map_number = 
			scr_new_map(current_biome, current_map_list);
		current_level = 0;
	}
	#endregion

	#region DELETE MAP					
	if (keyboard_check(vk_shift) && keyboard_check_pressed(vk_backspace) ){
		current_map_number = 
			scr_delete_map(current_biome, current_map_list, 
			               current_map_number);
		current_level = 0;
	}
	#endregion

	#endregion

}

//Toggle show_map_types							//<=== NEW EPISODE 11
if (keyboard_check_pressed(ord("H"))){
	show_map_types = !show_map_types
}