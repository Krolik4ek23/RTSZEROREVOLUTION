if(SERVER_SIDE and Building and Progress >= 100) {
	var Unit = create(Building, x, y);
	Unit.Plr = Plr;
	Unit.Dir = Dir;
	
	destroy(self);
}