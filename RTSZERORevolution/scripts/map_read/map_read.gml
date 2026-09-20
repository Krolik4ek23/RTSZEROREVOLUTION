///@param buff
function map_read(argument0) {
	var Map = argument0;
	var header = buffer_read(Map, buffer_string);

	var tileCount, objCount, TileLut, ObjLut, i, v, idx;
	var CompressedDataSize, RawData, DecompressedData, tileGrid, objGrid, xx, yy;

	if (header == "RTS1") {
		// --- НОВЫЙ ФОРМАТ ---
		tileCount = buffer_read(Map, buffer_u16);
		TileLut = array_create(tileCount + 1, 0);
		for (i = 1; i <= tileCount; i++) {
			idx = asset_get_index(buffer_read(Map, buffer_string));
			TileLut[i] = (idx < 0 ? 0 : idx);
		}

		objCount = buffer_read(Map, buffer_u16);
		ObjLut = array_create(objCount + 1, -1);
		for (i = 1; i <= objCount; i++) {
			idx = asset_get_index(buffer_read(Map, buffer_string));
			ObjLut[i] = (idx < 0 ? -1 : idx);
		}
	} else if (header == "RTS0") {
		// --- СТАРЫЙ ФОРМАТ (строка версии читается, но игнорируется) ---
		buffer_read(Map, buffer_string); // version

		TileLut = [0];
		while (true) {
			v = buffer_read(Map, buffer_u8);
			if (!v) break;
			idx = asset_get_index(buffer_read(Map, buffer_string));
			TileLut[v] = (idx < 0 ? 0 : idx);
		}

		ObjLut = [-1];
		while (true) {
			v = buffer_read(Map, buffer_u8);
			if (!v) break;
			idx = asset_get_index(buffer_read(Map, buffer_string));
			ObjLut[v] = (idx < 0 ? -1 : idx);
		}
	} else {
		return MAP_ERR_FORMAT;
	}

	// --- СЖАТЫЕ ДАННЫЕ ---
	CompressedDataSize = buffer_read(Map, buffer_u32);
	if (CompressedDataSize > buffer_get_size(Map) - buffer_tell(Map)) {
		return MAP_ERR_FORMAT;
	}

	RawData = buffer_create(CompressedDataSize, buffer_grow, 1);
	buffer_copy(Map, buffer_tell(Map), CompressedDataSize, RawData, 0);
	buffer_seek(Map, buffer_seek_relative, CompressedDataSize);
	DecompressedData = buffer_decompress(RawData);
	buffer_delete(RawData);
	if (!buffer_exists(DecompressedData)) {
		return MAP_ERR_FORMAT;
	}

	tileGrid = ds_grid_create(MAP_W, MAP_H);
	objGrid = ds_grid_create(MAP_W, MAP_H);

	for (xx = 0; xx < MAP_W; xx++)
		for (yy = 0; yy < MAP_H; yy++)
			tileGrid[# xx, yy] = TileLut[buffer_read(DecompressedData, buffer_u8)];

	for (xx = 0; xx < MAP_W; xx++)
		for (yy = 0; yy < MAP_H; yy++)
			objGrid[# xx, yy] = ObjLut[buffer_read(DecompressedData, buffer_u8)];

	buffer_delete(DecompressedData);
	return [tileGrid, objGrid];
}
