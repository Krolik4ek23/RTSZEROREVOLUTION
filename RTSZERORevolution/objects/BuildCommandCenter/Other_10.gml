event_inherited();

switch(EVENT[0]) {
	case EventType.CivAbilityBuildDone:
		switch(EVENT[1]) {
			case Ability.TankT1:
				var Unit = create(UnitTankT1, x - 16, y - 16);
				Unit.Plr = Plr;
				Unit.ToX = Unit.x + 32; Unit.ToY = Unit.y;
			break;
			
			case Ability.Dozer:
				var Unit = create(UnitDozer, x - 16, y - 16);
				Unit.Plr = Plr;
				Unit.ToX = Unit.x + 32; Unit.ToY = Unit.y;
			break;
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