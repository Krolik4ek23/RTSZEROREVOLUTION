draw_sprite_ext(sprUnitDozer_Base, 0, x, y, 1, 1, BaseDir, c_white, 1);
draw_sprite_ext(sprUnitDozer_Base, 1, x, y, 1, 1, BaseDir, TeamColors[Plr.Color], 0.8);
draw_sprite_ext(sprUnitDozer_Push, 0, x, y, 1, 1, BaseDir, c_white, 1);

// Полоска HP
if(HP < MaxHP and MaxHP > 0) {
	var BarW = 28;
	var BarY = y - sprite_get_height(sprite_index) / 2 - 6;
	draw_rectangle_color(x - BarW / 2, BarY, x + BarW / 2, BarY + 4, c_black, c_black, c_black, c_black, 0);
	draw_rectangle_color(x - BarW / 2 + 1, BarY + 1, x - BarW / 2 + 1 + max(0, (BarW - 2) * (HP / MaxHP)), BarY + 3, c_green, c_green, c_green, c_green, 0);
}