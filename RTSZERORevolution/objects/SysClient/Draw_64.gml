#region Отображение лобби
if(Status != ClientStatus.InGame) {
	draw_clear(P0);

	draw_sprite_ext(sprGuiLogo, 0, 256, 36, 2, 2, 0, PF, 1);

	gui_font(fn_default, fa_right, fa_bottom);
	gui_text(510, 382, Game.Copyright, 1, PF, 1);

	gui_font(fn_default, fa_middle, fa_middle);
	gui_text(256, 64, "RTSZero", 2, PF, 1);
	gui_text(256, 80, "Версия: " + Game.Version, 1, P8, 1);

	switch(Status) {
		case ClientStatus.Error:
			gui_text(256, 192, "Ошибка! Не удалось подключиться к серверу!", 1, PF, 1);
			if(gui_buttonText(156, 320, 200, 12, "Главное меню", 0)) instance_change(SysMenu, true);
		break;
		case ClientStatus.Disconnected:
			gui_text(256, 192, "Вы были отключены от сервера по причине:\n" + LastError, 1, PF, 1);
			if(gui_buttonText(156, 320, 200, 12, "Главное меню", 0)) instance_change(SysMenu, true);
		break;
		case ClientStatus.Connection:
			gui_text(256, 192, "Подключение к " + ServerIP + "...", 1, PF, 1);
		break;
		case ClientStatus.Matching:
			gui_text(256, 192, "Согласование настроек...", 1, PF, 1);
		break;
		case ClientStatus.Lobby:
			gui_font(fn_default, fa_middle, fa_middle);
	
			var yy = 96;
		
			if(GameMapPreview != NOTEXTURE) draw_sprite(GameMapPreview, 0, 260, yy);
			else gui_text(326, yy + 64, "Предпоказ\nнедоступен", 1, P8, 1);
		
			for(var i = 0; i < NET_PLAYERS; i++) {
				gui_rect(102, yy, 116, yy + 14, PlrObject[i].State == PlrStatus.Ready ? P2 : P1, 1, 0);
			
				gui_rect(118, yy, 222, yy + 14, P8, 1, 0);
				gui_text(172, yy + 7, PlrObject[i].Username, 1, PF, 1);
			
				gui_rect(224, yy, 238, yy + 14, P8, 1, 0);
				if(PlrObject[i].Team) gui_text(232, yy + 8, string(PlrObject[i].Team), 1, PF, 1);
				if (mouse_check_button_pressed(mb_left) and 
					PlrObject[i].Username == Game.Username and 
					point_in_rectangle(MouseGuiX, MouseGuiY, 224, yy, 238, yy + 14)) {
					
					network_packet(BUFF1, NetPacket.PlayerTable);
					buffer_write(BUFF1, buffer_u8, 2);
					network_send(BUFF1, Socket);
				}
			
				gui_rect(240, yy, 254, yy + 14, TeamColors[PlrObject[i].Color], 1, 0);
				if (mouse_check_button_pressed(mb_left) and 
					PlrObject[i].Username == Game.Username and 
					point_in_rectangle(MouseGuiX, MouseGuiY, 240, yy, 254, yy + 14)) {
					
					network_packet(BUFF1, NetPacket.PlayerTable);
					buffer_write(BUFF1, buffer_u8, 3);
					network_send(BUFF1, Socket);
				}
			
				yy += 16;
			}
		
			if(gui_buttonText(126, 340, 126, 16, "Выйти", 0)) {
				instance_change(SysMenu, true);
				exit;
			}
			if(gui_buttonText(260, 340, 126, 16, "Готовность", 0)) {
				network_packet(BUFF1, NetPacket.PlayerTable);
				buffer_write(BUFF1, buffer_u8, 1);
				network_send(BUFF1, Socket);
			}
		
			gui_font(fn_default, fa_left, fa_middle);
			gui_rect(102, 230, 410, 330, P8, 1, 0);
		
			for(var i = ds_list_size(Chat) - 1, yy = 228; i > -1; i--) {
				yy += 8;
				if(yy > 320) break;
				gui_text(104, yy, Chat[| i], 1, PF, 1);
			}
			if(i > -1) repeat(i + 1) ds_list_delete(Chat, 0);
		
			if(mouse_check_button_pressed(mb_left)) {
				ChatMessage = point_in_rectangle(MouseGuiX, MouseGuiY, 102, 230, 410, 330) ? "" : 0;
			}
		
			if(ChatMessage != 0) {
				gui_text(104, 326, ChatMessage + (current_time mod 1000 > 500 ? "_" : ""), 1, PF, 1);
			
				if(string_length(keyboard_string) < 50) ChatMessage = keyboard_string;
				else keyboard_string = ChatMessage;
			
				if(keyboard_check_pressed(vk_enter)) {
					network_packet(BUFF1, NetPacket.Chat);
					buffer_write(BUFF1, buffer_string, ChatMessage);
					network_send(BUFF1, Socket);
				
					keyboard_string = "";
				}
			} else {
				gui_text(104, 326, "Введите сообщение...", 1, PF, 0.5);
			}
		break;
	}
	exit;
}
#endregion

