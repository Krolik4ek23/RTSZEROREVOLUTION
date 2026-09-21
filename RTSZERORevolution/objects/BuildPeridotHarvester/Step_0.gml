// Добыча перидота: нужно нейтральный склад рядом
if(SERVER_SIDE) {
	HasSupply = false;
	with(BuildPeridotSupply) {
		if(Plr != Game.NeutralPlayer) continue;
		if(point_distance(x, y, other.x, other.y) <= 96) { other.HasSupply = true; break; }
	}
	
	if(HasSupply) {
		if(MineCooldown > 0) MineCooldown -= 1;
		else {
			MineCooldown = 120;
			Plr.Cash += 20;
		}
	} else {
		MineCooldown = 120;
	}
}
