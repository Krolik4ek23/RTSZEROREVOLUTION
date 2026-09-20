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

// Проверка условия победы
if(Status == ServerStatus.InGame and !GameOver and AlivePlayersAtStart > 1) {
	var AliveCount = 0;
	var WinnerSlot = -1;
	
	for(var i = 0; i < NET_PLAYERS; i++) {
		if(PlrObject[i].Color == 0) continue;
		
		var HasCC = false;
		with(BuildCommandCenter) {
			if(Plr == other.PlrObject[i]) { HasCC = true; break; }
		}
		
		if(HasCC) {
			AliveCount++;
			WinnerSlot = i;
		} else if(!PlrObject[i].Eliminated) {
			PlrObject[i].Eliminated = true;
			server_chat_message(PlrObject[i].Username + " уничтожен!", -1);
		}
	}
	
	if(AliveCount <= 1) {
		GameOver = true;
		if(WinnerSlot >= 0) server_chat_message(PlrObject[WinnerSlot].Username + " побеждает!", -1);
		else server_chat_message("Ничья!", -1);
	}
}