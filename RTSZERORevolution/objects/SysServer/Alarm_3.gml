for(var i = 0; i < NET_PLAYERS; i++) {
	if(PlrSocket[i] < 0) continue;
	
	network_packet(BUFF1, NetPacket.PlrInfo);
	buffer_write(BUFF1, buffer_u8, PlrObject[i].Color);
	buffer_write(BUFF1, buffer_u8, PlrObject[i].Team);
	buffer_write(BUFF1, buffer_u8, i);
	network_send(BUFF1, PlrSocket[i]);
}