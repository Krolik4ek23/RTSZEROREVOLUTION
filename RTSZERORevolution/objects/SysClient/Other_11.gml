for(var xx = 0; xx < MAP_W; xx++) {
	for(var yy = 0; yy < MAP_H; yy++) {
		var Tile = TileMap[# xx, yy];
		if(!Tile) continue;
		
		TileMap[# xx, yy] = 
			(Tile & 255) |
			((xx + 1 < MAP_W and Tile < TileMap[# xx + 1, yy] & 255) << 9) |
			((xx + 1 < MAP_W and yy - 1 > 0 and Tile < TileMap[# xx + 1, yy - 1] & 255) << 10) |
			((yy - 1 > 0 and Tile < TileMap[# xx, yy - 1] & 255) << 11) |
			((xx - 1 > 0 and yy - 1 > 0 and Tile < TileMap[# xx - 1, yy - 1] & 255) << 12) |
			((xx - 1 > 0 and Tile < TileMap[# xx - 1, yy] & 255) << 13) |
			((xx - 1 > 0 and yy + 1 < MAP_H and Tile < TileMap[# xx - 1, yy + 1] & 255) << 14) |
			((yy + 1 < MAP_H and Tile < TileMap[# xx, yy + 1] & 255) << 15) |
			((xx + 1 < MAP_W and yy + 1 < MAP_H and Tile < TileMap[# xx + 1, yy + 1] & 255) << 16);
	}
}

for(var xx = 0; xx < MAP_W; xx++) {
	for(var yy = 0; yy < MAP_H; yy++) {
		var Tile = ObjMap[# xx, yy];
		if (!object_exists(Tile)) continue;
		if(object_is_ancestor(Tile, Civilian)) continue;
		
		create(Tile, xx * 16, yy * 16);
	}
}

mp_grid_add_instances(Game.MapCollision, Terrains, false);

var Surf = surface_create(128, 128);

surface_set_target(Surf);
draw_clear(0);

for(var xx = 0; xx < MAP_W; xx++) {
	for(var yy = 0; yy < MAP_H; yy++) {
		var Tile = ObjMap[# xx, yy];
		if (object_exists(Tile) and !object_is_ancestor(Tile, Civilian)) {
			Tile = object_get_sprite(Tile);
			draw_sprite_ext(Tile, 0, xx, yy, 1/sprite_get_width(Tile), 1/sprite_get_height(Tile), 0, c_white, 1);
		} else {
			Tile = TileMap[# xx, yy] & 255;
			if(Tile) draw_sprite_ext(Tile, 0, xx, yy, 1/16, 1/16, 0, c_white, 1);
			else draw_point_color(xx, yy, 0);
		}
	}
}

surface_reset_target();
Minimap = sprite_create_from_surface(Surf, 0, 0, 128, 128, 0, 0, 0, 0);
surface_free(Surf);