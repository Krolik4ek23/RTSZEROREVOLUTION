///@param x1
///@param y1
///@param x2
///@param y2
///@param color
///@param alpha
///@param outline
function gui_rect(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	draw_set_alpha(argument5);
	draw_rectangle_color(argument0, argument1, argument2, argument3, argument4, argument4, argument4, argument4, argument6);
	draw_set_alpha(1);


}
