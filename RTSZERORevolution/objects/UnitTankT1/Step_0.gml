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

if(SeeX == 0) PushDir = BaseDir;