for(var xx = 0; xx < MAP_W; xx++) {
	for(var yy = 0; yy < MAP_H; yy++) {
		var Tile = ObjMap[# xx, yy];
		if(!Tile) continue;
		
		create(Tile, xx * 16, yy * 16);
	}
}

mp_grid_add_instances(Game.MapCollision, Terrains, false);