///@param x
///@param y
///@param w
///@param h
///@param text
///@param flags
function gui_buttonText(argument0, argument1, argument2, argument3, argument4, argument5) {

	var x1 = argument0,
		y1 = argument1,
		x2 = x1 + argument2,
		y2 = y1 + argument3,
		text = argument4,
		flags = argument5;

	begin
		if(flags & GUI_DISABLED > 0) {
			gui_rect(x1 - 1, y1 - 1, x2, y2, P8, 1, 0);
			gui_text(mean(x1, x2), mean(y1, y2), text, 1, PF, 1);
			gui_rect(x1 - 1, y1 - 1, x2, y2, 0, 0.2, false);
		
			return false;
		} else {
			var isHover = point_in_rectangle(MouseGuiX, MouseGuiY, x1, y1, x2, y2);
			gui_rect(x1 - 1, y1 - 1, x2, y2, P8, 1, 0);
			gui_text(mean(x1, x2), mean(y1, y2), text, 1, PF, 1);
			if(isHover) gui_rect(x1 - 1, y1 - 1, x2, y2, PF, 0.2, false);
	
			return isHover && mouse_check_button_pressed(mb_left);
		}
	end;


}
