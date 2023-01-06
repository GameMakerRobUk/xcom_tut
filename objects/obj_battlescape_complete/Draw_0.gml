if (state == e_bs.ready){			//<=== NEW EPISODE 11

	for (var levels = 0; levels < ds_list_size(battlescape); levels ++){

		var floor_grid = battlescape[| levels];

		var hcells = ds_grid_width(floor_grid);
		var vcells = ds_grid_height(floor_grid);
		
		for (var yy = 0; yy < vcells; yy ++){
			for (var xx = 0; xx < hcells; xx ++){
				var draw_x = (xx - yy) * (tile_width / 2);
				//var draw_y = (xx + yy) * (tile_height / 2) -     
				//	            (levels * ( (tile_height * 2)) ); 
				var draw_y = ( (xx + yy) * (tile_height / 2) ) - (levels * 24);
		
				var data = floor_grid[# xx, yy]; //Get the list for this cell  
			
				if (data != -1){
		
					//We use a for loop to draw everything thats in the cell
					for (var i = 0; i < e_tile_parts.last; i ++){				
						var ind = data[| i];
			
						if (ind > 0){											
							var spr = global.biomes[i][bs_biome];		
		
							//Draw the tile part (ground/wall west / wall north / deco 
							draw_sprite(spr, ind, draw_x, draw_y);
						}														
					}
		
				}
				////Draw the cursor
				//if (xx == grid_x && yy == grid_y)
				//	draw_sprite(spr_cursor, 0, draw_x, draw_y);
			}
		}
	}

}