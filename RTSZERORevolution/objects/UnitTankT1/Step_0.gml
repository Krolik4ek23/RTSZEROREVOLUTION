event_inherited();

if(point_distance(x, y, ToX, ToY) > 4) {
	var PathNumber = path_get_number(Path);
	if (path_get_number(Path) == 0 or 
		point_distance(path_get_point_x(Path, PathNumber - 1), path_get_point_y(Path, PathNumber - 1), ToX, ToY) > 12) {
	
		if(mp_grid_path(Game.MapCollision, Path, x, y, ToX, ToY, true)) {
			// Сглаживание пути (стены + здания)
			var i = 0;
			while(i < path_get_number(Path) - 2) {
				var X1 = path_get_point_x(Path, i),
					Y1 = path_get_point_y(Path, i),
					X2 = path_get_point_x(Path, i + 2),
					Y2 = path_get_point_y(Path, i + 2),
					R = 5;
				if(!collision_line(X1 - R, Y1 - R, X2 - R, Y2 - R, Terrains, false, false) and
				   !collision_line(X1 - R, Y1 - R, X2 - R, Y2 - R, Builds, false, false) and
				   !collision_line(X1 + R, Y1 - R, X2 + R, Y2 - R, Terrains, false, false) and
				   !collision_line(X1 + R, Y1 - R, X2 + R, Y2 - R, Builds, false, false) and
				   !collision_line(X1 - R, Y1 + R, X2 - R, Y2 + R, Terrains, false, false) and
				   !collision_line(X1 - R, Y1 + R, X2 - R, Y2 + R, Builds, false, false) and
				   !collision_line(X1 + R, Y1 + R, X2 + R, Y2 + R, Terrains, false, false) and
				   !collision_line(X1 + R, Y1 + R, X2 + R, Y2 + R, Builds, false, false)) {
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
			var OldX = x, OldY = y;
			move_contact_solid(PointDir, 0.8);
			// Если упёрлись в препятствие — скользим вдоль него
			if(point_distance(OldX, OldY, x, y) < 0.4) {
				move_contact_solid(PointDir + 90, 0.8);
				if(point_distance(OldX, OldY, x, y) < 0.4) {
					x = OldX; y = OldY;
					move_contact_solid(PointDir - 90, 0.8);
				}
			}
			// Если так и не сдвинулись — пересчитываем путь
			if(point_distance(OldX, OldY, x, y) < 0.1) {
				path_clear_points(Path);
			}
		} else path_delete_point(Path, 0);
		
		BaseDir -= angle_difference(BaseDir, PointDir) / 6;
	}
}

// Плавный поворот башни к цели атаки (без резких поворотов)
var TurretDir = BaseDir;
if(instance_exists(Target) and Damage > 0) {
	TurretDir = point_direction(x, y, Target.x, Target.y);
}
PushDir -= clamp(angle_difference(PushDir, TurretDir), -2.5, 2.5);

// Следы гусениц (только на клиенте и для видимых танков)
if(!SERVER_SIDE and (Plr == Game.OwnerPlayer or (Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team) or Game.FogGrid[# x div 16, y div 16])) {
	if(instance_number(ObjTrackMark) < 1000) {
		TrackTimer -= 1;
		if(TrackTimer <= 0 and point_distance(xprevious, yprevious, x, y) > 0.2) {
			TrackTimer = 12;
			var Track = create(ObjTrackMark, x + irandom_range(-6, 6), y + irandom_range(-6, 6));
			Track.image_angle = BaseDir + irandom_range(-15, 15);
		}
	}
}