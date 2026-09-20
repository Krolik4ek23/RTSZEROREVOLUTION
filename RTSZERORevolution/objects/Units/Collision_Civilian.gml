if(IgnoreCollisionBuilds and object_get_parent(other.object_index) == Builds) exit;
move_contact_solid(point_direction(other.x, other.y, x, y), 2);