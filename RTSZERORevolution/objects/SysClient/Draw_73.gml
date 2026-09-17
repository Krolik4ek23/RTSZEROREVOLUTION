if(Status != ClientStatus.InGame) exit;

with(Civilian) event_perform(ev_draw, ev_draw_begin);

if(!surface_exists(SurfShadow))
	SurfShadow = surface_create(512, 384);

surface_set_target(SurfShadow);
draw_clear_alpha(0, 0);
with(Civilian) event_perform(ev_other, ev_user1);
with(Terrains) event_perform(ev_other, ev_user1);
surface_reset_target();
	
shader_set(shr_shadowMap);
shader_set_uniform_f(shrUniform_size, 512, 384, 4);
draw_surface_stretched(SurfShadow,
	Game.CamX, Game.CamY,
	Game.CamW, Game.CamH
);
shader_reset();

with(Civilian) event_perform(ev_draw, ev_draw_end);
with(Terrains) event_perform(ev_draw, ev_draw_end);

if(!ds_list_empty(Pick)) {
	for(var j = ds_list_size(Pick), i = 0; i < j; i++) {
		var Unit = Pick[| i];
		draw_circle_color(Unit.x - 1, Unit.y - 1, Unit.OutlineRadius, c_red, c_red, 1);
		draw_circle_color(Unit.x - 1, Unit.y - 1, Unit.OutlineRadius + 0.5, c_red, c_red, 1);
	}
}

gpu_set_tex_filter(true);
draw_surface_stretched(SurfShroud, 0, 0, MAP_W * 16, MAP_H * 16);
gpu_set_tex_filter(false);

if(Game.AbilityUse[0] and point_in_rectangle(MouseGuiX, MouseGuiY, 0, 0, 384, 384)) {
	if(instance_exists(Game.AbilityUse[0])) {
		var AbObj = Game.AbilityUse[0],
			AbSlot = Game.AbilityUse[1],
			AbData = Game.AbilityUse[2];
		
		switch(Game.AbilitiesType[AbObj.Abilities[AbSlot]]) {
			case AbilityType.Building:
				var MX = MouseX div 16, 
					MY = MouseY div 16,
					Spr = Game.AbilitiesData[AbObj.Abilities[AbSlot]];
				
				if(mouse_wheel_down()) if(Game.AbilityUse[2] < 3) Game.AbilityUse[2]++ else Game.AbilityUse[2] = 0;
				if(mouse_wheel_up()) if(Game.AbilityUse[2] > 0) Game.AbilityUse[2]-- else Game.AbilityUse[2] = 3;
				
				var xx = MX * 16,
					yy = MY * 16,
					x1 = xx - sprite_get_xoffset(Spr),
					y1 = yy - sprite_get_yoffset(Spr),
					x2 = x1 + sprite_get_width(Spr) - 1,
					y2 = y1 + sprite_get_height(Spr) - 1;
				
				draw_sprite_ext(Spr, 0, xx, yy, 1, 1, AbData * 90, c_white, 0.75);
				
				var possible = 
					!(collision_rectangle(x1, y1, x2, y2, Builds, false, false) ||
					collision_rectangle(x1, y1, x2, y2, Terrains, false, false));
				
				gui_rect(x1, y1, x2, y2, possible ? c_green : c_red, 1, 1);
				gui_rect(x1 + 1, y1 + 1, x2 - 1, y2 - 1, possible ? c_green : c_red, 1, 1);
				
				if(possible and mouse_check_button_pressed(mb_left)) {
					network_packet(BUFF1, NetPacket.UnitControl);
					buffer_write(BUFF1, buffer_u16, AbObj.NetUID);
					buffer_write(BUFF1, buffer_u8, 3);
					buffer_write(BUFF1, buffer_u8, AbSlot);
					buffer_write(BUFF1, buffer_u8, MX);
					buffer_write(BUFF1, buffer_u8, MY);
					buffer_write(BUFF1, buffer_u8, AbData);
					buffer_write(BUFF1, buffer_u16, 0);
					network_send(BUFF1, other.Socket);
					
					Game.AbilityUse = [0, 0, 0];
				}
			break;
			default: Game.AbilityUse = [0, 0, 0];
		}
	} else Game.AbilityUse = [0, 0, 0];
}