var evId = async_load[? "id"];
var evType = async_load[? "type"];

if(evId != Socket) exit;

switch(evType) {
    case network_type_non_blocking_connect:
        var evSucceeded = async_load[? "succeeded"];
        if(evSucceeded) {
            Status = ClientStatus.Matching;
            
            network_packet(BUFF1, NetPacket.Connecting);
            buffer_write(BUFF1, buffer_string, Game.Username);
            buffer_write(BUFF1, buffer_string, Game.Version);
            network_send(BUFF1, Socket);
        } else {
            Status = ClientStatus.Error;
        }
    exit;
    
    case network_type_disconnect:
    exit;
    
    case network_type_data:
        var evBuff = async_load[? "buffer"];
        var evPacket = buffer_read(evBuff, buffer_u8);
    break;
    
    default: exit;
}

switch(evPacket) {
    case NetPacket.Connecting:
        Status = ClientStatus.Lobby;
    break;
    
    case NetPacket.Disconnecting:
        var npReason = buffer_read(evBuff, buffer_string);
        Status = ClientStatus.Disconnected;
        LastError = npReason;
    break;
    
    case NetPacket.PlayerTable:
        var num = buffer_read(evBuff, buffer_s8);
        if(num == -1) {
            for(var i = 0; i < NET_PLAYERS; i++) {
                PlrObject[i].Username = buffer_read(evBuff, buffer_string);
                if(PlrObject[i].Username == "") continue;
                
                PlrObject[i].Team = buffer_read(evBuff, buffer_u8);
                PlrObject[i].Color = buffer_read(evBuff, buffer_u8);
                PlrObject[i].State = buffer_read(evBuff, buffer_u8);
                PlrObject[i].Cash = buffer_read(evBuff, buffer_u16);
            }
            
            var npGameMap = buffer_read(evBuff, buffer_string);
            if(GameMap != npGameMap) {
                GameMap = npGameMap;
                if(GameMapPreview) {
                    sprite_delete(GameMapPreview);
                    GameMapPreview = NOTEXTURE;
                }
                var MapLoc = Game.DirectoryMaps + GameMap + ".png";
                if(file_exists(MapLoc)) GameMapPreview = sprite_add(MapLoc, 0, 0, 0, 0, 0);
            }
        } else {
            PlrObject[num].Username = buffer_read(evBuff, buffer_string);
            PlrObject[num].Team = buffer_read(evBuff, buffer_u8);
            PlrObject[num].Color = buffer_read(evBuff, buffer_u8);
            PlrObject[num].State = buffer_read(evBuff, buffer_u8);
        }
    break;
    
    case NetPacket.Chat:
        ds_list_add(Chat, buffer_read(evBuff, buffer_string));
    break;
    
    case NetPacket.MapTransfer:
        var npMapname = buffer_read(evBuff, buffer_string);
        var npMap = map_read(evBuff);
        
        if (is_array(npMap)) {
            TileMap = npMap[0];
            ObjMap = npMap[1];
            event_user(1);
            Status = ClientStatus.InGame;
        }
    break;
    
    case NetPacket.UnitSync:
        with(Civilian) IsAlive = false;
        while(true) {
            var npObjOID = buffer_read(evBuff, buffer_u16);
            if(npObjOID == 65535) break;
            
            var npObjUID = buffer_read(evBuff, buffer_u16);
            var npObjHP = buffer_read(evBuff, buffer_u16);
            var npObjPlr = buffer_read(evBuff, buffer_u8);
            
            if(object_get_parent(npObjOID) == Builds) {
                var npObjX = buffer_read(evBuff, buffer_u8) * 16;
                var npObjY = buffer_read(evBuff, buffer_u8) * 16;
            } else {
                var npObjX = buffer_read(evBuff, buffer_u16) / 10;
                var npObjY = buffer_read(evBuff, buffer_u16) / 10;
            }
            
            var ObjID = net_search_uid(npObjUID);
            if(!ObjID) ObjID = create(npObjOID, npObjX, npObjY);
            
            if(object_get_parent(npObjOID) == Builds) ObjID.Dir = buffer_read(evBuff, buffer_u8);
            
            if(point_distance(ObjID.x, ObjID.y, npObjX, npObjY) > 6) {
                ObjID.x = npObjX;
                ObjID.y = npObjY;
            }
            ObjID.x = convergence(ObjID.x, npObjX, 0.4);
            ObjID.y = convergence(ObjID.y, npObjY, 0.4);
            
            ObjID.NetUID = npObjUID;
            ObjID.HP = npObjHP;
            ObjID.Plr = (npObjPlr == 255 ? Game.NeutralPlayer : PlrObject[npObjPlr]);
            ObjID.IsAlive = true;
            
            if(ObjID.HasNetEvent) with(ObjID) event(EventType.NetRead, evBuff);
        }
        with(Civilian) if(!IsAlive) destroy(self);
    break;
    
    case NetPacket.PlrInfo:
        OwnerColor = buffer_read(evBuff, buffer_u8);
        OwnerTeam = buffer_read(evBuff, buffer_u8);
        OwnerSlot = buffer_read(evBuff, buffer_u8);
        
        destroy(Game.OwnerPlayer);
        Game.OwnerPlayer = PlrObject[OwnerSlot];
        
        with(BuildCommandCenter) {
            if(!Plr) continue;
            if(Plr.Color == Game.OwnerPlayer.Color) {
                camera_set_view_pos(CamID, x - 192, y - 192);
                break;
            }
        }
    break;
}