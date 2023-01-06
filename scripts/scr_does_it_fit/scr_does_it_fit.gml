/// @function scr_does_it_fit(map_xx, map_yy, h_pieces, v_pieces);
/// @param {real} map_xx The horizontal cell to start from
/// @param {real} map_yy The vertical cell to start from
/// @param {real} h_pieces How many horizontal cells in total?
/// @param {real} v_pieces How many vertical cells in total?

function scr_does_it_fit(map_xx, map_yy, h_pieces, v_pieces){
	fits = true; //will be set to false if any negative condition found
			
	for (var temp_yy = map_yy; temp_yy < (map_yy + v_pieces); temp_yy ++){
		for (var temp_xx = map_xx; temp_xx < (map_xx + h_pieces); temp_xx ++){
			var xx = (temp_xx * BASE_TILES_PER_PIECE);
			var yy = (temp_yy * BASE_TILES_PER_PIECE);
					
			floor_grid = battlescape[| 0];
					
			if (xx >= ds_grid_width(floor_grid) ||
				yy >= ds_grid_height(floor_grid) ||
				floor_grid[# xx, yy] != -1){
						
				//Map didn't fit
				fits = false;
				break;
			}
		}
	}
	
	return(fits);
}