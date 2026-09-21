alarm[0] = room_speed / 6;

if(!surface_exists(SurfShroud))
	SurfShroud = surface_create(256, 256);

// Сетка видимости (0 = туман, 1 = видно)
ds_grid_clear(Game.FogGrid, 0);
with(Civilian) {
	if(Plr.Color == Game.OwnerPlayer.Color or (Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team)) {
		ds_grid_set_disk(Game.FogGrid, x div 16, y div 16, VisionRadius, 1);
	}
}

// Запоминаем увиденные здания противника и убираем уничтоженные
with(Builds) {
	if(Plr.Color != Game.OwnerPlayer.Color and !(Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team)) {
		if(Game.FogGrid[# x div 16, y div 16]) Game.LastKnownGrid[# x div 16, y div 16] = id;
	}
}
for(var xx = 0; xx < MAP_W; xx++) {
	for(var yy = 0; yy < MAP_H; yy++) {
		var LK = Game.LastKnownGrid[# xx, yy];
		if(LK != -1 and !instance_exists(LK)) Game.LastKnownGrid[# xx, yy] = -1;
	}
}

// Обновляем сетку коллизий (стены + здания)
mp_grid_clear_all(Game.MapCollision);
mp_grid_add_instances(Game.MapCollision, Terrains, false);
mp_grid_add_instances(Game.MapCollision, Builds, false);

// Серый туман войны (карта видна, противники — нет)
surface_set_target(SurfShroud);
draw_clear_alpha(make_color_rgb(40, 40, 40), 0.7);

gpu_set_blendmode(bm_subtract);
with(Civilian) {
	if(Plr.Color == Game.OwnerPlayer.Color or (Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team)) {
		draw_circle_color(round(x/8) - 1, round(y/8) - 1, VisionRadius * 2, c_white, c_white, 0);
	}
}
gpu_set_blendmode(bm_normal);
surface_reset_target();