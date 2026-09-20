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

        var MapBuff = buffer_load(GameMapLoc);
        var Map = map_read(MapBuff);
        buffer_delete(MapBuff);

        if (is_array(Map)) {
            TileMap = Map[0];
            ObjMap  = Map[1];
        } else {
            show_message("Файл не является картой игры или повреждён.");
            GameMap = "";
            GameMapLoc = "";
        }
    }
}