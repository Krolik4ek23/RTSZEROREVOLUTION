switch(EVENT[0]) {
	case EventType.NetWrite:
		var Buff = EVENT[1];
		
		buffer_write(Buff, buffer_u16, round(ToX * 10));
		buffer_write(Buff, buffer_u16, round(ToY * 10));
		buffer_write(Buff, buffer_u16, instance_exists(Target) ? Target.NetUID : 0);
		buffer_write(Buff, buffer_u8, MoveOrder);
	break;
	
	case EventType.NetRead:
		var Buff = EVENT[1];
		
		ToX = buffer_read(Buff, buffer_u16) / 10;
		ToY = buffer_read(Buff, buffer_u16) / 10;
		var npTarget = buffer_read(Buff, buffer_u16);
		Target = npTarget ? net_search_uid(npTarget) : noone;
		MoveOrder = buffer_read(Buff, buffer_u8);
	break;
}