switch(EVENT[0]) {
	case EventType.CivAbilityStartBuild:
		var AbilitySlot = EVENT[1];
		var AbilityID = Abilities[AbilitySlot];
		
		if(Plr.Cash >= Game.AbilitiesPrice[AbilityID]) {
			Plr.Cash -= Game.AbilitiesPrice[AbilityID];
			
			for(var i = 0; i < 9; i++) {
				if(!QueueAbility[i]) {
					QueueAbility[i] = AbilityID;
					QueueProgress[i] = 0;
					break;
				}
			}
		}
	break;
}