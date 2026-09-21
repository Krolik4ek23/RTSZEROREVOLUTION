var Dist = point_distance(x, y, ToX, ToY);
if(Dist < Speed) {
	instance_destroy(self);
} else {
	var Dir = point_direction(x, y, ToX, ToY);
	x += lengthdir_x(Speed, Dir);
	y += lengthdir_y(Speed, Dir);
}
