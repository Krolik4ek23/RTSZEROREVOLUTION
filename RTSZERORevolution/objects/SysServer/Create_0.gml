Socket = network_create_server(network_socket_tcp, NET_PORT, NET_PLAYERS);
if(Socket < 0) {
	show_message("Не удалось создать сервер!");
	instance_change(SysMenu, true);
	exit;
}

Game.NetSide = 1;

Status = ServerStatus.Lobby;

GameMapLoc = "";
GameMap = "";

TileMap = 0;
ObjMap = 0;

alarm[0] = 60;

for(var i = 0; i < NET_PLAYERS; i++) {
	PlrSocket[i] = -1;
	PlrObject[i] = Player();
	PlrObject[i].Slot = i;
	PlrAuthed[i] = 0;
}

TimerStarter = 3;
TimerCounter = TimerStarter;

GameOver = false;
AlivePlayersAtStart = 0;

enum ServerStatus {
	Lobby,
	InGame
}