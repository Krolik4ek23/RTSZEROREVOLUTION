if(SERVER_SIDE and Building != noone) {
	if(Progress >= 100) {
		// Достроено — создаём здание
		var Unit = create(Building, x, y);
		Unit.Plr = Plr;
		Unit.Dir = Dir;
		
		destroy(self);
		exit;
	}
	
	// Распад, если никто не строит
	if(!BeingBuilt) {
		Progress -= 0.04;
		if(Progress <= 0) {
			// Недостроено — разрушается
			instance_destroy(self, false);
			exit;
		}
	}
	BeingBuilt = false;
	
	// HP пропорционален проценту стройки
	HP = max(1, MaxHP * Progress / 100);
}