///@param buff
function map_read(argument0) {
    var Map = argument0;

    show_debug_message("=== map_read START ===");
    show_debug_message("Buffer size: " + string(buffer_get_size(Map)));
    show_debug_message("Buffer position: " + string(buffer_tell(Map)));

    // --- ЗАГОЛОВОК ---
    var header = buffer_read(Map, buffer_string);
    show_debug_message("Header: '" + header + "'");
    if (header != "RTS0") {
        show_debug_message("!!! BAD HEADER");
        return MAP_ERR_FORMAT;
    }

    // --- ВЕРСИЯ ---
    var ver = buffer_read(Map, buffer_string);
    show_debug_message("Version: '" + ver + "', expected: '" + Game.Version + "'");
    if (ver != Game.Version) {
        show_debug_message("!!! BAD VERSION");
        return MAP_ERR_OUTDATED;
    }

    // --- СПРАЙТЫ ---
    var SId2Name = [0], OId2Name = [0];
    while (true) {
        var Val = buffer_read(Map, buffer_u8);
        if (!Val) break;
        SId2Name[Val] = asset_get_index(buffer_read(Map, buffer_string));
    }
    show_debug_message("Sprites read: " + string(array_length(SId2Name)));
    show_debug_message("Position after sprites: " + string(buffer_tell(Map)));

    // --- ОБЪЕКТЫ ---
    while (true) {
        var Val = buffer_read(Map, buffer_u8);
        if (!Val) break;
        OId2Name[Val] = asset_get_index(buffer_read(Map, buffer_string));
    }
    show_debug_message("Objects read: " + string(array_length(OId2Name)));
    show_debug_message("Position after objects: " + string(buffer_tell(Map)));

    // --- РАЗМЕР СЖАТЫХ ДАННЫХ ---
    var CompressedDataSize = buffer_read(Map, buffer_u32);
    show_debug_message("Compressed size: " + string(CompressedDataSize));

    var bytesLeft = buffer_get_size(Map) - buffer_tell(Map);
    show_debug_message("Bytes left: " + string(bytesLeft));

    if (CompressedDataSize > bytesLeft) {
        show_debug_message("!!! NOT ENOUGH DATA");
        return MAP_ERR_FORMAT;
    }

    // --- КОПИРОВАНИЕ СЖАТЫХ ДАННЫХ ---
    var RawData = buffer_create(CompressedDataSize, buffer_grow, 1);
    buffer_copy(Map, buffer_tell(Map), CompressedDataSize, RawData, 0);
    buffer_seek(Map, buffer_seek_relative, CompressedDataSize);   // ← ФИКС: сдвигаем курсор!

    show_debug_message("Position after compressed data: " + string(buffer_tell(Map)));

    // --- РАСПАКОВКА ---
    var DecompressedData = buffer_decompress(RawData);
    buffer_delete(RawData);

    if (!buffer_exists(DecompressedData)) {
        show_debug_message("!!! DECOMPRESS FAILED");
        return MAP_ERR_FORMAT;
    }

    show_debug_message("Decompressed size: " + string(buffer_get_size(DecompressedData)));
    show_debug_message("Expected size: " + string(MAP_W * MAP_H * 2));

    // --- ЧТЕНИЕ СЕТОК ---
    var tileGrid = ds_grid_create(MAP_W, MAP_H),
        objGrid  = ds_grid_create(MAP_W, MAP_H);

    for (var xx = 0; xx < MAP_W; xx++)
        for (var yy = 0; yy < MAP_H; yy++)
            tileGrid[# xx, yy] = SId2Name[buffer_read(DecompressedData, buffer_u8)];

    for (var xx = 0; xx < MAP_W; xx++)
        for (var yy = 0; yy < MAP_H; yy++)
            objGrid[# xx, yy] = OId2Name[buffer_read(DecompressedData, buffer_u8)];

    buffer_delete(DecompressedData);

    show_debug_message("=== map_read SUCCESS ===");
    show_debug_message("Final position: " + string(buffer_tell(Map)));

    return [tileGrid, objGrid];
}