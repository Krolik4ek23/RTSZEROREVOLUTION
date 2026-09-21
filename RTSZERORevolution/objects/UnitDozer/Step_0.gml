event_inherited();

if(point_distance(x, y, ToX, ToY) > 4) {
	var PathNumber = path_get_number(Path);
	if (path_get_number(Path) == 0 or 
		point_distance(path_get_point_x(Path, PathNumber - 1), path_get_point_y(Path, PathNumber - 1), ToX, ToY) > 12) {
	
		if(mp_grid_path(Game.MapCollision, Path, x, y, ToX, ToY, true)) {
			// Сглаживание пути (стены + здания)
			var i = 0;
			while(i < path_get_number(Path) - 2) {
				if(!collision_line(path_get_point_x(Path, i), path_get_point_y(Path, i), path_get_point_x(Path, i + 2), path_get_point_y(Path, i + 2), Terrains, false, false) and
				   !collision_line(path_get_point_x(Path, i), path_get_point_y(Path, i), path_get_point_x(Path, i + 2), path_get_point_y(Path, i + 2), Builds, false, false)) {
					path_delete_point(Path, i + 1);
				} else {
					i++;
				}
			}
		} else {
			ToX = x; ToY = y;
		}
	} else {
		var PointX = path_get_point_x(Path, 0),
			PointY = path_get_point_y(Path, 0),
			PointDir = point_direction(x, y, PointX, PointY);
		
		if(point_distance(x, y, PointX, PointY) > 2) {
			move_contact_solid(PointDir, 0.6);
		} else path_delete_point(Path, 0);
		
		BaseDir -= angle_difference(BaseDir, PointDir) / 6;
	}
}

if(instance_exists(Target) and Target.object_index == BuildFrame and Target.Building != noone) {
	// Строительство не прекращено — постройка не распадается, пока бульдозер привязан
	Target.BeingBuilt = true;
	
	var Dist = point_distance(x, y, Target.x, Target.y);
	var BuildSpr = object_get_sprite(Target.Building);
	var BRange = max(sprite_get_width(BuildSpr), sprite_get_height(BuildSpr)) / 2 + 16;
	
	if(Dist <= BRange) {
		// Стоп и строим
		ToX = x;
		ToY = y;
		if(Target.Progress < 100) Target.Progress += Target.ProgressSpeed;
	} else {
		// Едем к краю постройки (не в центр — иначе упрёмся в коллизию)
		var AppDir = point_direction(Target.x, Target.y, x, y);
		ToX = Target.x + lengthdir_x(BRange - 4, AppDir);
		ToY = Target.y + lengthdir_y(BRange - 4, AppDir);
	}
} else {
	Target = noone;
}