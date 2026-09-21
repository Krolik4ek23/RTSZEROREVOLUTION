///@param TileMap
///@param ObjMap
function map_generate(argument0, argument1) {
	var TM = argument0;
	var OM = argument1;
	var gx = 0, gy = 0, dx = 0, xx = 0, cx = 0;
	var RoadN = 38, RoadS = 89, B1X = 20, B2X = 108;

	// Трава — базовый слой
	ds_grid_set_region(TM, 0, 0, MAP_W - 1, MAP_H - 1, tlGrass);
	ds_grid_clear(OM, -1);

	// Река: вертикальный изгиб по центру + песчаные берега + непроходимая вода
	for(gy = 0; gy < MAP_H; gy++) {
		cx = 64 + round(3 * dsin(gy * 3));
		for(dx = -3; dx <= 3; dx++) {
			xx = cx + dx;
			if(xx < 0 or xx >= MAP_W) continue;

			if(abs(dx) <= 1) {
				TM[# xx, gy] = tlWater;
				OM[# xx, gy] = TerrainWater;
			} else {
				TM[# xx, gy] = tlSand;
			}
		}
	}

	// Две дороги (2 пути) с бродами через реку
	for(gx = 0; gx < MAP_W; gx++) {
		for(dx = 0; dx <= 2; dx++) {
			TM[# gx, RoadN + dx] = tlGravel; OM[# gx, RoadN + dx] = -1;
			TM[# gx, RoadS + dx] = tlGravel; OM[# gx, RoadS + dx] = -1;
		}
	}

	// Вертикальные отростки дорог к базам
	for(gy = RoadN; gy <= RoadS + 2; gy++) {
		TM[# B1X, gy] = tlGravel; OM[# B1X, gy] = -1;
		TM[# B2X, gy] = tlGravel; OM[# B2X, gy] = -1;
	}

	// Базы игроков (сервер назначит их игрокам по очереди)
	OM[# B1X, 64] = BuildCommandCenter;
	OM[# B2X, 64] = BuildCommandCenter;

	// Склады перидота (нейтральные)
	OM[# 36, 24] = BuildPeridotSupply;
	OM[# 92, 24] = BuildPeridotSupply;
	OM[# 36, 104] = BuildPeridotSupply;
	OM[# 92, 104] = BuildPeridotSupply;
	OM[# 48, 64] = BuildPeridotSupply;
	OM[# 80, 64] = BuildPeridotSupply;
}
