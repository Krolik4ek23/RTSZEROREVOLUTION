switch(EVENT[0]) {
	case EventType.NetWrite:
		var Buff = EVENT[1];
		
		buffer_write(Buff, buffer_u16, ToX);
		buffer_write(Buff, buffer_u16, ToY);
		//buffer_write(Buff, buffer_u16, BaseDir);
		//buffer_write(Buff, buffer_u16, PushDir);
	break;
	
	case EventType.NetRead:
		var Buff = EVENT[1];
		
		ToX = buffer_read(Buff, buffer_u16);
		ToY = buffer_read(Buff, buffer_u16);
		//BaseDir = buffer_read(Buff, buffer_u16);
		//PushDir = buffer_read(Buff, buffer_u16);
	break;
}