var evId = async_load[? "id"];
var evType = async_load[? "type"];

#region Обработка подключений
if(evId == Socket) {
	switch(evType) {
		case network_type_connect:
			var evSocket = async_load[? "socket"];
			var isDone = false;
			
			for(var i = 0; i < NET_PLAYERS; i++) {
				if(PlrSocket[i] != -1) continue;
				
				PlrSocket[i] = evSocket;
				PlrAuthed[i] = 0;
				PlrObject[i].Color = 0;
				PlrObject[i].Username = "...";
				
				alarm[0] = 2;
				
				isDone = true;
				break;
			}
			
			if(!isDone) server_disconnect(evSocket, "Все слоты заняты.");
		break;
		
		case network_type_disconnect:
			var evSocket = async_load[? "socket"];
			
			for(var i = 0; i < NET_PLAYERS; i++) {
				if(PlrSocket[i] != evSocket) continue;
				
				// Уничтожаем юнитов и здания отключившегося игрока
				DiscPlr = PlrObject[i];
				with(Civilian) {
					if(Plr == other.DiscPlr) instance_destroy(self, false);
				}
				
				PlrSocket[i] = -1;
				PlrAuthed[i] = 0;
				PlrObject[i].Color = 0;
				PlrObject[i].Username = "";
				
				alarm[0] = 2;
				break;
			}
		break;
	}
	exit;
}
#endregion
#region Обработка клиентов
if(evType != network_type_data) exit;

var plrSlot = -1;
for(var i = 0; i < NET_PLAYERS; i++) {
	if(PlrSocket[i] != evId) continue;
	
	plrSlot = i;
	break;
}
if(plrSlot == -1) exit;

var evBuff = async_load[? "buffer"];
var evPacket = buffer_read(evBuff, buffer_u8);

if(PlrAuthed[plrSlot] == 0 and evPacket != NetPacket.Connecting) {
	server_disconnect(PlrSocket[plrSlot], "Авторизация не пройдена.");
	exit;
}
#endregion

switch(evPacket) {
	case NetPacket.Connecting:
		var npUsername = buffer_read(evBuff, buffer_string);
		var npVersion = buffer_read(evBuff, buffer_string);
		
		for(var i = 0; i < NET_PLAYERS; i++) {
			if(PlrObject[i].Username == npUsername) {
				server_disconnect(PlrSocket[plrSlot], "Логин уже используется");
				exit;
			}
		}
		if(Status != ServerStatus.Lobby) server_disconnect(PlrSocket[plrSlot], "Игра уже началась");
		else if(GameMapLoc == "") server_disconnect(PlrSocket[plrSlot], "Сервер не выбрал карту.");
		else if(npVersion != Game.Version) server_disconnect(PlrSocket[plrSlot], "Версия клиента устарела.");
		else if(string_lettersdigits(npUsername) != npUsername) server_disconnect(PlrSocket[plrSlot], "Никнейм содержит запрещенные символы! Только A-Za-z0-9");
		else if(string_length(npUsername) < 4) server_disconnect(PlrSocket[plrSlot], "Никнейм слишком короткий(менее 4 символа)");
		else if(string_length(npUsername) > 16) server_disconnect(PlrSocket[plrSlot], "Никнейм слишком длинный(более 16 символов)");
		else {
			PlrAuthed[plrSlot] = true;
			PlrObject[plrSlot].Username = npUsername;
			for(var j = 1, i = 0; i < NET_PLAYERS; i++) {
				if(PlrObject[i].Color == j) {
					i = 0; j++;
					continue;
				}
			}
			PlrObject[plrSlot].Color = j;
			
			alarm[0] = 2;
			
			network_packet(BUFF1, NetPacket.Connecting);
			buffer_write(BUFF1, buffer_u8, 1);
			network_send(BUFF1, PlrSocket[plrSlot]);
		}
	break;
	
	case NetPacket.Chat:
		var npChatmessage = buffer_read(evBuff, buffer_string);
		if(npChatmessage == "") exit;
		
		if(string_char_at(npChatmessage, 1) == "/") {
			server_chat_message("Команды на данный момент не поддерживаются.", plrSlot);
		} else {
			server_chat_message(PlrObject[plrSlot].Username + " > " + npChatmessage, -1);
		}
	break;
	
	case NetPacket.PlayerTable:
		if(Status != ServerStatus.Lobby) exit;
		
		switch(buffer_read(evBuff, buffer_u8)) {
			case 1:
				PlrObject[plrSlot].State = (PlrObject[plrSlot].State == PlrStatus.NotReady ? PlrStatus.Ready : PlrStatus.NotReady);
			break;
			case 2:
				if(++PlrObject[plrSlot].Team > 4) PlrObject[plrSlot].Team = 0;
			break;
			case 3:
				var j = PlrObject[plrSlot].Color;
				for(var i = 0; i < NET_PLAYERS; i++) {
					if(PlrObject[i].Color == j) {
						if(j++ > 7) j = 1; 
						i = -1;
					}
				}
				PlrObject[plrSlot].Color = j;
			break;
		}
		
		network_packet(BUFF1, NetPacket.PlayerTable);
		buffer_write(BUFF1, buffer_s8, plrSlot);
		buffer_write(BUFF1, buffer_string, PlrObject[plrSlot].Username);
		buffer_write(BUFF1, buffer_u8, PlrObject[plrSlot].Team);
		buffer_write(BUFF1, buffer_u8, PlrObject[plrSlot].Color);
		buffer_write(BUFF1, buffer_u8, PlrObject[plrSlot].State);
		server_send_all(BUFF1);
		
		alarm[1] = room_speed;
	break;
	
	case NetPacket.UnitControl:
		while(true) {
			var npUID = buffer_read(evBuff, buffer_u16);
			if(!npUID) break;
			
			var ObjID = net_search_uid(npUID);
			var npType = buffer_read(evBuff, buffer_u8);
			
			if(npType == 1) {
				// Движение
				var npToX = buffer_read(evBuff, buffer_u16);
				var npToY = buffer_read(evBuff, buffer_u16);
				if(ObjID != noone and object_get_parent(ObjID.object_index) == Units) {
					ObjID.ToX = npToX;
					ObjID.ToY = npToY;
					ObjID.Target = noone;
				}
			} else if(npType == 2) {
				// Старт способности
				var npSlot = buffer_read(evBuff, buffer_u8);
				if(ObjID != noone) with(ObjID) event(EventType.CivAbilityStartBuild, npSlot);
			} else if(npType == 3) {
				// Размещение постройки
				var npSlot = buffer_read(evBuff, buffer_u8);
				var npCellX = buffer_read(evBuff, buffer_u8);
				var npCellY = buffer_read(evBuff, buffer_u8);
				var npDir = buffer_read(evBuff, buffer_u8);
				if(ObjID != noone) with(ObjID) event(EventType.CivAbilityStartBuild, npSlot, npCellX, npCellY, npDir);
			} else if(npType == 4) {
				// Атака
				var npTargetUID = buffer_read(evBuff, buffer_u16);
				if(ObjID != noone and object_get_parent(ObjID.object_index) == Units) {
					ObjID.Target = net_search_uid(npTargetUID);
				}
			}
		}
	break;
}