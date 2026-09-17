function Player() {
	var o = create(Container);

	o.Username = "";
	o.Slot = -1;
	o.Team = 0;
	o.Color = 0;
	o.AIScript = 0;
	o.State = PlrStatus.NotReady;

	o.Cash = 0;
	o.Energy = 0;

	return o;


}
