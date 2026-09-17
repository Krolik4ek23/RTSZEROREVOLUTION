///@param uid
function net_search_uid(argument0) {
	gml_pragma("forceinline");

	with(Civilian) if(NetUID == argument0) return id;
	return noone;


}
