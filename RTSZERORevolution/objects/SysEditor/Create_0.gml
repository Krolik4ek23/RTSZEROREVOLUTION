camera_set_view_pos(CamID, 0, -20);

TileMap = ds_grid_create(MAP_W, MAP_H);
ObjMap = ds_grid_create(MAP_W, MAP_H);
Minimap = -1;event_user(1);

Sidebar = [EditorSidebar.Empty];

BrushSize = 0;
BrushType = EditorBrushType.Circle;
BrushMat = 0;

MapName = "Unknown" + string(irandom(999));
MapPlayers = 2;
MapBorder = [64, 64];

ViewScale = 1;
PrevViewScale = 1;

enum EditorIcons {
	create = 0,
	Open = 1,
	Save = 2,
	Close = 3,
	Objects = 4,
	Tiles = 5,
	Settings = 6,
	Circle = 7,
	Rectangle = 8
}

enum EditorBrushType {
	Circle,
	Rectangle
}

enum EditorSidebar {
	Empty,
	MapSettings,
	Tilesetting,
	Objsetting
}