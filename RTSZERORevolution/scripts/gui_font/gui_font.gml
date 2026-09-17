///@param font
///@param halign
///@param valign
function gui_font(argument0, argument1, argument2) {
	gml_pragma("forceinline");

	if(argument0 != NULL) draw_set_font(argument0);
	draw_set_halign(argument1);
	draw_set_valign(argument2);


}
