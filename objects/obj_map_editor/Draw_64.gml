#region SHOW WHAT TILE IS GOING TO BE PLACED

var spr = global.biomes[tile_part_to_place][current_biome];
var scale = 2;
var dx = (display_get_gui_width()/2 ) - ( (scale * tile_width) / 2);
var dy = display_get_gui_height() - sprite_get_height(spr);

draw_sprite_ext(spr, tile_to_place, dx, dy, scale, scale, 0, c_white, 1);

#endregion

//Tell us what biome we're on	
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(c_white);			//<== NEW EPISODE 11
draw_text(display_get_gui_width() / 2, 0, global.biome_text[current_biome] );
draw_text(display_get_gui_width() / 2, 20, 
"Current Level: " + string(current_level) ); 
draw_text(display_get_gui_width() / 2, 40, 
"Current Map Number: " + string(current_map_number) ); 

#region SHOW / CHANGE MAP TYPE <=== NEW EPISODE 11

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var map_type = global.map_types[current_biome][current_map_number]; 
var text = global.map_type_text[map_type];
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

draw_text(0, 0, "Map Type: " + text);

#region SHOW THE MAP TYPES

if (show_map_types){
	for (var i = 0; i < e_map_type.last; i ++){
		var draw_y = 20 + (i * 20);
		
		if ( i == map_type ) draw_set_colour(c_white);
		else draw_set_colour(c_dkgrey);
		
		if (mx >0 && mx < string_width(global.map_type_text[i] ) &&
		    my > draw_y && my < (draw_y + 20 ) ){
		    
			draw_set_colour(c_lime);
			if (mouse_check_button_pressed(mb_left) ){
				global.map_types[current_biome][current_map_number] = i;
			}
		}
		
		draw_text( 0, draw_y, global.map_type_text[i] );
	}
}

#endregion

#endregion