///@param buff
///@param tileGrid
///@param objGrid
function map_write(argument0, argument1, argument2) {
    var tileGrid = argument1,
        objGrid = argument2,
        Map = argument0;

    show_debug_message("=== map_write START ===");
    show_debug_message("Map exists: " + string(buffer_exists(Map)));
    show_debug_message("Map initial size: " + string(buffer_get_size(Map)));
    show_debug_message("MAP_W=" + string(MAP_W) + ", MAP_H=" + string(MAP_H));

    // --- ЗАГОЛОВОК ---
    buffer_write(Map, buffer_string, "RTS0");
    buffer_write(Map, buffer_string, Game.Version);
    show_debug_message("After header — position: " + string(buffer_tell(Map)));

    // --- СПРАЙТЫ ТАЙЛОВ ---
    var spriteCount = 0;
    for (var i = 1; sprite_exists(i); i++) {
        var j = sprite_get_name(i);
        if (string_pos("tl", j) != 1) continue;
        buffer_write(Map, buffer_u8, i);
        buffer_write(Map, buffer_string, j);
        spriteCount++;
    }
    buffer_write(Map, buffer_u8, 0);
    show_debug_message("Sprites written: " + string(spriteCount));
    show_debug_message("After sprites — position: " + string(buffer_tell(Map)));

    // --- ОБЪЕКТЫ ---
    var objectCount = 0;
    for (var i = 1; object_exists(i); i++) {
        var j = object_get_name(i);
        if (i == Units or i == Builds) continue;
        
        // --- РАЗРЕШИТЬ СОХРАНЕНИЕ БАЗ ---
        if (i == BuildCommandCenter or i == BuildPeridotSupply) {
            buffer_write(Map, buffer_u8, i);
            buffer_write(Map, buffer_string, j);
            objectCount++;
            continue;
        }
        
        if (!object_is_ancestor(i, Civilian) and
            !object_is_ancestor(i, Terrains)) continue;
        buffer_write(Map, buffer_u8, i);
        buffer_write(Map, buffer_string, j);
        objectCount++;
    }
    buffer_write(Map, buffer_u8, 0);
    show_debug_message("Objects written: " + string(objectCount));
    show_debug_message("After objects — position: " + string(buffer_tell(Map)));

    // --- СЫРЫЕ ДАННЫЕ ---
    var RawDataSize = MAP_W * MAP_H * 2;
    show_debug_message("RawDataSize: " + string(RawDataSize));

    var RawData = buffer_create(RawDataSize, buffer_grow, 1);

    // --- tileGrid с защитой от pointer_null ---
    for (var xx = 0; xx < MAP_W; xx++)
        for (var yy = 0; yy < MAP_H; yy++) {
            var val = tileGrid[# xx, yy];
            if (!is_real(val)) val = 0;
            buffer_write(RawData, buffer_u8, val);
        }

    // --- objGrid с защитой от pointer_null ---
    for (var xx = 0; xx < MAP_W; xx++)
        for (var yy = 0; yy < MAP_H; yy++) {
            var val = objGrid[# xx, yy];
            if (!is_real(val)) val = 0;
            buffer_write(RawData, buffer_u8, val);
        }

    show_debug_message("RawData position: " + string(buffer_tell(RawData)));
    show_debug_message("RawData size: " + string(buffer_get_size(RawData)));

    // --- СЖАТИЕ ---
    var CompressedData = buffer_compress(RawData, 0, RawDataSize);
    var CompressedDataSize = buffer_get_size(CompressedData);
    buffer_delete(RawData);

    show_debug_message("CompressedDataSize: " + string(CompressedDataSize));

    // --- ЗАПИСЬ В Map ---
    buffer_write(Map, buffer_u32, CompressedDataSize);
    buffer_copy(CompressedData, 0, CompressedDataSize, Map, buffer_tell(Map));
    buffer_seek(Map, buffer_seek_relative, CompressedDataSize);
    buffer_delete(CompressedData);

    // --- ИТОГ ---
    show_debug_message("=== map_write END ===");
    show_debug_message("Map final size: " + string(buffer_get_size(Map)));
    show_debug_message("Map final position: " + string(buffer_tell(Map)));

    // --- ПРОВЕРКА ЗАГОЛОВКА (без порчи курсора!) ---
    var savePos = buffer_tell(Map);
    
    buffer_seek(Map, buffer_seek_start, 0);
    var checkHeader = buffer_read(Map, buffer_string);
    var checkVersion = buffer_read(Map, buffer_string);
    show_debug_message("Check Header: '" + checkHeader + "'");
    show_debug_message("Check Version: '" + checkVersion + "'");
    
    buffer_seek(Map, buffer_seek_start, savePos);
    show_debug_message("Position restored to: " + string(buffer_tell(Map)));
}