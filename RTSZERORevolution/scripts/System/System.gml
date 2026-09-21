function System() {
#region Цвета
#macro P0 $48494A
#macro P1 $5053C0
#macro P2 $339572
#macro P3 $338ABA
#macro P4 $BA8C4B
#macro P5 $8655BA
#macro P6 $94994D
#macro P7 $BBC7CB
#macro P8 $6C7173
#macro P9 $595CE9
#macro PA $33BE8C
#macro PB $33A5E3
#macro PC $E3A652
#macro PD $9E60E3
#macro PE $BAC258
#macro PF $DFEFF4
#endregion
#region Движок
#macro NULL ""
	randomize();
	display_set_gui_size(512, 384);
	network_set_config(network_config_connect_timeout, 5000);
	network_set_config(network_config_use_non_blocking_socket, true);
	math_set_epsilon(0.001);
	ds_set_precision(0.001);
	Version = GM_version;
	Copyright = "by Quad69";
	Username = "Player" + string(irandom(999));
	Directory = environment_get_variable("APPDATA") + "\\RTSZero\\";
	DirectoryMaps = Directory + "maps\\";

	if(!directory_exists(Directory)) directory_create(Directory);
	if(!directory_exists(DirectoryMaps)) directory_create(DirectoryMaps);

#macro MouseX mouse_x
#macro MouseY mouse_y

	MGX = 0; MGY = 0;
#macro MouseGuiX Game.MGX
#macro MouseGuiY Game.MGY

	Buff1 = buffer_create(1, buffer_grow, 1);
#macro BUFF1 Game.Buff1

	GameTC = [PF, P9, PA, PB, PC, PD, PE, P5, P2];
#macro TeamColors Game.GameTC
#endregion
#region GUI
#macro GUI_DISABLED 1
#macro GUI_NOBG 2
#endregion
#region Игровая карта
#macro MAP_W 128
#macro MAP_H 128
#endregion
#region Мультиплеер
#macro NET_PORT 46901
#macro NET_PLAYERS 8
#macro NET_SOCKAI -2
	enum NetPacket {
		Connecting,
		Disconnecting,
		PlayerTable,
		GameMap,
		Chat,
		MapTransfer,
		UnitSync,
		UnitControl,
		PlrInfo
	}
	enum PlrStatus {
		Unknown,
		NotReady,
		Ready,
		Spectator
	}

	NetSide = 0;
#macro SERVER_SIDE Game.NetSide == 1
#macro CLIENT_SIDE Game.NetSide == 2

	NetStatWrite = 0;
	NetStatRead = 0;

	global.g_buffer_zlib_chunk_size = 32;
#endregion
#region Библиотека объектов
	LibObjs = [
		TerrainWall,
		BuildCommandCenter
	];

	LibTile = [
		tlGrass,
		tlDirt,
		tlGravel,
		tlSand,
		tlWater
	];
#endregion
#region Шейдеры
	SHR_SHADOWMAP_SIZE = shader_get_uniform(shr_shadowMap, "u_Size");
#macro shrUniform_size Game.SHR_SHADOWMAP_SIZE
#endregion
#region Камера
#macro CamID view_camera[0]

	CamX = 0;
	CamY = 0;
	CamW = 0;
	CamH = 0;
#endregion
#region Система событий
	OBJEVENTSYSTEM = [];
#macro EVENT Game.OBJEVENTSYSTEM
#macro RESULT Game.OBJEVENTSYSTEM

	enum EventType {
		Command,
		NetWrite,
		NetRead,
		FileWrite,
		FileRead,
		CivAbilityBuildDone,
		CivAbilityStartBuild
	}
#endregion
#region CIVILIAN
	enum Ability {
		TankT1 = 1,
		Dozer = 2,
		CommandCenter = 3,
		PeridotHarvester = 4
	}
#endregion

	MapCollision = mp_grid_create(0, 0, MAP_W, MAP_H, 16, 16);

	OwnerPlayer = Player();
	NeutralPlayer = Player();


}
