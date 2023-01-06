//1 horizontal/vertical "piece" is 10x10
//2 hor, 1 ver = 20x10
//2 hor, 2 ver = 20x20 etc

//Get the width/height of an isometric tile 
//(only the diamond top part matters)

#macro BASE_TILES_PER_PIECE 10 //How many tiles horizontally/vertically is 1 "piece"

tile_width = sprite_get_width(t_grass);
tile_height = sprite_get_height(t_grass);

horizontal_pieces = 1;							
vertical_pieces = 1;							
									
var vcells = 10;											

enum e_cell{ part_to_place };

current_biome = e_biomes.farm_outside;
current_level = 0; //what level is current visible  
current_map_list = ds_list_create();
current_map_number = 0;		
scr_add_new_floor(current_map_list, current_level); 

tile_to_place = 1;									
tile_part_to_place = e_tile_parts.ground;     

show_all_levels = true;
show_map_types = false; //<=== NEW EPISODE 11

#region Set Camera position - Updated coords so camera should be centered regardless of size 

cx = -(camera_get_view_width(view_camera[0]) / 2) + (tile_width / 2);  
cy = -(camera_get_view_height(view_camera[0]) / 2) + ( (vcells * tile_height) / 2); 

camera_set_view_pos(view_camera[0], cx, cy);

#endregion

#region Setup Saving/loading

scr_external_load();					
if (global.all_biome_maps[| current_biome][| current_map_number] != undefined){ 
	scr_load_map(current_biome, current_map_number, current_map_list);          
}																				

#endregion