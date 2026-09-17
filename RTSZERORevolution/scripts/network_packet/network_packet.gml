///@param buffer
///@param netpacket
function network_packet(argument0, argument1) {
	gml_pragma("forceinline");

	buffer_seek(argument0, buffer_seek_start, 0);
	buffer_write(argument0, buffer_u8, argument1);


}
