event_inherited();

switch(EVENT[0]) {	
	case EventType.NetWrite:
		var buff = EVENT[1];
		buffer_write(buff, buffer_u16, round(Progress * 100));
		buffer_write(buff, buffer_u16, (Building == noone ? 65535 : Building));
	break;
	
	case EventType.NetRead:
		var buff = EVENT[1];
		Progress = buffer_read(buff, buffer_u16) / 100;
		var b = buffer_read(buff, buffer_u16);
		Building = (b == 65535 ? noone : b);
	break;
}