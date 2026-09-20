// Доход перидота
if(SERVER_SIDE) {
	if(IncomeCooldown > 0) IncomeCooldown -= 1;
	else {
		IncomeCooldown = 60;
		Plr.Cash += 40;
	}
}
