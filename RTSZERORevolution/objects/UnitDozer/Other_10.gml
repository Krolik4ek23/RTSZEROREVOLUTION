switch(EVENT[0]) {
	case EventType.NetWrite:
		var Buff = EVENT[1];
		
		buffer_write(Buff, buffer_u16, round(ToX * 10));
		buffer_write(Buff, buffer_u16, round(ToY * 10));
		buffer_write(Buff, buffer_u16, instance_exists(Target) ? Target.NetUID : 0);
	break;
	
	case EventType.NetRead:
		var Buff = EVENT[1];
		
		ToX = buffer_read(Buff, buffer_u16) / 10;
		ToY = buffer_read(Buff, buffer_u16) / 10;
		var npTarget = buffer_read(Buff, buffer_u16);
		Target = npTarget ? net_search_uid(npTarget) : noone;
	break;
	
	case EventType.CivAbilityStartBuild:
		var AbilityID = Abilities[EVENT[1]];
		switch(AbilityID) {
			case Ability.CommandCenter:
				var XX = EVENT[2] * 16, YY = EVENT[3] * 16, D = EVENT[4];
				
				var x1 = XX - 32, y1 = YY - 32, x2 = x1 + 63, y2 = y1 + 63;
				
				if (Plr.Cash >= Game.AbilitiesPrice[AbilityID] and 
					!collision_rectangle(x1, y1, x2, y2, Builds, false, false) and
					!collision_rectangle(x1, y1, x2, y2, Terrains, false, false)) {
						
					Plr.Cash -= Game.AbilitiesPrice[AbilityID];
					
					var Unit = create(BuildFrame, XX, YY);
					Unit.Building = BuildCommandCenter;
					Unit.ProgressSpeed = 1.6 / Game.AbilitiesTime[AbilityID];
					Unit.Plr = Plr;
					Unit.Dir = D;
				
					Target = Unit;
					ToX =  Unit.x;
					ToY = Unit.y;
				}
			break;
		}
	break;
}