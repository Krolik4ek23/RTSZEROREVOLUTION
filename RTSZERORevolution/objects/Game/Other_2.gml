System();

ini_open("profile.ini");
Game.Username = ini_read_string("account", "username", Game.Username);
ini_close();

AppPath = parameter_string(0);
AppArgs = "";
for(var i = 1; i < parameter_count(); i++) AppArgs += parameter_string(i) + " ";

AbilityUse = [0, 0, 0];
AbilitiesCount = 1;
ability_add("TankT1", AbilityType.Simple, 800, 8, 0);
ability_add("Dozer", AbilityType.Simple, 1000, 10, 0);
ability_add("CommandCenter", AbilityType.Building, 2000, 40, sprBuildCommandCenter);

create(SysMenu);

enum AbilityType {
	Move,
	Simple,
	Building,
	OnArea,
	OnVisibleArea,
	OnBuild,
	OnEnemyBuild,
	OnAllyBuild,
	OnUnit,
	OnEnemyUnit,
	OnAllyUnit,
	OnTarget,
	OnEnemyTarget,
	OnAllyTarget
}