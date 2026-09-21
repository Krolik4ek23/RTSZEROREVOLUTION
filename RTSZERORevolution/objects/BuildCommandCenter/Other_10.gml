event_inherited();

switch(EVENT[0]) {
	case EventType.CivAbilityBuildDone:
		{
			var BuildType = EVENT[1];
			// Выезд из ангара: верхний (приоритет), при стене на пути — низ/лево/право.
			var SX = x, SY = y, RX = x, RY = y, Placed = false;
			var cX = 0, cY = 0;
			
			// Верхний ангар
			cX = x + irandom_range(-8, 8); cY = y - 48;
			if(!collision_rectangle(cX - 8, cY - 8, cX + 8, cY + 8, Terrains, false, false) and
			   !collision_rectangle(cX - 8, cY - 8, cX + 8, cY + 8, Builds, false, false)) {
				SX = cX; SY = cY; RX = x + irandom_range(-24, 24); RY = y - 112;
				Placed = true;
			}
			// Нижний ангар
			if(!Placed) {
				cX = x + irandom_range(-8, 8); cY = y + 48;
				if(!collision_rectangle(cX - 8, cY - 8, cX + 8, cY + 8, Terrains, false, false) and
				   !collision_rectangle(cX - 8, cY - 8, cX + 8, cY + 8, Builds, false, false)) {
					SX = cX; SY = cY; RX = x + irandom_range(-24, 24); RY = y + 112;
					Placed = true;
				}
			}
			// Левый выход
			if(!Placed) {
				cX = x - 48; cY = y + irandom_range(-8, 8);
				if(!collision_rectangle(cX - 8, cY - 8, cX + 8, cY + 8, Terrains, false, false) and
				   !collision_rectangle(cX - 8, cY - 8, cX + 8, cY + 8, Builds, false, false)) {
					SX = cX; SY = cY; RX = x - 112; RY = y + irandom_range(-24, 24);
					Placed = true;
				}
			}
			// Правый выход (запасной)
			if(!Placed) {
				SX = x + 48; SY = y + irandom_range(-8, 8);
				RX = x + 112; RY = y + irandom_range(-24, 24);
			}
			
			var Unit = (BuildType == Ability.TankT1 ? create(UnitTankT1, SX, SY) : create(UnitDozer, SX, SY));
			Unit.Plr = Plr;
			Unit.ToX = RX;
			Unit.ToY = RY;
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