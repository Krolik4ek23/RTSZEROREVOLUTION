if(Status != ClientStatus.InGame) exit;

draw_clear(0);

var x1 = clamp(camera_get_view_x(CamID) div 16, 0, MAP_W),
	y1 = clamp(camera_get_view_y(CamID) div 16, 0, MAP_H),
	x2 = clamp(x1 + (camera_get_view_height(CamID) div 16) + 1, 0, MAP_W),
	y2 = clamp(y1 + (camera_get_view_height(CamID) div 16) + 1, 0, MAP_H);

for(var xx = x1; xx < x2; xx++) {
	for(var yy = y1; yy < y2; yy++) {
		var Tile = TileMap[# xx, yy] & 255;
		if(Tile) draw_sprite(Tile, Tile == tlWater ? -1 : 0, xx * 16, yy * 16);
	}
}

for(var xx = x1; xx < x2; xx++) {
	for(var yy = y1; yy < y2; yy++) {
		var TileData = TileMap[# xx, yy];
		if(!TileData) continue;
		
		var TileID = TileData & 255;
		
		if(TileID != tlWater) {
			if((TileData >> 9) & 1) draw_sprite(TileID, 1, xx * 16 + 16, yy * 16);
			if((TileData >> 10) & 1) draw_sprite(TileID, 2, xx * 16 + 16, yy * 16 - 16);
			if((TileData >> 11) & 1) draw_sprite(TileID, 3, xx * 16, yy * 16 - 16);
			if((TileData >> 12) & 1) draw_sprite(TileID, 4, xx * 16 - 16, yy * 16 - 16);
			if((TileData >> 13) & 1) draw_sprite(TileID, 5, xx * 16 - 16, yy * 16);
			if((TileData >> 14) & 1) draw_sprite(TileID, 6, xx * 16 - 16, yy * 16 + 16);
			if((TileData >> 15) & 1) draw_sprite(TileID, 7, xx * 16, yy * 16 + 16);
			if((TileData >> 16) & 1) draw_sprite(TileID, 8, xx * 16 + 16, yy * 16 + 16);
		}
	}
}

//for(var xx = x1; xx < x2; xx++) {
//	for(var yy = y1; yy < y2; yy++) {
//		var Tile = ObjMap[# xx, yy];
//		if(!Tile) continue;

//		draw_sprite(Tile, 0, xx * 16, yy * 16);
//		if(Tile == sprTerrainOak) {
//			for(var i = 0; i < 2; i++) draw_sprite_ext(sprTerrainOakLeaves, 0, xx * 16 + 8, yy * 16 + 8, 1 - (i / 6), 1 - (i / 6), 45 * i, c_white, 1);
//		}
//	}
//}