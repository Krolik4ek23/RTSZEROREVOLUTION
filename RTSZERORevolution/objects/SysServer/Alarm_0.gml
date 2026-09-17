alarm[0] = 15;

network_packet(BUFF1, NetPacket.PlayerTable);
buffer_write(BUFF1, buffer_s8, -1);
for(var i = 0; i < NET_PLAYERS; i++) {
	buffer_write(BUFF1, buffer_string, PlrObject[i].Username);
	if(PlrObject[i].Username == "") continue;
	
	buffer_write(BUFF1, buffer_u8, PlrObject[i].Team);
	buffer_write(BUFF1, buffer_u8, PlrObject[i].Color);
	buffer_write(BUFF1, buffer_u8, PlrObject[i].State);
	buffer_write(BUFF1, buffer_u16, PlrObject[i].Cash);
}
buffer_write(BUFF1, buffer_string, GameMap);
server_send_all(BUFF1);