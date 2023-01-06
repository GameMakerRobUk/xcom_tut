if (show_roof){
	var end_level = ds_list_size(battlescape) - 1;	
}else end_level = current_level;

for (var levels = 0; levels <= end_level; levels ++){ 

	var floor_grid = battlescape[| levels];

	var hcells = ds_grid_width(floor_grid);
	var vcells = ds_grid_height(floor_grid);
		
	for (var yy = 0; yy < vcells; yy ++){
		for (var xx = 0; xx < hcells; xx ++){
			var draw_x = (xx - yy) * (tile_width / 2);
			var draw_y = ( (xx + yy) * (tile_height / 2) ) - (levels * 24); 
		
			var data = floor_grid[# xx, yy]; //Get the list for this cell  
			var node = all_nodes[levels][xx][yy];  
			var actor_id = node.actor_id;			
			
			if (data != -1){
		
				//We use a for loop to draw everything thats in the cell
				for (var i = 0; i < e_tile_parts.last; i ++){				
					var ind = data[| i];
			
					//if (ind > 0 && i != e_tile_parts.wall_west){		
					if (ind > 0){		
						var spr = global.biomes[i][bs_biome];		
						draw_sprite(spr, ind, draw_x, draw_y);
					}														
				}
			}
			
			#region Draw actor																		
			
			if (actor_id != noone){
				var _xx = actor_id.x / GRID_SIZE; 
				var _yy = actor_id.y / GRID_SIZE;

				//Work out draw coordinates for the current_actor
				var actor_x = (_xx - _yy) * (tile_width / 2);
				var actor_y = ( (_xx + _yy) * (tile_height / 2) ) - (actor_id.level * 24); 
				draw_sprite(actor_id.sprite_index, actor_id.image_index, actor_x, actor_y);
			}
			
			#endregion
			
			//Draw the cursor										
			if (levels == current_level && xx == cursor_x && yy == cursor_y) 
				draw_sprite(spr_cursor, 0, draw_x, draw_y);
		}
	}
}

//Test nodes_within_range		
if (array_length(nodes_within_range) > 0) var a = nodes_within_range; 
else a = path;																		

for (var i = 0; i < array_length(a); i ++){ 

	var node = a[i];                         
	
	if (node._level == current_level){  
		var draw_x = (node.grid_x - node.grid_y) * (tile_width / 2);
		var draw_y = ( (node.grid_x + node.grid_y) * (tile_height / 2) ) - (current_level * 24); 
		draw_sprite_ext(t_grass, 0, draw_x, draw_y, 1, 1, 0, c_black, 0.5);
	}
}

//Test nodes_walk			
for (var i = 0; i < array_length(neighbours); i ++){ 

	var node = neighbours[i];
	
	var draw_x = (node.grid_x - node.grid_y) * (tile_width / 2);
	var draw_y = ( (node.grid_x + node.grid_y) * (tile_height / 2) ) - (current_level * 24); 

	draw_sprite_ext(t_grass, 0, draw_x, draw_y, 1, 1, 0, c_olive, 0.5);
}