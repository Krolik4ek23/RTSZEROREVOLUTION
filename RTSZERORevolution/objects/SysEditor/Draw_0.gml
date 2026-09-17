draw_clear(0);

draw_sprite_tiled(sprEditorGrid, 0, 0, 0);
draw_rectangle_color(1024 - (MapBorder[0] * 16), 1024 - (MapBorder[1] * 16), 1024 + (MapBorder[0] * 16), 1024 + (MapBorder[1] * 16), PD, PD, PD, PD, 1);

var x1 = clamp(camera_get_view_x(CamID) div 16, 0, MAP_W),
	y1 = clamp(camera_get_view_y(CamID) div 16, 0, MAP_H),
	x2 = clamp(x1 + (camera_get_view_height(CamID) div 16) + 1, 0, MAP_W),
	y2 = clamp(y1 + (camera_get_view_height(CamID) div 16) + 1, 0, MAP_H);

for(var xx = x1; xx < x2; xx++) {
	for(var yy = y1; yy < y2; yy++) {
		var Tile = TileMap[# xx, yy];
		if(Tile) draw_sprite(Tile, Tile == tlWater ? -1 : 0, xx * 16, yy * 16);
	}
}

for(var xx = x1; xx < x2; xx++) {
	for(var yy = y1; yy < y2; yy++) {
		var Tile = TileMap[# xx, yy];
		if(Tile and Tile != tlWater) {
			if(xx + 1 < MAP_W and Tile < TileMap[# xx + 1, yy]) draw_sprite(Tile, 1, xx * 16 + 16, yy * 16);
			if(xx + 1 < MAP_W and yy - 1 > 0 and Tile < TileMap[# xx + 1, yy - 1]) draw_sprite(Tile, 2, xx * 16 + 16, yy * 16 - 16);
			if(yy - 1 > 0 and Tile < TileMap[# xx, yy - 1]) draw_sprite(Tile, 3, xx * 16, yy * 16 - 16);
			if(xx - 1 > 0 and yy - 1 > 0 and Tile < TileMap[# xx - 1, yy - 1]) draw_sprite(Tile, 4, xx * 16 - 16, yy * 16 - 16);
			if(xx - 1 > 0 and Tile < TileMap[# xx - 1, yy]) draw_sprite(Tile, 5, xx * 16 - 16, yy * 16);
			if(xx - 1 > 0 and yy + 1 < MAP_H and Tile < TileMap[# xx - 1, yy + 1]) draw_sprite(Tile, 6, xx * 16 - 16, yy * 16 + 16);
			if(yy + 1 < MAP_H and Tile < TileMap[# xx, yy + 1]) draw_sprite(Tile, 7, xx * 16, yy * 16 + 16);
			if(xx + 1 < MAP_W and yy + 1 < MAP_H and Tile < TileMap[# xx + 1, yy + 1]) draw_sprite(Tile, 8, xx * 16 + 16, yy * 16 + 16);
		}
	}
}

for(var xx = x1; xx < x2; xx++) {
	for(var yy = y1; yy < y2; yy++) {
		var Tile = ObjMap[# xx, yy];
		if(!Tile) continue;
		
		Tile = object_get_sprite(Tile);
		
		draw_sprite(Tile, 0, xx * 16, yy * 16);
		if(Tile == sprTerrainOak) {
			for(var i = 0; i < 2; i++) draw_sprite_ext(sprTerrainOakLeaves, 0, xx * 16 + 8, yy * 16 + 8, 1 - (i / 6), 1 - (i / 6), 45 * i, c_white, 1);
		}
	}
}


if(point_in_rectangle(MouseGuiX, MouseGuiY, 0, 16, 384, 384)) {
	var MouseCellX = MouseX div 16,
		MouseCellY = MouseY div 16;
	
	if(BrushSize > 0) {
		var x1 = MouseCellX - BrushSize,
			y1 = MouseCellY - BrushSize,
			x2 = MouseCellX + BrushSize + 1,
			y2 = MouseCellY + BrushSize + 1;
		
		for(var xx = x1; xx < x2; xx++) {
			for(var yy = y1; yy < y2; yy++) {
				if(BrushType == EditorBrushType.Circle and point_distance(MouseCellX, MouseCellY, xx, yy) > BrushSize) continue;
				
				draw_rectangle_color(xx * 16, yy * 16, xx * 16 + 16, yy * 16 + 16, PC, PC, PC, PC, 1);
			}
		}
	} else {
		draw_rectangle_color(MouseCellX * 16, MouseCellY * 16, MouseCellX * 16 + 16, MouseCellY * 16 + 16, PC, PC, PC, PC, 1);
	}
}