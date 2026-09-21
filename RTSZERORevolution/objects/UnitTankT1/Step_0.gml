event_inherited();

if(point_distance(x, y, ToX, ToY) > 4) {
	var PathNumber = path_get_number(Path);
	if (path_get_number(Path) == 0 or 
		(path_get_point_x(Path, PathNumber - 1) != ToX or path_get_point_y(Path, PathNumber - 1) != ToY)) {
	
		if(!mp_grid_path(Game.MapCollision, Path, x, y, ToX, ToY, true)) {
			ToX = x; ToY = y;
		} else {
			path_optimize(Path, 16, Terrains);
		}
	} else {
		var PointX = path_get_point_x(Path, 0),
			PointY = path_get_point_y(Path, 0),
			PointDir = point_direction(x, y, PointX, PointY);
		
		if(point_distance(x, y, PointX, PointY) > 2) {
			if(abs(angle_difference(BaseDir, PointDir)) < 4) {
				move_contact_solid(PointDir, 0.8);
			}
		} else path_delete_point(Path, 0);
		
		BaseDir -= angle_difference(BaseDir, PointDir) / 6;
	}
}

if(instance_exists(Target) and Damage > 0) {
	PushDir -= angle_difference(PushDir, point_direction(x, y, Target.x, Target.y)) / 6;
} else {
	PushDir = BaseDir;
}

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