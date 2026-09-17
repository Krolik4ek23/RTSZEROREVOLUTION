///@param x1
///@param y1
///@param x2
///@param y2
///@param color
///@param alpha
function gui_line(argument0, argument1, argument2, argument3, argument4, argument5) {

	draw_set_alpha(argument5);
	draw_line_color(argument0, argument1, argument2, argument3, argument4, argument4);
	draw_set_alpha(1);


}
