function editor_minimap_refresh(argument0, argument1)
{
    var XX = argument0;
    var YY = argument1;

    var Tile = ObjMap[# XX, YY];

    if (Tile)
    {
        var Spr = object_get_sprite(Tile);

        if (Spr != -1)
        {
            draw_sprite_ext(
                Spr,
                0,
                XX,
                YY,
                1 / sprite_get_width(Spr),
                1 / sprite_get_height(Spr),
                0,
                c_white,
                1
            );
        }
    }
    else
    {
        Tile = TileMap[# XX, YY];

        if (Tile)
        {
            draw_sprite_ext(
                Tile,
                0,
                XX,
                YY,
                1 / 16,
                1 / 16,
                0,
                c_white,
                1
            );
        }
        else
        {
            draw_point_color(XX, YY, 0);
        }
    }
}