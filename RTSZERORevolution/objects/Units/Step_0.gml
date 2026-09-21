// Общая боевая логика юнитов (родитель Units).
// Вызывается из Step_0 дочерних юнитов через event_inherited().

if(Damage <= 0) exit;

// Проверяем цель; при её отсутствии — автоатака ближайшего врага
if(!instance_exists(Target) or Target.Plr == Plr or (Plr.Team != 0 and Plr.Team == Target.Plr.Team)) {
	Target = noone;
	AutoTarget = false;
	
	Nearest = noone;
	NearestDist = AttackRange;
	with(Civilian) {
		if(Plr == Game.NeutralPlayer) continue;
		if(Plr == other.Plr or (other.Plr.Team != 0 and other.Plr.Team == Plr.Team)) continue;
		if(point_distance(x, y, other.x, other.y) < other.NearestDist) {
			other.NearestDist = point_distance(x, y, other.x, other.y);
			other.Nearest = id;
		}
	}
	Target = Nearest;
	AutoTarget = (Target != noone);
	if(Target == noone) exit;
}

var Dist = point_distance(x, y, Target.x, Target.y);

// Проверка прямой видимости (не стреляем сквозь стены и здания),
// сама цель из проверки исключается
var LOS = true;
if(Dist <= AttackRange) {
	ds_list_clear(Game.LOSList);
	collision_line_list(x, y, Target.x, Target.y, Terrains, false, false, Game.LOSList, true);
	collision_line_list(x, y, Target.x, Target.y, Builds, false, false, Game.LOSList, true);
	var N = ds_list_size(Game.LOSList);
	for(var i = 0; i < N; i++) {
		if(Game.LOSList[| i] != Target) { LOS = false; break; }
	}
}

if(Dist <= AttackRange and LOS) {
	// Стреляем на ходу (не останавливаемся)
	if(AttackCooldown > 0) {
		AttackCooldown -= 1;
	} else {
		AttackCooldown = AttackSpeed;
		if(SERVER_SIDE) {
			with(Target) {
				if(object_index == BuildFrame) {
					// Атака по недостроенному зданию — сбиваем процент стройки
					Progress -= (other.Damage / MaxHP) * 100;
					if(Progress <= 0) instance_destroy(self, false);
				} else {
					HP -= other.Damage;
					if(HP <= 0) instance_destroy(self, false);
				}
			}
		} else if(Plr == Game.OwnerPlayer or (Plr.Team != 0 and Plr.Team == Game.OwnerPlayer.Team) or Game.FogGrid[# x div 16, y div 16]) {
			// Визуальный выстрел (только если стрелок видим)
			var Shot = create(ObjShot, x, y);
			Shot.ToX = Target.x;
			Shot.ToY = Target.y;
		}
	}
} else if(AutoTarget) {
	// Автоцель вне радиуса или без линии огня — теряем её (продолжаем движение)
	Target = noone;
	AutoTarget = false;
} else {
	// Приближаемся к цели на дистанцию атаки.
	// Для зданий цель — край здания (иначе mp_grid не проложит путь в центр).
	var AppDir = point_direction(Target.x, Target.y, x, y);
	var AppDist = AttackRange - 24;
	if(object_get_parent(Target.object_index) == Builds) {
		AppDist = max(AppDist, (Target.sprite_width + Target.sprite_height) / 4 + 8);
	}
	ToX = Target.x + lengthdir_x(AppDist, AppDir);
	ToY = Target.y + lengthdir_y(AppDist, AppDir);
	AttackCooldown = 0;
}
