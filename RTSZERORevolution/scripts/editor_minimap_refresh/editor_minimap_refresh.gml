///@param x
///@param y
function editor_minimap_refresh(argument0, argument1) {
    var XX = argument0, YY = argument1;

    var Tile = ObjMap[# XX, YY];
    if (Tile) {
        var spr = object_get_sprite(Tile);            // ← фикс
        if (sprite_exists(spr)) {
            draw_sprite_ext(spr, 0, XX, YY, 
                1/sprite_get_width(spr), 
                1/sprite_get_height(spr), 0, c_white, 1);
        }
    } else {
        Tile = TileMap[# XX, YY];
        if (Tile) draw_sprite_ext(Tile, 0, XX, YY, 1/16, 1/16, 0, c_white, 1);
        else draw_point_color(XX, YY, 0);
    }
}