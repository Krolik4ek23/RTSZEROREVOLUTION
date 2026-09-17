///@param obj
///@param [x
///@param y]
function create() {
	gml_pragma("forceinline");

	return(argument_count > 1 ? instance_create_depth(argument[1], argument[2], 0, argument[0]) : instance_create_depth(0, 0, 0, argument[0]));


}
