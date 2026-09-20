alarm[2] = 5;

network_packet(BUFF1, NetPacket.UnitSync);
with(Civilian) {
	if(!NetUID) continue;
	buffer_write(BUFF1, buffer_u16, object_index);
	buffer_write(BUFF1, buffer_u16, NetUID);
	buffer_write(BUFF1, buffer_u16, HP);
	buffer_write(BUFF1, buffer_u8, Plr == Game.NeutralPlayer ? 255 : Plr.Slot);
	if(object_get_parent(object_index) == Builds) {
		buffer_write(BUFF1, buffer_u8, x div 16);
		buffer_write(BUFF1, buffer_u8, y div 16);
		buffer_write(BUFF1, buffer_u8, Dir);
	} else {
		buffer_write(BUFF1, buffer_u16, round(x * 10));
		buffer_write(BUFF1, buffer_u16, round(y * 10));
	}
	if(HasNetEvent) event(EventType.NetWrite, BUFF1);
}

buffer_write(BUFF1, buffer_u16, 65535);
server_send_all(BUFF1);