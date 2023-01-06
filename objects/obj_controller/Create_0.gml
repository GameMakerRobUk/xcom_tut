#region SETUP ENUMS	

//What biome will the map use?
enum e_biomes{ 
	farm_outside, 
	barn, 
	city, 
	last,
} 

//What type of tile are we placing? 
//Floor/West Wall/North Wall/Decoration?
enum e_tile_parts{ 
	ground, 
	wall_west, 
	wall_north, 
	deco, 
	last,
}

enum e_map_type{		
	not_assigned,
	field,
	building,
	last,
}

#endregion

#macro GRID_SIZE 16

//Make a text array that we can use in the map_editor GUI	
global.map_type_text[e_map_type.not_assigned] = "Not Assigned";
global.map_type_text[e_map_type.field] = "Field";
global.map_type_text[e_map_type.building] = "Building";

#region SETUP BIOME SPRITES

global.biomes[e_tile_parts.ground][e_biomes.farm_outside] = t_farm_floor;
global.biomes[e_tile_parts.wall_west][e_biomes.farm_outside] = t_farm_wall_w;
global.biomes[e_tile_parts.wall_north][e_biomes.farm_outside] = t_farm_wall_n;
global.biomes[e_tile_parts.deco][e_biomes.farm_outside] = t_farm_deco;

//New - Barn/Farm Buildings
global.biomes[e_tile_parts.ground][e_biomes.barn] = t_barn_floor;
global.biomes[e_tile_parts.wall_west][e_biomes.barn] = t_barn_wall_w;
global.biomes[e_tile_parts.wall_north][e_biomes.barn] = t_barn_wall_n;
global.biomes[e_tile_parts.deco][e_biomes.barn] = t_barn_deco;

//New City
global.biomes[e_tile_parts.ground][e_biomes.city] = t_city_floor;
global.biomes[e_tile_parts.wall_west][e_biomes.city] = t_city_wall_w;
global.biomes[e_tile_parts.wall_north][e_biomes.city] = t_city_wall_n;
global.biomes[e_tile_parts.deco][e_biomes.city] = t_city_deco;

#endregion

#region SAVING/LOADING

//Create an array with text to help us identfy what biome we're on
global.biome_text[e_biomes.farm_outside] = "Farm - Outside";
global.biome_text[e_biomes.barn] = "Barn";
global.biome_text[e_biomes.city] = "City";

#macro MAX_LEVELS 12		
global.all_biome_maps = ds_list_create();

//Create a list for each biome (this list stores all maps for that biome)
for (var i = 0; i < e_biomes.last; i ++){
	var biome_map_list = ds_list_create();
	//Add as many lists as there are biomes to THIS list
	ds_list_add(global.all_biome_maps, biome_map_list);
}		

scr_external_load();					

#endregion

//Load the map editor room
room_goto(rm_map_editor);		
//room_goto(rm_battlescape);