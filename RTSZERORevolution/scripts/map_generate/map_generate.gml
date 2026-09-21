///@param TileMap
///@param ObjMap
function map_generate(argument0, argument1) {
	var TM = argument0,
		OM = argument1,
		x, y, dx, xx, cx,
		RoadN = 38, RoadS = 89, B1X = 20, B2X = 108;

	// Трава — базовый слой
	ds_grid_set_region(TM, 0, 0, MAP_W - 1, MAP_H - 1, tlGrass);
	ds_grid_clear(OM, -1);

	// Река: вертикальный изгиб по центру + песчаные берега + непроходимая вода
	for(y = 0; y < MAP_H; y++) {
		cx = 64 + round(3 * dsin(y * 3));
		for(dx = -3; dx <= 3; dx++) {
			xx = cx + dx;
			if(xx < 0 or xx >= MAP_W) continue;

			if(abs(dx) <= 1) {
				TM[# xx, y] = tlWater;
				OM[# xx, y] = TerrainWater;
			} else {
				TM[# xx, y] = tlSand;
			}
		}
	}

	// Две дороги (2 пути) с бродами через реку
	for(x = 0; x < MAP_W; x++) {
		for(dx = 0; dx <= 2; dx++) {
			TM[# x, RoadN + dx] = tlGravel; OM[# x, RoadN + dx] = -1;
			TM[# x, RoadS + dx] = tlGravel; OM[# x, RoadS + dx] = -1;
		}
	}

	// Вертикальные отростки дорог к базам
	for(y = RoadN; y <= RoadS + 2; y++) {
		TM[# B1X, y] = tlGravel; OM[# B1X, y] = -1;
		TM[# B2X, y] = tlGravel; OM[# B2X, y] = -1;
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
