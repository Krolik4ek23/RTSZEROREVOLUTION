///@param x
///@param y
///@param w
///@param h
///@param sprite
///@param subimg
///@param flags
function gui_buttonIcon(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	var x1 = argument0,
		y1 = argument1,
		x2 = x1 + argument2,
		y2 = y1 + argument3,
		sprite = argument4,
		subimg = argument5,
		flags = argument6;

	begin
		if(flags & GUI_DISABLED > 0) {
			if(flags & GUI_NOBG == 0) gui_rect(x1 - 1, y1 - 1, x2, y2, P8, 1, 0);
			draw_sprite(sprite, subimg, mean(x1, x2) - sprite_get_xoffset(sprite) - (sprite_get_width(sprite) / 2), mean(y1, y2) - sprite_get_yoffset(sprite) - (sprite_get_height(sprite) / 2));
			gui_rect(x1 - 1, y1 - 1, x2, y2, 0, 0.2, false);
		
			return false;
		} else {
			var isHover = point_in_rectangle(MouseGuiX, MouseGuiY, x1, y1, x2, y2);
			if(flags & GUI_NOBG == 0) gui_rect(x1 - 1, y1 - 1, x2, y2, P8, 1, 0);
			draw_sprite(sprite, subimg, mean(x1, x2) - sprite_get_xoffset(sprite) - (sprite_get_width(sprite) / 2), mean(y1, y2) - sprite_get_yoffset(sprite) - (sprite_get_height(sprite) / 2));
			if(isHover) gui_rect(x1 - 1, y1 - 1, x2, y2, PF, 0.2, false);
	
			return isHover && mouse_check_button_pressed(mb_left);
		}
	end;


}
