if(Building != noone) {
	draw_sprite_ext(object_get_sprite(Building), 0, x, y, 1, 1, 90 * Dir, c_white, 0.8);
}

// Полоска HP
if(HP < MaxHP and MaxHP > 0) {
	var BarW = 44;
	var BarY = y - sprite_get_height(object_get_sprite(Building != noone ? Building : object_index)) / 2 - 6;
	draw_rectangle_color(x - BarW / 2, BarY, x + BarW / 2, BarY + 4, c_black, c_black, c_black, c_black, 0);
	draw_rectangle_color(x - BarW / 2 + 1, BarY + 1, x - BarW / 2 + 1 + max(0, (BarW - 2) * (HP / MaxHP)), BarY + 3, c_green, c_green, c_green, c_green, 0);
}

gui_font(fn_default, fa_middle, fa_middle);
gui_text(x, y, string_format(Progress, 0, 2) + "%", 1, PF, 1);