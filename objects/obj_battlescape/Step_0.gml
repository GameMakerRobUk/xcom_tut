if (state == e_bs.create){      

	#region CREATE BATTLESCAPE 
	
	#region GET RID OF ANY EXISTING LISTS/GRIDS IN THE BATTLESCAPE 
	
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
	
	bs_biome = bs_data[e_bs_stats.biome][e_bs_values.actual]; 
	var biome_list = global.all_biome_maps[| bs_biome ];	       

	bs_w = bs_data[e_bs_stats.bs_w][e_bs_values.actual]; 
	bs_h = bs_data[e_bs_stats.bs_h][e_bs_values.actual];  
	w = bs_w * BASE_TILES_PER_PIECE;
	h = bs_h * BASE_TILES_PER_PIECE;
	
	if (bs_data[e_bs_stats.map_to_use][e_bs_values.actual] > -1){		
		
		#region Are we just using a single map as the battlescape?		
		
		scr_load_map(bs_biome, bs_data[e_bs_stats.map_to_use][e_bs_values.actual], battlescape);
		
		#endregion
		
	}else{
	
		#region Clear/update fields and building lists	
	
		//Clear lists
		for (var i = 0; i < e_map_type.last; i ++){
			ds_list_clear( bs_map_types[i] );
		}
	
		//Fill lists with maps  based on map type			
		for (var i = 0; i < ds_list_size(biome_list); i ++){
			var map = biome_list[| i];
			var map_type = global.map_types[bs_biome][ i ];
			var list = bs_map_types[map_type];
			ds_list_add( list, map);	
		}
	
		#endregion
	
		var buildings_placed = 0;				                      

		var floor_grid = ds_grid_create(w, h);
		ds_grid_clear(floor_grid, -1); //-1 means this cell hasn't been updated yet

		ds_list_add(battlescape, floor_grid);
	
		#region ADD BUILDINGS TO BATTLESCAPE RANDOMLY	
	
		var building_maps = bs_map_types[e_map_type.building];
	
		//If there are actually buildings to place
		if (ds_list_size(building_maps) > 0){
			//place as many buildings as wanted
			while ( buildings_placed < bs_data[e_bs_stats.wanted_buildings][0] ){
			
				#region Try and place a building
			
				//Every time we want to place a building, copy all of the building maps over to temp
				ds_list_copy(temp_list, building_maps);
			
				//Keep trying to place a building while there are maps we haven't tried
				while (ds_list_size(temp_list) > 0){
				
					#region Try a random building from our temp_list
				
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
					
						#region Pick random coordinates (up to 20 times)
					
						var rand_x = irandom_range(0, bs_w - h_pieces);
						var rand_y = irandom_range(0, bs_h - v_pieces);
					
						var fits = scr_does_it_fit(rand_x, rand_y, h_pieces, v_pieces);
					
						if ( fits ){
						
							scr_build_battlescape(rand_x, rand_y, temp_list_of_grids, temp_floor_grid, h_pieces, v_pieces);
						
							break;
						}else attempts ++;
					
						#endregion
					
					}
				
					#endregion
				
				}
				//Increase number of buildings placed by 1, even if one wasn't successfully placed
				//(to avoid never-ending loops)
				buildings_placed ++;
			
				#endregion
			
			}
		
		}else buildings_placed = bs_data[e_bs_stats.wanted_buildings][e_bs_values.actual];
	
		#endregion

		#region FILL IN REST OF BATTLESCAPE    
	
		for (var map_yy = 0; map_yy < bs_h; map_yy ++){

			for (var map_xx = 0; map_xx < bs_w; map_xx ++){
		
				var floor_grid = battlescape[| 0];
		
				//if this cell for the battlescape has been done, skip it
				if (floor_grid[# map_xx * BASE_TILES_PER_PIECE, map_yy * BASE_TILES_PER_PIECE] == -1){
		
					biome_list = bs_map_types[e_map_type.field]; 
				
					//copy all biome maps to the temp like
					ds_list_copy(temp_biome_list, biome_list);
					//Shuffle the list for randomness
					ds_list_shuffle(temp_biome_list);
		
					var fits = false;
					//Keep choosing a random map (and remove the maps that dont fit) 
					//from the temp_biome_list 
					while (!fits){
			
					#region PICK RANDOM MAPS AND SEE IF THEY FIT
			
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
				
					#region Does the map fit?
				
					var fits = scr_does_it_fit(map_xx, map_yy, h_pieces, v_pieces);
			
					#endregion
			
					#endregion
			
				}
		
				#region FITS - convert the map into usable data for the Battlescape  
			
				if (fits){
					map_xx = scr_build_battlescape(map_xx, map_yy, temp_list_of_grids, temp_floor_grid, h_pieces, v_pieces); 
				}
			
				#endregion
			
				}
			}
		}
	
		#endregion  

	}

	#endregion                    
	
	#region CREATE NODES					<=== UPDATED EP 17
	
	//Get rid of any existing nodes
	with obj_node instance_destroy();
	
	//So that we dont need 3 sets of this double for loop, I've used
	//"task" to represent what needs to be done within each iteration
	//of the double for loop. 
	for (var task = 0; task < 3; task ++){
		for (var level = 0; level < MAX_LEVELS; level ++){
			
			var floor_grid = battlescape[| level];
			
			for (var yy = 0; yy < h; yy ++){
				for (var xx = 0; xx < w; xx ++){
					
					if (task == 0){
						#region CREATE A NODE FOR EVERY CELL			<=== UPDATED EP 17
						
						// !!! Replacing structs with objects sorry! Tried something new and it didn't work! !!!
						
						//Create a struct for every cell, regardless of whether there's terrain or not
						//all_nodes[level][xx][yy] = {
						//	nodes_adj_all : array_create(0), //An array that stores all 8 adjacent nodes (up to 8 depending on node location)
						//	nodes_walk : array_create(0), //Stores all nodes that are WALKABLE from this node
						//}
						
						var _xx = xx * GRID_SIZE;												// <== NEW EP 17
						var _yy = yy * GRID_SIZE;												// <== NEW EP 17
						all_nodes[level][xx][yy] = instance_create_layer(_xx,_yy,layer,obj_node);  //	<=== UPDATED EP 17
						
						with all_nodes[level][xx][yy]{				
							nodes_adj_all = array_create(0); //An array that stores all 8 adjacent nodes (up to 8 depending on node location)
							nodes_walk = array_create(0); //Stores all nodes that are WALKABLE from this node
							grid_x = xx; //Store location of this node
							grid_y = yy; //Store location of this node
							_dist = 0;
							_parent = noone;
							_level = level;  
							actor_id = noone;
						}
						
						#endregion
					}
					if (task == 1){
						#region Fill nodes_adj_all array
						var node = all_nodes[level][xx][yy];
						
						//We want to end up with an array of 9 entries, with either struct_id's or -1 as the entries
						for (var adj_yy = (yy - 1); adj_yy < (yy + 2); adj_yy ++){
							for (var adj_xx = (xx - 1); adj_xx < (xx + 2); adj_xx ++){
								//If we're within bounds of the battlescape, add the adjacent node to this node's array
								if (adj_xx >= 0 && adj_xx < w && adj_yy >= 0 && adj_yy < h) {
									var adj_node = all_nodes[level][adj_xx][adj_yy];
									array_push(node.nodes_adj_all, adj_node); //all_nodes[level][adj_xx + x_count][adj_yy + y_count]
								}else array_push(node.nodes_adj_all, -1);
							}
						}	
						
						//Set the middle entry as -1 (because the middle entry is storing the node's id, we don't want that)
						node.nodes_adj_all[4] = -1;
						
						//Finally copy nodes_adj_all to the nodes_walk array
						for (var i = 0; i < array_length(node.nodes_adj_all); i ++)
							if (node.nodes_adj_all[i] != -1) array_push(node.nodes_walk, node.nodes_adj_all[i]);
						#endregion
					}
					if (task == 2){
						#region UPDATE nodes_walk arrays based on walls blocking movement
						var node = all_nodes[level][xx][yy];
						
						//Check for walls
						if (floor_grid != undefined) var data = floor_grid[# xx, yy];
						else data = -1;
						
						if (data != -1){
							var nodes_to_delete = array_create(0);
							var wall_w_image_index = data[| e_tile_parts.wall_west];													
							var door_value_w = deco_tracker[bs_biome][e_tile_parts.wall_west][wall_w_image_index]; 
							var wall_n_image_index = data[| e_tile_parts.wall_north];											
							var door_value_n = deco_tracker[bs_biome][e_tile_parts.wall_north][wall_n_image_index]; 
							
							//West wall blocks 0,3,6
							if (data[| e_tile_parts.wall_west] > 0 && door_value_w == e_door_type.none){ 
								array_push(nodes_to_delete, node.nodes_adj_all[0],
																				node.nodes_adj_all[3],
																				node.nodes_adj_all[6] );
							
								#region west walls - 3 blocks 1&7, and vice versa
								
								var adj_3 = node.nodes_adj_all[3];
								if (adj_3 != -1){
									var adj_1 = node.nodes_adj_all[1];
									var adj_7 = node.nodes_adj_all[7];
									var index = array_find(adj_3.nodes_walk, adj_1);
									if (index != -1) array_delete(adj_3.nodes_walk, index, 1);
									var index = array_find(adj_3.nodes_walk, adj_7);
									if (index != -1) array_delete(adj_3.nodes_walk, index, 1);
									
									if (adj_1 != -1){
										var index = array_find(adj_1.nodes_walk, adj_3);
										if (index != -1) array_delete(adj_1.nodes_walk, index, 1);
									}
									if (adj_7 != -1){
										var index = array_find(adj_7.nodes_walk, adj_3);
										if (index != -1) array_delete(adj_7.nodes_walk, index, 1);
									}
								}
								
								#endregion
							}
							//North wall blocks 0,1,2 - note that we can add 0 twice, that's OK.																								  
							if (data[| e_tile_parts.wall_north] > 0 && door_value_n == e_door_type.none){  
								array_push(nodes_to_delete, node.nodes_adj_all[0],
																				node.nodes_adj_all[1], 
																				node.nodes_adj_all[2]);
																				
								#region north wall 1 blocks 3&5, and vice versa
								
								var adj_1 = node.nodes_adj_all[1];
								if (adj_1 != -1){
									var adj_3 = node.nodes_adj_all[3];
									var adj_5 = node.nodes_adj_all[5];
									var index = array_find(adj_1.nodes_walk, adj_3);
									if (index != -1) array_delete(adj_1.nodes_walk, index, 1);
									var index = array_find(adj_1.nodes_walk, adj_5);
									if (index != -1) array_delete(adj_1.nodes_walk, index, 1);
									
									if (adj_3 != -1){
										var index = array_find(adj_3.nodes_walk, adj_1);
										if (index != -1) array_delete(adj_3.nodes_walk, index, 1);
									}
									if (adj_5 != -1){
										var index = array_find(adj_5.nodes_walk, adj_1);
										if (index != -1) array_delete(adj_5.nodes_walk, index, 1);
									}
								}
								
								#endregion								
							}
							
							#region DECORATION																	
							
							var deco_index = data[| e_tile_parts.deco];	                                   
							var stair_value = deco_tracker[bs_biome][e_tile_parts.deco][deco_index];
							
							if (data[| e_tile_parts.deco] > 0 && stair_value != e_stair_type.lower){ 
								//There is decoration, stop movement from all adjacent tiles
								for (var i = 0; i < array_length(node.nodes_adj_all); i ++){
									array_push(nodes_to_delete, node.nodes_adj_all[i]);
								}
							}
							
							#endregion
							
							#region Upper stair - connects to lower stair (7) and 0,1,2 in the upper level 
							
							if (stair_value == e_stair_type.upper){
								//Keep 7 as a connected node
								var adj_7 = node.nodes_adj_all[7];
								var index = array_find(nodes_to_delete, adj_7);
								if (index != -1) array_delete(nodes_to_delete, index, 1);
									
								//Add 1 from floor above
								if (level + 1 < MAX_LEVELS){
									var upper_node = all_nodes[level + 1][xx][yy];
									var nodes_to_add = [1];
									
									//This will probably be a script I replace all the "adding nodes stuff" with
									//passing an array to get the node_id's from and an array of entries to check 
									//the node_id array with.
									for (var i = 0; i < array_length(nodes_to_add); i ++){
										var node_to_add = upper_node.nodes_adj_all[ nodes_to_add[i] ];	
										if (node_to_add != -1){
											var index = array_find(node.nodes_walk, node_to_add);
											if (index == -1) array_push(node.nodes_walk, node_to_add);
										}
									}
								}
							}
							
							#endregion
							
							//Now we have an array of nodes that are blocked by this nodes walls
							for (var i = 0; i < array_length(nodes_to_delete); i ++){
								var adj_node = nodes_to_delete[i];
								
								//We might have added "-1's" to the nodes_to_delete array
								if (adj_node != -1){
								
									//remove adj_node from node's nodes_walk array
									var index = array_find(node.nodes_walk, adj_node);
									if (index != -1) array_delete(node.nodes_walk, index, 1);
								
									//Remove node from nodes_adj_all' nodes_walk array
									var index = array_find(adj_node.nodes_walk, node);
									if (index != -1) array_delete(adj_node.nodes_walk, index, 1);
								}
							}
							
						}//else there are no walls data == -1
						
						#region TILE BELOW 
							
						if (level > 0) && (data == -1 || data[| e_tile_parts.ground] == 0){
							var node_below = all_nodes[level - 1][xx][yy];
							array_push(node.nodes_walk, node_below);
						}
							
						#endregion
						
						//Edge case - above doesn't work for 1 case
						if (yy + 1) < h && floor_grid != undefined && floor_grid[# xx, yy + 1] != -1{
							if (floor_grid[# xx, yy + 1][| e_tile_parts.wall_north] > 0){
								var adj_node = node.nodes_adj_all[8];	
								if (adj_node != -1){
									var index = array_find(node.nodes_walk, adj_node);
									if (index != -1) array_delete(node.nodes_walk, index, 1);
								}
							}
						}
						
						#endregion
					}
				}
			}
		}
	}
	
	#endregion
	
	nodes_within_range = []; //Array to hold nodes within walk range of highlighted node
	path = []; //Array to hold the nodes that will be a path			
	
	#region CREATE UNITS				<=== UPDATED EP 17
	
	//Just one for now!
	spawn_x = ceil(w/2);
	spawn_y = ceil(h/2);
	
	var unit = instance_create_layer(spawn_x * GRID_SIZE, spawn_y * GRID_SIZE, layer, obj_actor);
	all_nodes[0][spawn_x][spawn_y].actor_id = unit;
	
	#region UPDATE UNIT VARS				<=== NEW EPISODE 17
	
	unit.grid_x = spawn_x;
	unit.grid_y = spawn_y;
	unit.level = 0;
	
	#endregion
	
	#endregion
	
	state = e_bs.ready;  
}                                          

if (state == e_bs.ready){       

	#region READY - change BS parameters
	
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
	
	#region GENERATE
	
	if ( keyboard_check_pressed(vk_enter) ){
		
		//Update max_maps
		bs_biome = bs_data[e_bs_stats.biome][e_bs_values.actual]; 
		bs_data[e_bs_stats.map_to_use][e_bs_values._max] = ds_list_size(global.all_biome_maps[| bs_biome ] ) -1; 
		
		state = e_bs.create;
		
	}
	
	#endregion
	
	#endregion                
	
	#region CURSOR  
	
	cursor_x = floor((mouse_x / tile_width) + (mouse_y / tile_height));
	cursor_y = floor((mouse_y / tile_height) - (mouse_x / tile_width));	
	
	cursor_x = clamp(cursor_x, 0, w - 1);
	cursor_y = clamp(cursor_y, 0, h - 1);
	
	//test nodes_walk
	var node = all_nodes[current_level][cursor_x][cursor_y];
	neighbours = node.nodes_walk;
	
	#endregion
	
	#region CHANGE CURRENT_LEVEL

	if (keyboard_check_pressed(vk_up) ) current_level ++;
	if (keyboard_check_pressed(vk_down) ) current_level --;
	current_level = clamp(current_level, 0, MAX_LEVELS - 1);

	#endregion
	
	#region PATH FINDING	  <=== UPDATED EPISODE 17
	
	/*
		To check our node system we want to be able to click any node
		anywhere in the map and see if a path can be generated for our unit
	*/
	
	if (mouse_check_button_pressed(mb_left) ){
		ca = obj_actor;																  //<=== NEW EPISODE 17
		var start_node = all_nodes[ca.level][ca.grid_x][ca.grid_y];  //<=== UPDATED EP 17
		var range = 6;
		
		if (array_length(nodes_within_range) == 0){ 
			nodes_within_range = scr_display_action_nodes(start_node, range);
			path_start_node = start_node;				
		}else{
			//Create a path from our nodes within range											
			var end_node = all_nodes[current_level][cursor_x][cursor_y];               
			
			if (array_find(nodes_within_range, end_node) != -1){		//<=== NEW EPISODE 17
				path = scr_generate_path(path_start_node, end_node, path);                  
				nodes_within_range = []; //Clear nodes_within_range		

				if (array_length(path) > 1){							//<=== NEW EPISODE 17
					#region Make actor move						<=== NEW EPISODE 17
			
					//Remove ca from current node
					all_nodes[ca.level][ca.grid_x][ca.grid_y].actor_id = noone;
					with ca{
						state = e_actor.move;                                         
						path = other.path;
						target_node = scr_get_next_path_node(path);
					}
			
					#endregion
				}
			}
		}
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