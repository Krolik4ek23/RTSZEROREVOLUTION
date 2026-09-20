for(var i = 0; i < 9; i++) {
	var AbilityID = QueueAbility[i];
	if(!AbilityID) continue;
	
	if(QueueProgress[i] < 100) {
		QueueProgress[i] += 1.6 / Game.AbilitiesTime[AbilityID];
	} else {
		if(SERVER_SIDE) event(EventType.CivAbilityBuildDone, AbilityID);
		QueueProgress[i] = 0;
		QueueAbility[i] = 0;
	}
	
	break;
}

// Доход
if(SERVER_SIDE) {
	if(IncomeCooldown > 0) IncomeCooldown -= 1;
	else {
		IncomeCooldown = 60;
		Plr.Cash += 20;
	}
}