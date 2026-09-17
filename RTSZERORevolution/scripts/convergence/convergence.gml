///@param a
///@param b
///@param mult
function convergence(argument0, argument1, argument2) {
	gml_pragma("forceinline");

	return(argument0 + ((argument1 - argument0) * argument2));


}
