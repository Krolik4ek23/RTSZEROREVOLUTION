if(Building != noone) {
	draw_sprite_ext(object_get_sprite(Building), 0, x, y, 1, 1, 90 * Dir, c_white, 0.8);
}

gui_font(fn_default, fa_middle, fa_middle);
gui_text(x, y, string_format(Progress, 0, 2) + "%", 1, PF, 1);