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
