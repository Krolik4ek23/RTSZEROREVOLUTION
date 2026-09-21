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

if(point_in_rectangle(MouseGuiX, MouseGuiY, 0, 0, 384, 384)) {
	if(!Game.AbilityUse[0]) {
		var isCtrl = keyboard_check(vk_lcontrol);
	
		if(mouse_check_button_pressed(mb_left)) {
			if(!isCtrl) ds_list_clear(Pick);
			with(Civilian) {
				if(Plr != Game.OwnerPlayer) continue;
				if(!point_in_rectangle(MouseX, MouseY, bbox_left, bbox_top, bbox_right, bbox_bottom)) continue;
		
				if(!isCtrl or ds_list_find_index(SysClient.Pick, id) == -1) ds_list_add(SysClient.Pick, id);
			}
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
			
			network_packet(BUFF1, NetPacket.UnitControl);
			for(var j = ds_list_size(Pick), i = 0; i < j; i++) {
				var Unit = Pick[| i];
				if(!instance_exists(Unit)) continue;
				if(object_get_parent(Unit.object_index) != Units) continue;
			
				buffer_write(BUFF1, buffer_u16, Unit.NetUID);
				if(EnemyTarget != noone and Unit.Damage > 0) {
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