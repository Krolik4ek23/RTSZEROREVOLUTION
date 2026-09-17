///@param name
///@param type
///@param price
///@param time
///@param data
function ability_add(argument0, argument1, argument2, argument3, argument4) {
	gml_pragma("forceinline");

	AbilitiesName[AbilitiesCount] = argument0;
	AbilitiesType[AbilitiesCount] = argument1;
	AbilitiesPrice[AbilitiesCount] = argument2;
	AbilitiesTime[AbilitiesCount] = argument3;
	AbilitiesData[AbilitiesCount] = argument4;

	AbilitiesCount++;


}
