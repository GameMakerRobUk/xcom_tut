/*
#region Terrain Grid Setup

#macro GRID_SIZE 16

#macro TILES_PER_MAP 10

current_map_number = 0;

isoON = true;
tile_width = sprite_get_width(t_grass);
tile_height = sprite_get_height(t_grass);
current_tile_to_place = e_tile_parts.ground;
current_level = 0; //what level is current visible
current_tile_set = e_tile_sets.farm_outside; //Which tile set should be drawn
show_all_levels = true; //Display all the tiles of all the levels in the editor
total_maps = 0; //How many 10x10 pieces have been made
horizontal_pieces = 1;
vertical_pieces = 1;
show_help = true;

//enum e_tile_parts{ ground, wall_west, wall_north, deco, last,} //What type of tile are we placing? Floor/West Wall/North Wall/Decoration?
//enum e_tile_sets{ farm_outside, barn, city, last,} //What biome?
enum e_t_stats{t_floor_index, t_wall_w_index, t_wall_n_index, t_deco_index, //Data that each cell holds
	           t_height, node_id, actor_id, last,
}
enum e_designation{field, road_N_end, road_W_end, road_N_W, road_E_end, //What kind of map is this?
	               road_N_E, road_E_W, building, road_S_end, road_N_S,
				   road_S_W, empty, road_S_E, last,
}
//enum e_map{ ground, west, north, deco, designation,}

a_tile_parts_txt[e_tile_parts.ground] = "GROUND";
a_tile_parts_txt[e_tile_parts.wall_west] = "WALLS WEST";
a_tile_parts_txt[e_tile_parts.wall_north] = "WALLS NORTH";
a_tile_parts_txt[e_tile_parts.deco] = "DECO";

tile_part_to_place = e_tile_parts.ground;

cx = 0;
cy = 0;



//Grid for stairs/doors
//e_tile_sets.something * 4

a_tile_set_txt[e_tile_sets.farm_outside] = "Farm - Outside";
a_tile_set_txt[e_tile_sets.barn] = "Farm - Barn";
a_tile_set_txt[e_tile_sets.city] = "City";

#endregion



#region CREATE THE GLOBAL MAP GRID AND SETUP THE CURRENT_MAP_LIST

/*
	Create a grid that will hold ALL the maps for ALL the biomes.
	If a cell in that grid is 0, there is no map
	Otherwise, it is a list that holds all the data for that map
*/

/*
global.all_maps = ds_grid_create(e_tile_sets.last, 1);

current_map_list = ds_list_create();
//scr_add_new_floor(e_tile_sets.farm_outside, current_map_list, current_level);

#endregion

#region MAP DESIGNATIONS

global.map_designations = ds_grid_create(e_tile_sets.last, 1);

des_text[e_designation.field] = "field";
des_text[e_designation.building] = "building";
des_text[e_designation.road_N_S] = "road_N_S";
des_text[e_designation.road_E_W] = "road_E_W";
des_text[e_designation.road_N_W] = "road_N_W";
des_text[e_designation.road_N_E] = "road_N_E";
des_text[e_designation.road_S_W] = "road_S_W";
des_text[e_designation.road_S_E] = "road_S_E";
des_text[e_designation.road_N_end] = "road_N_end";
des_text[e_designation.road_S_end] = "road_S_end";
des_text[e_designation.road_W_end] = "road_W_end";
des_text[e_designation.road_E_end] = "road_E_end";
des_text[e_designation.empty] = "do not assign";

show_designations = false;

#endregion

gridX = 0;
gridY = 0;

//Set Camera position
cx = -(tile_width * 7)
cy = -(tile_height * 5);
camera_set_view_pos(view_camera[0], cx, cy);

//scr_load_game_data();
//scr_load_map(0, e_tile_sets.farm_outside, current_map_list);

debug_on = false;