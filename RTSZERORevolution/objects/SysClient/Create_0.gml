Chat = ds_list_create();
ChatMessage = 0;

ServerIP = get_string("Введите адрес сервера:", "127.0.0.1");
if(ServerIP == "") {
	instance_change(SysMenu, true);
	exit;
}

Status = ClientStatus.Connection;
Socket = network_create_socket(network_socket_tcp);
network_connect(Socket, ServerIP, NET_PORT);

Game.NetSide = 2;

LastError = "";

for(var i = 0; i < NET_PLAYERS; i++) {
	PlrObject[i] = Player();
	PlrObject[i].Slot = i;
}

Minimap = NOTEXTURE;
SurfShroud = -1;alarm[0] = room_speed / 2;

GameMap = "";
GameMapPreview = NOTEXTURE;

TileMap = 0;
ObjMap = 0;

SurfShadow = -1;

OwnerTeam = -1;
OwnerColor = -1;
OwnerSlot = 0;

Pick = ds_list_create();

camera_set_view_pos(CamID, 0, 0);
camera_set_view_size(CamID, 512, 384);

enum ClientStatus {
	Error,
	Disconnected,
	Connection,
	Matching,
	Lobby,
	InGame
}