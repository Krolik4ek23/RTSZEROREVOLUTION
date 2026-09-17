draw_clear(P0);
draw_sprite_ext(sprGuiLogo, 0, 256, 36, 2, 2, 0, PF, 1);

gui_font(fn_default, fa_right, fa_bottom);
gui_text(510, 382, Game.Copyright, 1, PF, 1);

gui_font(fn_default, fa_middle, fa_middle);
gui_text(256, 64, "RTSZero", 2, PF, 1);
gui_text(256, 80, "Версия: " + Game.Version, 1, P8, 1);
gui_text(256, 192, "TPS: " + string(fps), 2, PF, 1);

if(gui_buttonText(156, 212, 200, 12, GameMap == "" ? "Карта не выбрана" : GameMap, 0)) {
    var Loc = get_open_filename_ext("RtsZeroMap|*.rzm", "", Game.DirectoryMaps, "Выбор карты...");
    if(Loc != "") {
        GameMapLoc = Loc;
        GameMap = filename_name(GameMapLoc);
        
        // ===== ОТЛАДКА: ЗАГРУЗКА ФАЙЛА =====
        show_debug_message("========================================");
        show_debug_message("=== LOADING MAP ===");
        show_debug_message("File: " + GameMapLoc);
        show_debug_message("MAP_ERR_FORMAT = " + string(MAP_ERR_FORMAT));
        show_debug_message("MAP_ERR_OUTDATED = " + string(MAP_ERR_OUTDATED));
        show_debug_message("MAP_W = " + string(MAP_W) + ", MAP_H = " + string(MAP_H));
        show_debug_message("Game.Version = '" + Game.Version + "'");
        
        var MapBuff = buffer_load(GameMapLoc);
        
        show_debug_message("Buffer exists: " + string(buffer_exists(MapBuff)));
        show_debug_message("Buffer size: " + string(buffer_get_size(MapBuff)));
        
        // Проверка заголовка ДО map_read
        if (buffer_exists(MapBuff)) {
            buffer_seek(MapBuff, buffer_seek_start, 0);
            var dbgHeader = buffer_read(MapBuff, buffer_string);
            var dbgVersion = buffer_read(MapBuff, buffer_string);
            show_debug_message("Raw header: '" + dbgHeader + "'");
            show_debug_message("Raw version: '" + dbgVersion + "'");
            buffer_seek(MapBuff, buffer_seek_start, 0);   // сброс курсора
        }
        // ===================================
        
        var Map = map_read(MapBuff);
        
        // ===== ОТЛАДКА: РЕЗУЛЬТАТ =====
        show_debug_message("map_read returned: " + string(Map));
        show_debug_message("typeof(Map): " + string(typeof(Map)));
        show_debug_message("is_array(Map): " + string(is_array(Map)));
        // ==============================
        
        buffer_delete(MapBuff);
        
        if (is_array(Map)) {
            TileMap = Map[0];
            ObjMap  = Map[1];
            
            // ===== ОТЛАДКА: УСПЕХ =====
            show_debug_message("=== MAP LOADED SUCCESSFULLY ===");
            show_debug_message("TileMap is ds_grid: " + string(ds_exists(TileMap, ds_type_grid)));
            show_debug_message("ObjMap is ds_grid: " + string(ds_exists(ObjMap, ds_type_grid)));
            // ==========================
            
        } else {
            // ===== ОТЛАДКА: ОШИБКА =====
            show_debug_message("=== MAP LOAD FAILED ===");
            show_debug_message("Error code: " + string(Map));
            switch (Map) {
                case MAP_ERR_FORMAT:
                    show_debug_message("Reason: MAP_ERR_FORMAT (bad format or corrupted)");
                break;
                case MAP_ERR_OUTDATED:
                    show_debug_message("Reason: MAP_ERR_OUTDATED (version mismatch)");
                break;
                default:
                    show_debug_message("Reason: UNKNOWN (" + string(Map) + ")");
            }
            // =========================
            
            switch (Map) {
                case MAP_ERR_FORMAT:
                    show_message("Файл не является картой игры или повреждён.");
                break;
                case MAP_ERR_OUTDATED:
                    show_message("Карта создана на другой версии редактора.");
                break;
                default:
                    show_message("Неизвестная ошибка карты: " + string(Map));
            }
            GameMap = "";
            GameMapLoc = "";
        }
    }
}