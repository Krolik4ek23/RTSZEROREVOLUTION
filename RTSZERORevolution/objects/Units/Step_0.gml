// Общая боевая логика юнитов (родитель Units).
// Вызывается из Step_0 дочерних юнитов через event_inherited().

if(Damage <= 0) exit;

if(!instance_exists(Target)) {
	Target = noone;
	exit;
}

// Не атакуем своих
if(Target.Plr == Plr or (Plr.Team != 0 and Plr.Team == Target.Plr.Team)) {
	Target = noone;
	exit;
}

var Dist = point_distance(x, y, Target.x, Target.y);

if(Dist <= AttackRange) {
	// Останавливаемся и атакуем
	ToX = x;
	ToY = y;
	
	BaseDir -= angle_difference(BaseDir, point_direction(x, y, Target.x, Target.y)) / 6;
	
	if(AttackCooldown > 0) {
		AttackCooldown -= 1;
	} else {
		AttackCooldown = AttackSpeed;
		if(SERVER_SIDE) {
			with(Target) {
				HP -= other.Damage;
				if(HP <= 0) instance_destroy(self, false);
			}
		}
	}
} else {
	// Преследуем цель
	ToX = Target.x;
	ToY = Target.y;
	AttackCooldown = 0;
}
