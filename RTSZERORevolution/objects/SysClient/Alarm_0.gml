alarm[0] = room_speed / 6;

if(!surface_exists(SurfShroud))
	SurfShroud = surface_create(256, 256);
	
surface_set_target(SurfShroud);
draw_clear(0);

gpu_set_blendmode(bm_subtract);
with(Civilian) {
	if(Plr.Color == Game.OwnerPlayer.Color or (Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team)) {
		draw_circle_color(round(x/8) - 1, round(y/8) - 1, VisionRadius * 2, c_white, c_white, 0);
	}
}
gpu_set_blendmode(bm_normal);
surface_reset_target();