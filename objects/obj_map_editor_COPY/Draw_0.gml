//for (var levels = 0; levels < current_level; levels ++){
for (var levels = 0; levels < ds_list_size(current_map_list); levels ++){
	
	if (show_all_levels || current_level == levels){
		
		//var ds_terrain_data = a_floor_levels[levels];
		var floor_grid = current_map_list[| levels];
		
		if (floor_grid != undefined){
		
			var hcells = ds_grid_width(floor_grid);
			var vcells = ds_grid_height(floor_grid);
		
			for (var yy = 0; yy < vcells; yy ++){
				for (var xx = 0; xx < hcells; xx ++){
					
					var draw_x = (xx - yy) * (tile_width / 2);
					var draw_y = (xx + yy) * (tile_height / 2) - (levels * ( (tile_height * 2) - 6) );
					var draw_y_lines = (xx + yy) * (tile_height / 2) - ( (levels - 1) * ( (tile_height * 2) - 6) );
					
					if (levels > 0 && levels <= current_level){
						//DRAW AN OUTLINE ON THE EDGES TO MAKE THINGS EASIER TO VISUALISE
						if (xx == 0) draw_sprite(spr_building_lines, 0, draw_x, draw_y_lines);
						if (yy == 0) draw_sprite(spr_building_lines, 1, draw_x, draw_y_lines);
					}
					
					var data_list = floor_grid [# xx, yy];
		
					for (var i = 0; i < e_tile_parts.last; i ++){
		
						//var spr = data_list[| i + 4];
						//if (spr == spr_down_arrow) show_debug_message("spr - draw line 32 obj_map_editor: " + string(spr) + " | tile_part: " + a_tile_parts_txt[i] );
						var spr = global.a_tile_sets[i][current_tile_set];
						var ind = data_list[| i];

						if (debug_on == false){
							if (isoON && ind > -1){
								//IF THE CURSOR IS BEHIND A WEST/NORTH WALL, MAKE THE WALL TRANSPARENT
								var alpha = 1;
								if (i == e_tile_parts.wall_west) && gridX = (xx - 1) && (gridY = yy || gridY = yy - 1) alpha = 0.25;
								if (i == e_tile_parts.wall_north) && gridY = (yy - 1) && (gridX = xx || gridX = xx - 1) alpha = 0.25;
								
								draw_sprite_ext(spr, ind, draw_x, draw_y, 1, 1, 0, c_white, alpha);
				
							}
						}else{
							draw_set_font(fnt_debug);
							if (i == tile_part_to_place)
								draw_text(draw_x, draw_y, string(spr) + " | " + string(ind) );	
						}
						
					}
					
					if (xx == gridX && yy == gridY){
						//SHOW CURSOR AND THE TILE THAT WILL BE PLACED
						var spr = global.a_tile_sets[tile_part_to_place][current_tile_set];
						if (levels <= current_level && levels > 0) draw_sprite(spr_cursor, 0, draw_x, draw_y + (tile_height * 2));
						if (levels == current_level) draw_sprite_ext(spr, current_tile_to_place, draw_x, draw_y, 1, 1, 0, c_gray, 0.5);
					}
					
					#region IF THE AXIS IS LOCKED, DISPLAY THE ROW/COLUMN
					
					if (levels == current_level){
						if keyboard_check(ord("Z") ){
							//X AXIS IS LOCKED
							if (xx = gridX){
								draw_sprite_ext(t_grass, 1, draw_x, draw_y, 1, 1, 0, c_blue, 0.5);
								if (levels > 0) draw_sprite(spr_cursor, 0, draw_x, draw_y + (tile_height * 2));
							}
						}
						if keyboard_check(ord("X") ){
							//X AXIS IS LOCKED
							if (yy = gridY){
								draw_sprite_ext(t_grass, 1, draw_x, draw_y, 1, 1, 0, c_blue, 0.5);
								if (levels > 0) draw_sprite(spr_cursor, 0, draw_x, draw_y + (tile_height * 2));
							}
						}
					}
					
					#endregion
					
					#region SHOW A DELETE SPRITE IF THE SPRITE IS EMPTY OR RMB IS HELD
					
					if (xx == gridX && yy == gridY && current_level == levels) && (mouse_check_button(mb_right) || current_tile_to_place == 0) 
						draw_sprite(spr_delete, tile_part_to_place, draw_x, draw_y);
					
					#endregion
					
					if (levels > 0 && levels <= current_level){
						//DRAW AN OUTLINE ON THE EDGES TO MAKE THINGS EASIER TO VISUALISE
						if (xx == (hcells - 1)) draw_sprite(spr_building_lines, 2, draw_x, draw_y_lines);
						if (yy == (vcells - 1)) draw_sprite(spr_building_lines, 3, draw_x, draw_y_lines);
					}
				}
			}
		
		}else show_debug_message("[ERROR] There is no grid for this floor level")
	}
}