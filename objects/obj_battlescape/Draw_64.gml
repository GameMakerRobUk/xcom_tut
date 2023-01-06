#region DRAW BATTLESCAPE CREATION PARAMETERS

draw_set_valign(fa_top);
var draw_x = display_get_gui_width() / 2;
	
for (var i = 0; i < e_bs_stats.last; i ++){
	var draw_y = (i * 20);
	if (i == selected_bs_data) draw_set_colour(c_lime);
	else draw_set_colour(c_white);
	
	draw_set_halign(fa_right);
	draw_text(draw_x, draw_y, bs_data[i][e_bs_values.text] );
	draw_set_halign(fa_left);
	draw_text(draw_x, draw_y, bs_data[i][e_bs_values.actual] );
}

#endregion

//Debug/Testing
draw_set_halign(fa_left); draw_set_valign(fa_top);
draw_text(0, 200, "cursor_x: " + string(cursor_x) );
draw_text(0, 220, "cursor_y: " + string(cursor_y) );
draw_text(0, 240, "tile_width: " + string(tile_width) );
draw_text(0, 260, "tile_height: " + string(tile_height) );
draw_text(0, 300, "fps_real: " + string(fps_real) );

var node = all_nodes[current_level][cursor_x][cursor_y];
draw_text(0, 320, "node: " + string(node) );
draw_text(0, 340, "_parent: " + string(node._parent) );
draw_text(0, 360, "_dist: " + string(node._dist) );

if (state == e_bs.ready){   
	draw_text(0, 280, "neighbours: " + string(array_length(neighbours) ) );
}
