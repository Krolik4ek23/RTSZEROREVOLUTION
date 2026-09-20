if(!surface_exists(Minimap)) Minimap = surface_create(MAP_W, MAP_H);
	
surface_set_target(Minimap);
draw_clear(0);

for(var xx = 0; xx < MAP_W; xx++) {
	for(var yy = 0; yy < MAP_H; yy++) {
		var Tile = ObjMap[# xx, yy];
		if (object_exists(Tile)) {
			Tile = object_get_sprite(Tile);
			draw_sprite_ext(Tile, 0, xx, yy, 1/sprite_get_width(Tile), 1/sprite_get_height(Tile), 0, c_white, 1);
		} else {
			Tile = TileMap[# xx, yy];
			if(Tile) draw_sprite_ext(Tile, 0, xx, yy, 1/16, 1/16, 0, c_white, 1);
			else draw_point_color(xx, yy, 0);
		}
	}
}

surface_reset_target();