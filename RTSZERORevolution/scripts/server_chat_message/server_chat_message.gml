///@param text
///@param slot
function server_chat_message(argument0, argument1) {
	gml_pragma("forceinline");

	network_packet(BUFF1, NetPacket.Chat);
	buffer_write(BUFF1, buffer_string, argument0);
	if(argument1 < 0) server_send_all(BUFF1);
	else network_send(BUFF1, PlrSocket[argument1]);


}
