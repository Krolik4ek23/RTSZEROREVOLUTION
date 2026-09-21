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
	// Проверка прямой видимости (не стреляем сквозь стены и здания)
	var LineDir = point_direction(x, y, Target.x, Target.y);
	var LineEndX = Target.x - lengthdir_x(Target.OutlineRadius, LineDir);
	var LineEndY = Target.y - lengthdir_y(Target.OutlineRadius, LineDir);
	
	if(collision_line(x, y, LineEndX, LineEndY, Terrains, false, false) or
	   collision_line(x, y, LineEndX, LineEndY, Builds, false, false)) {
		// Нет прямой видимости — подъезжаем в обход
		ToX = Target.x;
		ToY = Target.y;
		AttackCooldown = 0;
	} else {
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
			} else if(Plr == Game.OwnerPlayer or (Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team) or Game.FogGrid[# x div 16, y div 16]) {
				// Визуальный выстрел (только если стрелок видим)
				var Shot = create(ObjShot, x, y);
				Shot.ToX = Target.x;
				Shot.ToY = Target.y;
			}
		}
	}
} else {
	// Преследуем цель
	ToX = Target.x;
	ToY = Target.y;
	AttackCooldown = 0;
}
