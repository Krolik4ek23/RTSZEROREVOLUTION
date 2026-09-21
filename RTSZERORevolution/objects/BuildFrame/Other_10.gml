event_inherited();

switch(EVENT[0]) {	
	case EventType.NetWrite:
		var buff = EVENT[1];
		buffer_write(buff, buffer_u16, round(Progress * 100));
		buffer_write(buff, buffer_u16, (Building == noone ? 65535 : Building));
		buffer_write(buff, buffer_u16, MaxHP);
	break;
	
	case EventType.NetRead:
		var buff = EVENT[1];
		Progress = buffer_read(buff, buffer_u16) / 100;
		var b = buffer_read(buff, buffer_u16);
		Building = (b == 65535 ? noone : b);
		MaxHP = buffer_read(buff, buffer_u16);
		// Маска = реальный размер здания (для проверки размещения и коллизий)
		if(Building != noone) mask_index = object_get_sprite(Building);
	break;
}