tile_width = sprite_get_width(t_grass);
tile_height = sprite_get_height(t_grass);
cx = 0;
cy = 0;
battlescape = ds_list_create();

temp_biome_list = ds_list_create(); //Will hold all the maps for the biome, and if a map doesn't fit, the map is removed
temp_list_of_grids = ds_list_create(); //temporarily holds the data for each map
temp_floor_grid = ds_grid_create(1,1); //temporarily holds the data for a floor_grid
temp_list = ds_list_create(); //										 <== NEW EPISODE 11

#region SETUP STATES AND BATTLESCAPE STATS   <=== NEW EPISODE 11

//enum e_bs { create, ready };   
//enum e_bs_stats { biome, bs_w, bs_h, wanted_buildings, map_to_use, last }; 
//enum e_bs_values { actual, text, _min, _max };

state = e_bs.create;

bs_data[e_bs_stats.biome] = [e_biomes.city, "Biome: ", 0, e_biomes.last - 1];
bs_data[e_bs_stats.bs_w] = [5, "Width: ", 1, 20]; //Horizontal pieces
bs_data[e_bs_stats.bs_h] = [5, "Height: ", 1, 20]; //Vertical pieces
bs_data[e_bs_stats.wanted_buildings] = [2, "Buildings: ", 0, 10];  //How many buildings should there be (max)
//If > -1, the whole BS will be a single map
bs_data[e_bs_stats.map_to_use] = [-1, "Single Map to use: ", -1, ds_list_size(global.all_biome_maps[| e_biomes.city ] ) -1 ]; 

selected_bs_data = e_bs_stats.biome;

#endregion

#region INITIALISE MAP_TYPES ARRAY  <=== NEW EPISODE 11

//Have a list for each map type eg (field / building etc)
for (var yy = 0; yy < e_map_type.last; yy ++){
	bs_map_types[yy] = ds_list_create();
}

#endregion