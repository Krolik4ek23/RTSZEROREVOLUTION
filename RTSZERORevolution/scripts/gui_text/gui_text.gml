///@param x
///@param y
///@param text
///@param scale
///@param color
///@param alpha
function gui_text(argument0, argument1, argument2, argument3, argument4, argument5) {
	gml_pragma("forceinline");

	draw_text_transformed_color(argument0, argument1, argument2, argument3, argument3, 0, argument4, argument4, argument4, argument4, argument5);


}
