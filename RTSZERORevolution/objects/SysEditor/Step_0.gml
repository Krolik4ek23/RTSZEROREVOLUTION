var mouseOnField = point_in_rectangle(MouseGuiX, MouseGuiY, 0, 20, 384, 384);

if(mouse_check_button(vk_lcontrol)) {
	
} else {
	if(mouse_wheel_up() and BrushSize < 8) BrushSize++;
	if(mouse_wheel_down() and BrushSize > 0) BrushSize--;
}

if(mouseOnField and (mouse_check_button(mb_left) xor mouse_check_button(mb_right))) {
	var MouseCellX = MouseX div 16,
		MouseCellY = MouseY div 16,
		CurGrid = (Sidebar[0] == EditorSidebar.Tilesetting ? TileMap : ObjMap),
		BrushOp = mouse_check_button(mb_left) ? BrushMat : (Sidebar[0] == EditorSidebar.Tilesetting ? 0 : -1);
	
	if(BrushOp != -1 or mouse_check_button(mb_right)) {
		if(BrushSize == 0) {
			ds_grid_set(CurGrid, MouseCellX, MouseCellY, BrushOp);
		
			surface_set_target(Minimap);
			editor_minimap_refresh(MouseCellX, MouseCellY);
			surface_reset_target();
		} else if(BrushType == EditorBrushType.Circle) {
			ds_grid_set_disk(CurGrid, MouseCellX, MouseCellY, BrushSize, BrushOp);
		
			var x1 = MouseCellX - BrushSize, y1 = MouseCellY - BrushSize,
				x2 = MouseCellX + BrushSize + 1, y2 = MouseCellY + BrushSize + 1;
		
			surface_set_target(Minimap);
			for(var xx = x1; xx < x2; xx++) {
				for(var yy = y1; yy < y2; yy++) {
					if(point_distance(MouseCellX, MouseCellY, xx, yy) > BrushSize) continue;
					editor_minimap_refresh(xx, yy);
				}
			}
			surface_reset_target();
		} else if(BrushType == EditorBrushType.Rectangle) {
			ds_grid_set_region(CurGrid, MouseCellX - BrushSize, MouseCellY - BrushSize, MouseCellX + BrushSize, MouseCellY + BrushSize, BrushOp);
		
			var x1 = MouseCellX - BrushSize, y1 = MouseCellY - BrushSize,
				x2 = MouseCellX + BrushSize + 1, y2 = MouseCellY + BrushSize + 1;
		
			surface_set_target(Minimap);
			for(var xx = x1; xx < x2; xx++) {
				for(var yy = y1; yy < y2; yy++) {
					editor_minimap_refresh(xx, yy);
				}
			}
			surface_reset_target();
		}
	}
}

var x1 = camera_get_view_x(CamID),
	y1 = camera_get_view_y(CamID),
	x2 = camera_get_view_width(CamID),
	y2 = camera_get_view_height(CamID);

if(keyboard_check(ord("A"))) x1 -= 4;
if(keyboard_check(ord("D"))) x1 += 4;
if(keyboard_check(ord("W"))) y1 -= 4;
if(keyboard_check(ord("S"))) y1 += 4;
if(keyboard_check(vk_lcontrol)) ViewScale = clamp(ViewScale + ((mouse_wheel_down() - mouse_wheel_up()) * 0.1), 0.5, 4.0);

camera_set_view_pos(CamID, clamp(x1, 0, (MAP_W * 16) - x2), clamp(y1, -20, (MAP_H * 16) - y2));

if(PrevViewScale != ViewScale) {
	PrevViewScale = ViewScale;
	
	camera_set_view_size(CamID, 512 * ViewScale, 384 * ViewScale);
}