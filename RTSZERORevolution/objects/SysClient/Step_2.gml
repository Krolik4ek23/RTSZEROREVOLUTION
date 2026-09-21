if(Status != ClientStatus.InGame) exit;

// Очистка выделения от уничтоженных юнитов
for(var j = ds_list_size(Pick) - 1; j >= 0; j--) {
	if(!instance_exists(Pick[| j])) ds_list_delete(Pick, j);
}

var x1 = camera_get_view_x(CamID),
	y1 = camera_get_view_y(CamID),
	x2 = camera_get_view_width(CamID),
	y2 = camera_get_view_height(CamID);

if(keyboard_check(ord("A"))) x1 -= 4;
if(keyboard_check(ord("D"))) x1 += 4;
if(keyboard_check(ord("W"))) y1 -= 4;
if(keyboard_check(ord("S"))) y1 += 4;

camera_set_view_pos(CamID, clamp(x1, 0, (MAP_W * 16) - x2), clamp(y1, 0, (MAP_H * 16) - y2));

// Завершение выделения рамкой (даже если мышь вышла за поле)
if(DragActive and mouse_check_button_released(mb_left)) {
	DragActive = false;
	
	if(abs(MouseX - DragStartX) < 4 and abs(MouseY - DragStartY) < 4) {
		// Клик — выделяем юнита под курсором
		with(Civilian) {
			if(Plr != Game.OwnerPlayer) continue;
			if(!point_in_rectangle(MouseX, MouseY, bbox_left, bbox_top, bbox_right, bbox_bottom)) continue;
			if(!other.DragCtrl or ds_list_find_index(SysClient.Pick, id) == -1) ds_list_add(SysClient.Pick, id);
		}
	} else {
		// Рамка — выделяем всех своих юнитов в прямоугольнике
		SelX1 = min(DragStartX, MouseX);
		SelY1 = min(DragStartY, MouseY);
		SelX2 = max(DragStartX, MouseX);
		SelY2 = max(DragStartY, MouseY);
		with(Civilian) {
			if(Plr != Game.OwnerPlayer) continue;
			if(object_get_parent(object_index) != Units) continue;
			if(bbox_right < other.SelX1 or bbox_left > other.SelX2 or bbox_bottom < other.SelY1 or bbox_top > other.SelY2) continue;
			if(!other.DragCtrl or ds_list_find_index(SysClient.Pick, id) == -1) ds_list_add(SysClient.Pick, id);
		}
	}
}

if(point_in_rectangle(MouseGuiX, MouseGuiY, 0, 0, 384, 384)) {
	if(!Game.AbilityUse[0]) {
		var isCtrl = keyboard_check(vk_lcontrol);
	
		if(mouse_check_button_pressed(mb_left)) {
			// Начало выделения (клик или рамка)
			DragStartX = MouseX;
			DragStartY = MouseY;
			DragActive = true;
			DragCtrl = isCtrl;
			if(!isCtrl) ds_list_clear(Pick);
		}

		if(mouse_check_button_pressed(mb_right)) {
			// Ищем врага под курсором
			EnemyTarget = noone;
			with(Civilian) {
				if(Plr == Game.OwnerPlayer or (Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team)) continue;
				if(!point_in_rectangle(MouseX, MouseY, bbox_left, bbox_top, bbox_right, bbox_bottom)) continue;
				other.EnemyTarget = id;
				break;
			}
			
			// Ищем свою недостроенную постройку (для достройки бульдозером)
			BuildTarget = noone;
			with(BuildFrame) {
				if(Plr != Game.OwnerPlayer) continue;
				if(Progress >= 100) continue;
				if(!point_in_rectangle(MouseX, MouseY, bbox_left, bbox_top, bbox_right, bbox_bottom)) continue;
				other.BuildTarget = id;
				break;
			}
			
			network_packet(BUFF1, NetPacket.UnitControl);
			for(var j = ds_list_size(Pick), i = 0; i < j; i++) {
				var Unit = Pick[| i];
				if(!instance_exists(Unit)) continue;
				if(object_get_parent(Unit.object_index) != Units) continue;
			
				buffer_write(BUFF1, buffer_u16, Unit.NetUID);
				if(BuildTarget != noone and Unit.Damage <= 0) {
					// Достройка (бульдозер)
					buffer_write(BUFF1, buffer_u8, 5);
					buffer_write(BUFF1, buffer_u16, BuildTarget.NetUID);
				} else if(EnemyTarget != noone and Unit.Damage > 0) {
					// Атака
					buffer_write(BUFF1, buffer_u8, 4);
					buffer_write(BUFF1, buffer_u16, EnemyTarget.NetUID);
				} else {
					// Движение
					buffer_write(BUFF1, buffer_u8, 1);
					buffer_write(BUFF1, buffer_u16, MouseX);
					buffer_write(BUFF1, buffer_u16, MouseY);
				}
			}
			buffer_write(BUFF1, buffer_u16, 0);
			network_send(BUFF1, Socket);
		}
	} else {
		if(mouse_check_button_pressed(mb_right)) Game.AbilityUse = [0, 0, 0];
	}
}