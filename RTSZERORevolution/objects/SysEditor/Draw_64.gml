gui_rect(0, 0, 512, 20, P0, 1, 0);
gui_rect(383, 0, 512, 384, P0, 1, 0);
gui_line(0, 20, 512, 20, P7, 1);
gui_line(383, 20, 383, 384, P7, 1);
gui_line(383, 255, 512, 255, P7, 1);

if(!surface_exists(Minimap)) event_user(1);
draw_surface(Minimap, 384, 256);

var x1 = camera_get_view_x(CamID) div 16,
	y1 = camera_get_view_y(CamID) div 16,
	x2 = x1 + (24 * ViewScale),
	y2 = y1 + (24 * ViewScale);

gui_rect(384 + x1, 257 + y1, 384 + x2, 257 + y2, PB, 1, 1);
gui_rect(384 + 64 - MapBorder[0], 256 + 64 - MapBorder[1], 384 + 64 + MapBorder[0], 256 + 64 + MapBorder[1], PD, 0.7, 1);

if(gui_buttonIcon(4, 2, 16, 16, sprEditorIcons, EditorIcons.create, GUI_NOBG)) {
	if(show_question("Вы действительно хотите создать новую карту?")) {
		ds_grid_clear(TileMap, 0);
		ds_grid_clear(ObjMap, -1);
		event_user(1);
	}
}
if(gui_buttonIcon(24, 2, 16, 16, sprEditorIcons, EditorIcons.Open, GUI_NOBG)) {
	var Loc = get_open_filename_ext("RtsZeroMap|*.rzm", "", Game.DirectoryMaps, "Загрузка карты...");
	if(Loc != "") {
		var Buff = buffer_load(Loc);
		var Map = map_read(Buff);
		buffer_delete(Buff);
		
		if(is_array(Map)) {
			ds_grid_destroy(TileMap);
			TileMap = Map[0];
			ds_grid_destroy(ObjMap);
			ObjMap = Map[1];
		
			event_user(1);
		} else {
			show_message("Выбранный файл не является картой игры или повреждён.");
		}
	}
}
if(gui_buttonIcon(44, 2, 16, 16, sprEditorIcons, EditorIcons.Save, GUI_NOBG)) {
	var Loc = get_save_filename_ext("RtsZeroMap|*.rzm", "", Game.DirectoryMaps, "Сохранение карты...");
	if(Loc != "") {
		event_user(1);
		
		var Map = buffer_create(10, buffer_grow, 1);
		map_write(Map, TileMap, ObjMap);
		buffer_save(Map, Loc);
		buffer_delete(Map);
		
		surface_save(Minimap, Loc + ".png");
	}
}

gui_line(63, 2, 63, 16, P7, 0.5);

if (gui_buttonIcon(68, 2, 16, 16, sprEditorIcons, BrushType == EditorBrushType.Circle ? EditorIcons.Circle : EditorIcons.Rectangle, GUI_NOBG) or
	mouse_check_button_pressed(mb_middle)) {
	if(BrushType == EditorBrushType.Circle) BrushType = EditorBrushType.Rectangle;
	else BrushType = EditorBrushType.Circle;
}

gui_line(87, 2, 87, 16, P7, 0.5);

if(gui_buttonIcon(92, 2, 16, 16, sprEditorIcons, EditorIcons.Objects, GUI_NOBG)) {
	Sidebar = [EditorSidebar.Objsetting];
	BrushMat = -1;
}

if(gui_buttonIcon(112, 2, 16, 16, sprEditorIcons, EditorIcons.Tiles, GUI_NOBG)) {
	Sidebar = [EditorSidebar.Tilesetting];
	BrushMat = -1;
}


if(gui_buttonIcon(472, 2, 16, 16, sprEditorIcons, EditorIcons.Settings, GUI_NOBG)) {
	Sidebar = [EditorSidebar.MapSettings];
}
if(gui_buttonIcon(492, 2, 16, 16, sprEditorIcons, EditorIcons.Close, GUI_NOBG)) {
	instance_change(SysMenu, true);
}

gui_font(fn_default, fa_middle, fa_middle);

switch(Sidebar[0]) {
	#region Настройки карты
	case EditorSidebar.MapSettings:
		gui_text(448, 32, "Настройки карты", 1, PF, 1);
		
		if(gui_buttonText(398, 60, 100, 12, MapName, 0)) {
			var str = get_string("Введите новое название карты:", MapName);
			if(str != "") MapName = str;
		}
		
		if(gui_buttonText(398, 90, 42, 12, string(MapBorder[0]), 0)) {
			var int = get_integer("Введите новую ширину границ карты(16 - 64):", MapBorder[0]);
			MapBorder[0] = clamp(int, 16, 64);
		}
		gui_text(448, 96, "x", 1, PF, 1);
		if(gui_buttonText(456, 90, 42, 12, string(MapBorder[1]), 0)) {
			var int = get_integer("Введите новую высоту границ карты(16 - 64):", MapBorder[1]);
			MapBorder[1] = clamp(int, 16, 64);
		}
		
		if(gui_buttonText(398, 120, 100, 12, string(MapPlayers), 0)) {
			if(MapPlayers < 8) MapPlayers++ else MapPlayers = 2;
		}
		
		if(gui_buttonText(398, 150, 100, 12, "Создать карту", 0)) {
			if(show_question("Сгенерировать карту на 2 игроков (река + 2 пути)?")) {
				map_generate(TileMap, ObjMap);
				event_user(1);
			}
		}
		
		gui_font(fn_default, fa_left, fa_bottom);
		gui_text(398, 58, "Название карты:", 1, PF, 1);
		gui_text(398, 88, "Границы карты:", 1, PF, 1);
		gui_text(398, 118, "Максимум игроков:", 1, PF, 1);
		gui_text(398, 148, "Генератор (река + 2 пути):", 1, PF, 1);
	break;
	#endregion
	#region Тайлсеттинг
	case EditorSidebar.Tilesetting:
		gui_text(448, 32, "Тайлсеттинг", 1, PF, 1);
		
		if(gui_buttonIcon(390, 40, 16, 16, tlGrass, 0, 0)) BrushMat = tlGrass;
		if(gui_buttonIcon(410, 40, 16, 16, tlDirt, 0, 0)) BrushMat = tlDirt;
		if(gui_buttonIcon(430, 40, 16, 16, tlGravel, 0, 0)) BrushMat = tlGravel;
		if(gui_buttonIcon(450, 40, 16, 16, tlSand, 0, 0)) BrushMat = tlSand;
		if(gui_buttonIcon(470, 40, 16, 16, tlWater, 0, 0)) BrushMat = tlWater;
	break;
	#endregion
	#region Тайлсеттинг
	case EditorSidebar.Objsetting:
		gui_text(448, 32, "Объектсеттинг", 1, PF, 1);
		
		if(gui_buttonIcon(390, 40, 16, 16, sprEditorObjects, 1, 0)) BrushMat = TerrainWall;
		//if(gui_buttonIcon(410, 40, 16, 16, sprEditorObjects, 2, 0)) BrushMat = sprTerrainOak;
		if(gui_buttonIcon(430, 40, 16, 16, sprEditorObjects, 3, 0)) BrushMat = BuildCommandCenter;
		if(gui_buttonIcon(450, 40, 16, 16, sprEditorObjects, 4, 0)) BrushMat = BuildPeridotSupply;
	break;
	#endregion
}