// Юниты не расталкивают друг друга — только здания и стены
if(object_get_parent(other.object_index) == Units) exit;
if(IgnoreCollisionBuilds and object_get_parent(other.object_index) == Builds) exit;
move_contact_solid(point_direction(other.x, other.y, x, y), 2);