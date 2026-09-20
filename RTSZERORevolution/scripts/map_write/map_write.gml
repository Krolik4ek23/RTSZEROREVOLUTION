///@param buff
///@param tileGrid
///@param objGrid
function map_write(argument0, argument1, argument2) {
	var Map = argument0,
		tileGrid = argument1,
		objGrid = argument2;

	// --- ЗАГОЛОВОК ---
	buffer_write(Map, buffer_string, "RTS1");

	// --- ТАБЛИЦА ТАЙЛОВ (имена, чтобы формат не зависел от индексов ассетов) ---
	var Tiles = [tlGrass, tlDirt, tlGravel, tlSand, tlWater];
	buffer_write(Map, buffer_u16, array_length(Tiles));
	for (var i = 0; i < array_length(Tiles); i++) {
		buffer_write(Map, buffer_string, sprite_get_name(Tiles[i]));
	}

	// --- ТАБЛИЦА ОБЪЕКТОВ ---
	var Objs = [TerrainWall, BuildCommandCenter, BuildPeridotSupply];
	buffer_write(Map, buffer_u16, array_length(Objs));
	for (var i = 0; i < array_length(Objs); i++) {
		buffer_write(Map, buffer_string, object_get_name(Objs[i]));
	}

	// --- СЫРЫЕ ДАННЫЕ (логические ID: 0 = пусто, 1..N = индекс в таблице) ---
	var RawData = buffer_create(MAP_W * MAP_H * 2, buffer_grow, 1);

	for (var xx = 0; xx < MAP_W; xx++) {
		for (var yy = 0; yy < MAP_H; yy++) {
			var val = tileGrid[# xx, yy];
			var logical = 0;
			for (var k = 0; k < array_length(Tiles); k++) {
				if (Tiles[k] == val) { logical = k + 1; break; }
			}
			buffer_write(RawData, buffer_u8, logical);
		}
	}

	for (var xx = 0; xx < MAP_W; xx++) {
		for (var yy = 0; yy < MAP_H; yy++) {
			var val = objGrid[# xx, yy];
			var logical = 0;
			for (var k = 0; k < array_length(Objs); k++) {
				if (Objs[k] == val) { logical = k + 1; break; }
			}
			buffer_write(RawData, buffer_u8, logical);
		}
	}

	// --- СЖАТИЕ ---
	var CompressedData = buffer_compress(RawData, 0, buffer_tell(RawData));
	buffer_delete(RawData);
	var CompressedDataSize = buffer_get_size(CompressedData);

	buffer_write(Map, buffer_u32, CompressedDataSize);
	buffer_copy(CompressedData, 0, CompressedDataSize, Map, buffer_tell(Map));
	buffer_seek(Map, buffer_seek_relative, CompressedDataSize);
	buffer_delete(CompressedData);
}
