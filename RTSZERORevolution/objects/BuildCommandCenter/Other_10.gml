event_inherited();

switch(EVENT[0]) {
	case EventType.CivAbilityBuildDone:
		{
			var BuildType = EVENT[1];
			// Спавн снаружи здания со случайным смещением (без наложений),
			// юнит сам едет к точке сбора
			var SX = x + 48 + irandom(16);
			var SY = y - 24 + irandom(48);
			var Unit = (BuildType == Ability.TankT1 ? create(UnitTankT1, SX, SY) : create(UnitDozer, SX, SY));
			Unit.Plr = Plr;
			Unit.ToX = x + 96 + irandom(32);
			Unit.ToY = y + 96 + irandom(32);
		}
	break;
	
	case EventType.NetWrite:
		var buff = EVENT[1];
		for(var i = 0; i < 9; i++) {
			buffer_write(buff, buffer_u8, QueueAbility[i]);
			if(QueueAbility[i]) buffer_write(buff, buffer_u16, round(QueueProgress[i] * 100));
		}
	break;
	
	case EventType.NetRead:
		var buff = EVENT[1];
		for(var i = 0; i < 9; i++) {
			QueueAbility[i] = buffer_read(buff, buffer_u8);
			if(QueueAbility[i]) QueueProgress[i] = buffer_read(buff, buffer_u16) / 100;
		}
	break;
}