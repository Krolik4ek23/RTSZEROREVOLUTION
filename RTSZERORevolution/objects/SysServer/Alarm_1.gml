var isAllDone = true;
for(var i = 0; i < NET_PLAYERS; i++) {
    if(PlrSocket[i] == -1) continue;
    if(PlrObject[i].State == PlrStatus.Ready) continue;
    
    isAllDone = false;
    break;
}

if(isAllDone) {
    network_packet(BUFF1, NetPacket.Chat);
    buffer_write(BUFF1, buffer_string, "Старт игры через " + string(TimerCounter) + " секунд.");
    server_send_all(BUFF1);
    
    if(TimerCounter-- < 1) {
        network_packet(BUFF1, NetPacket.MapTransfer);
        buffer_write(BUFF1, buffer_string, GameMap);   // ← имя СНАЧАЛА
        map_write(BUFF1, TileMap, ObjMap);             // ← карта ПОСЛЕ
        server_send_all(BUFF1);
        
        show_debug_message("=== SERVER: MapTransfer sent ===");
        show_debug_message("Buffer size: " + string(buffer_get_size(BUFF1)));
        
        event_user(1);
        for(var i = 0; i < NET_PLAYERS; i++) {
            if(PlrObject[i].Color == 0) continue;
            
            with(BuildCommandCenter) {
                if(Plr == Game.NeutralPlayer) {
                    Plr = other.PlrObject[i];
                    Plr.Cash = 5000;
                    break;
                }
            }
        }
        with(BuildCommandCenter) if(Plr == Game.NeutralPlayer) destroy(self);
        
        alarm[2] = 2;
        alarm[3] = 4;
        Status = ServerStatus.InGame;
    } else alarm[1] = room_speed;
} else {
    TimerCounter = TimerStarter;
}