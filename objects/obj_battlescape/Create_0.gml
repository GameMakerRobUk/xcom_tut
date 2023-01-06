tile_width = sprite_get_width(t_grass);
tile_height = sprite_get_height(t_grass);
cx = 0;
cy = 0;

battlescape = ds_list_create();
bs_biome = e_biomes.farm_outside;

temp_biome_list = ds_list_create(); //Will hold all the maps for the biome, and if a map doesn't fit, the map is removed
temp_list_of_grids = ds_list_create(); //temporarily holds the data for each map
temp_floor_grid = ds_grid_create(1,1); //temporarily holds the data for a floor_grid
temp_list = ds_list_create();		//<== step 7

#region SETUP STATES AND BATTLESCAPE STATS   

enum e_bs { create, ready };  
enum e_bs_stats { biome, bs_w, bs_h, wanted_buildings, map_to_use, last }; 
enum e_bs_values { actual, text, _min, _max };

state = e_bs.create;          

bs_data[e_bs_stats.biome] = [e_biomes.city, "Biome: ", 0, e_biomes.last - 1];
bs_data[e_bs_stats.bs_w] = [5, "Width: ", 1, 20]; //Horizontal pieces
bs_data[e_bs_stats.bs_h] = [5, "Height: ", 1, 20]; //Vertical pieces
bs_data[e_bs_stats.wanted_buildings] = [2, "Buildings: ", 0, 10];  //How many buildings should there be (max)
//If > -1, the whole BS will be a single map
bs_data[e_bs_stats.map_to_use] = [-1, "Single Map to use: ", -1, ds_list_size(global.all_biome_maps[| e_biomes.city ] ) -1 ]; 

selected_bs_data = e_bs_stats.biome;

#endregion   

#region INITIALISE MAP_TYPES ARRAY  

//Have a list for each map type eg (field / building etc)
for (var yy = 0; yy < e_map_type.last; yy ++){
	bs_map_types[yy] = ds_list_create();
}

#endregion

current_level = 0;	
show_roof = false;

#region Track which images are stairs / doors  

enum e_stair_type { none, lower, upper };
enum e_door_type { none, closed, open };

#region INITIALISE deco_tracker arrays
/*
	For every biome, and every tile part, make an array that is as long as 
	there are images in that tile_part's sprite. Eg if there are 10 west_wall 
	pieces for the city biome, that array should be 10 entries long.
	We won't use the array for floors (I think) but using a double for loop
	like this saves us many lines of code!
*/
for (var biome = 0; biome < e_biomes.last; biome ++){
	for (var tile_part = 0; tile_part < e_tile_parts.last; tile_part ++){
		var spr = global.biomes[tile_part][biome];
		var images = sprite_get_number(spr);
	
		deco_tracker[biome][tile_part] = array_create(images);
	}
}

#endregion

#region UPDATE deco_tracker arrays

deco_tracker[e_biomes.barn][e_tile_parts.deco][1] = e_stair_type.lower;
deco_tracker[e_biomes.barn][e_tile_parts.deco][2] = e_stair_type.upper;

deco_tracker[e_biomes.city][e_tile_parts.deco][1] = e_stair_type.lower;
deco_tracker[e_biomes.city][e_tile_parts.deco][2] = e_stair_type.upper;
deco_tracker[e_biomes.city][e_tile_parts.deco][3] = e_stair_type.lower;
deco_tracker[e_biomes.city][e_tile_parts.deco][4] = e_stair_type.upper;

deco_tracker[e_biomes.barn][e_tile_parts.wall_west][1] = e_door_type.closed;
deco_tracker[e_biomes.barn][e_tile_parts.wall_north][1] = e_door_type.closed;

//If there are more than 2 to change, I'm using a for loop.
for (var i = 1; i <= 4; i ++){
	deco_tracker[e_biomes.city][e_tile_parts.wall_west][i] = e_door_type.closed;
	deco_tracker[e_biomes.city][e_tile_parts.wall_north][i] = e_door_type.closed;
}

#endregion

#endregion