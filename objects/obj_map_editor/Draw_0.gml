#region SET WHAT LEVELS WE WANT TO SEE

var end_level = current_level;	

if (show_all_levels){
	var start_level = 0;
}else{	
	var start_level = current_level;
}

#endregion

for (var levels = start_level; levels <= end_level; levels ++){ 
		
	var floor_grid = current_map_list[| levels];

	var hcells = ds_grid_width(floor_grid);
	var vcells = ds_grid_height(floor_grid);
		
	for (var yy = 0; yy < vcells; yy ++){
		for (var xx = 0; xx < hcells; xx ++){
			var draw_x = (xx - yy) * (tile_width / 2);
			var draw_y = ( (xx + yy) * (tile_height / 2) ) - (levels * 24); 
			//var draw_y = (xx + yy) * (tile_height / 2) - (levels * ( (tile_height * 2)) ); 
		
			var data = floor_grid [# xx, yy]; //Get the list for this cell  
		
			//We use a for loop to draw everything thats in the cell
			for (var i = 0; i < e_tile_parts.last; i ++){				
				var ind = data[| i];
			
				if (ind > 0){											
					var spr = global.biomes[i][current_biome];		
		
					//Draw the tile part (ground/wall west / wall north / deco 
					
					#region DRAW TILE PART AND MAKE WALLS TRANSPARENT IF THE CURSOR IS BEHIND THEM
					
					var alpha = 1;  
					
					if (i == e_tile_parts.wall_west) && grid_x = xx - 1 && (grid_y = yy || grid_y = yy - 1) alpha = 0.25; 
					if (i == e_tile_parts.wall_north) && grid_y = yy - 1 && (grid_x = xx || grid_x = xx - 1) alpha = 0.25;  
								
					draw_sprite_ext(spr, ind, draw_x, draw_y, 1, 1, 0, c_white, alpha);
					
					#endregion
					
				}														
			}
		
			#region TESTING - SHOW NUMBERS - commented out
			/*
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_set_colour(c_white);
			draw_text(draw_x + (tile_width / 2), draw_y, string( floor_grid[# xx, yy][| e_tile_parts.ground] ) );
			*/
			#endregion
			
			//Draw the cursor
			if (xx == grid_x && yy == grid_y)
				draw_sprite(spr_cursor, 0, draw_x, draw_y);
				
			#region SHOW A DELETE SPRITE IF THE SPRITE IS EMPTY OR RMB IS HELD  <== NEW EPISODE 10
					
			if (xx == grid_x && yy == grid_y && current_level == levels) && 
			   (mouse_check_button(mb_right) || tile_to_place == 0) 
					draw_sprite(spr_delete, tile_part_to_place, draw_x, draw_y);
					
			#endregion
				
			#region IF THE AXIS IS LOCKED, DISPLAY THE ROW/COLUMN  
					
			if (levels == current_level){
				if ( keyboard_check(ord("Z") ) && xx = grid_x ) || ( keyboard_check(ord("X") ) && yy = grid_y){
					draw_sprite_ext(t_grass, 1, draw_x, draw_y, 1, 1, 0, c_blue, 0.5);
					//Make it easier to see when editing higher levels
					if (levels > 0) draw_sprite(spr_cursor, 0, draw_x, draw_y + (tile_height * 2));
				}
			}
					
			#endregion
		}
	}
}