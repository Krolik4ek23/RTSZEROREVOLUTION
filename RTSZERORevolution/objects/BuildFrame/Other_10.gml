event_inherited();

switch(EVENT[0]) {	
	case EventType.NetWrite:
		var buff = EVENT[1];
		buffer_write(buff, buffer_u16, round(Progress * 100));
		buffer_write(buff, buffer_u8, Building);
	break;
	
	case EventType.NetRead:
		var buff = EVENT[1];
		Progress = buffer_read(buff, buffer_u16) / 100;
		Building = buffer_read(buff, buffer_u8);
	break;
}