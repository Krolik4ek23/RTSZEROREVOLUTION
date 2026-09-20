if(SERVER_SIDE and Building != noone and Progress >= 100) {
	var Unit = create(Building, x, y);
	Unit.Plr = Plr;
	Unit.Dir = Dir;
	
	destroy(self);
}