///@param buffer
///@param socket
function network_send(argument0, argument1) {
	gml_pragma("forceinline");

	Game.NetStatWrite += network_send_packet(argument1, argument0, buffer_tell(argument0)) - 12;


}
