if (show_help){
	
	#region SHOW HELP

	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_colour(c_white);
	draw_set_font(fnt_gui);

	var xx = 0;
	var gh = display_get_gui_height();
	draw_text(xx, gh - 0, "[Backspace] - Delete this Map");
	draw_text(xx, gh - 20, "[Enter] - New Map");
	draw_text(xx, gh - 40, "[O/P] - Load prev/next Map");
	draw_text(xx, gh - 60, "[F5] - Save map");
	draw_text(xx, gh - 80, "[T/R + SHIFT] - change Biome");
	draw_text(xx, gh - 100, "[Tab + SHIFT] - toggle show_all_levels");
	draw_text(xx, gh - 120, "[WASD] - Move map around | + [SHIFT] Expand/Decrease Map Size");
	draw_text(xx, gh - 140, "[Right/Left] - change tile | + [SHIFT] Cycle Part");
	draw_text(xx, gh - 160, "[Up/Down] - change level | + [SHIFT] Add/Delete floor");
	draw_text(xx, gh - 180, "[mb_right] - remove wall/decoration");
	draw_text(xx, gh - 200, "[mb_left] - place tile | + [SHIFT] paint floor with tile");
	draw_text(xx, gh - 220, "[Z/X] - Lock Y/X axis in place - useful for walls etc");
	draw_text(xx, gh - 240, "[H] - Display/Hide Map Designations - [Up/Down] to choose");

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	
	draw_text(display_get_gui_width()/2, 0, "[Press ESC to hide help]" );
	
	#endregion

}else{
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	
	draw_text(display_get_gui_width()/2, 0, "[Press ESC to show help]" );
}
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_text(display_get_gui_width()/2, 20, "Tileset: : " + a_tile_set_txt[current_tile_set] );
draw_text(display_get_gui_width()/2, 40, "Tile Part to Place: : " + a_tile_parts_txt[tile_part_to_place] );
draw_text(display_get_gui_width()/2, 60, "current_tile_to_place: " + string(current_tile_to_place));
draw_text(display_get_gui_width()/2, 80,"current_level: " + string(current_level));

draw_set_halign(fa_left);

#region SHOW CONTENTS OF GLOBAL.ALL_MAPS

for (var yy = 0; yy < ds_grid_height(global.all_maps); yy ++){
	for (var xx = 0; xx < ds_grid_width(global.all_maps); xx ++){
		var entry = string ( global.all_maps[# xx, yy] );
		var str = string_copy(entry, 1, 3);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_colour(c_white);
		
		if (yy == current_map_number && xx == current_tile_set) draw_set_colour(c_lime);
		
		var des = global.map_designations[# xx, yy];
		draw_text(xx * 80, 30 + ( yy * 30), str + " | " + string(des) );
	}
}

#endregion

#region SHOW CURRENT DESIGNATION FOR THIS MAP

draw_set_halign(fa_left);
draw_set_valign(fa_top);
var des = global.map_designations[# current_tile_set, current_map_number];

if (des != undefined){
	des = real(des);
	var txt = des_text[ des ];
}else txt = string(des);

draw_text(100, 0, "Desgination: " + txt);

#endregion

if (show_designations){
	
	#region SHOW THE CURRENT SELECTED DESIGNATION FROM THE WHOLE DESIGNATION LIST
	
	var draw_x = 100 + string_width("Desgination: ");
	var start_y = 20;
	
	for (var i = 0; i < array_length(des_text); i ++){
		var text = des_text[i];
		var draw_y = start_y + (i * 20);
		
		draw_set_colour(c_black);
		if (i == des) draw_set_colour(c_lime);
		draw_text(draw_x, draw_y, text);
	}
	
	#endregion
}
