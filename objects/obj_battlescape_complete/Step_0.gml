#region CREATE BATTLESCAPE

if (state == e_bs.create){				//<=== NEW EPISODE 11
	
	#region GET RID OF ANY EXISTING LISTS/GRIDS IN THE BATTLESCAPE  <== NEW EPISODE 11
	
	for (var i = 0; i < ds_list_size(battlescape); i ++){
		var floor_grid = battlescape[| i];

		for (var yy = 0; yy < ds_grid_height(floor_grid); yy ++){
			for (var xx = 0; xx < ds_grid_width(floor_grid); xx ++){
				var data_list = floor_grid[# xx, yy];
				if (data_list != -1) ds_list_destroy(data_list);
			}
		}
		
		ds_grid_destroy(floor_grid);
	}
	
	ds_list_clear(battlescape);
	
	#endregion
	
	bs_biome = bs_data[e_bs_stats.biome][e_bs_values.actual]; //<=== NEW EPISODE 11
	var biome_list = global.all_biome_maps[| bs_biome ];	       //<== UPDATED EPISODE 11

	bs_w = bs_data[e_bs_stats.bs_w][e_bs_values.actual];//5; //How many 10x10 pieces wide should the battlescape map be?  <=== UPDATED EPISODE 11
	bs_h = bs_data[e_bs_stats.bs_h][e_bs_values.actual];//5; //How many 10x10 pieces high should the battlescape map be? <=== UPDATED EPISODE 11
	w = bs_w * BASE_TILES_PER_PIECE;
	h = bs_h * BASE_TILES_PER_PIECE;
	
	if (bs_data[e_bs_stats.map_to_use][e_bs_values.actual] > -1){												//<== NEW EPISODE 11
		
		#region Are we just using a single map as the battlescape?									<== NEW EPISODE 11
		
		scr_load_map(bs_biome, bs_data[e_bs_stats.map_to_use][e_bs_values.actual], battlescape);
		
		#endregion
		
	}else{																											//<== NEW EPISODE 11
		
		#region MAKE A RANDOMLY-GENERATED BATTLESCAPE using our new parameters  (Added this region EPISODE 11)
	
		#region Clear/update fields and building lists										  <== NEW EPISODE 11
	
		//Clear arrays
		for (var i = 0; i < e_map_type.last; i ++){
			ds_list_clear( bs_map_types[i] );
		}
	
		//Fill lists with maps  based on map type												<== NEW EPISODE 11
		for (var i = 0; i < ds_list_size(biome_list); i ++){
			var map = biome_list[| i];
			var map_type = global.map_types[bs_biome][i];
			var list = bs_map_types[map_type]
			ds_list_add( list, map);	
		}
	
		#endregion

		var buildings_placed = 0;					//<=== NEW EPISODE 11;

		var floor_grid = ds_grid_create(w, h);
		ds_grid_clear(floor_grid, -1); //-1 means this cell hasn't been updated yet

		ds_list_add(battlescape, floor_grid);
	
		#region ADD BUILDINGS TO BATTLESCAPE RANDOMLY	<=== NEW EPISODE 11
	
		var building_maps = bs_map_types[e_map_type.building];
	
		//If there are actually buildings to place
		if (ds_list_size(building_maps) > 0){
			//place as many buildings as wanted
			while ( buildings_placed < bs_data[e_bs_stats.wanted_buildings][0] ){
				//Every time we want to place a building, copy all of the building maps over to temp
				ds_list_copy(temp_list, building_maps);
			
				//Keep trying to place a building while there are maps we haven't tried
				while (ds_list_size(temp_list) > 0){
					//Pick a random building
					ds_list_shuffle(temp_list);
					var map_str = temp_list[| 0];
					ds_list_delete(temp_list, 0);
				
					ds_list_read(temp_list_of_grids, map_str);
					var grid_str = temp_list_of_grids[| 0];
			
					ds_grid_read(temp_floor_grid, grid_str);
				
					//How big is this building?
					var h_pieces = ds_grid_width( temp_floor_grid ) div BASE_TILES_PER_PIECE;
					var v_pieces = ds_grid_height( temp_floor_grid ) div BASE_TILES_PER_PIECE;
					
					//Pick a random start location (allowing for the size of the building)
					var attempts = 0;
					
					while (attempts < 20){
						var rand_x = irandom_range(1, bs_w - h_pieces);
						var rand_y = irandom_range(1, bs_h - v_pieces);
					
						var fits = scr_does_it_fit(rand_x, rand_y, h_pieces, v_pieces);
					
						if ( fits ){
						
							scr_build_battlescape(rand_x, rand_y, temp_list_of_grids, temp_floor_grid, h_pieces, v_pieces);
						
							break;
						}else attempts ++;
					}
				}
				//Increase number of buildings placed by 1, even if one wasn't successfully placed
				//(to avoid never-ending loops)
				buildings_placed ++;
			}
		
		}else buildings_placed = bs_data[e_bs_stats.wanted_buildings][0];
	
		#endregion
	
		//Fill in the rest of the battlescape, starting from the top left (this is the code we had before, with a few changes)
		for (var map_yy = 0; map_yy < bs_h; map_yy ++){

			for (var map_xx = 0; map_xx < bs_w; map_xx ++){
		
				var floor_grid = battlescape[| 0];
		
				//if this cell for the battlescape has been done, skip it
				if (floor_grid[# map_xx * BASE_TILES_PER_PIECE, map_yy * BASE_TILES_PER_PIECE] == -1){
				
					biome_list = bs_map_types[e_map_type.field];			//<=== UPDATED EPISODE 11
		
					//copy all biome maps to the temp like
					ds_list_copy(temp_biome_list, biome_list);
					//Shuffle the list for randomness
					ds_list_shuffle(temp_biome_list);
		
					var fits = false;
					//Keep choosing a random map (and remove the maps that dont fit) from the temp_biome_list 
					while (!fits){
			
						#region PICK RANDOM MAPS AND SEE IF THEY FIT				<=== UPDATED EPISODE 11
			
						//Get the map string
						var map_str = temp_biome_list[| 0];
						ds_list_delete(temp_biome_list, 0);
				
						//Get the hor/ver pieces of the map
						ds_list_read(temp_list_of_grids, map_str);
						var grid_str = temp_list_of_grids[| 0];
			
						ds_grid_read(temp_floor_grid, grid_str);
			
						var h_pieces = ds_grid_width(temp_floor_grid)/BASE_TILES_PER_PIECE;
						var v_pieces = ds_grid_height(temp_floor_grid)/BASE_TILES_PER_PIECE;
				
						//right now we have a temp_list of floor grid strings
						//the bottom floor grid (0) has been converted into a grid
						//the cells in that floor grid are still strings though
						//(they haven't been converted into lists yet)
				
						#region Does the map fit?																<=== UPDATED EPISODE 11
					
						#region COPY and COMMENT this out, moving it to a script		<=== EPISODE 11
						/* 
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
						*/
						#endregion
					
						var fits = scr_does_it_fit(map_xx, map_yy, h_pieces, v_pieces);
			
						#endregion
			
						#endregion
			
					}
		
					#region FITS - convert the map into usable data for the Battlescape
			
					if (fits){
					
						scr_build_battlescape(map_xx, map_yy, temp_list_of_grids, temp_floor_grid, h_pieces, v_pieces);		//<=== NEW EPISODE 11
					
						#region COPY and COMMENT out below, adding to scr_build_battlescape
					
						/*
						//Calculate the start_xx/start_yy/end_xx/end_yy for the battlescape
						var start_xx = map_xx * BASE_TILES_PER_PIECE;
						var end_xx = start_xx + (h_pieces * BASE_TILES_PER_PIECE);
						var start_yy = map_yy * BASE_TILES_PER_PIECE;
						var end_yy = start_yy + (v_pieces * BASE_TILES_PER_PIECE);
			
						for (var i = 0; i < ds_list_size(temp_list_of_grids); i ++){
							var floor_grid_str = temp_list_of_grids[| i];
				
							if (i >= ds_list_size(battlescape) ){
								var floor_grid = ds_grid_create(w, h);
								ds_list_add(battlescape, floor_grid);
							}else floor_grid = battlescape[| i];
				
							ds_grid_read(temp_floor_grid, floor_grid_str);
							var yy_count = 0;
				
							for (var yy = start_yy; yy < end_yy; yy ++){
								var xx_count = 0;
								for (var xx = start_xx; xx < end_xx; xx ++){
									//Get the list string
									var list_str = temp_floor_grid[# xx_count, yy_count];
						
									//Make a list
									var list = ds_list_create();
									//Convert the string into that list
									ds_list_read(list, list_str);
									//Save that list to the appropriate cell
									floor_grid[# xx, yy] = list;
						
									xx_count ++;
								}	
								yy_count ++;
							}
						}
			
						//Update map_xx
						map_xx += (h_pieces - 1);
						*/
						#endregion
					}
			
					#endregion
				}
			}
		}	
		
		#endregion //<== NEW EPISODE 11
		
	}
		
	state = e_bs.ready;  //<=== NEW EPISODE 11
}

#endregion

if (state == e_bs.ready){
	#region READY - change BS parameters?			<=== NEW EPISODE 11
	
	#region Change selected stat
	
	if (keyboard_check_pressed(vk_down) ){
		selected_bs_data ++;
		if selected_bs_data >= e_bs_stats.last selected_bs_data = 0;
	}
	
	if (keyboard_check_pressed(vk_up) ){
		selected_bs_data --;
		if selected_bs_data < 0 selected_bs_data = e_bs_stats.last - 1;
	}
	
	#endregion
	
	#region Change Value
	
	if (keyboard_check_pressed(vk_left) ){
		bs_data[selected_bs_data][e_bs_values.actual] --;
		if (bs_data[selected_bs_data][e_bs_values.actual] < bs_data[selected_bs_data][e_bs_values._min])
			bs_data[selected_bs_data][e_bs_values.actual] = bs_data[selected_bs_data][e_bs_values._min];
	}
	
	if (keyboard_check_pressed(vk_right) ){
		bs_data[selected_bs_data][e_bs_values.actual] ++;
		if (bs_data[selected_bs_data][e_bs_values.actual] > bs_data[selected_bs_data][e_bs_values._max])
			bs_data[selected_bs_data][e_bs_values.actual] = bs_data[selected_bs_data][e_bs_values._min];
	}
	
	#endregion
	
	//GENERATE
	if ( keyboard_check_pressed(vk_enter) ){
		
		//Update max_maps
		bs_biome = bs_data[e_bs_stats.biome][e_bs_values.actual]; 
		bs_data[e_bs_stats.map_to_use][e_bs_values._max] = ds_list_size(global.all_biome_maps[| bs_biome ] ) -1; 
		
		state = e_bs.create;
		
	}
	
	#endregion
}


#region Move Camera Around
	
if (keyboard_check(ord("W")) ) cy -= 8;
if (keyboard_check(ord("S")) ) cy += 8;
if (keyboard_check(ord("A")) ) cx -= 8;
if (keyboard_check(ord("D")) ) cx += 8;

camera_set_view_pos(view_camera[0], cx, cy);

#endregion