gui_font(fn_default, fa_middle, fa_middle);

//Рендер миникарты
draw_sprite(sprGuiPanel, 0, 382, 0);
draw_sprite_stretched(Minimap, 0, 383, 0, 128, 128);
with(Civilian) draw_sprite_ext(sprPoint, 0, 383 + round(x/16), round(y/16), 1, 1, 0, TeamColors[Plr.Color], 1);
if(!surface_exists(SurfShroud)) {
	SurfShroud = surface_create(256, 256);
	alarm[0] = 2;
}
draw_surface_stretched(SurfShroud, 383, 0, 128, 128);

gui_text(448, 136, string(Game.OwnerPlayer.Cash) + "$", 1, PF, 1);

//Рисование обводки
if(!ds_list_empty(Pick)) {
	var FirstUnit = Pick[| 0];
	
	if(instance_exists(FirstUnit)) with(FirstUnit) {
		var xx = 400, yy = 145;
		for(var i = 0; i < 9; i++) {
			if(Abilities[i] > 0) {
				if(Game.OwnerPlayer.Cash >= Game.AbilitiesPrice[Abilities[i]]) {
					draw_sprite(sprGuiAbilities, Abilities[i], xx, yy);
					if(point_in_rectangle(MouseGuiX, MouseGuiY, xx, yy, xx + 29, yy + 29)) {
						draw_set_alpha(0.3);
						draw_rectangle_color(xx, yy, xx + 29, yy + 29, c_white, c_white, c_white, c_white, 0);
						draw_set_alpha(1);
							
						if(mouse_check_button_pressed(mb_left)) {
							if(Game.AbilitiesType[Abilities[i]] == AbilityType.Simple) {
								network_packet(BUFF1, NetPacket.UnitControl);
								buffer_write(BUFF1, buffer_u16, NetUID);
								buffer_write(BUFF1, buffer_u8, 2);
								buffer_write(BUFF1, buffer_u8, i);
								buffer_write(BUFF1, buffer_u16, 0);
								network_send(BUFF1, other.Socket);
							} else {
								Game.AbilityUse = [id, i, 0];
							}
						}
					}
				} else {
					shader_set(shr_blackAndWhite);
					draw_sprite(sprGuiAbilities, Abilities[i], xx, yy);
					shader_reset();
				}
			}
				
			if(xx < 464) xx += 32 else {xx = 400; yy += 32};
		}
		
		if(object_get_parent(FirstUnit.object_index) == Builds) {
			var xx = 400, yy = 273;
			for(var i = 0; i < 9; i++) {
				if(QueueAbility[i] > 0) {
					draw_sprite_ext(sprGuiAbilities, QueueAbility[i], xx, yy, 1, 1, 0, c_gray, 1);
					if(QueueProgress[i] > 0) {
						var zz = (QueueProgress[i] / 100) * 30;
						draw_sprite_part_ext(sprGuiAbilities, QueueAbility[i], 0, 30 - zz, 30, zz, xx, yy + 30 - zz, 1, 1, c_white, 1);
					}
					gui_text(xx + 15, yy + 15, string_format(QueueProgress[i], 0, 1) + "%", 1, PF, 0.8);
					
					if(point_in_rectangle(MouseGuiX, MouseGuiY, xx, yy, xx + 29, yy + 29)) {
						draw_set_alpha(0.3);
						draw_rectangle_color(xx, yy, xx + 29, yy + 29, c_white, c_white, c_white, c_white, 0);
						draw_set_alpha(1);
					}
				}
				
				if(xx < 464) xx += 32 else {xx = 400; yy += 32};
			}
		}

	}
}

// Чат в игре
while(ds_list_size(Chat) > 14) ds_list_delete(Chat, 0);
gui_font(fn_default, fa_left, fa_middle);
for(var i = ds_list_size(Chat) - 1, yy = 372; i >= 0; i--) {
	gui_text(4, yy, Chat[| i], 1, PF, 1);
	yy -= 10;
}